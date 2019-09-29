//
//  MovieListController.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 28/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class MovieListController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var sortOptionsCollectionView: UICollectionView!
    
    var movies = [Movie]()
    var genres = [Genre]()
    
    var selectedIndex = 0
    
    var searchTask: URLSessionTask?
    var genreTask: URLSessionTask?
    
    let sortOptions = ["Release date", "Title"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        genreTask = MovieDBClient.getGenres() { (genres, error) in
            self.genres = genres
        }
    }

}

extension MovieListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
                
        searchTask = MovieDBClient.searchMovies(query: searchText) { (movies, error) in
            self.movies = movies
            self.movieTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension MovieListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        cell.configure(movie: movies[indexPath.row], genres: genres)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // view.endEditing(true)
        // selectedIndex = indexPath.row
        // performSegue(withIdentifier: "showDetail", sender: nil)
        // tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = movieTableView.cellForRow(at: indexPath) as? MovieCell {
            print("pressed \(cell.movieId!)")
        }
    }
    
}

extension MovieListController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortOptionCell", for: indexPath) as! SortOptionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        sortOptionsCollectionView.indexPathsForVisibleItems.forEach { ip in
            sortOptionsCollectionView.deselectItem(at: ip, animated: true)
            
            updateCell(withIndexPath: ip)
            
            //let selectedSortOption = sortOptions[indexPath.row]
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCell(withIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateCell(withIndexPath: indexPath)
    }
    
    func updateCell(withIndexPath indexPath: IndexPath) {
        
        let cell = sortOptionsCollectionView.cellForItem(at: indexPath) as! SortOptionCell
        
        cell.sortOptionLabel.text = sortOptions[indexPath.row]
        
        var cellColor: UIColor = .clear
        var textColor: UIColor = .secondaryLabel
        var textFont: UIFont = .systemFont(ofSize: 17.0)
        
        if cell.isSelected {
            cellColor = .systemOrange
            textColor = .black
            textFont = UIFont.boldSystemFont(ofSize: 17.0)
            
            print("Selected \(sortOptions[indexPath.row])")
        }
        
        cell.SortOptionView.backgroundColor = cellColor
        cell.sortOptionLabel.textColor = textColor
        cell.sortOptionLabel.font = textFont
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        self.sortOptionsCollectionView?.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
        
        updateCell(withIndexPath: indexPathForFirstRow)
    }
    
}
