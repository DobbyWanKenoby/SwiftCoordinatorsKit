// Базовый протоколо, которому должен соответствовать юбой координатор
public protocol Coordinator: AnyObject {
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
