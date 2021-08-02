import UIKit
import SwiftCoordinatorsKit

/*
 MainFlowCoordinator - Координатор основного потока выполнения экземпляра приложения.
 После запуска приложения и создания AppCoordinator, SceneCoordinator, данный координатор является основным управляющим в рамках экзмепляра приложения (сцены)
 */

protocol MainFlowCoordinatorProtocol: BasePresenter, Transmitter {}

class MainFlowCoordinator: BasePresenter, MainFlowCoordinatorProtocol {

    var isShared = false
    var mode: CoordinatorMode = .normal
    
    override var presenter: UIViewController? {
        didSet {
            (rootCoordinator as! SceneCoordinator).presenter = presenter
        }
    }
    
    required init(rootCoordinator: Coordinator? = nil) {
        super.init(rootCoordinator: rootCoordinator)
        presenter = nil
        //(rootCoordinator as! SceneCoordinator).presenter = presenter
    }
    
    required public init(presenter: UIViewController?, rootCoordinator: Coordinator? = nil) {
        fatalError("init(presenter:rootCoordinator:) has not been implemented")
    }
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        
        // Запускаем координатор Инициализации
        let initializatorCoordinator = CoordinatorFactory.getInitializatorCoordinator(rootCoordinator: self)
        // С помощью следующей строки кода
        // базовый контроллер InitializatorCoordinator станет базовым контроллером Scene Coordinator
        self.presenter = initializatorCoordinator.presenter
        // Запуск потока InitializatorCoordinator
        initializatorCoordinator.startFlow {
            
            // По окончании работы координатора инициализации
            // должен начать работу FunctionalCoordinator и отобразиться интерфейс приложения
            let functionalCoordinator = CoordinatorFactory.getFunctionalCoordinator(rootCoordinator: self)
            self.route(from: self.presenter!, to: functionalCoordinator.presenter!, method: .presentFullScreen) {}
            functionalCoordinator.startFlow()
                      
        }

    }
    
}
