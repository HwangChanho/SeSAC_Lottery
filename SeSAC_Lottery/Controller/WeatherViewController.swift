//
//  WeatherViewController.swift
//  SeSAC_Lottery
//
//  Created by ChanhoHwang on 2021/10/27.
//

import UIKit
import CoreLocation
import Kingfisher

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var lon: Double = 0
    var lat: Double = 0
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var labelOnView: [UIView]!
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        setUp()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation() //위치 정보 받아오기 시작
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        
        findAddress(lat: lat, long: lon)
        
        WeatherAPIManager.shared.getWeatherApiData(lat: lat, lon: lon) {code, json in
            switch code {
            case 200:
                var temp = json["main"]["temp"].doubleValue
                temp = temp - 273.15
                self.degreeLabel.text = "지금은 \(round(temp))℃ 에요"
                
                let humidity = json["main"]["humidity"].doubleValue
                self.humidityLabel.text = "\(humidity)% 만큼 습해요"
                
                let wind = json["wind"]["speed"].doubleValue
                self.windyLabel.text = "\(round((wind * 100) / 100))m/s의 바람이 불어요"
                
                // https://openweathermap.org/img/wn/10d@2x.png
                let icon = json["weather"][0]["icon"].stringValue
                print(json)
                print("icon: \(icon)")
                let imageURL = URL(string: "\(Endpoint.weatherImageURL)\(icon)@2x.png")
                self.imageView.kf.setImage(with: imageURL)
                
                self.greetingLabel.text = "오늘도 행복한 하루 보내세요"
                
            case 400:
                print(json)
            default:
                print("error")
            }
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func reloadButtonClicked(_ sender: UIButton) {
        
    }
    
    func setUp() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 hh시 mm분"
        let current_date_string = formatter.string(from: Date())
        
        dateLabel.text = current_date_string
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 20)
        
        locationLabel.text = ""
        locationLabel.textColor = .white
        locationLabel.font = .systemFont(ofSize: 23)
        
        imageView.backgroundColor = .white
        
        setLabel(degreeLabel)
        setLabel(humidityLabel)
        setLabel(windyLabel)
        setLabel(greetingLabel)
        
        for i in 0 ... 4 {
            labelOnView[i].backgroundColor = .white
            labelOnView[i].layer.cornerRadius = 15
            labelOnView[i].layer.masksToBounds = true
        }
        
    }
    
    func setLabel(_ label: UILabel) {
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
    }
    
    // 주소 찾기
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name {
                    print(name)
                    self.locationLabel.text = name
                } //전체 주소
            }
        })
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
        }
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


