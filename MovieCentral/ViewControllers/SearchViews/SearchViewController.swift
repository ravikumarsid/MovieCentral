//
//  SearchViewController.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 1/5/19.
//  Copyright © 2019 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit
import TMDBSwift

class SearchViewController: UITableViewController {
    
    private var searchResults = [PersonResults]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let apiFetcher = SearchAPIFetcher()
    private var previousRun = Date()
    private let minInterval = 0.05
    var delegate: SearchDismissManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupTableViewBackgroundView()
        setupSearchBar()
        tableView.isMultipleTouchEnabled = false;

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.peopleNameTextView.text = searchResults[indexPath.row].name
        
        if let profilePath = searchResults[indexPath.row].profile_path {
            let url: URL = TMDBClient.imageURL(imagePath: profilePath, imageSize: TMDBPosterImageSizes.w342)!
            let imageData = try! Data(contentsOf: url)
            let image = UIImage(data: imageData)
       
            cell.backgroundColor = UIColor.clear
            cell.searchImage.image = image
   
        } else {
            cell.backgroundColor = UIColor.clear
            cell.searchImage.image = UIImage(named: "no-image-icon")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let personId = String(self.searchResults[indexPath.row].id)
            let personName = String(self.searchResults[indexPath.row].name)
            self.delegate?.addPeople(id: personId, name: personName)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func setupSearchBar() {
        searchController.searchBar.delegate = self as? UISearchBarDelegate
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search any actor/crew"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = cancelBtn
        
    }
    
    private func setupTableViewBackgroundView() {
        let backgroundViewLabel = UILabel(frame: .zero)
        backgroundViewLabel.textColor = .darkGray
        backgroundViewLabel.numberOfLines = 0
        //backgroundViewLabel.text = "Oops, /n No results to show! ..."
        tableView.backgroundView = backgroundViewLabel
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func fetchResults(for text: String) {
        print("text serached was: \(text)")
        apiFetcher.search(searchText: text) { (results
            , error) in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
}
