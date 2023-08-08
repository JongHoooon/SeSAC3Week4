//
//  ViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/07.
//

import UIKit

import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()
    }

    func callRequest() {
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=20120101"
        
        AF.request(
            url,
            method: .get
        )
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let name = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
                
                print("--------------------------------------")
                print(name)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

