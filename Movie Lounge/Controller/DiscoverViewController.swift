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
        super.viewDidLoad()
        
        seriesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.GetData()
        
    }
    
    func GetData(){
        
        let discoverMoviesService = DiscoverMoviesService()
        discoverMoviesService.fetchMovies().observeOn(MainScheduler.instance).subscribe(onNext: { movies in
            self.loadDataFromCache()
        }).disposed(by: disposeBag)
        
        let discoverSeriesService = DiscoverSeriesService()
        discoverSeriesService.fetchSeries().observeOn(MainScheduler.instance).subscribe(onNext: { movies in
            self.loadDataFromCache()
        }).disposed(by: disposeBag)
        
    }
    
    func loadDataFromCache(){
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











