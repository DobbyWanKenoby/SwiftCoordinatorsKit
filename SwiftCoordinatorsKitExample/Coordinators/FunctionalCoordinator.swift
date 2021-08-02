/*
 FunctionalCoordinator - координатор, предназначенный для выполнения приложением своих функций
 Запускается после InitializatorCoordinator и отображает интерфейс приложения
 */

import UIKit
import SwiftCoordinatorsKit

protocol FunctionalCoordinatorProtocol: BasePresenter, Transmitter {}

final class FunctionalCoordinator: BasePresenter, FunctionalCoordinatorProtocol {
    
    // используется для доступа к презентеру, как к Navigation Controller
    // свойство - синтаксический сахар
    var navigationPresenter: UINavigationController {
        presenter as! UINavigationController
    }
    
    required init(rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        super.init(presenter: nil, rootCoordinator: rootCoordinator, options: options)
        presenter = UINavigationController()
    }
    
    required public init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil) {
        fatalError("init(presenter:rootCoordinator:) has not been implemented")
    }
    
    @discardableResult required public init(rootCoordinator: Coordinator? = nil) {
        fatalError("init(rootCoordinator:) has not been implemented")
    }
    
    required public init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil, options: [CoordinatorOption] = []) {
        fatalError("init(presenter:rootCoordinator:options:) has not been implemented")
    }
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        
        let c = ControllerFactory.getRedController()
        navigationPresenter.viewControllers.append(c)
        
        // ...
        
    }

    
}
