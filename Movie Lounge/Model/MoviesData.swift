//
//  SearchMoviesData.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation


struct MoviesData: Codable {
    
    let results: [MoviesResults]
   
}

struct MoviesResults: Codable {
    
    let id: Int?
    let vote_average: Double?
    let title: String?
    let release_date: String?
    let overview: String?
    let poster_path: String?
    
}
