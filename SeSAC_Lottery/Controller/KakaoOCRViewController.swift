//
//  KakaoOCRViewController.swift
//  SeSAC_Lottery
//
//  Created by ChanhoHwang on 2021/10/27.
//

import UIKit

class KakaoOCRViewController: UIViewController {

    @IBOutlet weak var textImage: UIImageView!
    @IBOutlet weak var translateTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        guard let image = textImage.image else { return print("No Image") }
        
        KakaoOCRAPIManager.shared.fetchImageData(image: image) { code, json in
            
            switch code {
            case 200:
                print(json)
            case 400:
                print(json)
            default:
                print("error")
            }
        }
    }
}
