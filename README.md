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

<b>Рекомендації до виконання:</b><br>

<table>
    <tr>
        <td>&bull; Встановити Golang та налаштувати середовище розробки (Codespaces вже містить всі необхідні налаштування) (Інструкція для OC Windows)</td>
        <td><a href="https://go.dev/doc/install">Завантажити Golang</a> та встановити на ваш ПК!</td>
        <td><a href=""></a></td>
        <td><a href=""></a></td>
        <td><a href=""></a></td>
        <td><a href=""></a></td>
    </tr>
    <tr>
        <td>&bull; Створити новий проєкт на GitHub та налаштувати Git.</td>
        <td><a href="https://github.com/AlbertRipak/kbot">KBOT</a></td>
    </tr>
    <tr>
        <td>&bull; Додати залежність на бібліотеку github.com/spf13/cobra за домопогою import</td>
        <td>```go 
                go install github.com/spf13/cobra-cli@latest 
            ```
            ```go 
                cobra-cli init
            ```        
            ```go 
                cobra-cli add kbot
            ```        
</td>
    </tr>
    <tr>
        <td>&bull; </td>
        <td><a href=""></a></td>
    </tr>
    <tr>
        <td>&bull; </td>
        <td><a href=""></a></td>
    </tr>
    <tr>
        <td>&bull; </td>
        <td><a href=""></a></td>
    </tr>
</table>


Створити Telegram-бота за допомогою BotFather.
Отримати токен бота та зберегти його у змінну середовища TELE_TOKEN.
Імпортувати необхідні бібліотеки.
Встановити бібліотеку gopkg.in/telebot.v3 за допомогою go get.
Отримати токен бота зі змінної середовища.
Створити об'єкт бота за допомогою telebot.NewBot().
Додати обробник повідомлень за допомогою kbot.Handle(telebot.OnText, func(m telebot.Context)
Описати функцію-обробник, яка буде відповідати на повідомлення.
Зібрати, запустити та перевірити бота
Створити файл README з описом проєкту, посиланням на бота у форматі t.me/<Імʼя_бота>_bot, включаючи інструкції для встановлення та приклади використання команд.
Завантажити код на GitHub.
Надіслати посилання на репозиторій як відповідь


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