# ПРИМЕР ПРОЕКТА НА ОСНОВЕ SwiftCoordinatorsKit

Проект создан для демонстрации использованиия SwiftCoordinatorsKit в проекте.

## Структура проекта

В составе проекта используются пять координаторов:

- `AppCoordinator` - координатор приложения. 
- `SceneCoordinator` - координатор сцены.
- `MainFlowCoordinator` - координатор основного потока выполнения экземпляра приложения.
- `InitializatorCoordinator` - координатор инициализации.
- `FunctionalCoordinator` - координатор, предназначенный для выполнения приложением своих функций.

### Фабрика координаторов

Для создания коориднаторов в проекте используется фабрика `CoordinatorFactory`.

### Координатор `AppCoordinator`

Данный координатор входит в состав SwiftCoordinatorsKit и используется в проекте в исходном виде. Он создается и внедряется в файле `AppDelegate.swift`.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // координатор приложения
    var coordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Создание координатора приложения
        coordinator = CoordinatorFactory.getAppCoordinator()
        // Запуск потока координатора
        coordinator.startFlow(finishCompletion: nil)
        return true
    }
    
    // ...
    
}
```

Данный координатор является старшим в приложении, все остальные координаторы находятся ниже его. Его основная задача в следующем:
- принимать события, поступающие в приложение из вне и передавать дальше в приложение.
- передавать данные между отдельными сценами (если у проект может быть запущен в режиме нескольких окон). 

Для `AppCoordinator` не вызывается метод запуска потока `startFlow`, но при необходимости вы можете это сделать, если требуется выполнить какую-либо работу (например осуществить подключение к базе данных или общим для приложения ресурсам/микросервисам), передав в него соответствующее замыкание.

В данном примере `AppCoordinator` не имеет какой-лиюо связи с "внешним миром", но в собственном проекте вы можете настроить его, на прием и передачу поступающих push-уведомлений, событий и т.д.

### Координатор `SceneCoordinator`

Данный координатор входит в состав SwiftCoordinatorsKit и используется в проекте в исходном виде. Он создается и внедряется в файле `SceneDelegate.swift`.

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // ...
    // координатор сцены
    var coordinator: SceneCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return
        }
        window.windowScene = windowScene
        
        // создание координатор сцены
        coordinator = CoordinatorFactory.getSceneCoordinator(appCoordinator: (UIApplication.shared.delegate as! AppDelegate).coordinator, window: window)
        // создание координатора основного потока
        let mainFlowCoordinator = CoordinatorFactory.getMainFlowCoordinator(rootCoordinator: coordinator)
        mainFlowCoordinator.startFlow()
        window.makeKeyAndVisible()
        
    }
    
    // ...
    
}
```
Данный координатор является основным в рамках сцены и управляет всем, что происходит в ней. Обычно приложение имеет всего одну сцену, поэтому работает цепочка: `AppCoordinator` -> `SceneCoordinator` -> Множество дочерних координаторов.


Для `SceneCoordinator` не вызывается метод запуска потока `startFlow`, но при необходимости вы можете это сделать, если требуется выполнить какую-либо работу (например осуществить подключение к базе данных или т.д.), передав в него соответствующее замыкание.

### Координатор `MainFlowCoordinator`

### Координатор `InitializatorCoordinator`

### Координатор `FunctionalCoordinator`
