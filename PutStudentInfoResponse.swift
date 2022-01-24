//
//  PutStudentInfoResponse.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

struct PutStudentInfoResponse : Codable {
    
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        
        case updatedAt
    }
}
