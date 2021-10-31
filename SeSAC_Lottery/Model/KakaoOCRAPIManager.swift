//
//  KakaoOCRAPIManager.swift
//  SeSAC_Lottery
//
//  Created by ChanhoHwang on 2021/10/28.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit.UIImage

class KakaoOCRAPIManager {
    
    static let shared = KakaoOCRAPIManager()
    
    func fetchImageData(image: UIImage, result: @escaping (Int, JSON) -> ()) {
        let header: HTTPHeaders = [
            "Authorization": APIKey.KAKAO_AK,
            "Content-Type": "multipart/form-data"
        ]
        
        guard let imageData = image.pngData() else { return } // 이미지 파일 포맷
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "myImage")
        }, to: Endpoint.visionURL, headers: header)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let code = response.response?.statusCode ?? 500
                
                result(code, json)
                
            case .failure(let error): // 네트워크 통신 실패시
                print(error)
            }
        }
    }
    
}
