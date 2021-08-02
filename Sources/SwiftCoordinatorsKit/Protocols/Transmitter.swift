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
    
    // Передача данных, если координатор работает в режиме normal
    private func send(signalOnNormalMode signal: Signal, handledCoordinators: inout [Coordinator], resultSignals: inout [Signal]) {
        
        // передача в зависимые контроллеры
        getAllControllers().forEach { _c in
            if let _r = _c as? Receiver {
                if let answer =  _r.receive(signal: signal) {
                    resultSignals.append(answer)
                }
            }
        }
        
        // передача в зависимые координаторы
        getAllCoordinators().forEach { (_c) in
            if let _uc = _c as? Transmitter {
                _uc.send(signal: signal, handledCoordinators: &handledCoordinators, resultSignals: &resultSignals)
            } else if let _r = _c as? Receiver {
                if let answer =  _r.receive(signal: signal) {
                    resultSignals.append(answer)
                }
            }
        }
    }
    
    // Передача данных, если координатор работает в режиме isolate
    private func send(signalOnIsolateMode signal: Signal, handledCoordinators: inout [Coordinator], resultSignals: inout [Signal]) {
        
        // передача в зависимые контроллеры
        getAllControllers().forEach { _c in
            if let _r = _c as? Receiver {
                if let answer =  _r.receive(signal: signal) {
                    resultSignals.append(answer)
                }
            }
        }
        
        // передача в зависимые координаторы
        getAllCoordinators().forEach { (_c) in
            if let _uc = _c as? Transmitter,
               _uc.options.contains(.shared) || _c === self.rootCoordinator {
                _uc.send(signal: signal, handledCoordinators: &handledCoordinators, resultSignals: &resultSignals)
            } else if let _r = _c as? Receiver & Coordinator,
                      _r.options.contains(.shared) || _c === self.rootCoordinator {
                if let answer =  _r.receive(signal: signal) {
                    resultSignals.append(answer)
                }
            }
        }
    }
    
    // Передача данных, если координатор работает в режиме normal
//    private func send(signalOnTrunkMode signal: Signal,
//                      handledCoordinators: inout [Coordinator],
//                      resultSignals: inout [Signal],
//                      toCoordinators coordinators: [Coordinator] = [],
//                      andControllers controllers: [UIViewController] = []) {
//
//        // передача в зависимые контроллеры
//        getAllControllers().forEach { _c in
//            if controllers.contains(_c),  let _r = _c as? Receiver {
//                if let answer =  _r.receive(signal: signal) {
//                    resultSignals.append(answer)
//                }
//            }
//        }
//
//        // передача в зависимые координаторы
//        getAllCoordinators().forEach { (_c) in
//            if coordinators.contains(where: { $0 === _c }) {
//                // Сперва передаем сигнал в ресиверы
//                if let _r = _c as? Receiver {
//                    if let answer =  _r.receive(signal: signal) {
//                        resultSignals.append(answer)
//                    }
//                }
//                // Далее передаем сигнал в трансмиттеры
//                if let _uc = _c as? Transmitter {
//                    _uc.send(signal: signal, handledCoordinators: &handledCoordinators, resultSignals: &resultSignals)
//                }
//            }
//        }
//    }
    
    // Возвращает массив всех связанных координаторов
    // включая родительский и дочерние
    private func getAllCoordinators() -> [Coordinator] {
        var allCoordinators: [Coordinator] = []
        if let _rc = self.rootCoordinator {
            allCoordinators.append(_rc)
        }
        if childCoordinators.count > 0 {
            allCoordinators += childCoordinators
        }
        return allCoordinators
    }
    
    // Возвращает массив всех связанных контроллеров
    // включая презентер (главный) и дочерние
    private func getAllControllers() -> [UIViewController] {
        var allControllers: [UIViewController] = []
        if let presenter = self as? Presenter {
            allControllers = presenter.childControllers
            if let _p = presenter.presenter {
                allControllers.append(_p)
            }
        }
        return allControllers
    }
    
    // Дальнейшая передача данных, но с учетом списка координаторов, которые уже обработали данный сигнал
    // Используется, чтобы исключить повторную обратную передачу
    private func send(signal inputSignal: Signal, handledCoordinators: inout [Coordinator], resultSignals: inout [Signal]) {
        guard handledCoordinators.firstIndex(where: { $0 === self }) == nil else {
            return
        }
        handledCoordinators.append(self)
        
        // если текущий координатор - ресивер, то вызываем соответсвующий методы
        if let _r = self as? Receiver {
            if let result = _r.receive(signal: inputSignal) {
                resultSignals.append(result)
            }
        }
        
        // изменение сигнала
        let signal = edit(signal: inputSignal)
        
        // определение режима работы координатора и дальнейшая рассылка сигнала
        if options.contains(.isolateMode) {
            send(signalOnIsolateMode: signal,
                 handledCoordinators: &handledCoordinators,
                 resultSignals: &resultSignals)
        } else {
            send(signalOnNormalMode: signal,
                 handledCoordinators: &handledCoordinators,
                 resultSignals: &resultSignals)
        }
//        switch mode {
//        case .normal:
            
//        case .trunk(toCoordinators: let coordinators, andControllers: let controllers):
//            send(signalOnTrunkMode: signal,
//                 handledCoordinators: &handledCoordinators,
//                 resultSignals: &resultSignals,
//                 toCoordinators: coordinators,
//                 andControllers: controllers)
//        case .isolate:
            
//        }
        
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
