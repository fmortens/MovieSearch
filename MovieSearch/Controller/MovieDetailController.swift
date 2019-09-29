//
//  MovieDetailController.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 29/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {
    
    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    var movieId: Int?
    var detailsTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let id = self.movieId {
            updateUI(movieId: id)
        } else {
            print("Missing movie id")
        }
    }
    
    func updateUI(movieId id: Int) {
        
        detailsTask = MovieDBClient.getMovieDetails(byId: id) { (details, error) in
            
            if let movieDetails = details {
                
                self.movieTitleLabel.text = movieDetails.title
                self.movieDescriptionLabel.text = movieDetails.overview
                
                if let releaseDate = movieDetails.releaseDate {
                    self.movieReleaseLabel.text = "Released \(releaseDate)"
                } else {
                    self.movieReleaseLabel.isHidden = true
                }
                
                if let posterPath = movieDetails.posterPath {
                    MovieDBClient.downloadPosterImage(path: posterPath) { data, error in
                        guard let data = data else {
                            return
                        }
                        
                        let image = UIImage(data: data)
                        self.moviePosterView.image = image
                    }
                }
                
            } else {
                print("Could not load movie details")
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
