//
//  BasketballCourtsProvider.swift
//  Alamofire01
//
//  Created by steven.chou on 2017/3/28.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation
import Alamofire

enum GetCourtError: Error {

    case responseError
    case invalidResponseData
}

class BasketballCourtsProvider {

    static let shared = BasketballCourtsProvider()

    typealias GetCourtCompletion = ([BasketballCourt]?, Error?) -> Void

    func getApiData(city: String, gymType: String, completion: @escaping GetCourtCompletion) {
        let urlString = "http://iplay.sa.gov.tw/api/GymSearchAllList?"
        let parameters: Parameters = ["City": city, "GymType": gymType]

        var basketballCourts = [BasketballCourt]()

        Alamofire.request(urlString, parameters: parameters).validate().responseJSON { response in

            if response.result.isSuccess {
                if let results = response.value as? [[String: AnyObject]] {

                    for result in results {
                        guard
                            let gymID = result["GymID"] as? Int,
                            let name = result["Name"] as? String,
                            let operationTel = result["OperationTel"] as? String,
                            let address = result["Address"] as? String,
                            let rate = result["Rate"] as? Int,
                            let rateCount = result["RateCount"] as? Int,
                            let gymFuncList = result["GymFuncList"] as? String,
                            let latLng = result["LatLng"] as? String
                            else { return }

                        var latitudeAndLongitude = latLng.components(separatedBy: ",")
                        var latitude = ""
                        var longitude = ""

                        // MARK: Get latitude and longitude
                        if latitudeAndLongitude.count == 2 {
                            latitude = latitudeAndLongitude[0]
                            longitude = latitudeAndLongitude[1]
                        } else {
                            print("=== The Latitude and Longitude are wrong -> Court: \(name)")
                        }

                        let basketballCourt = BasketballCourt(courtID: gymID, name: name, tel: operationTel, address: address, rate: rate, rateCount: rateCount, gymFuncList: gymFuncList, latitude: latitude, longitude: longitude)

                        basketballCourts.append(basketballCourt)
                    }

                    // todo: 過濾球場

                    completion(basketballCourts, nil)

                } else { completion(nil, GetCourtError.invalidResponseData) }

            } else { completion(nil, GetCourtError.responseError) }
        }
    }
}
