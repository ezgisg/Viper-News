//
//  Router.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let apiKey = "79ee84ba5ad9405194416de10bb228ec"
    
    case sources
    case everything(source: String?, page: Int?, query: String?)
    
    var baseURL: URL? {
        return URL(string: "https://newsapi.org/v2/")
    }
    
    var path: String {
        switch self {
        case .sources:
            return "sources"
        case .everything(source: _, page: _, query: _):
            return "everything"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sources, .everything:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: Parameters = [:]
        switch self {
        case .sources:
            return nil
        case .everything(source: let source, page: let page, query: let query):
            if let source {
                params["sources"] = source
            }
            if let page {
                params["page"] = page
            }
            if let query {
                params["q"] = query
            }
        }
        
        return params
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        guard let baseURL else {throw URLError(.badURL)}
        var urlRequest = URLRequest(url: baseURL.appending(path: path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var completeParameters = parameters ?? [:]
        completeParameters["apiKey"] = Router.apiKey
        
        do {
           let request = try encoding.encode(urlRequest, with: completeParameters)
            debugPrint("***** MY URL: ", request.url ?? "")
            return request
        } catch  {
            debugPrint("***** Error urlrequest: ", error)
            throw error 
        }
        
    }
}
