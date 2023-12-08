//
//  SurveyController.swift
//  Kukushka_iOSSDK
//
//  Created by Aleksunder Volkov on 08.11.2023.
//

import WebKit
import Foundation

protocol SurveyViewable {
    func start(with url: String)
    func show(completion: (() -> Void)?)
    func hide()
}

final class SurveyWebViewController: UIViewController {
    
    private let jsHandler: WKScriptMessageHandler
    private var webView: WKWebView?
    var webViewBottomConstraint: NSLayoutConstraint?
    
    private func setupWebView() {
        let preferences = WKPreferences()
        let webConfiguration = WKWebViewConfiguration()
        let userController: WKUserContentController = WKUserContentController()
        let source = JScripts.addEventListener
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userController.addUserScript(script)
        userController.add(jsHandler, name: "iosListener")
        webConfiguration.preferences = preferences
        webConfiguration.userContentController = userController
    
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.scrollView.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    init(with handler: WKScriptMessageHandler) {
        self.jsHandler = handler
        super.init(nibName: nil, bundle: nil)
        setupWebView()
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        guard let webView else {
            print("\(Constants.Environment.sdkName) webView haven't initilized")
            return
        }
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewBottomConstraint = webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        guard let webViewBottomConstraint else { return }
        let constraints = [
            webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webViewBottomConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
}

extension SurveyWebViewController: SurveyViewable {
    
    func start(with url: String) {
        guard let webView else {
            print("\(Constants.Environment.sdkName) webView haven't initilized")
            return
        }
        guard let url = URL(string: url) else {
            print("\(Constants.Environment.sdkName) wrong url")
            return
        }
        webView.load(URLRequest(url:url))
    }

    func show(completion: (() -> Void)? = nil) {
        self.webView?.evaluateJavaScript(JScripts.timerScript)
        UIApplication.shared.windows.first?.rootViewController?.topMostViewController()?.presentFull(self, completion: completion)
    }
    
    func hide() {
        self.webView = nil
        self.dismiss(animated: false)
    }
}

extension SurveyWebViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil // Disable zooming
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
}

extension SurveyWebViewController {
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            guard let webView else { return }
            webViewBottomConstraint?.constant = 0
            let keyboardHeight = keyboardFrame.height
            webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardHeight, right: 0)
            webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
            view.layoutIfNeeded()
            
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        guard let webView else { return }
        webViewBottomConstraint?.constant = 0
        webView.scrollView.contentInset = .zero
        webView.scrollView.scrollIndicatorInsets = .zero
        view.layoutIfNeeded()
    }

}


