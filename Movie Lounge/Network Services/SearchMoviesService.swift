//
//  SearchNetworkServices.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RxSwift

struct SearchMoviesService {
    
    func fetchMovies(with movieName: String)-> Observable<MoviesData>{
        
        return Observable.create { (observer) -> Disposable in
            
            let completeQueryURL = EndPoints.SearchMovies.topUrl + Keys.clientID + EndPoints.SearchMovies.endUrl + movieName
            
            
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
                            
                            let decodedMoviesData = try decoder.decode(MoviesData.self, from: safeData)
                            observer.onNext(decodedMoviesData)
                            
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




