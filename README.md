> В составе проекта есть пример приложения, созданного с использовванием координаторов. Подробнее об этом в разделе про установку `SCK`.

# SwiftCoordinatorsKit (SCK)

Библиотека на Swift для, создания и использования __координаторов__ в проекте. С помощью `SCK` вы можете как создавать собственные коордтинаторы, так и использовать входящие в состав библиотеки. 

__Платформа__: iOS UIKit

## Основные возможности SCK

Основная возможность SCK - это __создание иерархии координаторов__ и вью контроллеров. 
__Координаторы__ могут решать одну или несколько следующих задач:

1. Управление логикой и способом отображения сцен (вью контроллеров).
2. Передача данных внутри приложения и их обработка:
 - Координатор может создавать данные и отправлять их в иерархию.
 - Координатор и вью контроллер могут принимать данные, передаваемые внутри иерархии.
 - Координатор может изменять и передавать дальше измененные данные.
 - Координатор и вью контроллер могут обрабатывать поступающие в них данные

__Контроллеры__ предназначены исключительно для отображения интерфейса.

Вся функциональность SCK основана на использовании протоколов, все взаимодействие всех элементов идет через протоколы. Функциональные возможности координаторов определяются перечнем протоколов из состава SCK, на которые они подписаны. SCK имеет ряд базовых реализаций координаторов уже наделенных предварительной функциональностью.

## Преимущества использования SCK

Использование SCK позволяет добиться следующих **преимуществ**:

- максимально низкая связанность между элементами приложения (в частности между вью контроллерами);
- переиспользуемость сцен/вью контроллеров, их независимость от порядка и способа отображения;
- упрощение процесса передачи данных между сценами и внутри приложения, снятие этой обязанности с вью контроллеров;
- возможность создания Микросервисов, реализующих конкретную функциональность;
- повышения удобства тестирования (координатор может быть с легкостью замокан или протестирован).

## Описание 

### Словарь

- __Иерархия__ - Координаторы, Презентеры, Трансмиттеры и Ресиверы, организующие собой структуру Дерево с единым корнем.
- __Координатор__ - класс, подписанный на протокол `Coordinator`. Может быть в подчиненности у другого координатора и/или иметь подчиненне координаторы. 
- __Презентер__ - координатора, подписанный на протокол `Presenter`. Может отображать сцены на экране устройства.
- __Трансмиттер__ - координатор, подписанный на протокол `Transmitter`. Может принимать и передавать данные по иерархии.
- __Ресивер__ - трансмиттер, подписанный на протокол `Receiver`. Может реагировать на поступающие данные (обабатывать и/или изменять их).

### Создание иерархии координаторов и вью контроллеров

Координаторы реализуют структуру данных "Дерево", где у каждого координатора может быть один родитель и произвольное количество сыновей. Приложение должно иметь один главный координатор и множество дочерних, каждый из которых может иметь свое множество дочерних координаторов, и т.д.

