//
//  TMDBConstants.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 11/18/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import Foundation

struct TMDB {
    static let APIScheme = "https"
    static let APIHost = "api.themoviedb.org"
    static let APIPath = "/3"
    
    static let youtube_url_path: String = "https://www.youtube.com/watch?v="
    
}

struct TMDBParameterKeys {
    static let APIKey = "api_key"
    static let page = "page"
     static let region = "region"
}

struct TMDBParameterValues {
    static let APIKey = "7fbb44def93e985a9e7fae26792df9ab"
    static let region_US = "US"
}

struct TMDBRequestPaths {
    static let APIMoviesNowPlaying = "/movie/now_playing"
}

struct TMDBPosterImageSizes {
   static let w92 = "w92"
   static let w154 = "w154"
   static let w185 = "w185"
   static let w342 = "w342"
   static let w500 = "w500"
   static let w780 = "w780"
   static let original = "original"
}

struct TMDBDataKeys {
    static let MovieOriginalTitle = "original_title"
    static let PosterPath = "poster_path"
    static let BackdropPath = "backdrop_path"
    static let Overview = "overview"
    static let title = "title"
    static let id = "id"
    static let releaseDate = "release_date"
    
    static let youtube_video_type = "type"
    
    static let youtube_video_trailer_value = "Trailer"
}

struct TMDBGenreIDs {
    static let Action = 28
    static let Adventure = 12
    static let Animation = 16
    static let Comedy = 35
    static let Crime = 80
    static let Documentary = 99
    static let Drama = 18
    static let Family = 10751
    static let Fantasy = 14
    static let History = 36
    static let Horror = 27
    static let Music = 10402
    static let Mystery = 9648
    static let Romance = 10749
    static let ScienceFiction = 878
    static let TVMovie = 10770
    static let Thriller = 53
    static let War = 10752
    static let Western = 37
}

struct TMDBSortCriteria {
    static let PopAsc = "popularity.asc"
    static let PopDesc = "popularity.desc"
    static let RelDateAsc = "release_date.asc"
    static let RelDateDesc = "release_date.desc"
    static let RevAsc = "revenue.asc"
    static let RevDesc = "revenue.desc"
    static let PriRelDateAsc = "primary_release_date.asc"
    static let PriRelDateDesc = "primary_release_date.desc"
    static let OrigTitleAsc = "original_title.asc"
    static let OrigTitleDesc = "original_title.desc"
    static let VoteAvgAsc = "vote_average.asc"
    static let VoteAvgDesc = "vote_average.desc"
    static let VoteCountAsc = "vote_count.asc"
    static let VoteCountDesc = "vote_count.desc"

}

struct TMDBError {
    static let NoNetworkConnection = "The device is not connected to the internet!"
}


