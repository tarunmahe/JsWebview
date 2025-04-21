import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(AdmobControllerPlugin)
public class AdmobControllerPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AdmobControllerPlugin"
    public let jsName = "AdmobController"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "open", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "close", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = AdmobController()

    @objc func open(_ call: CAPPluginCall) {
        guard let url = call.getString("url") else {
            call.reject("Must provide a URL")
            return
        }

        // Get the optional showCloseButton parameter, default to false
        let showCloseButton = call.getBool("showCloseButton") ?? false

        let result = implementation.open(url: url, showCloseButton: showCloseButton)
        if result {
            call.resolve()
        } else {
            call.reject("Failed to open URL")
        }
    }

    @objc func close(_ call: CAPPluginCall) {
        let result = implementation.close()
        if result {
            call.resolve()
        } else {
            call.reject("Failed to close")
        }
    }
}
