# kbot
<b>DevOps - module 2</b><br>
<b>KBOT - приклад програмування телеграм бота на мові Golang</b><br>
<b>Технічне Завдання на розробку функціонального Telegram-бота з кореневою командою та налаштуваннями.</b><br>
<b>Вимоги:</b><br>
&bull; Мова Golang;<br>
&bull; Фреймворки github.com/spf13/cobra та gopkg.in/telebot.v3;<br>
&bull; Реалізувати обробники повідомлень для бота, які будуть відповідати на повідомлення в Telegram;<br>
&bull; Створити функції-обробники повідомлень бота;<br>
&bull; Додати ці функції до методів об'єкта telebot.Bot;<br>
&bull; Обробляти повідомлення відповідно до їх типу та вмісту.<br>

<b>Таблиця рекомендацій для виконання:</b>
| Рекомендації та приклад виконання                                                                      |
|------------------------------------------------------------------------------------|
| &bull; Встановити Golang та налаштувати середовище розробки.  <a href="https://go.dev/doc/install">Інструкція для OC Windows </a> |
| &bull; <a href="#newProjectGit">Створюємо новий проєкт на GitHub.</a>|
| &bull; <a href="#cobra">Додати залежність на бібліотеку github.com/spf13/cobra за домопогою import.</a>  |
| &bull; <a id="telegram_bot">Створити Telegram-бота за допомогою<a> <a href="https://telegram.me/BotFather">BotFather.</a>  |
| &bull; <a href="#tele_token">Отримати токен бота та зберегти його у змінну середовища TELE_TOKEN.</a>|
| &bull; <a href="#import_package">Імпортувати необхідні бібліотеки.</a> |
| &bull; <a href="#import_telebot">Встановити бібліотеку gopkg.in/telebot.v3 за допомогою go get.</a> |
| &bull; <a href="#get_token">Отримати токен бота зі змінної середовища. </a>|
| &bull; <a href="#new_object">Створити об'єкт бота за допомогою telebot.NewBot().</a>|
| &bull; <a href="#new_message">Додати обробник повідомлень за допомогою kbot.Handle</a>|
| &bull; <a href="#about_message">Описати функцію-обробник, яка буде відповідати на повідомлення.</a>|
| &bull; <a href="#build_bot">Зібрати, запустити та перевірити бота.</a>|
| &bull; Створити файл <a href="https://github.com/AlbertRipak/kbot">README</a> з описом проєкту, посиланням на бота у форматі https://t.me/albertripak_bot, включаючи інструкції для встановлення та приклади використання команд.</a>|
| &bull; <a href="https://github.com/AlbertRipak/kbot">Завантажити код на GitHub</a>.

<b><a id="cobra">GITHUB.COM/SPF13/COBRA</a></b>
Генеруємо початковий код
```cmd
go install github.com/spf13/cobra-cli@latest
```
Генеруємо файл main.go, основний файл коду
заповнить файл go.mod початковими модулями 
та додасть файл в директорію cmd/root.go де знаходиться згенерований початковий код
за допомогою команди:
```cmd
cobra-cli init
```
код версіїї буде розміщуватись тут:
```cmd
cobra-cli add version
```
код безпосередньо нашого боту буде розміщуватись тут:
```cmd
cobra-cli add kbot
```

<b><a id="tele_token">Токен телеграм бота</a></b>
Після проходження кроку <a href="#telegram_bot">"Створити Telegram-бота за допомогою BotFather"</a>
BotFather надасть вам токен за допомогою якого можна встановити зв'язок з Телеграм Ботом.
Для того щоб зберегти токен в змінну середовища, потрібно виконати наступні кроки:
```cmd
TELE_TOKEN=[copy and past your token here]
export TELE_TOKEN
```

<b><a id="tele_token">Щоб встановити бібліотеку telebot.v3 потрібно:</a></b>
у файл cmd/kbot.go в блок import додати рядок telebot "gopkg.in/telebot.v3"
```cmd
import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
    telebot "gopkg.in/telebot.v3"
)
```
<b><a id="import_telebot">Щоб імпортувати необхідні бібліотеки потрібно:</a></b>
у файл cmd/kbot.go в блок import додати наступне
```cmd
import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
)
```
<b><a href="#get_token">Щоб отримати токен зі змінної середовища потрібно: </a></b>
у файлі cmd/kbot.go додати в блок var () наступний рядок
```cmd
var (
	//TeleToken bot
	TeleToken = os.Getenv("TELE_TOKEN")
)
```
<a id="new_object">Щоб створити об'єкт бота за допомогою telebot.NewBot().</a>
в файл cmd/kbot.go додати наступне
```cmd
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
    }
```
<b><a id="new_message">Додати обробник повідомлень за допомогою kbot.Handle</a></b>
<b><a id="about_message">Описати функцію-обробник, яка буде відповідати на повідомлення міститься у блоці switch payload{}</a></b>
```cmd
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
```
<a id="build_bot">Щоб зібрати, запустити та перевірити бота.</a>
```bash
git clone https://github.com/AlbertRipak/kbot.git
TELE_TOKEN=[copy and past your token here]
export TELE_TOKEN
go build -ldflags "-X 'github.com/AlbertRipak/kbot/cmd.appVersion=1.0.5'"
./kbot start
```

![Image](./data/cobra.gif)

P.S.
1. Для ємоджі використувувався сайт <a href="https://emojipedia.org/">emojipedia.org</a>!
2. gofmt - це інструмент форматування коду Golang. Він використовує табуляцію для відступу та пробіли для вирівнювання. Вирівнювання передбачає, що редактор використовує шрифт фіксованої ширини.
Прапори:
-s - цей прапор вказує gofmt форматувати код лише в режимі "стиснення". Це означає, що код буде форматований без змін в його логіці.
-w - цей прапор вказує gofmt записувати зміни форматування назад до вихідних файлів.

```go
gofmt -s -w ./
```

<a href="https://pkg.go.dev/cmd/gofmt">Документація по gofmt!</a>

<a href="https://go.dev/">![Image](./data/go-blue.svg)</a>