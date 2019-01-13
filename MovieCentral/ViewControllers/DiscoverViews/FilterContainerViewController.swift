//
//  FilterContainerViewController.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 12/22/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit
import TMDBSwift

protocol SearchDismissManager {
    func addPeople(id: String, name: String)
}

class FilterContainerViewController: UIViewController,SearchDismissManager, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func addPeople(id: String, name: String){
        print("Added person with id: \(id) and name: \(name)")
        
        if personIDs != nil {
           self.personIDs!.append(id)
            let uniqueOrdered = Array(NSOrderedSet(array: personIDs!))
            self.personIDs = uniqueOrdered as? [String]
        } else {
             self.personIDs = [id]
        }
        
        
        if personNames != nil {
            self.personNames!.append(name)
            let uniqueOrdered = Array(NSOrderedSet(array: personNames!))
            self.personNames = uniqueOrdered as? [String]
    
        } else {
            self.personNames = [name]
        }
        
        DispatchQueue.main.async {
            self.actorNames.text = self.personNames!.joined(separator: ", ")
        }
        
        
        

        print("Added count: \(String(describing: personIDs?.count)) and name is \(String(describing: personNames?.count)) ")
    }
    
    
    @IBOutlet weak var sortByPicker: UIPickerView!
    @IBOutlet weak var doneFilterButton: UIButton!
    
    @IBOutlet weak var actorNames: UITextView!
    
    var delegate: DismissManager?

    var filterSortParams: [DiscoverParam]?
    var persons: PersonResults?
    
    var personIDs: [String]?
    var personNames: [String]?
    var pickerDataSelectedIndex: Int?
    

    let pickerData: [String] = ["Popularity - Descending", "Popularity - Ascending", "Release Date - Descending", "Release Date - Ascending", "Revenue - Descending", "Revenue - Ascending", "Primary Release Date - Descending", "Primary Release Date - Ascending", "Original Title - Descending", "Original Title - Ascending", "Vote Average - Descending", "Vote Average - Ascending", "Vote Count - Descending", "Vote Count - Ascending"]
    
    @IBOutlet weak var actionMov: UISwitch!
    @IBOutlet weak var adventureMov: UISwitch!
    @IBOutlet weak var animationMov: UISwitch!
    @IBOutlet weak var comedyMov: UISwitch!
    @IBOutlet weak var documentaryMov: UISwitch!
    @IBOutlet weak var dramaMov: UISwitch!
    @IBOutlet weak var familyMov: UISwitch!
    @IBOutlet weak var fantasyMov: UISwitch!
    @IBOutlet weak var historyMov: UISwitch!
    @IBOutlet weak var horrorMov: UISwitch!
    @IBOutlet weak var musicMov: UISwitch!
    @IBOutlet weak var mysteryMov: UISwitch!
    @IBOutlet weak var romanceMov: UISwitch!
    @IBOutlet weak var scifiMov: UISwitch!
    @IBOutlet weak var tvMov: UISwitch!
    @IBOutlet weak var thrillerMov: UISwitch!
    @IBOutlet weak var warMov: UISwitch!
    
    @IBOutlet weak var westernMov: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        sortByPicker.selectRow(0, inComponent: 0, animated: true)

        self.sortByPicker.dataSource = self
        self.sortByPicker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("View will appear")
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        _ = pickerData[pickerView.selectedRow(inComponent: 0)]
        pickerDataSelectedIndex = pickerView.selectedRow(inComponent: 0)
        print("Selected value is : \(String(describing: pickerDataSelectedIndex))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
//        delegate?.changeValue(value: addParamsforMovie())
//        print("csort params is: \(String(describing: addParamsforMovie()))")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue" {
            
            let nextVC = segue.destination as! SearchViewController
            nextVC.delegate = self
        }
        
    }
    
    
    @IBAction func doneFilter(_ sender: Any) {
        
        var sortParams: [DiscoverParam] =  addParamsforMovie()

        if let perIDS = personIDs {
            var personsStr = perIDS.joined(separator: ",")
            
            print("Added the following persons: \(String(describing: personsStr))")
            sortParams.append(DiscoverParam.with_people(personsStr))
        }
        
       
        
        delegate?.changeValue(value: sortParams)
       
        print("Presenting view controller: \(String(describing: FilterContainerViewController.topViewController(rootViewController: self)))")
    
        print("Current picker index is: \(String(describing: pickerDataSelectedIndex))")
        print("Current sort params is: \(String(describing: sortParams))")
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension FilterContainerViewController {
    class func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }
        
        switch presented {
        case let navigationController as UINavigationController:
            return topViewController(rootViewController: navigationController.viewControllers.last)
            
        case let tabBarController as UITabBarController:
            return topViewController(rootViewController: tabBarController.selectedViewController)
            
        default:
            return topViewController(rootViewController: presented)
        }
    }
    
    var previousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers{
            let n = controllersOnNavStack.count
            //if self is still on Navigation stack
            if controllersOnNavStack.last === self, n > 1{
                return controllersOnNavStack[n - 2]
            }else if n > 0{
                return controllersOnNavStack[n - 1]
            }
        }
        return nil
    }
}

extension FilterContainerViewController {
    
    private func addParamsforMovie() -> [DiscoverParam]{
        var discoverParams: [DiscoverParam] = []
        //let apikey = TMDBParameterValues.APIKey
        
        if actionMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Action.rawValue))
            
        }
        if adventureMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Adventure.rawValue))
        }
        if animationMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Animation.rawValue))
        }
        if comedyMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Comedy.rawValue))
        }
        if documentaryMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Documentary.rawValue))
        }
        if dramaMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Drama.rawValue))
        }
        if familyMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Family.rawValue))
        }
        if fantasyMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Fantasy.rawValue))
        }
        if historyMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.History.rawValue))
        }
        if horrorMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Horror.rawValue))
        }
        if musicMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Music.rawValue))
        }
        if mysteryMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Mystery.rawValue))
        }
        if romanceMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Romance.rawValue))
        }
        if scifiMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.ScienceFiction.rawValue))
        }
        if tvMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.TvMovie.rawValue))
        }
        if thrillerMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.Thriller.rawValue))
        }
        if warMov.isOn {
            discoverParams.append(DiscoverParam.with_genres(MovieGenres.War.rawValue))
        }
        
        var sortByParam: DiscoverParam?
        
        switch pickerDataSelectedIndex {
        case 0:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.popularity_desc.rawValue)
        case 1:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.popularity_asc.rawValue)
        case 2:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.release_date_desc.rawValue)
        case 3:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.release_date_asc.rawValue)
        case 4:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.revenue_desc.rawValue)
        case 5:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.revenue_asc.rawValue)
        case 6:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.primary_release_date_desc.rawValue)
        case 7:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.primary_release_date_asc.rawValue)
        case 8:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.original_title_desc.rawValue)
        case 9:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.original_title_asc.rawValue)
        case 10:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.vote_average_desc.rawValue)
        case 11:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.vote_average_asc.rawValue)
        case 12:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.vote_count_desc.rawValue)
        case 13:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.vote_count_asc.rawValue)
        default:
            sortByParam = DiscoverParam.sort_by(DiscoverSortByMovie.popularity_desc.rawValue)
        }
        
        discoverParams.append(sortByParam!)
        
        return discoverParams
    }
}
