// Базовый протоколо, которому должен соответствовать юбой координатор
public protocol Coordinator: class {
    // Настройки координатора
    var options: [CoordinatorOption] { get }
    // Замыкание, которое будет выполнено по завершению потока
    var finishCompletion: (() -> Void)? { get set }
    // ссылка на родительский координатор
    var rootCoordinator: Coordinator? { get set }
    // ссылки на дочерние координаторы
    var childCoordinators: [Coordinator] { get set }
    // старт работы координатора
    func startFlow(finishCompletion: (() -> Void)?)
    // завершение рабоыт координатора
    // при этом выполняется замыкание, переданное в startFlow
    func finishFlow()
}

extension Coordinator {

    func startFlow(finishCompletion: (() -> Void)? = nil) {
        self.finishCompletion = finishCompletion
    }
    
    public func finishFlow() {
        self.finishCompletion?()
        if let rootCoordinator = rootCoordinator  {
            for (index, child) in rootCoordinator.childCoordinators.enumerated() {
                if child === self {
                    rootCoordinator.childCoordinators.remove(at: index)
                    child.rootCoordinator = nil
                }
            }
        }
        childCoordinators.forEach { (coordinator) in
            coordinator.finishFlow()
        }
    }
    
}

// Настройки координатора
public enum CoordinatorOption {
    
    // Общий координатор
    // Данный в такой координатор передаются даже в случае работы передющего координатора в режиме isolateMode
    case shared

    // Изолированный режим
    // сигналы передаются в родительский координатора, в дочерние-shared координаторы (isShared == true) и в дочерние контроллеры
    // в дочерние координаторы не передаются
    case isolateMode

    // Режим Транк
    // сигналы передаются только в указанные координаторы
    //case trunkMode(toCoordinators: [Coordinator], andControllers: [UIViewController])
}
