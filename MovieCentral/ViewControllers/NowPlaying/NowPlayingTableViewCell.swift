//
//  NowPlayingTableViewCell.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 11/24/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit

class NowPlayingTableViewCell: UITableViewCell {

   @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = contentView.center
        contentView.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    
    
}
