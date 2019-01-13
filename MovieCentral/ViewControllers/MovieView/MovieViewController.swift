//
//  MovieViewController.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 12/8/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit
import TMDBSwift
import CoreData

class MovieViewController: UIViewController {
    
    @IBOutlet weak var backgroundPoster: UIImageView!
    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var movieTitle: UITextView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var videoLinkLabel: UITextView!
    @IBOutlet weak var addWatchlistBtn: UIButton!
    
    var tmdbMovie: MovieMDB?
    var dataController: DataController!
    var movie_genres_string: String?
    var movie_video_url: String?
    var fetchedResultsController: NSFetchedResultsController<Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResults()
        
        if let movie = self.tmdbMovie {
            
            let release_date = movie.release_date!
            let release_year = release_date.prefix(4)
            var movie_genres_array = [String]()
            

            for mov_id in movie.genreIds! {
                let genre_name = String("\(TMDBClient.getGenres(forID: mov_id)!)")
                movie_genres_array.append(genre_name)
            }
            
            movie_genres_string = movie_genres_array.joined(separator: ", ")
            
            
            DispatchQueue.main.async {
                self.genreLabel.text = self.movie_genres_string
            }
      
                TMDBClient.getMovieVideoURLsForMovie(withID: movie.id) { (videourl, error) in
                    
                    if case .failure = error {
                        return
                    }
                    
                    guard let videourl = videourl, !videourl.isEmpty else {
                        self.videoLabel.isHidden = true
                        self.videoLinkLabel.isHidden = true
                        return
                    }
                    self.movie_video_url = videourl
                     print("video present are: \(videourl)")
                    let attributedString = NSMutableAttributedString(string:"Trailer")
                    _ = attributedString.setAsLink(textToFind: "Trailer", linkURL: videourl)
                    DispatchQueue.main.async {
                        //self.videoLinkLabel.text = videourl
                    self.videoLinkLabel.attributedText =
                        attributedString
                    }
                }
 
            if let posterPath = tmdbMovie?.backdrop_path {
                let url: URL = TMDBClient.imageURL(imagePath: posterPath, imageSize: TMDBPosterImageSizes.w500)!
                let imageData = try! Data(contentsOf: url)
                
                let image = UIImage(data: imageData)
                backgroundPoster.image = image
                overviewText.text = movie.overview
                movieTitle.text = movie.title! + " (" + "\(release_year)" + ")"
    
            } else {
                backgroundPoster.image = UIImage(named: "no-image-icon")
                overviewText.text = movie.overview
                movieTitle.text = movie.title! + " (" + "\(release_year)" + ")"
            }
        }
        
        
        
        
    }
    
    func setupFetchedResults() {
        //Check if movie already exists
        let fetchRequest:NSFetchRequest<Movie> = Movie.fetchRequest()
        let tmdbMovID: String = String(self.tmdbMovie!.id)
        let predicate = NSPredicate(format: "tmdbMovieID = '\(tmdbMovID)'")
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "movieName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try? fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
     
        
        if (fetchedResultsController.fetchedObjects?.count)! > 0 {
            print("Object already exists")
            addWatchlistBtn.isEnabled = false
        } else {
            print("Object does not exist")
        }
        
    }
    

    
    @IBAction func addToWatchlistTapped(_ sender: Any) {
  
        let movie = Movie(context: dataController.viewContext)
        movie.tmdbMovieID = String(self.tmdbMovie!.id)
        movie.movieName = self.tmdbMovie?.original_title
        movie.overviewText = self.tmdbMovie?.overview
        movie.movieYear = self.tmdbMovie?.release_date
        movie.genres = self.movie_genres_string
        movie.posterImage = self.backgroundPoster.image!.pngData()
        movie.trailerURL = self.movie_video_url
        
         try? self.dataController.viewContext.save()
        print("Added to database")
        addWatchlistBtn.isEnabled = false
    }
    
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
