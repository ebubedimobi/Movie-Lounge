//
//  SeriesCacheManager.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

import RealmSwift


struct SeriesCacheManager {
    
    func recieveData(with seriesData: SeriesData){
        
        saveToDataBase(with: seriesData)
    }
    
    private func saveToDataBase(with seriesData: SeriesData){
        emptyDataBase()
        let realm = try! Realm()
        
        
        for series in seriesData.results{
            
            do{
                let newSeries = SeriesCacheData()
                newSeries.id = series.id ?? Int.random(in: 0...999)
                newSeries.vote_average = series.vote_average ?? 0
                newSeries.title = series.name
                newSeries.release_date = series.first_air_date
                newSeries.overview = series.overview
                newSeries.poster_path = series.poster_path
                try realm.write{
                    realm.add(newSeries)
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
                
                realm.delete(realm.objects(SeriesCacheData.self))
            }
            
        }catch{
            print("error while deleting")
        }
        
        
    }
    
    
}
