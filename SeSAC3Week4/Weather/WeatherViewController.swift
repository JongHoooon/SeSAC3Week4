//
//  WeatherViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/08.
//

import UIKit

import Alamofire
import SwiftyJSON

final class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()
    }
    
    func callRequest() {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=\(APIKey.weatherKey)"
        
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
                
                print("------------------------------")
                 
                let temp = json["main"]["temp"].doubleValue - 273.15
                let humidity = json["main"]["humidity"].intValue
                
                let id = json["weather"][0]["id"].intValue
                
                self.tempLabel.text = "\(temp)"
                self.humidityLabel.text = "\(humidity)"

                print(temp, humidity, id)
                
                switch id {
                case 800:
                    self.weatherLabel.text = "매우 맑음"
                case 801...899:
                    self.weatherLabel.text = "구름이 낀 날씨입니다."
                default:
                    self.weatherLabel.text = "나머지는 생략..!!!"
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
