//
//  Endpoints.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    
    case getStudentLocation(params: [String:String])
    case postStudentLocation
    case updateStudentLocation(objectId: String)
    case getSession(userId: String)
    case postSession
    case deleteSession
    
    var url: URL {
        switch self {
        case let .getStudentLocation(params):
            var components = URLComponents(string: Endpoints.base + "/StudentLocation")
            components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }
            return components!.url!
        case .postStudentLocation: return URL(string: Endpoints.base + "/StudentLocation")!
        case let .updateStudentLocation(objectId): return URL(string: Endpoints.base + "/StudentLocation" + "/" + objectId)!
        case let .getSession(userId): return URL(string: Endpoints.base + "/users" + "/" + userId)!
        case .postSession: return URL(string: Endpoints.base + "/session")!
        case .deleteSession: return URL(string: Endpoints.base + "/session")!
        }
    }
}
