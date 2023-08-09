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
    
    @IBAction func tappedNewRecommendButton(_ sender: UIButton) {
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
                
                Task {
                    do {
                        self?.beerImageView.image = try await self?.fetchImage(url: imageURL)
                    } catch {
                        self?.beerImageView.image = UIImage(systemName: "mug")
                        print(error)
                    }
                }
                
                self?.nameLabel?.text = name
                self?.descriptionLabel?.text = description
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchImage(url: String) async throws -> UIImage {
                
        guard let url = URL(string: url) else {
            throw BeerError.noBeerImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw BeerError.noData
        }
        
        return image
    }
}

enum BeerError: Error {
    case noBeerImage
    case noData
}
