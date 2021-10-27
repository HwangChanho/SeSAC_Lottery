//
//  weatherAPIManager.swift
//  SeSAC_Lottery
//
//  Created by ChanhoHwang on 2021/10/27.
//

import Foundation
import SwiftyJSON
import Alamofire

class WeatherAPIManager {
    
    static let shared = WeatherAPIManager()
    
    typealias CompletionHandler = (Int, JSON) -> ()
    
    func getWeatherApiData(lat: Double, lon: Double, result: @escaping CompletionHandler) {
        
        let url = "\(Endpoint.weatherURL)?lat=\(lat)&lon=\(lon)&appid=\(APIKey.WEATHER_API)"
        
        AF.request(url, method: .post)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let code = response.response?.statusCode ?? 500
                
                result(code, json)
                
            case .failure(let error): // 네트워크 통신 실패시
                print(error)
            }
        }
    }
}
