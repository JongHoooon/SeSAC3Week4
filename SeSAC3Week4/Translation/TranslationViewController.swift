//
//  TranslationViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/07.
//

import UIKit

import Alamofire
import SwiftyJSON

class TranslationViewController: UIViewController, Alertable {
    
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var requestButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        detectLanguage(completionHandler: translateLanguage(languageCode:))
    }
}

private extension TranslationViewController {
    
    func detectLanguage(completionHandler: @escaping (String) -> Void) {
        
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
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
                let languageCode = json["langCode"].stringValue
                
                completionHandler(languageCode)
            case let .failure(error):
                switch response.response?.statusCode {
                case 400:
                    self?.presnetSimpleAlert(message: "번역할 내용을 입력해주세요!")
                case 500:
                    self?.presnetSimpleAlert(message: "Internal server errors")
                default:
                    self?.presnetSimpleAlert(message: "알 수 없는 오류입니다.")
                }
                print(error)
            }
        }
    }
    
    func translateLanguage(languageCode: String) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        let parameters: Parameters = [
            "source": languageCode,
            "target": "en",
            "text": originalTextView.text ?? ""
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: header
        )
        .validate()
        .responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                self?.translateTextView.text = data
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
