
/// Координатор-ресивер может обрабатывать принимаемые сигналы
public protocol Receiver {
    @discardableResult
    func receive(signal: Signal) -> Signal?
}

extension Receiver {
   public func receive(signal: Signal) -> Signal? {
        return nil
    }
}
