/*
 FunctionalCoordinator - координатор, предназначенный для выполнения приложением своих функций
 Запускается после InitializatorCoordinator и отображает интерфейс приложения
 */

import UIKit
import SwiftCoordinatorsKit

protocol FunctionalCoordinatorProtocol: BasePresenter, Transmitter {}

final class FunctionalCoordinator: BasePresenter, FunctionalCoordinatorProtocol {
    var isShared: Bool = false
    var mode: CoordinatorMode = .normal
    
    // используется для доступа к презентеру, как к Navigation Controller
    // свойство - синтаксический сахар
    var navigationPresenter: UINavigationController {
        presenter as! UINavigationController
    }
    
    required init(rootCoordinator: Coordinator? = nil) {
        super.init(rootCoordinator: rootCoordinator)
        presenter = UINavigationController()
    }
    
    required public init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil) {
        fatalError("init(presenter:rootCoordinator:) has not been implemented")
    }
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        
        let c = ControllerFactory.getRedController()
        navigationPresenter.viewControllers.append(c)
        
        // ...
        
    }

    
}
