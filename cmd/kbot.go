/*
Copyright © 2024 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	//TeleToken bot
	TeleToken = os.Getenv("TELE_TOKEN")

	// Universal markup builders.
	menu     = &telebot.ReplyMarkup{ResizeKeyboard: true}
	selector = &telebot.ReplyMarkup{}

	// Reply buttons.
	btnStart = menu.Text("🇺🇦 Start")
	btnHelp  = menu.Text("⚙ Help")
	btnDate  = menu.Text("📆 Date")

	// Inline buttons.
	//
	// Pressing it will cause the client to
	// send the bot a callback.
	//
	// Make sure Unique stays unique as per button kind
	// since it's required for callback routing to work.
	//

	btnPrev = selector.Data("⬅", "prev", "...")
	btnNext = selector.Data("➡", "next", "...")

	// Get current date
	currentTime = time.Now()
)

// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		menu.Reply(
			menu.Row(btnStart),
			menu.Row(btnHelp),
			menu.Row(btnDate),
		)

		selector.Inline(
			selector.Row(btnPrev, btnNext),
		)
		kbot.Handle("/start", func(c telebot.Context) error {
			return c.Send("Здоровенькі були!", menu)
		})

		kbot.Handle("/help", func(c telebot.Context) error {
			return c.Send("/start  - привітання та початок роботи з kbot" +
				"\n/help - виводить перелік можливостей kbot" +
				"\n/date - отримай поточну дату та час")
		})

		kbot.Handle("/helpNext", func(c telebot.Context) error {
			return c.Send("/start  - привітання та початок роботи з kbot" +
				"\n/help - виводить перелік можливостей kbot" +
				"\n/date - отримай поточну дату та час")
		})

		kbot.Handle(&btnStart, func(c telebot.Context) error {
			return c.Send("Здоровенькі були!", menu)
		})

		// On reply button pressed (message)
		kbot.Handle(&btnHelp, func(c telebot.Context) error {
			return c.Send("/start  - привітання та початок роботи з kbot" +
				"\n/help - виводить перелік можливостей kbot" +
				"\n/date - отримай поточну дату та час")
		})

		// On inline button pressed (callback)
		kbot.Handle(&btnPrev, func(c telebot.Context) error {
			return c.Respond()
		})

		// On inline button pressed (Date)
		kbot.Handle(&btnDate, func(c telebot.Context) error {
			return c.Send(currentTime.String() + "\nБезкорисна функція! Но най буде 😌")
		})

		// Перевіряємо наявність токена Телеграм
		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Print(m.Message().Payload, m.Text())
			payload := m.Message().Payload

			switch payload {
			case "hello":
				err = m.Send(fmt.Sprintf("Hello I'm Kbot %s", appVersion))
			default:
				err = m.Send(fmt.Sprintf("Ой, чоловіче, що ж тиж хочеш?" + "\nТицьни сюди і дізнаєшся що я вмію /help" + "\nабо сюди і дізнайся що я вмію тяльки це /helpNext"))
			}
			return err
		})

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
