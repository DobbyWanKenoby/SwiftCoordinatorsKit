/*
 Фабрика вью контроллеров
 Используется для удобного создания и получения экземпляров классов контроллеров
 */

import UIKit

class ControllerFactory {
    
    // Контроллер инициализатора приложения
    // Запускается и отображается первым и в процессе того, как координатор производит различные первичные операции, вроде загрузки данных из сети, сохранения данных в базу и т.д.
    static func getGreenController() -> GreenControllerProtocol {
        return GreenController.getInstance()
    }
    
    // Контроллер, предназначенный для отображения основного интерфейса приложения
    // Запускается и отображается после окончания работы InitializationCoordinator
    static func getRedController() -> RedControllerProtocol {
        return RedController.getInstance()
    }

}
