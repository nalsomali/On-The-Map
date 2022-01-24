//
//  onTheMapClient.swift
//  On the Map
//
//  Created by Nada  on 22/08/2021.
//

import Foundation

class onTheMapClient {
    class func postSession(username: String, password: String, completion: @escaping (PostSessionResponse?, Error?) -> Void) {
        let body = Udacity(udacity: UdacityInfo(username: username, password: password))
        BaseClient.taskForPOSTRequest(url: Endpoints.postSession.url, responseType: PostSessionResponse.self, body: body, additionalReqValue: ["application/json":"Accept"], isAuthenticated: true) { response, error in
            if let error = error {
                completion(nil,error)
            } else {
                completion(response, nil)
            }
        }
    }
    
    class func deleteSession(completion: @escaping (DeleteSessionResponse?, Error?) -> Void) {
        BaseClient.taskForDELETERequest(url: Endpoints.deleteSession.url, responseType: DeleteSessionResponse.self, isAuthenticated: true) { response, error in
            if let error = error {
                completion(nil,error)
            } else {
                completion(response, nil)
            }
        }
    }
    
    class func getSession(userId: String, completion: @escaping ([String:AnyObject]?, Error?) -> Void) {
        BaseClient.taskForGETRequest(url: Endpoints.getSession(userId: userId).url, isAuthenticated: true) { resultDict, error in
            if let response = resultDict {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}

