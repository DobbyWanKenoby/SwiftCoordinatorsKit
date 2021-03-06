/*
 InitializatorCoordinator - координатор инициализации
 Предназначен для выполнения различных процедур инцииализации приложения, например загрузки обновлений из сети
 
 Данный координатор является Презентером, и для отображения процесса инициализации используется вью контроллер, хранящийся в свойстве presenter
 */

import UIKit

protocol InitializatorCoordinatorProtocol: BasePresenter, Transmitter {}

final class InitializatorCoordinator: BasePresenter, InitializatorCoordinatorProtocol {
    var edit: ((Signal) -> Signal)?
    
    override func startFlow(withWork work: (() -> Void)? = nil, finishCompletion: (() -> Void)? = nil) {
        super.startFlow(withWork: work, finishCompletion: finishCompletion)
        (self.presenter as? GreenControllerProtocol)?.initializationDidEnd = {
            // действия на контроллере, которые будут выполнены в конце инициализации
            self.finishFlow()
        }
        // тут могут быть различные операции инициализации
        // вроде загрузки данных из сети
        // при этом можно настроить обмен данными с базовым вью контроллером
        // чтобы отображать процесс выполнения операций

    }

    
}
