//
//  StudentInfoResults.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

struct StudentInformationResults: Codable {
    
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
