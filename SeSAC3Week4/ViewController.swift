//
//  ViewController.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/07.
//

import UIKit

import Alamofire
import SwiftyJSON

struct Movie {
    var title: String
    var release: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.rowHeight = 60.0
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
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
                
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//
//                print(name1, name2, name3)
//
//
//
//                self.movieList.append(name1)
//                self.movieList.append(name2)
//                self.movieList.append(name3)
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = item["movieNm"].stringValue
                    let openDt = item["openDt"].stringValue
                    
                    let movie = Movie(
                        title: movieNm,
                        release: openDt
                    )
                    self.movieList.append(movie)
                }
                
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return movieList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath
        )
        
        cell.textLabel?.text = movieList[indexPath.row].title
        cell.detailTextLabel?.text = movieList[indexPath.row].release
        
        return cell
    }
    
}
