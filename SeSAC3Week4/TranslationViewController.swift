//
//  TranslationViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/07.
//

import UIKit

import Alamofire
import SwiftyJSON

class TranslationViewController: UIViewController {
    
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
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        let parameters: Parameters = [
            "source": "ko",
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
