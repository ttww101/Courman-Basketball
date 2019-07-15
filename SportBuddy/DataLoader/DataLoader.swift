
import Foundation

enum NetworkError: Error {
    
    case dataTaskError
    
    case parseError
    
    case formURLFail
    
    case other

}

enum Result<T> {
    
    case success(T)
    
    case error(Error)
}

protocol NetworkService { //ISP
    
    @discardableResult
    func getData(url: URL, headers: [String: String]?,
                 completionHandler: @escaping (Result<Data>) -> Void) -> RequestToken
}

class DataLoader: NSObject, NetworkService, URLSessionDelegate {
    
    var session: URLSession = URLSession.shared
    
    // init for singleton (can be change if there's other session provide for another singleton)
    override init() {
        super.init()
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
    }
    
    @discardableResult
    func getData(url: URL, headers: [String: String]? = nil,
                 completionHandler: @escaping (Result<Data>) -> Void) -> RequestToken {
        
        let request: URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }()
        
        let task = session.dataTask(with: request) { (data, _, error) in
            
            switch (data, error) {
                
            case (_, let error?):
                
                completionHandler(.error(error))
                
            case (let data?, _):
                
                completionHandler(.success(data))
                
            case (nil, nil):
                
                completionHandler(.error(NetworkError.dataTaskError))
                
            default: break
                
            }
        }
        
        task.resume()
        
        return RequestToken(task: task)
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
