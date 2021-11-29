//
//  ViewController.swift
//  WeatherAppSample
//
//  Created by Andrew Vijay on 28/11/21.
//

import UIKit

struct MainWeatherData: Codable {
    let name: String
    let weather: [Weather]
    let wind: Wind
    let main: Main
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon : String
}


class ViewController: UIViewController {
    
    @IBOutlet weak var CityNameLabel: UILabel!
    
    @IBOutlet weak var WeatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var WeatherIconImageView: UIImageView!
    
    @IBOutlet weak var TemperatureLabel: UILabel!
    
    @IBOutlet weak var HumidityLabel: UILabel!
    
    @IBOutlet weak var WindSpeedLabel: UILabel!
    
    //Step - 1 --> URL String
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Waterloo,ca&appid=c2011a89d9569314651c56e8f075f98f&units=metric"
    
    var cityName:String = ""
    var weatherMain: String = ""
    var tempDegree: Double = 0
    var humidityPercent: Int = 0
    var windSpeed: Double = 0
    var icon: String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Step - 2 ---> URL Session
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: urlString)
        
        if let url = url{
            //Step - 3 --->Create a data task
            
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    print(data)
                    let jsonDecoder = JSONDecoder()
                    
                    do{
                    
                        let readableData = try jsonDecoder.decode(MainWeatherData.self, from: data)

                        print("Place: ",readableData.name) //Place
                        print("Weather Details: ",readableData.weather[0])
                        print("Weather: ",readableData.weather[0].main) //Weather
                        print("Humidity: ",readableData.main.humidity,"%")   //Humidity
                        print("Temperature: ",readableData.main.temp,"°")   //Temperature
                        print("WindSpeed: ",readableData.wind.speed,"km/h")      //WindSpeed
                    
                        DispatchQueue.main.async {
                            self.cityName = readableData.name
                            self.weatherMain = readableData.weather[0].main
                            self.tempDegree = readableData.main.temp
                            self.humidityPercent = readableData.main.humidity
                            self.windSpeed = readableData.wind.speed
                            self.icon = readableData.weather[0].icon
                            
                            self.CityNameLabel.text = self.cityName
                            self.WeatherDescriptionLabel.text = self.weatherMain
                            self.TemperatureLabel.text = "\(self.tempDegree)°C"
                            self.HumidityLabel.text = "Humidity: \(self.humidityPercent)%"
                            self.WindSpeedLabel.text = "Wind: \(self.windSpeed) Km/h"
                            
                            switch(readableData.weather[0].id) {
                            case 200..<233:
                                self.WeatherIconImageView.image = UIImage(named: "ThunderStorm")
                            case 300..<322:
                                self.WeatherIconImageView.image = UIImage(named: "Rain")
                            case 500..<532:
                                self.WeatherIconImageView.image = UIImage(named: "Rain")
                            case 600..<623:
                                self.WeatherIconImageView.image = UIImage(named: "Snow")
                            case 701..<782:
                                self.WeatherIconImageView.image = UIImage(named: "Atmosphere")
                            case 800:
                                self.WeatherIconImageView.image = UIImage(named: "Clear")
                            case 801..<805:
                                self.WeatherIconImageView.image = UIImage(named: "Cloudy")
                            default:
                                self.WeatherIconImageView.image = UIImage(named: "Clear")
                            }
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            print("Not able to decode ", error);
                        }
                    }
                }
            }
            //Step - 4 ---> Resume your data task
            dataTask.resume()
        }
    }
}

