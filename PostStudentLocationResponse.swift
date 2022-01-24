//
//  PostStudentLocationResponse.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

struct PostStudentLocationResponse: Codable {
    
    let objectId: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        
        case objectId
        case createdAt
        
    }
    
}
