
import Foundation

class RequestToken {
    
    private weak var task: URLSessionTask? //DIP
    
    init(task: URLSessionTask? = nil) {
        
        self.task = task
    }
    
    //TODO: Ask where to use
    func cancel() {//SIP
        
        task?.cancel()
    }
}
