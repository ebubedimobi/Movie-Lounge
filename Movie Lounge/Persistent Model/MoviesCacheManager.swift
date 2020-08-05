//
//  MoviesCacheManager.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift


struct MoviesCacheManager {
    
    func recieveData(with moviesData: MoviesData){
        
        saveToDataBase(with: moviesData)
    }
    
    private func saveToDataBase(with moviesData: MoviesData){
        emptyDataBase()
        let realm = try! Realm()
        
        
        for movie in moviesData.results{
            
            do{
                let newMovie = MoviesCacheData()
                newMovie.id = movie.id ?? Int.random(in: 0...999)
                newMovie.vote_average = movie.vote_average ?? 0
                newMovie.title = movie.title
                newMovie.release_date = movie.release_date
                newMovie.overview = movie.overview
                newMovie.poster_path = movie.poster_path
                try realm.write{
                    realm.add(newMovie)
                }
                
            }catch{
                print("error while saving\(error)")
            }
        }
        
        
    }
    
    private func emptyDataBase(){
        let realm = try! Realm()
        do{
            
            try realm.write{
                
                realm.delete(realm.objects(MoviesCacheData.self))
            }
            
        }catch{
            print("error while deleting")
        }
        
        
    }
    
    
}
