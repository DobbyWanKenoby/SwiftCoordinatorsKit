import UIKit

// MARK: - Template Coordinators

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
        self.rootCoordinator?.removeChild(coordinator: self)
    }
}

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
