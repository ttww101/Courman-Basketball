//
//  Blah.swift
//  SportBuddy
//
//  Created by Wu on 2019/7/9.
//  Copyright © 2019 stevenchou. All rights reserved.
//

import Foundation

class Blah:NSObject, URLSessionDelegate {
    
    func rest() {
        let path = "https://iplay.sa.gov.tw/odata/GymSearch"
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print(response)
            print(data)
//            let json:JSON = JSON(data: data!)
//            if let c = json["content"].string {
//                print(c)
//            }
        })
        task.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("*** received SESSION challenge...\(challenge)")
        let trust = challenge.protectionSpace.serverTrust!
        let credential = URLCredential(trust: trust)
        
//        guard isSSLPinningEnabled else {
//            print("*** SSL Pinning Disabled -- Using default handling.")
//            completionHandler(.useCredential, credential)
//            return
//        }
        
        let myCertName = "iPlay"
        var remoteCertMatchesPinnedCert = false
        if let myCertPath = Bundle.main.path(forResource: myCertName, ofType: "cer") {
            if let pinnedCertData = NSData(contentsOfFile: myCertPath) {
                // Compare certificate data
                let remoteCertData: NSData = SecCertificateCopyData(SecTrustGetCertificateAtIndex(trust, 0)!)
                if remoteCertData.isEqual(to: pinnedCertData as Data) {
                    print("*** CERTIFICATE DATA MATCHES")
                    remoteCertMatchesPinnedCert = true
                }
                else {
                    print("*** MISMATCH IN CERT DATA.... :(")
                }
                
            } else {
                print("*** Couldn't read pinning certificate data")
            }
        } else {
            print("*** Couldn't load pinning certificate!")
        }
        
        if remoteCertMatchesPinnedCert {
            print("*** TRUSTING CERTIFICATE")
            completionHandler(.useCredential, credential)
        } else {
            print("NOT TRUSTING CERTIFICATE")
            completionHandler(.rejectProtectionSpace, nil)
        }
    }
}
