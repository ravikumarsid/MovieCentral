//
//  ViewController.swift
//  MovieCentral
//
//  Created by Ravi Kumar Venuturupalli on 11/12/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure FirebaseUI
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let authUI = FUIAuth.defaultAuthUI()
        
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        authUI?.providers = providers
        
        let authViewController = authUI?.authViewController()
        
        self.present(authViewController!, animated: false, completion: nil)
       
        
        
    }
    
    
}

