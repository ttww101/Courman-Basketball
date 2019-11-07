import Foundation

extension RequestToken {
func cancelCanRun(_ message: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
}
