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
    
    
    override func awakeFromNib() {
//        titleLabel?.numberOfLines = 0
//        titleLabel?.lineBreakMode = .byWordWrapping
//        titleLabel?.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
    }
    
    func configure(movie: Movie) {
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = movie.title != "" ? movie.title : movie.originalTitle
        titleLabel.textAlignment = .right
        
        
//        dateLabel.text = "Released \(movie.releaseYear))"
//        genreLabel.text = "\(movie.genreIds)"
        
    }

}
