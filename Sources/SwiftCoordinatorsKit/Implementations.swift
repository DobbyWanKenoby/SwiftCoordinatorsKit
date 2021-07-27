import UIKit

// MARK: - Template Coordinators

open class BaseCoordinator: Coordinator {
    public var rootCoordinator: Coordinator? = nil
    public var childCoordinators: [Coordinator] = []
    public var finishCompletion: (() -> Void)? = nil
    @discardableResult
    required public init(rootCoordinator: Coordinator? = nil) {
        if let rootCoordinator = rootCoordinator {
            self.rootCoordinator = rootCoordinator
            self.rootCoordinator?.childCoordinators.append(self)
        }
    }
    
    public func startFlow(finishCompletion: (() -> Void)? = nil) {
        self.finishCompletion = finishCompletion
    }
    
    public func finishFlow() {
        self.finishCompletion?()
        self.rootCoordinator?.removeChild(coordinator: self)
    }
}

open class BasePresenter: BaseCoordinator, Presenter {
    public var childControllers: [UIViewController] = []
    public var presenter: UIViewController?
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
