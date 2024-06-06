//
//  NetworkManager.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation
import Alamofire


final class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
//    var reachabilityManager = NetworkReachabilityManager()?.isReachable
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func request<T: Decodable> (_ request: URLRequestConvertible, decodeToType type: T.Type, completion: @escaping (Result<T,Error>) -> ()) {
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(type.self, from: data)
                    completion(.success(result))
                } catch  {
                    completion(.failure(error))
                    //TODO: Alert
                    print("***Decoding error: \(error)***")
                }
            case .failure(let error):
                completion(.failure(error))
                //TODO: Alert
                print("***Decoding error: \(error)***")
            }
        }
    }
    
}
