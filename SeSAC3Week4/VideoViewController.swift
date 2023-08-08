//
//  VideoViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/08.
//

import UIKit

import Alamofire
import SwiftyJSON

class VideoViewController: UIViewController {

    var documents: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest()
    }
    
    func callRequest() {
        
        let text = "아이유".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://dapi.kakao.com/v2/search/web?query=\(text)"
        let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
        
        AF.request(
            url,
            method: .get,
            headers: header
        )
        .validate()
        .responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for item in json["documents"].arrayValue {
                    self?.documents.append(item["title"].stringValue)
                }
                
                print(self?.documents)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
