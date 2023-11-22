//
//  JSHandler.swift
//  Kukushka_iOSSDK
//
//  Created by Aleksunder Volkov on 03.11.2023.
//

import Foundation
import WebKit

protocol JSHandlerDelegate: AnyObject {
    func onPageReady()
    func onSuccess(unq: Bool?)
    func onJSFail(data: Any?)
    func onJSLoadFail()
    func surveyAvailable()
    func onUnavailable()
    func onLinkRecieved(link: String)
}

enum ResponseType {
    case surveyMaster(response: JSResponse)
    case customData(response: JSCustomResponse)
}

final class JSHandler: NSObject {
    
    weak var delegate: JSHandlerDelegate?
    
    private func getJSON(fromString jsonString: String) -> Any? {
        if let data = jsonString.removingPercentEncoding?.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with:data , options: .fragmentsAllowed) {
            return jsonObject
        }
        return nil
    }
    
    private func handle (response: ResponseType) {
        
        switch response {
        case .surveyMaster(let response):
            switch response.surveyMaster.event {
            case .onPageReady:
                delegate?.onPageReady()
            case .onSuccess:
                delegate?.onSuccess(unq: response.surveyMaster.data?.body?.nq)
            case .onFail:
                delegate?.onJSFail(data: response.surveyMaster.data)
            case .onLoadFail:
                delegate?.onJSLoadFail()
            case .onSurveyAvailable:
                delegate?.surveyAvailable()
            case .onSurveyUnavailable:
                delegate?.onUnavailable()
            }
        case .customData(let response):
            if let customData = response.customData,
                  customData.name == "ctaLinkClicked",
                  let link = customData.data?.link {
                delegate?.onLinkRecieved(link: link)
            }
        }
    }
}

extension JSHandler: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Constants.Environment.debugMode ? print("\(Constants.Environment.sdkName) message body: \(message.body)") : nil
        Constants.Environment.debugMode ? print("\(Constants.Environment.sdkName) message frameInfo: \(message.frameInfo)") : nil

        if message.name == "iosListener" {
            
            guard let body = message.body as? String else {
                Constants.Environment.debugMode ? print("\(Constants.Environment.sdkName) message body not String") : nil
                return
            }
            
            guard let jsonString = getJSON(fromString: body) as? String else {
                if let jsonData = body.data(using: .utf8) {
                    do {
                        let apiResponse = try JSONDecoder().decode(JSCustomResponse.self, from: jsonData)
                        handle(response: .customData(response: apiResponse))
                    } catch {
                        print("\(Constants.Environment.sdkName) errror during serialization JSCustomResponse")
                    }
                }
                return
            }
            
            guard let jsonData = jsonString.data(using: .utf8) else {
                print("\(Constants.Environment.sdkName) error during body transform to data")
                return
            }
            
            Constants.Environment.debugMode ? print("\(Constants.Environment.sdkName) response:  \(body)") : nil
            do {
                let apiResponse = try JSONDecoder().decode(JSResponse.self, from: jsonData)
                Constants.Environment.debugMode ? print("\(Constants.Environment.sdkName) apiResponse.surveyMaster.event:  \(apiResponse.surveyMaster.event)") : nil
                handle(response: .surveyMaster(response: apiResponse))
                    
            } catch {
                print("\(Constants.Environment.sdkName) errror during serialization json response")
            }
        }
    }
    
}
