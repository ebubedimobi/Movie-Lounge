//
//  Constants.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

struct Constants {
    static let cellIdentifier = "ReuseableCell"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    
    struct Segue {
        static let discToInfo = "goToInfoFromDiscover"
        static let favsToInfo = "goToInfoFromFavs"
        static let searchToInfo = "goToInfoFromSearch"
    }
}
