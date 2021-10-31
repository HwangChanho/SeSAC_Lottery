//
//  Lotto.swift
//  SeSAC_Lottery
//
//  Created by ChanhoHwang on 2021/10/26.
//

import Foundation
import UIKit

struct Lotto : Codable {
    var drwNoDate: String = ""
    var drwtNo: [Int] = []
    var drwNo: Int = 0
    
    var latestRound = 0
    
    func lottoColor(_ num: Int) -> UIColor {
        switch num {
        case 1 ... 10:
            return .yellow
        case 11 ... 20:
            return .blue
        case 21 ... 30:
            return .red
        case 31 ... 40:
            return .black
        case 41 ... 45:
            return .green
        default:
            return .purple
        }
    }
}
