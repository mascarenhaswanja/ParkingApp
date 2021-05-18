//
//  SignUpViewController.swift
//  ParkingApp
//
//  Created by Muzammil  on 2021-05-18.
//

import Foundation
import UIKit
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    // Varialbles
    let defaults = UserDefaults.standard
    
    // reference to the firestore database
    let db = Firestore.firestore()
    
    
    // MARK: OUTLETS
    @IBOutlet weak var signupLogo: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfCNumber: UITextField!
    @IBOutlet weak var tfplateNumber: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupLogo?.image = UIImage(named:"logo")
        
//        password?.isSecureTextEntry = true
    }
}
