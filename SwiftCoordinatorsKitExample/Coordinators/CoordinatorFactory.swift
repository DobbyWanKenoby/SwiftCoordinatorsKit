/*
 Фабрика координаторов
 Используется для удобного создания и получения экземпляров классов координаторов
 */

import UIKit

class CoordinatorFactory {
    
    // MARK: Главный координатор приложения
    @discardableResult
    static func getAppCoordinator(options: [CoordinatorOption] = []) -> AppCoordinator {
        return AppCoordinator(options: options)
    }
    
    // MARK: Координатор сцены
    @discardableResult
    static func getSceneCoordinator(appCoordinator: AppCoordinator, window: UIWindow, options: [CoordinatorOption] = []) -> SceneCoordinator {
        return SceneCoordinator(appCoordinator: appCoordinator, window: window, options: options)
    }
    
    // MARK: Координатор основного потока
    @discardableResult
    static func getMainFlowCoordinator(rootCoordinator: Coordinator, options: [CoordinatorOption] = []) -> MainFlowCoordinatorProtocol {
        return MainFlowCoordinator(rootCoordinator: rootCoordinator, options: options)
    }
    
    // MARK: Координатор инициализации
    // Используется для обеспечения процесса загрузки приложения
    // и отображения результатов этой загрузки
    @discardableResult
    static func getInitializatorCoordinator(rootCoordinator coordinator: Coordinator?, options: [CoordinatorOption] = []) -> InitializatorCoordinatorProtocol {
        let controller = ControllerFactory.getGreenController()
        return InitializatorCoordinator(presenter: controller, rootCoordinator: coordinator, options: options)
    }
    
    // MARK: Координатор основного функционала
    // Используется для работы с основными функциями приложения
    // запускается после отбработки координатора инициализации
    @discardableResult
    static func getFunctionalCoordinator(rootCoordinator: Coordinator?, options: [CoordinatorOption] = []) -> FunctionalCoordinatorProtocol {
        return FunctionalCoordinator(rootCoordinator: rootCoordinator, options: options)
    }


}
