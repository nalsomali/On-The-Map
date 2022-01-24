//
//  base.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation
class BaseClient {
    
    static var userKey: String = ""
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type,isAuthenticated: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        DispatchQueue.main.async(qos: .utility) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let decoder = JSONDecoder()
                var newData = data
                do {
                    if isAuthenticated {
                        let range = (5..<data.count)
                        newData = data.subdata(in: range) /* subset response data! */
                        print(String(data: newData, encoding: .utf8)!)
                    }
                    let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    completion(responseObject, nil)
                } catch {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    class func taskForGETRequest(url: URL,isAuthenticated: Bool = false, completion: @escaping ([String:AnyObject]?, Error?) -> Void) {
        
        DispatchQueue.main.async(qos: .utility) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                var newData = data
                if isAuthenticated {
                    let range = (5..<data.count)
                    newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                }
                if let responseObject = BaseClient.convertDataToDictionary(data: newData) {
                    completion(responseObject, nil)
                } else {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, additionalReqValue: [String: String]? = nil, isAuthenticated: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for item in additionalReqValue ?? [:] {
            request.addValue(item.key, forHTTPHeaderField: item.value)
        }
        DispatchQueue.main.async(qos: .utility) {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let decoder = JSONDecoder()
                var newData = data
                do {
                    if isAuthenticated {
                        let range = (5..<data.count)
                        newData = data.subdata(in: range) /* subset response data! */
                        print(String(data: newData, encoding: .utf8)!)
                    }
                    let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    completion(responseObject, nil)
                } catch {
                    completion(nil, error)
                }
                
            }
            task.resume()
        }
    }
    
    class func taskForDELETERequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isAuthenticated: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        if isAuthenticated {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        DispatchQueue.main.async(qos: .utility) {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let decoder = JSONDecoder()
                var newData = data
                do {
                    if isAuthenticated {
                        let range = (5..<data.count)
                        newData = data.subdata(in: range) /* subset response data! */
                        print(String(data: newData, encoding: .utf8)!)
                    }
                    let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    completion(responseObject, nil)
                } catch {
                    completion(nil, error)
                }
                
            }
            task.resume()
        }
    }
    
    private class func convertDataToDictionary(data: Data) -> [String:AnyObject]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json
        } catch {
            return nil
        }
    }
}
