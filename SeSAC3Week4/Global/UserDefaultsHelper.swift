//
//  UserDefaultsHelper.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/11.
//

import Foundation

class UserDefaultsHelper {
    
    static let standard = UserDefaultsHelper() // 싱글톤 패턴
    
    private init() {}   // 접근 제어자
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String { // 컴파일 최적화
        case nickname
        case age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
}
