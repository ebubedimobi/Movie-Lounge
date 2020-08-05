//
//  DiscoverSeriesData.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RxSwift


struct DiscoverSeriesService {
    
    
    func fetchSeries()-> Observable<SeriesData>{
        
        return Observable.create { (observer) -> Disposable in
            
            let completeQueryURL = EndPoints.discoverSeries.baseUrl + Keys.clientID
            
            if let url = URL(string: completeQueryURL){
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil{
                        print("Newtwork Problem \(error!)")
                        observer.onError(error!)
                        return
                    }
                    
                    if let safeData = data{
                        
                        let decoder = JSONDecoder()
                        
                        do{
                            
                            let decodedSeriesData = try decoder.decode(SeriesData.self, from: safeData)
                            let seriesCacheManager = SeriesCacheManager()
                            seriesCacheManager.recieveData(with: decodedSeriesData)
                            observer.onNext(decodedSeriesData)
                            
                        }catch{
                            
                            print("could not parse Json---\(error)")
                            observer.onError(error)
                        }
                        
                    }else {
                        print("Data is empty")
                        observer.onError(NSError(domain: "Data is empty", code: -1, userInfo: nil))
                    }
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            
            return Disposables.create { }
        }
        
    }
    
    
}

