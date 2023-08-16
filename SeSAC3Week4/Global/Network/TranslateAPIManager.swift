//
//  TranslateAPIManager.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/11.
//

import Foundation

import Alamofire
import SwiftyJSON

final class TranslateAPIManager {
    
    static let shared = TranslateAPIManager()
    private init() {}
    
    let headers: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.naverClientID,
        "X-Naver-Client-Secret": APIKey.naverClientSecret
    ]
    
    func callRequest(text: String, resultString: @escaping (String) -> Void) {
        
        let url = EndPoint.naverPapagoTranslation

        let parameters: Parameters = [
            "source": "ko",
            "target": "en",
            "text": text
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
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                resultString(data)
                
            case .failure(let error):
                print(error)
            }
        }

        
    }
}
