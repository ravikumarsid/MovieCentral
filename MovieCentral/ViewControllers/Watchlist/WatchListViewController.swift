//
//  WatchListViewController.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 1/13/19.
//  Copyright © 2019 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit
import CoreData

protocol DataControllerManager {
    func updateDataControlManager(value: DataController)
}

class WatchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataControllerManager {
    
    func updateDataControlManager(value: DataController) {
        self.dataController = value
        print("Updated data controller")
    }
    
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Movie>!
    var moviesWatchList: [Movie]?
    
    @IBOutlet weak var watchlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchlistTableView.dataSource = self
        watchlistTableView.delegate = self
        setupFetchedResultsController()

        // Do any additional setup after loading the view.
        print("fetched results are: \(String(describing: fetchedResultsController.fetchedObjects?.count))")
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFetchedResultsController()
        print("view will appear fetched results are: \(String(describing: fetchedResultsController.fetchedObjects?.count))")
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "movieName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try? fetchedResultsController.performFetch()
            self.moviesWatchList = fetchedResultsController.fetchedObjects
            
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController.fetchedObjects?.count == 0 {
            self.watchlistTableView.setEmptyMessage("You don't have any movies in your watchlist yet. All the movies in your watchlist will show up here.")
            return 0
        } else {
            self.watchlistTableView.restore()
            return (fetchedResultsController.fetchedObjects?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = watchlistTableView.dequeueReusableCell(withIdentifier: "watchlistCell") as! WatchListCell
        
        if ((fetchedResultsController.fetchedObjects?.count)!) > 0 {
            let coreDatamovie = fetchedResultsController.object(at: indexPath)
            let release_date = coreDatamovie.movieYear!
            let release_year = release_date.prefix(4)
            cell.movieName.text = coreDatamovie.movieName! + " (" + "\(release_year)" + ")"
            cell.movieImage.image = UIImage(data: coreDatamovie.posterImage!)
        } else {
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let movieToDelete = fetchedResultsController.object(at: indexPath)
            
            if fetchedResultsController.fetchedObjects?.count == 1 {
                self.moviesWatchList?.removeAll()
                dataController.viewContext.delete(movieToDelete)
                try? dataController.viewContext.save()
                self.watchlistTableView.reloadData()
                self.watchlistTableView.setContentOffset(.zero, animated: true)
                
            } else {
                self.moviesWatchList?.remove(at: indexPath.row)
                dataController.viewContext.delete(movieToDelete)
                try? dataController.viewContext.save()
                self.watchlistTableView.reloadData()
                self.watchlistTableView.setContentOffset(.zero, animated: true)
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension WatchListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                watchlistTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                if fetchedResultsController.fetchedObjects!.count == 1 {
                } else {
                    watchlistTableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            break;
        default:
            print("...")
        }
    }
}

//https://stackoverflow.com/questions/15746745/handling-an-empty-uitableview-print-a-friendly-message
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
