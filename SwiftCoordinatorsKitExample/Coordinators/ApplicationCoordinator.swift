import UIKit
import SwiftCoordinatorsKit

/*
 ApplicationCoordinator - главный координатор приложения
 Может производить базовые для приложения задачи, загружать другие координаторы, создавать микросервисы и т.д.
 Он создается первым в SceneDelegate и далее производит загрузку остальных компонентов, а также запускается поток flow следующего координатора
 
 ApplicationCoordinator будет являться презентером и трансмиттером
 при этом он не будет иметь собственного отображаемого интерфейса,
 а будет транслировать через себя содержимое вложенных координаторов-презенторов
 */

protocol ApplicationCoordinatorProtocol: BasePresenter, Transmitter {
    // данный координатор имеет привязку к окну приложения
    var window: UIWindow? { get set }
}

final class ApplicationCoordinator: BasePresenter, ApplicationCoordinatorProtocol {
    //var rootCoordinator: Coordinator? = nil
    //var childCoordinators: [Coordinator] = []
    
    var window: UIWindow?
    
    override var presenter: UIViewController? {
        didSet {
            window?.rootViewController = presenter
            window?.makeKeyAndVisible()
        }
    }

    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        
        // Запускаем координатор Инициализации
        let initializatorCoordinator = CoordinatorFactory.getInitializatorCoordinator(rootCoordinator: self)
        // С помощью следующей строки кода
        // базовый контроллер InitializatorCoordinator станет базовым контроллером ApplicationCoordinator
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
