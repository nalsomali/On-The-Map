//
//  User.swift
//  On the Map
//
//  Created by Nada  on 22/08/2021.
//

import Foundation

struct Udacity: Codable {
        var udacity: UdacityInfo
        
        enum CodingKeys: String, CodingKey {
            case udacity
        }
    }

    struct UdacityInfo: Codable {
        
        var username: String
        var password: String
        
        enum CodingKeys: String, CodingKey {
            
            case username
            case password
            
        }
    }
