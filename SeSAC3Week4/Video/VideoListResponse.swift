//
//  VideoListResponse.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/16.
//

import Foundation

struct VideoListResponse: Decodable {
    let meta: Meta?
    let documents: [Document]?
    
    struct Document: Decodable {
        let url: String?
        let datetime: String?
        let thumbnail: String?
        let author, title: String?
        let playTime: Int?

        enum CodingKeys: String, CodingKey {
            case url, datetime, thumbnail, author, title
            case playTime = "play_time"
        }
    }
    
    struct Meta: Decodable {
        let totalCount: Int?
        let isEnd: Bool?
        let pageableCount: Int?

        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case isEnd = "is_end"
            case pageableCount = "pageable_count"
        }
    }
}



