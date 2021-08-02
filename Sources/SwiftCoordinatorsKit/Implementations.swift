import UIKit

// Типовые координаторы, которые могут быть использованы в проекте
// ТАк же на их основе можно создавать собственные координаторы

// MARK: Базовый координатор
// При создании принимает ссылку на родительский коодинатор
open class BaseCoordinator: Coordinator {
    open var options: [CoordinatorOption] = []
    open var rootCoordinator: Coordinator? = nil
    open var childCoordinators: [Coordinator] = []
    open var finishCompletion: (() -> Void)? = nil
    @discardableResult
    required public init(rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        self.options = options
        if let rootCoordinator = rootCoordinator {
            self.rootCoordinator = rootCoordinator
            self.rootCoordinator?.childCoordinators.append(self)
        }
    }
    
    open func startFlow(finishCompletion: (() -> Void)? = nil) {
        self.finishCompletion = finishCompletion
    }

}

// MARK: Базовый презентер
// // При создании принимает ссылку на родительский коодинатор и контроллер, в котором будет отображать интерфейс (например Tab Bar Controller или Navigation Controller)
open class BasePresenter: BaseCoordinator, Presenter {
    open var childControllers: [UIViewController] = []
    open var presenter: UIViewController? = nil
    required public init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        super.init(rootCoordinator: rootCoordinator, options: options)
        if let presenter = presenter {
            self.presenter = presenter
        }
    }
    
    @discardableResult required public init(rootCoordinator: Coordinator? = nil) {
        super.init(rootCoordinator: rootCoordinator)
        //fatalError("init(rootCoordinator:) has not been implemented")
    }
    
    @discardableResult required public init(rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        fatalError("init(rootCoordinator:options:) has not been implemented")
    }
}

// MARK: Координатор приложения
// Создается на уровне AppDelegate
// Управляет общей работой приложения и всеми общими для приложения ресурсами
open class AppCoordinator: BaseCoordinator, Transmitter {
    
    public required init(rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        if rootCoordinator != nil {
            fatalError("AppCoordinator can not have root coordinator")
        }
        super.init(rootCoordinator: nil, options: options)
    }
    
    convenience init() {
        self.init(rootCoordinator: nil)
    }
    
}

// MARK: Координатор сцены
// Создается на уровне SceneDelegate
// Управляет работой сцены и всеми общими для сцены ресурсами
open class SceneCoordinator: BasePresenter, Transmitter {
    
    // ссылка на окно, в котором отображается интерфейс
    var window: UIWindow!
    
    // при изменении значения
    open override var presenter: UIViewController? {
        didSet {
            window.rootViewController = presenter
            window.makeKeyAndVisible()
        }
    }
    
    convenience init(appCoordinator: AppCoordinator, window: UIWindow) {
        self.init(presenter: nil, rootCoordinator: appCoordinator)
        self.window = window
    }
    
    
}
