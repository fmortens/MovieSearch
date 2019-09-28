//
//  MovieResponse.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 28/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}
