import UIKit

// Типовые координаторы, которые могут быть использованы в проекте
// ТАк же на их основе можно создавать собственные координаторы

// MARK: Базовый координатор
// При создании принимает ссылку на родительский коодинатор
open class BaseCoordinator: Coordinator {
    open var rootCoordinator: Coordinator? = nil
    open var childCoordinators: [Coordinator] = []
    open var finishCompletion: (() -> Void)? = nil
    @discardableResult
    required public init(rootCoordinator: Coordinator? = nil) {
        if let rootCoordinator = rootCoordinator {
            self.rootCoordinator = rootCoordinator
            self.rootCoordinator?.childCoordinators.append(self)
        }
    }
    
    open func startFlow(finishCompletion: (() -> Void)? = nil) {
        self.finishCompletion = finishCompletion
    }
    
    open func finishFlow() {
        self.finishCompletion?()
        if let rootCoordinator = rootCoordinator  {
            for (index, child) in rootCoordinator.childCoordinators.enumerated() {
               if child === self {
                    rootCoordinator.childCoordinators.remove(at: index)
                    child.rootCoordinator = nil
               }
           }
        }
    }
}

// MARK: Базовый презентер
// // При создании принимает ссылку на родительский коодинатор и контроллер, в котором будет отображать интерфейс (например Tab Bar Controller или Navigation Controller)
open class BasePresenter: BaseCoordinator, Presenter {
    open var childControllers: [UIViewController] = []
    open var presenter: UIViewController?
    required public init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil) {
        super.init(rootCoordinator: rootCoordinator)
        if let presenter = presenter {
            self.presenter = presenter
        }
    }
    
    @discardableResult required public init(rootCoordinator: Coordinator? = nil) {
        fatalError("init(rootCoordinator:) has not been implemented")
    }
}
