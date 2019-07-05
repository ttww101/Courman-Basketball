//
//  WeatherProvider.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/31.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation
import Alamofire

enum GetWeatherError: Error {

    case cannotGetTown
    case responseError
    case invalidResponseData
}

class WeatherProvider {

    static let shared = WeatherProvider()

    typealias GetWeather = (Weather?, Error?) -> Void

    func getWeather(town: String, completion: @escaping GetWeather) {

        let townlist = Towns().list
        var townObject = townlist.filter { $0.key == town }

        if townObject.count != 0 {
            let townID = townObject[0].value
            let urlString = "https://works.ioa.tw/weather/api/weathers/\(townID).json"

            Alamofire.request(urlString).responseJSON { response in

                if response.result.isSuccess {
                    if let result = response.value as? [String: AnyObject] {

                        guard
                            let desc = result["desc"] as? String,
                            let temperature = result["temperature"] as? Int,
                            let time = result["at"] as? String
                            else { return }

                        let weatherPicName = self.getWeatherPicName(weahterDesc: desc)

                        let weatherInfo = Weather(desc: desc,
                                                  weatherPicName: weatherPicName,
                                                  temperature: temperature,
                                                  time: time)

                        completion(weatherInfo, nil)

                    } else { completion(nil, GetWeatherError.invalidResponseData) }
                } else { completion(nil, GetWeatherError.responseError) }
            }

        } else {
            print("=== Error: Cannot Get Town")

            completion(nil, GetWeatherError.cannotGetTown)
            return
        }

    }

    func getWeatherPicName(weahterDesc: String) -> String {

        var weatherPicName = ""

        let characters = Array(weahterDesc.characters)

        let rainy = characters.filter({ (char) -> Bool in
            char == "雨"
        })

        let clear = characters.filter({ (char) -> Bool in
            char == "晴"
        })

        let cloudy = characters.filter({ (char) -> Bool in
            char == "雲" || char == "陰"
        })

        // check weather
        if rainy.count != 0 && cloudy.count != 0 {
            weatherPicName = Constant.ImageName.weatherRainy
        } else if clear.count != 0 && cloudy.count != 0 {
            weatherPicName = Constant.ImageName.weatherPartlyClear
        } else if cloudy.count != 0 {
            weatherPicName = Constant.ImageName.weatherCloudy
        } else if clear.count != 0 {
            weatherPicName = Constant.ImageName.weatherClear
        } else if rainy.count != 0 {
            weatherPicName = Constant.ImageName.weatherRainy
        } else {
            weatherPicName = Constant.ImageName.weatherClear
        }

        return weatherPicName
    }
}
