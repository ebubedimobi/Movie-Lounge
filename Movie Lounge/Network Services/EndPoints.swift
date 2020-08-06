//
//  EndPoints'.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

struct EndPoints {

    struct SearchMovies {
        static let topUrl = "https://api.themoviedb.org/3/search/movie?api_key="
        static let endUrl = "&query="
        
    }
    
    struct discoverMovies{
        static let baseUrl = "https://api.themoviedb.org/3/movie/popular?api_key="
        static let endUrl = "&page="
    }
    
    struct discoverSeries {
        static let baseUrl = "https://api.themoviedb.org/3/tv/popular?api_key="
    }

    
    
}
