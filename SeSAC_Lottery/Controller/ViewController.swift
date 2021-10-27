//
//  ViewController.swift
//  SeSAC_Lottery
//
//  Created by ChanhoHwang on 2021/10/25.
//

import UIKit
import SwiftyJSON
import Alamofire

// 986
class ViewController: UIViewController {
    
    @IBOutlet weak var roundTextField: UITextField!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var numberLabel: [UILabel]!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var latestRound = 0
    var selectRow = 0
    
    var lottory: Lotto = .init()
    var pickerViewArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        print("in: \(UserDefaults.standard.integer(forKey: "round"))")
        
        if UserDefaults.standard.integer(forKey: "round") != 0 {
            latestRound = UserDefaults.standard.integer(forKey: "round")
        } else {
            latestRound = 986
        }
        
        pickerViewArray = Array(0 ... latestRound)
        pickerViewArray.reverse()
        
        print("latestRound: \(latestRound)")
        
        setUp()
        
        getApi(roundNum: latestRound)
    }
    
    func setUp() {
        roundTextField.textColor = .black
        roundTextField.text = "\(latestRound)"
        roundTextField.font = .boldSystemFont(ofSize: 18)
        roundTextField.textAlignment = .center
        roundTextField.borderStyle = .none
        
        infoLabel.textColor = .black
        infoLabel.font = .boldSystemFont(ofSize: 13)
        infoLabel.text = "당첨번호 안내"
        
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 11)
        dateLabel.text = "일자 추첨"
        
        roundLabel.text = "\(latestRound)회"
        roundLabel.textColor = .red
        roundLabel.font = .boldSystemFont(ofSize: 23)
        roundLabel.textAlignment = .right
        
        textLabel.text = "당첨결과"
        textLabel.textColor = .black
        textLabel.font = .boldSystemFont(ofSize: 23)
        textLabel.textAlignment = .left
        
        plusLabel.text = "+"
        plusLabel.textColor = .black
        plusLabel.textAlignment = .center
        
        bonusLabel.text = "보너스"
        bonusLabel.font = .systemFont(ofSize: 11)
        bonusLabel.textColor = .black
        
        for i in 0 ... 6 {
            numberLabel[i].text = "1"
            numberLabel[i].textColor = .white
            numberLabel[i].font = .boldSystemFont(ofSize: 20)
            numberLabel[i].backgroundColor = .black
            numberLabel[i].layer.masksToBounds = true
            numberLabel[i].layer.cornerRadius = 20.95
            numberLabel[i].textAlignment = .center
        }
        
        getDate()
    }
    
    func getApi(roundNum: Int) -> Bool {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(roundNum)"
        
        AF.request(url, method: .post).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // print("JSON: \(json)"
                let drwNoDate = json["drwNoDate"].stringValue
                let drwtNo6 = json["drwtNo6"].intValue
                let drwtNo5 = json["drwtNo5"].intValue
                let drwtNo4 = json["drwtNo4"].intValue
                let drwtNo3 = json["drwtNo3"].intValue
                let drwtNo2 = json["drwtNo2"].intValue
                let drwtNo1 = json["drwtNo1"].intValue
                let bonusNum = json["bnusNo"].intValue
                let drwNo = json["drwNo"].intValue
                
                let data = Lotto(drwNoDate: drwNoDate, drwtNo: [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bonusNum], drwNo: drwNo)
                
                print(data)
                self.lottory = data
                
            case .failure(let error):
                print(error)
            }
        }
        
        return true
    }
    
    func getDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd EEE"
        
        let current_date_string = formatter.string(from: Date())
        let result = current_date_string.components(separatedBy: " ")
        if result[1] == "Sat" {
            latestRound += 1
            UserDefaults.standard.set(latestRound, forKey: "round")
        } else {
            print(result)
        }
    }
    
    func setLabel(roundNum: Int) {
        getApi(roundNum: roundNum)
        
        roundTextField.text = "\(lottory.drwNo)"
        dateLabel.text = "\(lottory.drwNoDate)일자 추첨"
        roundLabel.text = "\(lottory.drwNo)회"
        
        let lotto = Lotto()
        for i in 0 ... 6 {
            numberLabel[i].text = "\(lottory.drwtNo[i])"
            numberLabel[i].backgroundColor = lotto.lottoColor(lottory.drwtNo[i])
        }
        
        // reload
    }
    
    @IBAction func roundInput(_ sender: UITextField) {
        if let num = Int(sender.text ?? "\(latestRound)") {
            setLabel(roundNum: num)
        } else {
            // 경고 토스트 메세지 띄우기
        }
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return latestRound
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerViewArray[row])
    }
    
    // 선택한 Array의 row값을 가져오기 위해서 초기값인 selectRow에 해당 row를 가져옴
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = latestRound - row
        print(selectRow)
        setLabel(roundNum: selectRow)
    }
    
}
