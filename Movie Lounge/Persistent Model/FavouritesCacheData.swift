//
//  FavouritesCacheData.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 06.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift

class FavouritesCacheData: Object{
    
    @objc dynamic var id: Int = 0
    @objc dynamic var vote_average: Double = 0
    @objc dynamic var title: String?
    @objc dynamic var release_date: String?
    @objc dynamic var overview: String?
    @objc dynamic var poster_path: String?
    
}
