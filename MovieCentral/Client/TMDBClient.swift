//
//  TMDBClient.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 11/18/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//




import Foundation
import TMDBSwift

class TMDBClient: NSObject {

    static func createTMDBURLFromParameters(_ parameters: [String:AnyObject], requestPath: String) -> URL{
        var components = URLComponents()
        components.scheme = TMDB.APIScheme
        components.host = TMDB.APIHost
        
        
        components.path = TMDB.APIPath + requestPath
        components.queryItems = [URLQueryItem]()
        
        for (key, val) in parameters {
            let queryItem = URLQueryItem(name: key , value: val as? String)
            components.queryItems?.append(queryItem)
        }
        print("The url is: \(components.url!)")
        return components.url!
    }
    
    
    private func DiscoverMovies(discoverParams: [DiscoverParam]) {
        TMDBConfig.apikey = TMDBParameterValues.APIKey
        
        DiscoverMovieMDB.discoverMovies(params: discoverParams){ data, movieArr in
            if let movieArr = movieArr{
                print("Number of movies is \(movieArr.count)")
                
                for movie in movieArr {
                    print(movie.title as Any)
                    print(movie.original_title as Any)
                    print(movie.release_date as Any)
                    print(movie.overview as Any)
                    
                }
            }
        }
    }
    
    
    static func imageURL(imagePath: String, imageSize: String) -> URL? {
        let imageSize: String = imageSize
        if let url = URL(string: "https://image.tmdb.org/t/p/\(imageSize)\(imagePath)") {
            return url
        }
        return nil
    }
    
   
    static func getMovieVideoURLsForMovie(withID: Int, completionHandler: @escaping (String?, NetworkError) -> ()){
        TMDBConfig.apikey = TMDBParameterValues.APIKey
        
        MovieMDB.videos(movieID: withID) { (data, videosArr) in
            
            var videoURL: String = ""
            
            if let videoArr = videosArr {
                
                for video in videoArr {
                    
                    if video.type == TMDBDataKeys.youtube_video_trailer_value {
                        
                        
                        let videourl: String = "\(TMDB.youtube_url_path)\(video.key!)"

                        videoURL = videourl
                    }
                }
                 print("Video urls ar: \(videoURL)")
                completionHandler(videoURL, .success)
            }
            
            guard let empty = videosArr?.isEmpty, !empty else {
                completionHandler(nil, .failure)
                return
            }
        }
    }
    
    
    static func getNowPlayingMovies(pageNumber: Int, completionHandlerNowPlaying: @escaping (_ nowPlayingArr: [MovieMDB]?, _ error: Error?) -> ()) {
          TMDBConfig.apikey = TMDBParameterValues.APIKey
        
        func sendError(error: String) {
            _ = [NSLocalizedDescriptionKey: error]
             print(error)
            completionHandlerNowPlaying(nil, error as? Error)
        }

        
        MovieMDB.nowplaying(page: pageNumber) { (ClientReturn, nowplayingMovieArr) in
            
            if Reachability.isConnectedToNetwork() != true {
                sendError(error: TMDBError.NoNetworkConnection)
                return
            }
            
            guard (ClientReturn.error == nil) else {
                sendError(error: "There was a error in your request: \(String(describing: ClientReturn.error))")
                return
            }
        
            
           guard let empty = nowplayingMovieArr?.isEmpty, !empty else{
            sendError(error: "No data was returned by the request!")
            return
            }
            
            completionHandlerNowPlaying(nowplayingMovieArr, nil)
            
        }
        
    }

    
}

extension TMDBClient {
    static func getGenres(forID: Int) -> MovieGenres? {
        
        let input_genre_id = String(forID)
        
        if TMDBGenreIDs.Action == forID {
            return MovieGenres.Action
            
        }
        if TMDBGenreIDs.Adventure == forID {
            return MovieGenres.Adventure
        }
        if TMDBGenreIDs.Animation == forID {
            return MovieGenres.Animation
        }
        if TMDBGenreIDs.Comedy == forID {
            return MovieGenres.Comedy
        }
        if TMDBGenreIDs.Crime == forID {
            return MovieGenres.Crime
        }
        if TMDBGenreIDs.Documentary == forID {
            return MovieGenres.Documentary
        }
        if TMDBGenreIDs.Drama == forID {
            return MovieGenres.Drama
        }
        if TMDBGenreIDs.Family == forID {
            return MovieGenres.Family
        }
        if TMDBGenreIDs.Fantasy == forID {
            return MovieGenres.Fantasy
        }
        if TMDBGenreIDs.History == forID {
            return MovieGenres.History
        }
        if TMDBGenreIDs.Horror == forID {
            return MovieGenres.Horror
        }
        if TMDBGenreIDs.Music == forID {
            return MovieGenres.Music
        }
        if TMDBGenreIDs.Mystery == forID {
            return MovieGenres.Mystery
        }
        if TMDBGenreIDs.Romance == forID {
            return MovieGenres.Romance
        }
        if TMDBGenreIDs.ScienceFiction == forID {
            return MovieGenres.ScienceFiction
        }
        if TMDBGenreIDs.TVMovie == forID {
            return MovieGenres.TvMovie
        }
        if TMDBGenreIDs.Thriller == forID {
            return MovieGenres.Thriller
        }
        if TMDBGenreIDs.War == forID {
            return MovieGenres.War
        }
        if TMDBGenreIDs.Western == forID {
            return MovieGenres.Western
        }
        
        else {
        return nil
        }
    }
    
}
