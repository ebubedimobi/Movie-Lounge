//
//  SharedData.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 06.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

struct InformationData {
    let id: Int?
    let vote_average: Double?
    let title: String?
    let release_date: String?
    let overview: String?
    let poster_path: String?
    var isSaved: Bool?
    let saveLocation: Int?
}
