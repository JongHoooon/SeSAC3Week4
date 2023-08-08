//
//  BeerViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/08.
//

import UIKit

import Alamofire
import SwiftyJSON

final class BeerViewController: UIViewController {

    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest()
    }
    
    private func callRequest() {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(
            url,
            method: .get
        )
        .validate()
        .responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)[0]
                print("JSON: \(json)")
                 
                let name = json["name"].stringValue
                let imageURL = json["image_url"].stringValue
                let description = json["description"].stringValue
                
                DispatchQueue.global().async {
                    let beerImage = try? UIImage(data: Data(contentsOf: URL(string: imageURL)!))
                    DispatchQueue.main.async {
                        self?.beerImageView.image = beerImage
                    }
                }
                
                self?.nameLabel?.text = name
                self?.descriptionLabel?.text = description
            case .failure(let error):
                print(error)
            }
        }
    }
}
