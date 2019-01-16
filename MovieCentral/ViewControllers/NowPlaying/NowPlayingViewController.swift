//
//  NowPlayingViewController.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 11/18/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TMDBSwift
import CoreData

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    var movieResults: TMDBMovieResults?
    var movieRes: [MovieMDB]?
    
    var delegate: DataControllerManager?
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
    
        fetchNowPlaying()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((movieRes) != nil){
            print("Number of items in result: \((movieRes!.count))")
            return (movieRes!.count)
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nowPlayingTableView.dequeueReusableCell(withIdentifier: "nowPlayingCell") as! NowPlayingTableViewCell
        //cell.activityIndicator.startAnimating()
        if ((movieRes) != nil){
            
            let movie = movieRes![indexPath.row]
   
            if let posterPath = movie.poster_path {
                let url: URL = TMDBClient.imageURL(imagePath: posterPath, imageSize: TMDBPosterImageSizes.w342)!
                let imageData = try! Data(contentsOf: url)
                
                let image = UIImage(data: imageData)
                cell.activityIndicator.stopAnimating()
                cell.backgroundColor = UIColor.clear
                cell.imageView?.center = cell.center
                cell.imageView?.image = image
            } else {
                cell.activityIndicator.stopAnimating()
                cell.backgroundColor = UIColor.clear
                cell.imageView?.center = cell.center
                cell.imageView?.image = UIImage(named: "no-image-icon")  
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       

        self.performSegue(withIdentifier: "showMovie", sender: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if Reachability.isConnectedToNetwork() != true {
            return false
        }
        if let movieres = movieRes {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlert(alertTitle: "Check Internet connection", alertMesssage: "The device is not connected to the internet.")
            return
        }
        
        let destinationVC = segue.destination as! MovieViewController
        let movieIndex = nowPlayingTableView.indexPathForSelectedRow?.row
        destinationVC.tmdbMovie = movieRes![movieIndex!]
        destinationVC.dataController = dataController
    }

    @IBAction func refreshTapped(_ sender: Any) {
        fetchNowPlaying()
    }
    
        
}



extension NowPlayingViewController {
    
    func fetchNowPlaying(){
        
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlert(alertTitle: "Check Internet connection", alertMesssage: "The device is not connected to the internet.")
            return
        }
        let spinnerView = UIViewController.displaySpinner(onView: self.view)
        TMDBClient.getNowPlayingMovies(pageNumber: 1) { (movieArr, error) in
            print("The errorntable view: \(String(describing: error))")
            UIViewController.removeSpinner(spinner: spinnerView)
            if let error = error {
                print("The error intable view: \(error)")
                if error.localizedDescription == "The device is not connected to the internet." {
                    self.displayAlert(alertTitle: "Check Internet connection", alertMesssage: "The device is not connected to the internet.")
                }
                if error.localizedDescription == "Incorrect API key." {
                     self.displayAlert(alertTitle: "Something went wrong with TMDB", alertMesssage: "Check TMDB API settings.")
                }
            } else {
                self.movieRes = movieArr
                DispatchQueue.main.async {
                    self.nowPlayingTableView.reloadData()
                }
                
                
            }
        }
    
    }
    
 
}


