//
//  DeleteSessionResponse.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

struct DeleteSessionResponse: Codable {
    let session: Session
    
    enum CodingKeys: String, CodingKey{
        case session
    }
}
