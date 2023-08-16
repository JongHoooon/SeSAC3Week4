//
//  KakaoError.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/16.
//

import Foundation

import Alamofire

enum KakaoError: Error  {
    enum BadStatusCode: Int, Error, CaseIterable {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case tooMayRequest = 429
        case internalServerError = 500
        case badGateway = 502
        case serviceUnavailable = 503
    }
}

extension KakaoError.BadStatusCode {
    var message: String {
        switch self {
        case .badRequest:
            return "요청 파라미터를 확인해주세요."
        case .unauthorized:
            return "인증 오류"
        case .forbidden:
            return "접근 권한이 없습니다."
        case .tooMayRequest:
            return "정해진 사용량이나 초당 요청한도를 초과했습니다."
        case .internalServerError:
            return "서버 에러 입니다."
        case .badGateway:
            return "서로 다른 프로토콜을 연결해주는 게이트웨이가 잘못된 프로토콜을 연결하거나 연결된 프로토콜에 문제가 있어 통신이 제대로 되지 않은 상태입니다."
        case .serviceUnavailable:
            return "서버가 요청을 처리할 준비가 되지 않은 상태입니다."
        }
    }
}
