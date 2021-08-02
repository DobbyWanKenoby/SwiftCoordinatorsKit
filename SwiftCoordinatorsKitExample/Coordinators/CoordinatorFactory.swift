/*
 Фабрика координаторов
 Используется для удобного создания и получения экземпляров классов координаторов
 */

import UIKit
import SwiftCoordinatorsKit

class CoordinatorFactory {
    
    // MARK: Главный координатор приложения
    @discardableResult
    static func getAppCoordinator() -> AppCoordinator {
        return AppCoordinator()
    }
    
    // MARK: Координатор сцены
    @discardableResult
    static func getSceneCoordinator(appCoordinator: AppCoordinator, window: UIWindow) -> SceneCoordinator {
        return SceneCoordinator(appCoordinator: appCoordinator, window: window)
    }
    
    // MARK: Координатор основного потока
    @discardableResult
    static func getMainFlowCoordinator(rootCoordinator: Coordinator) -> MainFlowCoordinatorProtocol {
        return MainFlowCoordinator(rootCoordinator: rootCoordinator)
    }
    
    // MARK: Координатор инициализации
    // Используется для обеспечения процесса загрузки приложения
    // и отображения результатов этой загрузки
    @discardableResult
    static func getInitializatorCoordinator(rootCoordinator coordinator: Coordinator?) -> InitializatorCoordinatorProtocol {
        let controller = ControllerFactory.getGreenController()
        return InitializatorCoordinator(presenter: controller, rootCoordinator: coordinator)
    }
    
    // MARK: Координатор основного функционала
    // Используется для работы с основными функциями приложения
    // запускается после отбработки координатора инициализации
    @discardableResult
    static func getFunctionalCoordinator(rootCoordinator: Coordinator?) -> FunctionalCoordinatorProtocol {
        return FunctionalCoordinator(rootCoordinator: rootCoordinator)
    }


}
