//
//  WeatherProvider.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
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

    func getWeather(city: String, completion: @escaping GetWeather) {

        var apiTime = ""
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter1.locale = Locale.current
        let currentDateString = formatter1.string(from: today)
        
        let getformatter = DateFormatter()
        getformatter.dateFormat = "yyyy"
        let year = getformatter.string(from: today)
        getformatter.dateFormat = "MM"
        let month = getformatter.string(from: today)
        getformatter.dateFormat = "dd"
        let day = getformatter.string(from: today)
        
        let formatter2 = DateFormatter()
        formatter2.timeZone = NSTimeZone.default
        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard
            let morningDate = formatter2.date(from: "\(year)-\(month)-\(day) 06:00:00")
        else {
            completion(nil, NetworkError.other)
            return }
        
        let morninDateString = formatter2.string(from: morningDate)
        
        if (currentDateString <= morninDateString) {
            apiTime = morninDateString.replacingOccurrences(of: " ", with: "T")
        } else {
            guard
                let eveningDateString = formatter2.date(from: "\(year)-\(month)-\(day) 18:00:00")
                else {
                    completion(nil, NetworkError.other)
                    return }
            apiTime = formatter2.string(from: eveningDateString)
            apiTime = apiTime.replacingOccurrences(of: " ", with: "T")
        }
        
        let urlComponents = NSURLComponents(string: "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001/")!
        
        urlComponents.queryItems = [
            NSURLQueryItem(name: "Authorization", value:"CWB-B1E81EE3-A140-4940-A4C5-0017D2F92079"),
            NSURLQueryItem(name: "locationName", value:city),
            NSURLQueryItem(name: "startTime", value:apiTime)
            ] as [URLQueryItem]
        
        guard let url = urlComponents.url else {
            completion(nil, NetworkError.formURLFail)
            return
        }
        
        Alamofire.request(url).responseJSON { response in

            if response.result.isSuccess {
                if let result = response.value as? [String: AnyObject] {

                    var description1 = ""
                    var temperature = ""
                    var rainRate = ""
                    var description2 = ""
                    
                    guard
                        let records = result["records"] as? Dictionary<String, AnyObject>
                        , let location = records["location"] as? Array<AnyObject>
                        , let firstObject = location[0] as? Dictionary<String, AnyObject>
                        , let weatherElements = firstObject["weatherElement"] as? Array<Dictionary<String, AnyObject>>
                        else { return }
                    
                    for weatherElement in weatherElements {
                        guard let type = weatherElement["elementName"] as? String else { return }
                        if let timeData = weatherElement["time"]?.firstObject as? Dictionary<String, AnyObject>
                            , let parameter = timeData["parameter"] as? Dictionary<String, AnyObject>
                            , let targetString = parameter["parameterName"] as? String {
                            if type == "Wx" {
                                description1 = targetString
                            } else if type == "CI" {
                                description2 = targetString
                            } else if type == "PoP" {
                                rainRate = targetString
                            } else if type == "MinT" {
                                temperature = targetString
                            }
                        }
                    }
                   
                    let weatherInfo = Weather(description: description1, temperature: temperature,
                                              rainRate: rainRate, feel: description2)
                    completion(weatherInfo, nil)

                } else {
                    completion(nil, GetWeatherError.invalidResponseData) }
            } else { completion(nil, GetWeatherError.responseError) }
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
