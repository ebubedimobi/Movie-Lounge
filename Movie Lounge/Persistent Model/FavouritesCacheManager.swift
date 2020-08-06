//
//  FavouritesCacheManager.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 06.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift

struct FavouritesCacheManager {
    
    func recieveDataToSave(with informationData: InformationData) -> Bool{
        
        let realm = try! Realm()
        
        if realm.objects(FavouritesCacheData.self).filter("id == %@", informationData.id!).isEmpty{
            saveToDataBase(with: informationData)
            return true
        }else{
            return false
        }
        
    }
    
    func recieveDataToDelete(with informationData: InformationData){
        let realm = try! Realm()
        do{
            try realm.write{
                //realm.delete(movieForDeletion)
                realm.delete(realm.objects(FavouritesCacheData.self).filter("id == %@", informationData.id!))
            }
        }catch{
            print("error while deleting\(error)")
        }
    }
    
    private func saveToDataBase(with movie: InformationData){
        
        let realm = try! Realm()
        let newFav = FavouritesCacheData()
        do{
            newFav.id = movie.id ?? Int.random(in: 0...999)
            newFav.vote_average = movie.vote_average ?? 0
            newFav.title = movie.title
            newFav.release_date = movie.release_date
            newFav.overview = movie.overview
            newFav.poster_path = movie.poster_path
            try realm.write{
                realm.add(newFav)
            }
        }catch{
            print("error while saving\(error)")
        }
    }
    
    func checkIFInFavourites(with id: Int)-> Bool{
        
        let realm = try! Realm()
        if realm.objects(FavouritesCacheData.self).filter("id == %@", id).isEmpty{
            return false
        }else{
            return true
        }
    }
}
