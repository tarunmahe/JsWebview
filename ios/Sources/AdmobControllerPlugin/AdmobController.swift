import Foundation
import UIKit
import WebKit

@objc public class AdmobController: NSObject, WKNavigationDelegate {
    private var webView: WKWebView?
    private var viewController: UIViewController?
    private var closeButton: UIButton?

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
            // Create configuration that disables bouncing and zooming
            let config = WKWebViewConfiguration()

            // Create a container view with black background for safe area
            let containerView = UIView(frame: UIScreen.main.bounds)
            containerView.backgroundColor = .black

            // Create the web view with configuration - position to respect safe area
            self.webView = WKWebView(frame: .zero)
            self.webView?.navigationDelegate = self

            // Disable scrolling and bouncing
            self.webView?.scrollView.isScrollEnabled = false
            self.webView?.scrollView.bounces = false

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
        let block = {
            self.viewController?.dismiss(animated: true)
            self.viewController = nil
            self.webView = nil
            self.closeButton = nil
        }

        DispatchQueue.main.async(group: nil, qos: .default, flags: [], execute: block)

        return true
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


}
