//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 28/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    var movieId: Int?
    
    func configure(movie: Movie, genres availableGenres: [Genre]) {
        
        movieId = movie.id
        
        titleLabel.text = movie.title != "" ? movie.title : movie.originalTitle
        releaseYearLabel.text = "Released \(movie.releaseYear)"
        
        if movie.genreIds.count > 0 {
            
            var genreNames = [String]()
            movie.genreIds.forEach { (id) in
                
                if let genre = availableGenres.first(where: { (genre) -> Bool in
                    genre.id == id
                }) {
                    genreNames.append(genre.name)
                }
                
            }
            
            genreLabel.text = genreNames.joined(separator: ", ")
            
        }
        
        if let posterPath = movie.posterPath {
            MovieDBClient.downloadThumbnailImage(path: posterPath) { data, error in
                guard let data = data else {
                    return
                }
                
                let image = UIImage(data: data)
                self.thumbnail.image = image
            }
        }
        
    }

}
