import UIKit

// Координатор-презентор отвечает за отображение сцен на экране
// и переход между ними
public protocol Presenter where Self: Coordinator {
    // ссылки на дочерние контроллеры
    // используется, когда в свойстве presenter хранится контейнерный контроллер
    var childControllers: [UIViewController] { get set }
    var presenter: UIViewController? { get set }
    // Переход к экрану
    func route(from: UIViewController, to: UIViewController, method: RouteMethod, completion: (() -> Void)?)
    // Обратный переход с экрана
    func disroute(controller: UIViewController, method: DisrouteMethod, completion: (() -> Void)?)
}

extension Presenter {
    public func route(from sourceController: UIViewController, to destinationController: UIViewController, method: RouteMethod, completion: (() -> Void)? = nil) {
        switch method {
        case .custom(let transitionDelegate):
            destinationController.transitioningDelegate = transitionDelegate
            destinationController.modalPresentationStyle = .custom
            sourceController.present(destinationController, animated: true, completion: completion)
        case .presentFullScreen:
            sourceController.transitioningDelegate = nil
            destinationController.modalPresentationStyle = .fullScreen
            destinationController.modalTransitionStyle = .coverVertical
            sourceController.present(destinationController, animated: true, completion: completion)
        case .presentCard:
            sourceController.transitioningDelegate = nil
            sourceController.modalPresentationStyle = .none
            sourceController.modalTransitionStyle = .coverVertical
            sourceController.present(destinationController, animated: true, completion: completion)
        case .navigationPush:
            (sourceController as! UINavigationController).pushViewController(destinationController, animated: true)
            completion?()
        }
    }
    
    public func disroute(controller: UIViewController, method: DisrouteMethod, completion: (() -> Void)? = nil) {
        switch method {
        
        case .dismiss:
            controller.dismiss(animated: true, completion: completion)
        case .navigationPop:
            (controller as! UINavigationController).popViewController(animated: true)
            completion?()
        }
    }
}

// MARK: TransitionDelegate
// Используется в случае, когда необходимо отобразить сцену с помощью метода route используя кастомный Transition Delegate

public protocol SCKTransitionDelegate: UIViewControllerTransitioningDelegate {
    init(transitionData: TransitionData?)
}

extension SCKTransitionDelegate {
    public init(transitionData: TransitionData? = nil) {
        fatalError("This initializator can not used in \(Self.self) type")
    }
}

// Данные для UIViewControllerTransitioningDelegate, обеспечивающие кастомный переход
// Тут могут находиться произвольные данные, которые необходимо передать в UIViewControllerTransitioningDelegate
public protocol TransitionData {}

// Типы переходов между вью контроллерами
public enum RouteMethod {
    case presentCard
    case presentFullScreen
    case navigationPush
    case custom(SCKTransitionDelegate)
}

public enum DisrouteMethod {
    case dismiss
    case navigationPop
}
