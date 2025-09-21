<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8" />
<title>Ink + Локации и Картинки</title>
<style>
  body {
    font-family: Arial, sans-serif;
    margin: 15px;
    max-width: 600px;
  }
  #location {
    font-weight: bold;
    font-size: 1.2em;
    margin-bottom: 8px;
  }
  #locationImage {
    max-width: 100%;
    max-height: 300px;
    object-fit: contain;
    margin-bottom: 15px;
    border: 1px solid #ccc;
  }
  #storyText {
    white-space: pre-wrap;
    margin-bottom: 15px;
  }
  #choices button {
    display: block;
    padding: 8px 12px;
    margin-bottom: 8px;
    font-size: 1em;
    cursor: pointer;
    width: 100%;
  }
</style>
</head>
<body>

<div id="location">Локация: </div>
<img id="locationImage" src="" alt="Локация" />
<div id="storyText"></div>
<div id="choices"></div>

<!-- inkjs библиотека -->
<script src="https://cdn.jsdelivr.net/npm/inkjs@1.12.1/ink.js"></script>

<script>
// Встроенный Ink JSON (получен из ink/script.ink с помощью inklecate)
// Обратите внимание: для реального проекта лучше держать ink в отдельном JSON.
// Здесь для простоты всё вместе.
const storyContent = {
    "inkVersion":20,
    "root":[
        ["^","VAR location = \"Лес — начало\"\n"],
        ["^","=== start ===\n"],
        ["^","# Локация: {location}\n"],
        ["* ","Идти налево\n",["^","location = \"Лес — левая тропа\"\n",["->","путь_налево"]]],
        ["* ","Идти направо\n",["^","location = \"Лес — правая тропа\"\n",["->","идти_дальше_"]]],
        ["^","\n"],
        ["== путь_налево ==\n"],
        ["^","# Локация: {location}\n"],
        ["* ","Исследовать хижину\n",["^","location = \"Хижина\"\n",["->","хижина"]]],
        ["* ","Оставить её и пройти дальше\n",["^","location = \"Лес — дальше по левой тропе\"\n",["->","идти_дальше_налево"]]],
        ["^","\n"],
        ["== хижина ==\n"],
        ["^","# Локация: {location}\n"],
        ["* ","Осмотреться\n",["->","осмотр_хижины"]],
        ["* ","Выйти обратно\n",["^","location = \"Лес — левая тропа\"\n",["->","идти_дальше_налево"]]],
        ["^","\n"],
        ["== осмотр_хижины ==\n"],
        ["^","# Локация: {location}\n"],
        ["* ","Читать книгу\n",["->","загадка"]],
        ["* ","Положить книгу обратно\n",["^","location = \"Лес — дальше по левой тропе\"\n",["->","идти_дальше_налево"]]],
        ["^","\n"],
        ["== загадка ==\n"],
        ["^","# Локация: {location}\n"],
        ["^","В книге есть загадка: \"Что идет, не двигаясь?\"\n\n"],
        ["* ","Время\n",["->","правильный_ответ"]],
        ["* ","Тень\n",["->","неправильный_ответ"]],
        ["* ","Вода\n",["->","неправильный_ответ"]],
        ["^","\n"],
        ["== правильный_ответ ==\n"],
        ["^","# Локация: {location}\n"],
        ["^","Поздравляю! Вы решили загадку и получили магические силы.\n"],
        ["->","END"],
        ["== неправильный_ответ ==\n"],
        ["^","# Локация: {location}\n"],
        ["^","К сожалению, это неправильный ответ. Ваше приключение закончилось.\n"],
        ["->","END"],
        ["== идти_дальше_налево ==\n"],
        ["^","# Локация: {location}\n"],
        ["^","Вы проходите дальше и выходите из леса, добравшись до безопасного места.\n"],
        ["->","END"],
        ["== идти_дальше_ ==\n"],
        ["^","# Локация: {location}\n"],
        ["^","Вы решили пройти дальше по пути направо и попадаете в открытое поле.\n"],
        ["* ","Исследовать поле\n",["^","location = \"Поле\"\n",["->","поле"]]],
        ["* ","Вернуться назад\n",["^","location = \"Лес — начало\"\n",["->","назад_к_началу"]]],
        ["^","\n"],
        ["== поле ==\n"],
        ["^","# Локация: {location}\n"],
        ["^","На поле растут красивые цветы, и пчелы жужжат. Это конец вашей истории.\n"],
        ["->","END"],
        ["== назад_к_началу ==\n"],
        ["^","# Локация: {location}\n"],
        ["->","start"],
        ["== END ==\n"],
        ["-> DONE"],
        ["==="]
    ]
};

window.onload = function () {
  const story = new inkjs.Story(storyContent);

  const locationDiv = document.getElementById('location');
  const locationImage = document.getElementById('locationImage');
  const storyTextDiv = document.getElementById('storyText');
  const choicesDiv = document.getElementById('choices');

  // Картинки локаций (положите такие изображения рядом с index.html либо пропишите ваши пути)
  // Для демонстрации используем ссылки на бесплатные картинки из интернета, чтобы это работало без файлов.
  const imageMap = {
    "Лес — начало": "https://i.imgur.com/Rgx4UwB.jpg",
    "Лес — левая тропа": "https://i.imgur.com/LHnZ3tf.jpg",
    "Хижина": "https://i.imgur.com/bN4DkDr.jpg",
    "Лес — дальше по левой тропе": "https://i.imgur.com/Rgx4UwB.jpg",
    "Лес — правая тропа": "https://i.imgur.com/85bCxuS.jpg",
    "Поле": "https://i.imgur.com/R51XSwr.jpg"
  };

  function continueStory() {
    // Получаем весь следующий текст (до следующего выбора)
    let text = '';
    while (story.canContinue) {
      text += story.Continue() + '\n';
    }
    storyTextDiv.textContent = text.trim();

    // Убираем старые кнопки выбора
    choicesDiv.innerHTML = '';

    // Текущая локация
    const location = story.variablesState['location'] || '';

    // Обновляем локацию и картинку
    locationDiv.textContent = "Локация: " + location;

    if (imageMap[location]) {
      locationImage.src = imageMap[location];
      locationImage.style.display = "block";
      locationImage.alt = location;
    } else {
      locationImage.style.display = "none";
    }

    // Если история закончилась
    if (story.currentChoices.length === 0) {
      let restartBtn = document.createElement('button');
      restartBtn.textContent = "Начать заново";
      restartBtn.onclick = () => {
        locationImage.style.display = "block";
        story.ResetState();
        continueStory();
      };
      choicesDiv.appendChild(restartBtn);
    } else {
      // Добавляем кнопки для текущих выборов
      story.currentChoices.forEach((choice, i) => {
        let button = document.createElement('button');
        button.textContent = choice.text.trim();
        button.onclick = () => {
          story.ChooseChoiceIndex(i);
          continueStory();
        };
        choicesDiv.appendChild(button);
      });
    }
  }

  continueStory();
};
</script>

</body>
</html>
