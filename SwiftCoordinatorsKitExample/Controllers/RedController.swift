import UIKit

/*
 Контроллер, отображаемый в ходе работы FunctionalCoordinator
 Предназначен для отображения основного интерфейса приложения
 */

protocol RedControllerProtocol where Self: UIViewController {}

class RedController: UIViewController, RedControllerProtocol {

    var initializationDidEnd: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
}
