//
//  ViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-12.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    // Varialbles
    let defaults = UserDefaults.standard
    
    // reference to the firestore database
    let db = Firestore.firestore()

    // MARK: OUTLETS
    @IBOutlet weak var imageLogo: UIImageView!
    
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var rememberMe: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageLogo?.image = UIImage(named:"logo")
        
//        password?.isSecureTextEntry = true
    }

    @IBOutlet weak var loginButton: UIButton!
    

}
