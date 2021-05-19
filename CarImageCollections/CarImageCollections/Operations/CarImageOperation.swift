import UIKit


final class CarImageOperation: AsyncOperation {
    var image: UIImage?
    private let url: URL
    private let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    private var task: URLSessionDataTask?
    
    init(url: URL, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.url = url
        self.completionHandler = completion
        super.init()
    }
    
    override func main() {
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.state = .finished }
            guard !self.isFinished else { return }
            
            if let completion = self.completionHandler {
                completion(data, response, error)
                return
            }
            
            guard error == nil,
                  let data = data else {
                return
            }
            
            self.image = UIImage(data: data)
        }
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}
