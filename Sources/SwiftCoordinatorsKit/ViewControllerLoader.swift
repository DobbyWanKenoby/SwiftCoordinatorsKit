import UIKit

// Точка входа в любой контроллер - метод getInstance
// Сам определяет, создан ли контрллер с помощью Storyboard или кодом
extension UIViewController {
    static func getInstance() -> Self {
        if let controller = (Self() as? StoryboardBasedViewController) {
            return controller.getInstanceFromStoryboard() as! Self
        } else {
            return Self()
        }
    }
}

// View Controller должен быть подписан на протокол StoryboardBasedViewController, если он создается на основе Storyboard
// Точка входа в любой ViewController - статический метод getInstance()
// он сам определяет, грузить Controller со Storyboard или создавать напрямую
public protocol StoryboardBasedViewController: AnyObject {
    /// Storyboard ID контроллера в storyboard-файле
    var viewControllerIdentifier: String { get }
    /// Имя storyboard файла, где хранится контроллер
    var storyboardFileName: String { get }
    /// получение экземпляра контроллера
    func getInstanceFromStoryboard() -> Self
}

extension StoryboardBasedViewController where Self: UIViewController {
    func getInstanceFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardFileName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! Self
    }
}
