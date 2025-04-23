import Foundation
import UIKit
import WebKit

@objc public class AdmobController: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    private var webView: WKWebView?
    private var viewController: UIViewController?
    private var closeButton: UIButton?
    private let messageHandlerName = "controllerHandler" // Define a name for the message handler

    // Custom view controller class that supports all orientations
    private class WebViewController: UIViewController {
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .all  // Support all orientations
        }

        override var prefersStatusBarHidden: Bool {
            return true  // Hide status bar for fullscreen experience
        }
    }

    @objc public func open(url: String, showCloseButton: Bool = false) -> Bool {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return false
        }

        let block = {
            // Create configuration with user content controller
            let config = WKWebViewConfiguration()
            let userContentController = WKUserContentController()
            // Add the message handler
            userContentController.add(self, name: self.messageHandlerName)
            config.userContentController = userContentController

            // Create a container view with black background for safe area
            let containerView = UIView(frame: UIScreen.main.bounds)
            containerView.backgroundColor = .black

            // Create the web view with the updated configuration
            self.webView = WKWebView(frame: .zero, configuration: config) // Use the new config
            self.webView?.navigationDelegate = self

            // Allow scrolling and bouncing (removed disabling lines)
            // self.webView?.scrollView.bounces = false // Keep bouncing disabled or enable as needed

            // Setup auto layout for the web view
            self.webView?.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(self.webView!)

            // Load the URL
            self.webView?.load(URLRequest(url: url))

            // Create the custom view controller for presentation
            let vc = WebViewController()
            vc.view = containerView
            vc.modalPresentationStyle = .fullScreen

            // Setup constraints for the web view to respect safe area
            NSLayoutConstraint.activate([
                self.webView!.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor),
                self.webView!.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor),
                self.webView!.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor),
                self.webView!.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor)
            ])

            // Add close button if requested
            if showCloseButton {
                let closeButton = UIButton(type: .system)
                closeButton.setTitle("Close", for: .normal)
                closeButton.addTarget(self, action: #selector(self.closeButtonTapped), for: .touchUpInside)
                closeButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
                closeButton.setTitleColor(.white, for: .normal)
                closeButton.layer.cornerRadius = 15

                closeButton.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(closeButton)

                NSLayoutConstraint.activate([
                    closeButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
                    closeButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                    closeButton.widthAnchor.constraint(equalToConstant: 60),
                    closeButton.heightAnchor.constraint(equalToConstant: 30)
                ])

                self.closeButton = closeButton
            }

            // Present the view controller
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.present(vc, animated: true)
                self.viewController = vc
            }
        }

        DispatchQueue.main.async(group: nil, qos: .default, flags: [], execute: block)

        return true
    }

    @objc private func closeButtonTapped() {
        self.close()
    }

    @objc public func close() -> Bool {
        // Ensure dismissal and cleanup happens on the main thread
        DispatchQueue.main.async {
            // Check if viewController exists before attempting to dismiss
            guard let vc = self.viewController else {
                // If already dismissed or nil, clean up remaining resources
                self.cleanupResources()
                return
            }

            vc.dismiss(animated: true) {
                // Clean up resources in the completion handler after dismissal
                self.cleanupResources()
            }
        }
        return true
    }

    // Helper function for cleanup to avoid repetition
    private func cleanupResources() {
        // Use optional chaining for safety
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: self.messageHandlerName)
        self.viewController = nil
        self.webView = nil
        self.closeButton = nil
    }

    // WKNavigationDelegate method to prevent navigation to other pages if needed
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Allow all navigations within the WebView
        decisionHandler(.allow)
    }

    // Handle SSL certificate issues
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.useCredential, nil)
            return
        }
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }

    // MARK: - WKScriptMessageHandler Delegate
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Check if the message is from our handler
        if message.name == messageHandlerName {
            // Process the message body
            // The body can be any object that JS can send (String, Number, Dictionary, Array, etc.)
            print("Received message from JS: \(message.body)")

            // Example: Handle different message types or data
            if let messageBody = message.body as? String {
                if messageBody == "close" {
                    // If JS sends "closeAd", close the webview
                    self.close()
                } else {
                    // Handle other string messages
                    print("Received string message: \(messageBody)")
                }
            } else if let messageDict = message.body as? [String: Any] {
                // Handle dictionary messages
                print("Received dictionary message: \(messageDict)")
                if let action = messageDict["action"] as? String, action == "close" {
                     self.close()
                }
            }
            // Add more handling as needed for different data types or structures
        }
    }
}
