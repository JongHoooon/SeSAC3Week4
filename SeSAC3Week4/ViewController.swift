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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.rowHeight = 60.0
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
        
        indicatorView.isHidden = true
    }

    func callRequest(date: String) {
        
        indicatorView.isHidden = true
        indicatorView.startAnimating()
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        
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
  
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = item["movieNm"].stringValue
                    let openDt = item["openDt"].stringValue
                    
                    let movie = Movie(
                        title: movieNm,
                        release: openDt
                    )
                    self.movieList.append(movie)
                }
                
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
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

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        /*
         1. 8글자       ex) 20220101
         2. 날짜형식    bad) 20223333
         3. 어제까지
         */
        movieList.removeAll()
        callRequest(date: searchBar.text!)
        
    }
    
}
