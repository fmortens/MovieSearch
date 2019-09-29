//
//  MovieDetailController.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 29/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {
    
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Showing movie id \(movieId ?? 0)")
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
