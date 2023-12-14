//
//  JSResponse.swift
//  Kukushka_iOSSDK
//
//  Created by Aleksunder Volkov on 08.11.2023.
//

import Foundation

struct JSCustomResponse: Codable {
    let customData: CustomData?
}

struct JSResponse: Codable {
    let surveyMaster: SurveyMasterResponse
}

struct SurveyMasterResponse: Codable {
    let event: SurveyEvent
    let data: SurveyData?
}

enum SurveyEvent: String, Codable {
    case onPageReady
    case onSuccess
    case onFail
    case onLoadFail
    case onSurveyAvailable
    case onSurveyUnavailable
}

struct SurveyData: Codable {
    let body: SurveyDataBody?
}

struct SurveyDataBody: Codable {
    let nq: Int
}

struct CustomData: Codable {
    let name: String?
    let data: DataClass?
}

struct DataClass: Codable {
    let link: String?
}
