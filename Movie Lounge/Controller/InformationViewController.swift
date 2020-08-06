//
//  InformationViewController.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import Kingfisher

class InformationViewController: UIViewController {
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var overview: UILabel!
    
  var borrowedCollectionView: UICollectionView?
        
        var informationData: InformationData?
        override func viewDidLoad() {
            super.viewDidLoad()
            loadData()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            loadData()
            
        }
        
        
        
        func loadData(){
            movieName.text = informationData?.title
            movieYear.text = setYear(with: informationData?.release_date)
            movieRating.text = String(informationData?.vote_average ?? 0)
            overview.text = informationData?.overview
            setImage()
            setHeart()
            
            
        }
        
        
        func setYear(with date: String?) -> String? {
            
            let array = date?.components(separatedBy: "-")
            return array?[0]
            
            
        }
        func setHeart(){
            let favouritesCacheManager = FavouritesCacheManager()
            
            if let id = informationData?.id{
                
                if favouritesCacheManager.checkIFInFavourites(with: id){
                    
                    likeButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    informationData?.isSaved = true
                }else{
                    likeButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
                    informationData?.isSaved = false
                }
            }
            
        }
        
        
        
        @IBAction func likeButtonPressed(_ sender: UIButton) {
            
            let favouritesCacheManager = FavouritesCacheManager()
            
            if informationData?.isSaved == false{
                //save
                if informationData != nil{
                    let check = favouritesCacheManager.recieveDataToSave(with: informationData!)
                    borrowedCollectionView?.reloadData()
                    handleCheck(with: check)
                }
                
            }else{
                //delete
                delete()
                borrowedCollectionView?.reloadData()
                
            }
            
        }
        
        func handleCheck(with check: Bool){
            if check{
                informationData?.isSaved = true
                setHeart()
            }
        }
        
        func delete(){
            let favouritesCacheManager = FavouritesCacheManager()
            if informationData != nil{
                favouritesCacheManager.recieveDataToDelete(with: informationData!)
                informationData?.isSaved = false
                setHeart()
            }
        }
        
        func setImage(){
            
            if let imageUrl = URL(string: Constants.baseImageUrl + (self.informationData?.poster_path ?? "")  ){
                imageCover.kf.indicatorType = .activity
                imageCover.kf.setImage(
                    with: imageUrl,
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),
                        .cacheOriginalImage
                ])
                
            }
            
        }
    }
