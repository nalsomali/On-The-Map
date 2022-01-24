//
//  studentclient.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

class studentClient {
    class func getStudentLocation (params: [String:String]? = nil, completion: @escaping ([StudentInformation], Error?) -> Void) {
        BaseClient.taskForGETRequest(url: Endpoints.getStudentLocation(params: params ?? [:]).url,
                                     responseType: StudentInformationResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(student: PostUserInformation, completion: @escaping (Bool, Error?) -> Void) {
        BaseClient.taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostStudentLocationResponse.self, body: student) { response, error in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func updateStudentLocation(objectId: String, student: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateStudentLocation(objectId: objectId).url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(student)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        task.resume()
    }
}
