import UIKit

/*
 Контроллер, отображаемый в ходе работы FunctionalCoordinator
 Предназначен для отображения основного интерфейса приложения
 */

protocol FunctionalControllerProtocol where Self: UIViewController {}

class FunctionalController: UIViewController, FunctionalControllerProtocol {

    var initializationDidEnd: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
}
