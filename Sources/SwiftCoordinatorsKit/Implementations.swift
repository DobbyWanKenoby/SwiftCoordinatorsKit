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
    public init(rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
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
    
    public init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        super.init(rootCoordinator: rootCoordinator, options: options)
        if let presenter = presenter {
            self.presenter = presenter
        }
    }
    
    @discardableResult
    public init(rootCoordinator: Coordinator? = nil) {
        super.init(rootCoordinator: rootCoordinator)
    }
}

// MARK: Координатор приложения

/// Координатор приложения создается на уровне AppDelegate и управляет работой приложения, общими ресурсами и передачей данных на уровне приложения в целом.
open class AppCoordinator: BaseCoordinator, Transmitter {
    public var edit: ((Signal) -> Signal)?
    
    public required init(options: [CoordinatorOption] = []) {
        super.init(rootCoordinator: nil, options: options)
    }
    
    convenience init() {
        self.init(rootCoordinator: nil)
    }
    
    @discardableResult
    public override init(rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        if rootCoordinator != nil {
            fatalError("init(rootCoordinator:options:) has not been implemented")
        }
        super.init(rootCoordinator: nil, options: options)
    }
    
}

// MARK: Координатор сцены

/// Координатор сцены создается на уровне SceneDelegate и управляет работой сцены, передачей данных и общими ресурсами на уровне сцены.
///
/// В режиме работы с несколькими сценами (например на iPad) у каждой из них будет свой SceneCoordinator
open class SceneCoordinator: BasePresenter, Transmitter {
    public var edit: ((Signal) -> Signal)?
    
    // ссылка на окно, в котором отображается интерфейс
    var window: UIWindow!
    
    // при изменении значения
    open override var presenter: UIViewController? {
        didSet {
            window.rootViewController = presenter
            window.makeKeyAndVisible()
        }
    }
    
    convenience init(appCoordinator: AppCoordinator, window: UIWindow, options: [CoordinatorOption] = []) {
        self.init(presenter: nil, rootCoordinator: appCoordinator, options: options)
        self.window = window
    }
    
    
}