На рисунке приведен пример структуры координаторов одной из версий приложения [**SubsTracker - трекер подписок**](https://github.com/DobbyWanKenoby/SubsTracker)

![Пример иерархии](https://github.com/DobbyWanKenoby/SubsTracker/raw/main/_tmp/AppScheme.png)

Как видно в составе проекта присутствует главный координатор приложения `ApplicationCoordinator`, и множество подчиненных. 

`ApplicationCoordinator` производит предварительную настройку прилоежния, в том числе создавая все необходимые дочерние координаторы (в том числе микросервисы). 

`InitializationCoordinator` предназначен для инициализации данных приложения, он запускается и отображается первым после `ApplicationCoordinator`. В нем производится проверка наличия новых данных на сервера, а так же отображается "анимированный SplashScreen" с индикатором загрузки.

`FunctionalCoordinator` предназначен для решения основных функций приложения - управления списком подписок.

Как видно из примера, координаторы находятся состоянии "отец-сын", а некоторые контроллеры многократно переиспользуются в различных координаторах.

Так же из примера видно, что в составе проекта созданы несколько __микросервисов__, каждый из которых отвечает за реализацию какой-то уникальной функциональности внутри приложения, например сохранения определенной сущности в базу данных, или создание нотификаций, или получения данных из сети, или организация работы с CoreData и т.д.

### Управление логикой и способом отображения сцен

__Координатор-презентер__ имеет один базовый вью контроллер, с помощью которого он отображает интерфейс. Обычно в качестве базового устанавливают контейнерный контроллер(Tab Bar Controller или Navigation Controller). Или если координатор должен отображать всего одну сцену без TabBar или NavigationBar, то в качестве базового может выступать любой вью контроллер.

__Координатор-презентер__ определяет:

- логику отображения сцен (какая сцена и когда должна быть отображена).
- способ отображения сцен (present, в стеке Navigation Contoller и т.д.).
- наполняет вью контроллер данными в соответствии с его протоколом.

> **Пример**
> 
> У вас есть дерево координаторов `RootCoordinator` > `ChildCoordinator` в состоянии подчиненности друг к другу.
> `RootCoordinator` в качестве презентера имеет `TabBarController`. 
> `BaseCoordinator` в качестве презентера имеет `NavigationController`. 
> Итоговый интерфейс будет включать два контейнерных контроллера: сперва будет идти `TabBarController`, а в него вложен `NavigationController`.
> И уже в `NavigationController` вы сможете отображать необходимые вам сцены.

Координатор, при необходимости, может иметь множество подчиненных вью контроллеров (сцен), отображением которых он управляет, и которые отображает внутри базового контроллера. Все подчиненные сцены (вью контроллеры) содержатся в свойстве `childControllers` координатора.

> **Пример**
> 
> В дополнении к предыдущему Примеру у `BaseCoordinator` в свойстве `childControllers` есть некоторый вью контроллер, чья сцена в итоге и будет выведена на экран. При этом она будет обернута в `NavigationController`, а он в свою очередь обернут в `TabBarController`.

Стоит отметить, что один и тот же вью контроллер может быть подчиненным разных координаторов, то есть он может переиспользоваться.

### Работа с данными внутри иерархии.

Внутри иерархии координаторов и вью контроллеров могут передаваться данные. Для этого используется специальный формат, имеющий название "Сигнал" (Signal). Сигнал отправляется в иерархию и распространяется по всем ее элементам, каждый из которых может принять и обработать данные.
    
> **Пример**
> 
> Если на одном из экранов приложения создается некий объект, который должен быть распространен на другие экраны, то данные могут передаваться по иерархии координаторов, пока не достигнут места (или мест) назначения. 
> 
> Например, приложение "Заметки". Экран создания "Заметки" не должен создавать заметку, он должен лишь предоставлять графический интерфейс для ее создания. После нажатия на кнопку "Сохранить" сущность "Заметка" упаковывается в Сигнал и отправляется по иерархии координаторов и вью контроллеров. При достижении экрана со списком заметок - она добавляется в него, а при достижении координатора, обеспечивающего сохранение заметок - она сохраняется в долговременное хранилище.

## Координаторы и потоки (flow) 

Координатор создается, когда в приложении необходимо выделить решение некоторой задачи. В контексте SCK процесс функционирования координатора называется **потоком** (flow). После того, как координатор создан и готов к выполнению возложенных на него функций - необходимо запустить поток, вызвав метод `startFlow()`. При завершении поток вызывается метод `finishFlow()`.

> **Пример**
> 
> Координатор `ApplicationCoordinator` может решать задачу обеспечения работы приложеняи в целом, в частности определения стартового экрана (в зависимости от того, залогинен ли пользователь), загрузку вспомогательных библиотек и т.д. Образно говоря, он создает поток `Application`.
> 
> Координатор `AuthCoordinator` (будет дочерним по отношению к `ApplicationCoordinator`) может обеспечивать работу авторизированного пользователя и предоставлять доступ к соответствующим сценам (главный экран приложения, экран настроек и т.д.).
> 
> Координатор `NotAuthCoordinator` (будет дочерним по отношению к `ApplicationCoordinator`) может обеспечивать работу неавторизированного пользователя и предоставлять доступ к соответствующим сценам (экран авторизации, регистрации и т.д.).

Дочерний координатор функционирует в рамках родительского потока, при этом создает свой собственный поток.

# Использование SCK

Суть использования SCK заключается в установке библиотеки, создании (при необходимости, т.к. вы можете использовать координаторы, доступные "из коробки") и внедрении координаторов.

## Шаблон проекта

> 
> В составе библиотеки есть готовый пример проекта с несколькими координаторами. В нем вы можете посмотреть порядок их создания и использования.
> Проект можно посмотреть в составе проекта в папке [`SwiftCoordinatorsKitExample`](https://github.com/DobbyWanKenoby/SwiftCoordinatorsKit/tree/main/SwiftCoordinatorsKitExample), или установил библиотеку с помощью Swift Package Manager, и посмотреть его в Xcode.
> 

## Установка SCK

### Swift Package Manager

>
>	 Другие менеджеры зависимостей не поддерживаются
>

- Откройте проект в Xcode, в который требуется добавить SCK
- Перейдите к настройкам проекта
- Выберите вкладку Swift Packages
- Нажмите кнопку "+" (Add Package Dependency)
- Введите адрес репозитоия (https://github.com/DobbyWanKenoby/SwiftCoordinatorsKit) и нажмите кнопку "Next"
- Укажите загружаемую версию и нажмите кнопку "Next"
- Дождитесь установки

## Использование SCK в проекте

### Создание координаторов

#### Создание главного координатора приложения

#### Создание микросервиса

#### Создание презентера

### Передача и обработка данных

#### Передача данных

#### Обработка данных внутри координатора

#### Обработка данных внутри вью контроллера

## Дополнительные возможности

SCK предоставляет набор дополнительных функциональных возможностей, напрямую не относящихся к теме координаторов, но позволяющих повысить уровень удобства процесса разработки.

### Создание экземпляров вью контроллеров

Данные дополняются...




