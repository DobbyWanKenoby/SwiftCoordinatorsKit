import UIKit

// Типовые координаторы, которые могут быть использованы в проекте
// ТАк же на их основе можно создавать собственные координаторы

// MARK: Базовый координатор

/// Базовый координатор содержит базовую функциональность.
///
/// Рекоменудется наследовать собственные координаторы от данного.
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
    
    open func startFlow(withWork work: (() -> Void)? = nil, finishCompletion: (() -> Void)? = nil) {
        self.finishCompletion = finishCompletion
        work?()
    }

}

// MARK: Базовый презентер

/// Базовый координатор-презентер содержит базовую функциональность Презентера.
///
/// Рекоменудется наследовать собственные координаторы от данного.
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
///
/// Рекомендуется использовать данный координатор для управления на уровне приложения.
open class AppCoordinator: BaseCoordinator, Transmitter {
    public var edit: ((Signal) -> Signal)?
    
    public required init(options: [CoordinatorOption] = []) {
        super.init(rootCoordinator: nil, options: options)
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
/// В режиме работы с несколькими сценами (например на iPad) у каждой из них будет свой SceneCoordinator.
/// Рекомендуется использовать данный координатор для управления на уровне сцены.
open class SceneCoordinator: BasePresenter, Transmitter {
    public var edit: ((Signal) -> Signal)?
    
    // ссылка на окно, в котором отображается интерфейс
    public var window: UIWindow!
    
    // при изменении значения
    open override var presenter: UIViewController? {
        didSet {
            window.rootViewController = presenter
            window.makeKeyAndVisible()
        }
    }
    
    public convenience init(appCoordinator: AppCoordinator, window: UIWindow, options: [CoordinatorOption] = []) {
        self.init(presenter: nil, rootCoordinator: appCoordinator, options: options)
        self.window = window
    }
    
}
