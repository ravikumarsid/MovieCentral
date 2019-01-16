//
//  DiscoverViewController.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 12/18/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

protocol DismissManager {
    func changeValue(value: [DiscoverParam])
}

import UIKit
import TMDBSwift
import CoreData

class DiscoverViewController: UIViewController, DismissManager, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var nextPagebtn: UIButton!
    @IBOutlet weak var discoverCollectionview: UICollectionView!
    
    
    var moviesArray: [TMDBMovie]?
    var movieArr: [MovieMDB]?
    var sortParams: [DiscoverParam]?
    var dataController: DataController!
    
    var currentPageNumber: Int = 1
    var maxTotalPages: Int?
    
    var isActionSelected: Bool = false
    let reuseIdentifier = "discoverCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 10.0, right: 1.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        self.currentPageNumber = 1
        super.viewDidLoad()
        
        self.nextPagebtn.isHidden = true
        self.discoverCollectionview.dataSource = self
        self.discoverCollectionview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func changeValue(value: [DiscoverParam]) {
        self.sortParams = value
        print("CVparams is: \(String(describing: sortParams))")
    }
    
    @IBAction func addFilterTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func searchButton(_ sender: Any) {
        print("The value of page is: \(currentPageNumber)")
        
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlert(alertTitle: "Check Internet connection", alertMesssage: "The device is not connected to the internet.")
            return
        }
        
        TMDBClient.checkTMDBAPIResponseCheck { (isWorking, error) in
            if (isWorking == false) {
                self.displayAlert(alertTitle: "Something went wrong with TMDB", alertMesssage: "Check TMDB API settings.")
                return
            }
        }
        
        if self.movieArr != nil {
            self.movieArr?.removeAll()
            DispatchQueue.main.async {
                self.discoverCollectionview.reloadData()
            }
        }
        
        let spinner = UIViewController.displaySpinner(onView: discoverCollectionview)
        var discoverParams: [DiscoverParam]?
        print("the sort params are: \(String(describing: self.sortParams))")
        
        if self.sortParams != nil {
            discoverParams = self.sortParams
            print("Sort params were set")
        } else {
            discoverParams = [DiscoverParam.sort_by(DiscoverSortByMovie.popularity_desc.rawValue)]
            print("Sort params were not set")
        }
        
        var curPage: Int?

        TMDBConfig.apikey = TMDBParameterValues.APIKey
        DiscoverMovieMDB.discoverMovies(params: discoverParams!){ data, movieArr in
            
           
            
            
            self.maxTotalPages = data.pageResults?.total_pages
            
            curPage = data.pageResults?.page
            
            if let movieArr = movieArr{
                UIViewController.removeSpinner(spinner: spinner)
                self.movieArr = movieArr
            }
            DispatchQueue.main.async {
                self.discoverCollectionview.reloadData()
                self.discoverCollectionview.scrollsToTop = true
            }
            UIViewController.removeSpinner(spinner: spinner)
        }
            self.nextPagebtn.isHidden = false
    }
    
    
    @IBAction func getNextPage(_ sender: Any) {
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlert(alertTitle: "Check Internet connection", alertMesssage: "The device is not connected to the internet.")
            return
        }
        TMDBClient.checkTMDBAPIResponseCheck { (isWorking, error) in
            if (isWorking == false) {
                self.displayAlert(alertTitle: "Something went wrong with TMDB", alertMesssage: "Check TMDB API settings.")
                return
            }
        }
        
        if currentPageNumber <= self.maxTotalPages! {
            print("Current page is : \(currentPageNumber)")
            if currentPageNumber == self.maxTotalPages!{
                self.nextPagebtn.isHidden = true
            } else {
            self.movieArr = nil
            currentPageNumber += 1
                if currentPageNumber == self.maxTotalPages! - 1{
                    self.nextPagebtn.isHidden = true
                }
            fetchNextResultsPage(pageNumber: currentPageNumber)
            }
        }

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (movieArr != nil ) {
            return movieArr!.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let movArr = movieArr {
            if indexPath.row == movArr.count - 1 && movArr.count < 61 {
                //fetchMoreResults()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiscoverCell
        
        cell.backgroundColor = UIColor.darkGray
        if (movieArr != nil ) {
            
            cell.activityIndicator.startAnimating()
            let movie = movieArr![indexPath.row]
            
            let release_date = movie.release_date!
            let release_year = release_date.prefix(4)
            
            if let posterPath = movie.poster_path {
                let url: URL = TMDBClient.imageURL(imagePath: posterPath, imageSize: TMDBPosterImageSizes.w342)!
                let imageData = try! Data(contentsOf: url)
                
                let image = UIImage(data: imageData)
                cell.activityIndicator.stopAnimating()
                cell.backgroundColor = UIColor.clear
                cell.movieImage.image = image
                cell.movieTextField.text = movie.title! + " (" + "\(release_year)" + ")"
            } else {
                cell.activityIndicator.stopAnimating()
                cell.backgroundColor = UIColor.clear
                cell.movieImage.image = UIImage(named: "no-image-icon")
                cell.movieTextField.text = movie.title! + " (" + "\(release_year)" + ")"
                
            }
  
        }
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "filterSegue" {
        
        let nextVC = segue.destination as! FilterContainerViewController
        nextVC.delegate = self
        }
        
        
        if segue.identifier == "discoverSegue" {

            let indexPaths = self.discoverCollectionview.indexPathsForSelectedItems
            let indexPath = indexPaths?[0]
            let nextVC = segue.destination as! MovieViewController
            print("Index of selected cell is \(String(describing: indexPath))")
            nextVC.tmdbMovie = self.movieArr?[indexPath!.row]
            nextVC.dataController = dataController
        }
    }


    
    
    
    private func fetchDiscoverMovieResults(_ sortparams: [DiscoverParam]) {
        TMDBConfig.apikey = TMDBParameterValues.APIKey
        
        DiscoverMovieMDB.discoverMovies(params: sortparams){ data, movieArr in
            if let movieArr = movieArr{
                self.movieArr = movieArr
            }
        }
        DispatchQueue.main.async {
            self.discoverCollectionview.reloadData()
        }
    }
    
    private func fetchNextResultsPage(pageNumber: Int){
        TMDBConfig.apikey = TMDBParameterValues.APIKey
        var fetchMoreSortParams: [DiscoverParam] = []
        
        if let sortParameters = self.sortParams {
            print("sort params present")
           fetchMoreSortParams = sortParameters
        } else {
            print("sort params not present")
            fetchMoreSortParams = [DiscoverParam.sort_by(DiscoverSortByMovie.popularity_desc.rawValue)]
        }
        
        fetchMoreSortParams.append(DiscoverParam.page(pageNumber))
        let spinner = UIViewController.displaySpinner(onView: discoverCollectionview)
        
        DiscoverMovieMDB.discoverMovies(params: fetchMoreSortParams){ data, movieArr in
            if let movieArray = movieArr{
                print("Number of movies is next page is \(movieArray.count)")
                self.movieArr = movieArray
                UIViewController.removeSpinner(spinner: spinner)
                DispatchQueue.main.async {
                    self.discoverCollectionview.reloadData()
                    self.discoverCollectionview.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                      at: .top,
                                                      animated: true)
                }
            }
        }
    }
    
}
    
    
    extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
        }
}

