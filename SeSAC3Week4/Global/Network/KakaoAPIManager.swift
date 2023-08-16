//
//  KakaoAPIManager.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/11.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    private init() {}
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
    
    func callRequest(
        type: Endpoint,
        query: String,
        page: Int,
        completionHandler: @escaping (Result<VideoListResponse, Error>) -> Void
    ) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = type.reqeustURL + text + "&size=30&page=\(page)"
        
        AF.request(
            url,
            method: .get,
            headers: header
        )
        .validate(statusCode: 200...500)
        .responseDecodable(
            of: VideoListResponse.self,
            completionHandler: { response in
                switch response.result {
                case let .success(value):
                    completionHandler(.success(value))
                case let .failure(error):
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    if let kakaoStatusError = KakaoError.BadStatusCode(rawValue: statusCode) {
                        completionHandler(.failure(kakaoStatusError))
                    } else {
                        completionHandler(.failure(error))
                    }
                }
            }
        )
    }
}
