//
//  BasketballCourtsProvider.swift
//  Alamofire01
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation
import Alamofire

enum GetCourtError: Error {

    case responseError
    case invalidResponseData
}

class BasketballCourtsProvider {

    let dataLoader = DataLoader()
    
    private var requestToken: RequestToken? = nil
    
    typealias GetCourtCompletion = ([BasketballCourt]?, Error?) -> Void

    
    func URLSession(session: URLSession, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!)
        )
    }
    
    private func getCertificates() -> [SecCertificate] {
        let url = Bundle.main.url(forResource: "iPlay", withExtension: "cer")!
        let localCertificate = try! Data(contentsOf: url) as CFData
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate)
            else { return [] }
        
        return [certificate]
    }
    
    func getApiData(city: String, gymType: String, completion: @escaping GetCourtCompletion) {
        
        
        let urlComponents = NSURLComponents(string: "https://iplay.sa.gov.tw/odata/GymSearch")!
        
        urlComponents.queryItems = [
            NSURLQueryItem(name: "City", value:city),
            NSURLQueryItem(name: "GymType", value:gymType)] as [URLQueryItem]

        var basketballCourts = [BasketballCourt]()

        
        guard let url = urlComponents.url else {
            completion(nil, NetworkError.formURLFail)
            return
        }
        
        requestToken = dataLoader.getData(url: url, headers: nil, completionHandler: { result in //[unowned self]
            
            switch result {
                
            case .success(let data):
                
                let decoder = JSONDecoder()
                
                do {
                    // check if dictionary
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                    guard
                        let results = jsonObject?["value"] as? [Dictionary<String, AnyObject>]
                    else { return }
                    
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

                    
                } catch {
                    
                }
                
                break
                
            case .error(let error): break
                
                
//                completionHandler(nil, error)
            }
        })
//        sessionManager?.request(urlString, parameters: parameters).validate().responseJSON { response in
//            print(response)
//            if response.result.isSuccess {
//
//                } else {
//                    completion(nil, GetCourtError.invalidResponseData)
//                }
//
//            } else {
//                completion(nil, GetCourtError.responseError)
//            }
//        }
    }
}
