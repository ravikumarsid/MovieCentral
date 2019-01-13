//
//  SearchAPIFetcher.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 1/5/19.
//  Copyright © 2019 Ravi Kumar Venuturupalli. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import TMDBSwift

enum NetworkError: Error {
    case failure
    case success
}


class SearchAPIFetcher {
    
    var searchResults: [PersonResults]?
    
    func search(searchText: String, completionHandler: @escaping ([PersonResults]?, NetworkError) -> ()) {
        
        TMDBConfig.apikey = TMDBParameterValues.APIKey
        
        SearchMDB.person(query: searchText, page: 1, includeAdult: true) { (ClientReturn
            , personResults) in
            
            if let personResult = personResults {
                self.searchResults = personResult
                
                //for person in personResult {
                  
                    //print("per name is :\(String(describing: person.name))")
                    //print("per path is : \(person.profile_path!)")
                //}
                completionHandler(personResult, .success)
            }
            guard let empty = personResults?.isEmpty, !empty else {
                completionHandler(nil, .failure)
                return
            }
            
      
            
            
            
        }
    }
    
}
