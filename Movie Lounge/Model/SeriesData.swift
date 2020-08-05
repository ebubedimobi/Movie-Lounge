//
//  SeriesData.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

struct SeriesData: Codable {
    
    let results: [SeriesResults]
   
}

struct SeriesResults: Codable {
    
    let id: Int?
    let vote_average: Double?
    let name: String?
    let first_air_date: String?
    let overview: String?
    let poster_path: String?
    
}
