//
//  MovieCollectionViewCell.swift
//  Movie Lounge
//
//  Created by Ebubechukwu Dimobi on 05.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellViewHolder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        cellViewHolder.layer.cornerRadius = cellViewHolder.frame.size.height / 13
        image.layer.cornerRadius = image.frame.size.height / 13
        
    }

}
