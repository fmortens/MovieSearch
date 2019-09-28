//
//  MovieDBResponse.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 28/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import Foundation

struct MovieDBResponse: Codable {
    
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension MovieDBResponse: LocalizedError {
    
    var errorDescription: String? {
        return statusMessage
    }
    
}
