import UIKit

/*
 Контроллер, отображаемый в ходе работы InitializationCoordinator
 Предназначен для того, чтобы визуально отображать процесс инициализации приложения
 Чтобы в процессе загрузки необходимых данных не весел пустой экран
 
 На нем можно выводить анимированный SplashScreen, индикатор загрузки и т.д.
 */

protocol GreenControllerProtocol where Self: UIViewController {
    // замыкание, определяющее действие в конце инициализации
    var initializationDidEnd: (() -> Void)? { get set }
}

class GreenController: UIViewController, GreenControllerProtocol {

    var initializationDidEnd: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(1)
        initializationDidEnd?()
    }
    
}
