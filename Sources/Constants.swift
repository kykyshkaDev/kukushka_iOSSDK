//
//  Constants.swift
//  Kukushka_iOSSDK
//
//  Created by Aleksunder Volkov on 03.11.2023.
//

import Foundation

enum Constants {

    enum Platform: Int {
        case iOS = 0
        case android = 1
        case windows = 2
        case mac = 3
        case linux = 4
        case unknowned = 5
    }
    
    enum Environment {
        static let surveyUrl = "https://survey.kykyshka.ru/"
        static let sdkName = "[KukushkaSDK]"
        static var debugMode = false
        //TODO: how to read from .podspec?
        static let SDKversion = "1.0.3"
    }
    
    
}

