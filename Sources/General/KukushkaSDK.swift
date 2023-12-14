///
///
///
public typealias Handler = ((_ data: Any?) -> Void)
///
///
///
public typealias OnSuccess = ((_ userUnqualified: Int) -> Void)


public protocol SurveyClient {
    ///
    /// If suvey preloaded show survey else load survey and show
    ///
    func showSurvey()
    ///
    /// Preload survey
    ///
    func hasSurvey()
    ///
    /// Callback for finishing survey
    /// If userUnqualified == false or nil,
    /// so Survey was succesfully finished, else  “User not fit for survey”
    ///
    var onSurveySuccess: OnSuccess? { get set }
    ///
    /// Callbak for last survey haven't finished, user closed survey before finishing
    ///
    var onFail: Handler? { get set }
    ///
    /// Callback for error loading survey
    ///
    var onLoadFail: Handler? { get set }
    ///
    /// Callback for survey was founded
    ///
    var onSurveyAvailable: Handler? { get set }
    ///
    /// Callback fo survey haven't found for user
    ///
    var onSurveyUnavailable: Handler? { get set }
    ///
    /// Callback on start survey
    ///
    var onSurveyStart: Handler? { get set }
}


import WebKit

public final class SurveyMaster: NSObject {
    ///
    /// user id
    ///
    private let userId: String
    ///
    /// Game key
    ///
    private let gameKey: String
    ///
    ///
    ///
    public var onSurveySuccess: OnSuccess?
    public var onSurveyAvailable: Handler?
    public var onSurveyUnavailable: Handler?
    public var onSurveyStart: Handler?
    public var onFail: Handler?
    public var onLoadFail: Handler?
    
    private var surveyWebViewController: SurveyWebViewController?
    private var isPageReady = false
    private var showSurveyPressed = false
    
    private func checkIsInitialized() {
        if gameKey.isEmpty {
            fatalError("\(Constants.Environment.sdkName) SDK not initialized")
        }
    }
    
    private var surveyUrl: String {
        return Constants.Environment.surveyUrl +
        "?isWebView=1" +
        "&send_from_page=1" +
        "&platform=\(Constants.Platform.iOS.rawValue)" +
        "&gid=\(gameKey)" +
        "&uid=\(userId)" +
        "&version=\(Constants.Environment.SDKversion)" +
        "&lastSurvey=-1"
    }
    
    private var timer: Timer?
    
    private func setupJsHandler() -> WKScriptMessageHandler {
        let jsHandler: WKScriptMessageHandler = JSHandler()
        (jsHandler as? JSHandler)?.delegate = self
        return jsHandler
    }
    
    private func startTimer() {
        print("\(Constants.Environment.sdkName) Timer started")
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10 * 60.0, repeats: false) { [weak self] _ in
            self?.timerFinished()
            print("\(Constants.Environment.sdkName) Timer finished")
        }
    }

    private func timerFinished() {
        isPageReady = false
        showSurveyPressed = false
    }

    deinit {
        timer?.invalidate()
    }
    ///
    /// If debug true logs enabled
    ///
    public init(
        userId: String,
        gameKey: String,
        debugMode: Bool = false
    ) {
        guard !gameKey.isEmpty else {
                fatalError("\(Constants.Environment.sdkName) Game key must be not empty")
        }
        self.userId = userId
        self.gameKey = gameKey
        Constants.Environment.debugMode = debugMode
        print("\(Constants.Environment.sdkName) SurveyMaster inited")
    }
}

extension SurveyMaster: SurveyClient {
    
    public func showSurvey() {
        showSurveyPressed = true
        if surveyWebViewController == nil {
            surveyWebViewController = SurveyWebViewController(with: setupJsHandler())
        }
        if !isPageReady {
            hasSurvey()
        } else {
            surveyWebViewController?.show() { [weak self] in
                self?.onSurveyStart?(nil)
            }
        }
    }
    
    public func hasSurvey() {
        checkIsInitialized()
        print("\(Constants.Environment.sdkName)Checking for surveys..")
        if surveyWebViewController == nil {
            surveyWebViewController = SurveyWebViewController(with: setupJsHandler())
        }
        surveyWebViewController?.start(with: surveyUrl)
    }
}

extension SurveyMaster: JSHandlerDelegate {
    
    func onPageReady() {
        startTimer()
        isPageReady = true
        if showSurveyPressed {
            surveyWebViewController?.show() { [weak self] in
                self?.onSurveyStart?(nil)
            }
        }
    }
    
    func onSuccess(unq: Int) {
        surveyWebViewController?.hide()
        surveyWebViewController = nil
        isPageReady = false
        showSurveyPressed = false
        onSurveySuccess?(unq)
    }
    
    func onJSFail(data: Any?) {
        surveyWebViewController?.hide()
        surveyWebViewController = nil
        showSurveyPressed = false
        isPageReady = false
        onFail?(data)
    }
    
    func onJSLoadFail() {
        surveyWebViewController?.hide()
        surveyWebViewController = nil
        showSurveyPressed = false
        isPageReady = false
        onLoadFail?(nil)
    }
    
    func surveyAvailable() {
        onSurveyAvailable?(nil)
    }
    
    func onUnavailable() {
        showSurveyPressed = false
        isPageReady = false
        onSurveyUnavailable?(nil)
    }
    
    func onLinkRecieved(link: String) {
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url, options: [:]) { _ in
            // success 
        }
    }
}

