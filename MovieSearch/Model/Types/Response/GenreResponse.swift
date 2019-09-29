//
//  GenreResult.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 28/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import Foundation

struct GenreResponse: Codable {
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }
}
