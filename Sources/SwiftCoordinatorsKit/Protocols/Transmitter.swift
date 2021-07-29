import UIKit

// Координаторы могут передавать и обрабатывать данные
// Вью контроллеры могут только обрабатывать данные (передавать им некуда)
//
// Координаторы могут быть:
//  - трансмиттеры - получают данные и при возможности передают их далее. Так как координаторы образую дерево, то данные могут циркулировать внутри приложения
//  - ресиверы - обрабатывают принятые данные

// MARK: - Signal

// Передаваемые (transmit) и принимаемые/обрабатываемые (receive) данные должны быть подписаны на данный протокол
public protocol Signal {}

// MARK: - Transmitter

// Координатор-трансмиттер может передавать данные дальше в цепочке трансмиттеров.
// Данные передаются родительскому и дочерним координаторам сразу в обе стороны
// Ответ может быть отправлен в координатор, отправивший сигнал (source)
// или в другой указанный координатор
public protocol Transmitter where Self: Coordinator {
    // Передача данных в связанные координаторы и контроллеры
    // При таком запросе координатор не ожидает ответ
    // а если ответ все же будет , то он будет обработан в методе receive ресивера, указанного в параметре withAnswerToReceiver
    //  - signal - передаваемые данные
    //  - withAnswerToReceiver - приемник ответа, в который будут отправляться ответные сигналы
    //  - completion - обработчик ответных сигналов
    func broadcast(signal: Signal,
                   withAnswerToReceiver: Receiver?,
                   completion: ((_ answerSignal: Signal) -> Void)?)
    
    // Передача данных в связанные координаторы и контроллеры
    // При таком запросе координатор ожидает и обабатывает полученный ответ inline (то есть в качестве возвращаемого значения)
    //  - signalWithReturnAnswer - передаваемые данные
    //  - completion - обработчик ответных сигналов
    func broadcast(signalWithReturnAnswer: Signal,
                   completion: ((_ answerSignal: Signal) -> Void)?) -> [Signal]
    
    // Преобразование данных перед их дальнейшей передачей
    //  - signal - передаваемые данные
    // С помощью метода можно внести в данные изменения
    func edit(signal: Signal) -> Signal
}

extension Transmitter {
    
    public func edit(signal: Signal) -> Signal {
        return signal
    }
    
    public func broadcast(signalWithReturnAnswer signal: Signal,
                          completion: ((_ answerSignal: Signal) -> Void)? = nil ) -> [Signal] {
        var coordinators: [Coordinator] = []
        var resultSignals: [Signal] = []
        self.send(signal: signal, handledCoordinators: &coordinators, resultSignals: &resultSignals)
        // если передан обработчик ответных сигналов
        if let completion = completion {
            resultSignals.forEach { oneSignalAnswer in
                completion(oneSignalAnswer)
            }
        }
        return resultSignals
    }
    
    public func broadcast(signal: Signal,
                          withAnswerToReceiver receiver: Receiver?,
                          completion: ((_ answerSignal: Signal) -> Void)? = nil) {
        var coordinators: [Coordinator] = []
        var resultSignals: [Signal] = []
        self.send(signal: signal, handledCoordinators: &coordinators, resultSignals: &resultSignals)
        resultSignals.forEach { oneSignalAnswer in
            receiver?.receive(signal: oneSignalAnswer)
            if let completion = completion {
                completion(oneSignalAnswer)
            }
        }
    }
    
    // Дальнейшая передача данных, но с учетом списка координаторов, которые уже обработали данный сигнал
    // Используется, чтобы исключить повторную обратную передачу
    private func send(signal inputSignal: Signal, handledCoordinators: inout [Coordinator], resultSignals: inout [Signal]) {
        guard handledCoordinators.firstIndex(where: { $0 === self }) == nil else {
            return
        }
        handledCoordinators.append(self)
        
        let signal = edit(signal: inputSignal)
        
        // передача в дочерние контроллеры
        if let presenter = self as? Presenter {
            presenter.childControllers.forEach { childController in
                (childController as? Receiver)?.receive(signal: signal)
            }
        }
        
        if let root = rootCoordinator as? Transmitter {
            root.send(signal: signal, handledCoordinators: &handledCoordinators, resultSignals: &resultSignals)
        }
        childCoordinators.forEach { child in
            if let childReciever = child as? Receiver {
                if let answer = childReciever.receive(signal: signal) {
                    // отправляем ответ обратно
                   // answerReceiver?.receive(signal: answer)
                    resultSignals.append(answer)
                }
            }
            
            if let childTransmitter = child as? Transmitter {
                childTransmitter.send(signal: signal, handledCoordinators: &handledCoordinators, resultSignals: &resultSignals)
            }
        }
    }
}

// MARK: - Receiver

// Координатор-ресивер может обрабатывать принимаемые сигналы
public protocol Receiver {
    @discardableResult
    func receive(signal: Signal) -> Signal?
}

extension Receiver {
   public func receive(signal: Signal) -> Signal? {
        return nil
    }
}
