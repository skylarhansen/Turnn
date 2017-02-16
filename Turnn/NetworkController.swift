//
//  NetworkController.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/18/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation

class NetworkController {
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func performRequestForURL(_ url: URL, httpMethod: HTTPMethod, urlParameters: [String:String]? = nil, body: Data? = nil, completion: ((_ data: Data?, _ error: NSError?) -> Void)?) {
        
//        let requestURL = urlFromURLParameters(url, urlParameters: urlParameters)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if let completion = completion {
                completion(data, error as NSError?)
            }
        }) 
        dataTask.resume()
    }
    
    static func urlFromURLParameters(_ url: URL, urlParameters: [String: String]?) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = urlParameters?.flatMap({URLQueryItem(name: $0.0, value: $0.1)})
        
        if let url = components?.url {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
}
