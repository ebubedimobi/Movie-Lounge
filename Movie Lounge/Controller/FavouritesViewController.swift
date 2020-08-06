//
//  FavouritesViewController.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    private  var favouriteMovies: Results<FavouritesCacheData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        loadDataFromCache()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        removeKeyBoard()
        loadDataFromCache()
    }
    
    private func removeKeyBoard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    private func loadDataFromCache(){
        let realm = try! Realm()
        self.favouriteMovies = realm.objects(FavouritesCacheData.self)
        collectionView.reloadData()
        
    }
    
}


//MARK: - UICollectionViewDataSource Methods

extension FavouritesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        cell.ratingsLabel.text = String(favouriteMovies?[indexPath.row].vote_average ?? 0)
        cell.nameLabel.text = favouriteMovies?[indexPath.row].title
        
        if let imageUrl = URL(string: Constants.baseImageUrl + (self.favouriteMovies?[indexPath.row].poster_path ?? "")  ){
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(
                with: imageUrl,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
            ])
            
        }
        return cell
        
    }
}

//MARK: - UICollectionViewDelegate Methods
extension FavouritesViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.favsToInfo, sender: self)
        
    }
}

//MARK: - Quering/searching from Realm
//MARK: - UISearchBarDelegate Methods

extension FavouritesViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        favouriteMovies = favouriteMovies?.filter("title CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        collectionView.reloadData()
        
    }
    
    //starts searching once person starts typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.reloadData()
        if searchBar.text?.count == 0{
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadDataFromCache()
        }
        //         else {
        //
        //            favouriteMovies = favouriteMovies?.filter("title CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        //
        //             collectionView.reloadData()
        //         }
    }
    
    
}



//MARK: - Segues and Navigation
extension FavouritesViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.favsToInfo{
            
            let InfoVc = segue.destination as! InformationViewController
            if let index = collectionView.indexPathsForSelectedItems?[0].row, let movie = favouriteMovies?[index]{
                let infoData = InformationData(id: movie.id, vote_average: movie.vote_average, title: movie.title, release_date: movie.release_date, overview: movie.overview, poster_path: movie.poster_path, isSaved: true, saveLocation: index)
                
                InfoVc.informationData = infoData
                InfoVc.borrowedCollectionView = self.collectionView
            }
            
        }
    }
    
    
}
