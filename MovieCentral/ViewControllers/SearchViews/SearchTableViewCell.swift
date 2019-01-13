//
//  SearchTableViewCell.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 1/5/19.
//  Copyright © 2019 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var peopleNameTextView: UITextView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = contentView.center
        contentView.addSubview(activityIndicator)
        return activityIndicator
    }()
}
