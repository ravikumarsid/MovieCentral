//
//  TMDBMovie.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 11/22/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import Foundation
import UIKit

class TMDBMovie {
    
    var backdropImage: UIImage?
    var posterImage: UIImage?
    var backdropURL: URL?
    var posterURL: URL?
    let posterPath: String
    let backdropPath: String
    let title: String
    let overview: String
    let tmdbMovieID: Int
    let releaseDate: String
    
    init(tmdbMovieID: Int, posterPath: String, backdropPath: String, title: String, overview: String, releaseDate: String) {
        self.tmdbMovieID = tmdbMovieID
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
    }
    
    func imageURL(isPosterURL: Bool, posterSize: String) -> URL? {
        let imagePath: String = isPosterURL ? posterPath : backdropPath
        if let url = URL(string: "https://image.tmdb.org/t/p/\(posterSize)\(imagePath)") {
            return url
        }
        return nil
    }

}
