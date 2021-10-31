//
//  UserDefaultsManager.swift.swift
//  SeSAC_Lottery
//
//  Created by ChanhoHwang on 2021/11/01.
//

import Foundation

final class UserDefaultsManager {
    static let shared  = UserDefaultsManager()
    
    var lotto = Lotto()
    
    init() {
        load(roundNum: 1)
    }
    
    func save(roundNum: Int) {
        do {
            let userData = try JSONEncoder().encode(lotto)
            UserDefaults.standard.set(userData, forKey: UserDefaultKey.userInfo + "\(roundNum)")
            UserDefaults.standard.synchronize()
            print("save success : \(lotto)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(roundNum: Int) {
        do {
            if let data = UserDefaults.standard.data(forKey: UserDefaultKey.userInfo + "\(roundNum)") {
                let decoded = try JSONDecoder().decode(Lotto.self, from: data)
                lotto = decoded
            }
            print("load success : \(lotto)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
