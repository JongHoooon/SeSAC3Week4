//
//  TranslationViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/07.
//

import UIKit

import Alamofire
import SwiftyJSON

struct LanguageCode: Decodable {
    let langCode: String
}

struct TranslationResult: Decodable {
    let message: Message?
}

struct Message: Decodable {
    let type: String?
    let result: MessageResult?
    let version: String?
    let service: String?

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case result
        case version = "@version"
        case service = "@service"
    }
}

struct MessageResult: Decodable {
    let srcLangType: String?
    let translatedText: String?
    let engineType: String?
    let tarLangType: String?
}


class TranslationViewController: UIViewController, AlertableProtocol {
    
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var requestButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("고래밥", forKey: "nickanme")
        UserDefaults.standard.set(33, forKey: "age")
        
        UserDefaults.standard.string(forKey: "nickname")
        UserDefaults.standard.integer(forKey: "age")
        
        originalTextView.text = UserDefaultsHelper.standard.nickname
        UserDefaultsHelper.standard.nickname = "칙촉"
        
        [
            originalTextView,
            translateTextView
        ].forEach {
            $0?.text = ""
            $0?.layer.borderWidth = 1.0
            $0?.layer.borderColor = UIColor.label.cgColor
        }
        translateTextView.isEditable = false
    }
    
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
//        detectLanguage(completionHandler: translateLanguage(languageCode:))
        
        TranslateAPIManager.shared.callRequest(
            text: originalTextView.text,
            resultString: { [weak self] resultString in
                self?.translateTextView.text = resultString
            }
        )
        
//        Task {
//            do {
//                let languageCode = try await detectLanguage2()
//                let translatedText = try await translateLanguage2(languageCode: languageCode)
//                translateTextView.text = translatedText
//            } catch {
//                if let translationError = error as? TranslationError {
//                    presentSimpleAlert(message: translationError.message)
//                } else {
//                    presentSimpleAlert(message: "알 수 없는 오류입니다.")
//                    print(error)
//                }
//            }
//        }
    }
}

private extension TranslationViewController {
    
    func detectLanguage(completionHandler: @escaping (String) -> Void) {
        
        let url = EndPoint.naverPapagoDetectLanguage
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        let parameters: Parameters = [
            "query": originalTextView.text ?? "",
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseJSON { [weak self] response in
            
            switch response.result {
            case let .success(value):
                
                let json = JSON(value)
                print(json)
                let languageCode = json["langCode"].stringValue
                
                completionHandler(languageCode)
            case let .failure(error):
                switch response.response?.statusCode {
                case 400:
                    self?.presentSimpleAlert(message: "번역할 내용을 입력해주세요!")
                case 500:
                    self?.presentSimpleAlert(message: "Internal server errors")
                default:
                    self?.presentSimpleAlert(message: "알 수 없는 오류입니다.")
                }
                print(error)
            }
        }
    }
    
    func translateLanguage(languageCode: String) {
        TranslateAPIManager.shared.callRequest(
            text: originalTextView.text,
            resultString: { [weak self] resultString in
                self?.translateTextView.text = resultString
            }
        )
    }
    
    func detectLanguage2() async throws -> String {
        
        let url = EndPoint.naverPapagoDetectLanguage
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        let parameters: Parameters = [
            "query": originalTextView.text ?? "",
        ]
        let request = AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: headers
        )
        let dataTask = request.serializingDecodable(LanguageCode.self)
        let response = await dataTask.response.response
        
        switch await dataTask.result {
        case .success(let value):
            print(value.langCode)
            return value.langCode
        case .failure(let error):
            switch response?.statusCode {
            case 400:
                throw TranslationError.noText
            case 500:
                throw TranslationError.internalServer
            default:
                throw error
            }
        }
    }
    
    func translateLanguage2(languageCode: String) async throws -> String {
        
        let url = EndPoint.naverPapagoTranslation
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        let parameters: Parameters = [
            "source": languageCode,
            "target": "en",
            "text": originalTextView.text ?? ""
        ]
        let request = AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: header
        )
        let dataTask = request.serializingDecodable(TranslationResult.self)
        
        switch await dataTask.result {
        case .success(let value):
            return value.message?.result?.translatedText ?? ""
        case .failure(let error):
            throw error
        }
    }
    
    enum TranslationError: Error {
        case noText
        case internalServer
        case unknown
        
        var message: String {
            switch self {
            case .noText:
                return "번역할 내용을 입력해주세요."
            case .internalServer:
                return "Internal server error"
            case .unknown:
                return "알 수 없는 오류입니다."
            }
        }
    }
}
