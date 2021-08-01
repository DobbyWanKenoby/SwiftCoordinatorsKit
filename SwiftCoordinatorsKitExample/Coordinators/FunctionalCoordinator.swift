/*
 FunctionalCoordinator - координатор, предназначенный для выполнения приложением своих функций
 Запускается после InitializatorCoordinator и отображает интерфейс приложения
 */

import UIKit
import SwiftCoordinatorsKit

protocol FunctionalCoordinatorProtocol: BasePresenter, Transmitter {}

final class FunctionalCoordinator: BasePresenter, FunctionalCoordinatorProtocol {
    
    override func startFlow(finishCompletion: (() -> Void)? = nil) {
        super.startFlow(finishCompletion: finishCompletion)
        
        // ...
        
    }

    
}
