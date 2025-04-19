import Foundation

@objc public class AdmobController: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
