//
//  ViewController.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var seriesCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    private let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    private  var trendingMovies: Results<MoviesCacheData>?
    private  var trendingSeries: Results<SeriesCacheData>?
    
    
    override func viewDidLoad() {
      loadDataFromCache()
        
        seriesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.GetData()
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        self.GetData()
    }
    private func GetData(){
        
        let discoverMoviesService = DiscoverMoviesService()
            discoverMoviesService.fetchMovies().observeOn(MainScheduler.instance).subscribe(onNext: { movies in
            self.loadDataFromCache()
        }).disposed(by: disposeBag)
        
        let discoverSeriesService = DiscoverSeriesService()
        discoverSeriesService.fetchSeries().observeOn(MainScheduler.instance).subscribe(onNext: { movies in
            self.loadDataFromCache()
        }).disposed(by: disposeBag)
        
    }
    
    private func loadDataFromCache(){
        self.trendingMovies = realm.objects(MoviesCacheData.self)
        self.trendingSeries = realm.objects(SeriesCacheData.self)
        seriesCollectionView.reloadData()
        moviesCollectionView.reloadData()
        
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == seriesCollectionView{
            return trendingSeries?.count ?? 0
        }else{
            return trendingMovies?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == seriesCollectionView{
            let cell = seriesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! MovieCollectionViewCell
            
            cell.ratingsLabel.text = String(trendingSeries?[indexPath.row].vote_average ?? 0)
            cell.nameLabel.text = trendingSeries?[indexPath.row].title
            
            if let imageUrl = URL(string: Constants.baseImageUrl + (self.trendingSeries?[indexPath.row].poster_path ?? "")  ){
                cell.image.kf.indicatorType = .activity
                cell.image.kf.setImage(
                    with: imageUrl,
                    //placeholder: UIImage(named: "logo"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),
                        .cacheOriginalImage
                ])
                
            }
            return cell
            
        }else{
            let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! MovieCollectionViewCell
            
            cell.ratingsLabel.text = String(trendingMovies?[indexPath.row].vote_average ?? 0)
            cell.nameLabel.text = trendingMovies?[indexPath.row].title
            
            if let imageUrl = URL(string: Constants.baseImageUrl + (self.trendingMovies?[indexPath.row].poster_path ?? "")  ){
                cell.image.kf.indicatorType = .activity
                cell.image.kf.setImage(
                    with: imageUrl,
                    //placeholder: UIImage(named: "logo"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),
                        .cacheOriginalImage
                ])
                
            }
            return cell
        }
        
    }
}

//MARK: - UICollectionViewDelegate Methods
extension DiscoverViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.discToInfo, sender: self)
        
    }
    
}

//MARK: - Segues and Navigation
extension DiscoverViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.discToInfo{
            
            if seriesCollectionView.indexPathsForSelectedItems?.count != 0{
                let InfoVc = segue.destination as! InformationViewController
                if let index = seriesCollectionView.indexPathsForSelectedItems?[0].row, let movie = trendingSeries?[index]{
                    let infoData = InformationData(id: movie.id, vote_average: movie.vote_average, title: movie.title, release_date: movie.release_date, overview: movie.overview, poster_path: movie.poster_path, isSaved: false, saveLocation: nil)
                    
                    InfoVc.informationData = infoData
                    seriesCollectionView.deselectItem(at: (seriesCollectionView.indexPathsForSelectedItems?[0])!, animated: true)
                }
                
            }else{
                let InfoVc = segue.destination as! InformationViewController
                if let index = moviesCollectionView.indexPathsForSelectedItems?[0].row, let movie = trendingMovies?[index]{
                    let infoData = InformationData(id: movie.id, vote_average: movie.vote_average, title: movie.title, release_date: movie.release_date, overview: movie.overview, poster_path: movie.poster_path, isSaved: false, saveLocation: nil)
                    
                    InfoVc.informationData = infoData
                    seriesCollectionView.deselectItem(at: (moviesCollectionView.indexPathsForSelectedItems?[0])!, animated: true)
                    
                }
            }
        }
    }
    
    
}













