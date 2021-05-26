import UIKit

enum FetchType {
    case normal
    case semaphore
}

class NetworkManager {
    static let shared = NetworkManager()
    let semaphore = DispatchSemaphore(value: 2)
    
    private init() {}
    
    func fetchImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    func fetchImageByTwo(with url: URL, completion: @escaping (UIImage?) -> Void) {
        semaphore.wait()
        print("Semaphore IN!")
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            print("Done")
            guard let self = self else { return }
            defer { self.semaphore.signal() }
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
}
