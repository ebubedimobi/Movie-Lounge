//
//  SearchViewController.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var moviesData: MoviesData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        removeKeyBoard()
        
    }
    
    private func removeKeyBoard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    
    
}

//MARK: - UICollectionViewDataSource Methods
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesData?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        cell.ratingsLabel.text = String(moviesData?.results[indexPath.row].vote_average ?? 0)
        cell.nameLabel.text = moviesData?.results[indexPath.row].title
        
        
        
        if let imageUrl = URL(string: Constants.baseImageUrl + (self.moviesData?.results[indexPath.row].poster_path ?? "")  ){
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
extension SearchViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.searchToInfo, sender: self)
        
    }
    
    
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if var name = searchBar.text{
            
            
            if name.contains(" "){
                
                name = self.removeSpaces(in: name )
            }
            
            DispatchQueue.main.async {
                searchBar.endEditing(true)
            }
            
            let searchMoviesService = SearchMoviesService()
            searchMoviesService.fetchMovies(with: name).observeOn(MainScheduler.instance).subscribe(onNext: { movies in
                self.moviesData = movies
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        }
    }
    
    private func removeSpaces(in item: String)->String{
        let array = item.components(separatedBy: " ")
        var result = String()
        for x in 0..<array.count{
            if x != array.count-1{
                result += "\(array[x])%20"
            }else {
                result += "\(array[x])"
            }
        }
        
        return result
    }
}

//MARK: - Segues and Navigation
extension SearchViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.searchToInfo{
            
            let InfoVc = segue.destination as! InformationViewController
            if let index = collectionView.indexPathsForSelectedItems?[0].row, let movie = moviesData?.results[index]{
                let infoData = InformationData(id: movie.id, vote_average: movie.vote_average, title: movie.title, release_date: movie.release_date, overview: movie.overview, poster_path: movie.poster_path, isSaved: false, saveLocation: nil)
                
                InfoVc.informationData = infoData
            }
            
        }
    }
    
    
}
