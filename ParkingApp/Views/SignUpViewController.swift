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
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupLogo?.image = UIImage(named:"logo")
        
//        password?.isSecureTextEntry = true
    }
    
    
    @IBAction func signUp(_ sender: Any) {
                     let contactNumber = tfCNumber.text
        // 1. get the mandatoory inputs from the textbox
               guard let firstName = tfName.text,
                     let lastName = tfLName.text,
                     let email = tfEmail.text,
                     let password = tfPassword.text,
                     let confirmPassword = tfConfirmPassword.text,
                     //let contactNumber = tfCNumber.text,
                     let plateNumber = tfplateNumber.text
               else {
                     return
               }
        
               // optional, but helpful
               if ( firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || plateNumber.isEmpty ) {
                   print("You must enter the required fields")
                   self.showFailedAlert()
                   return
               }

               
               //confirm if passwords are matched
               if ( password != confirmPassword ) {
                   print("You must enter same password")
                   self.showPasswordAlert()
                   return
               }
               // 2. add it to firebase
               let user = [
                   "First Name":firstName,
                   "Last Name":lastName,
                   "email":email,
                   "password":password,
                   "Confirm Password":confirmPassword,
                   "Contact Number":contactNumber,
                   "Car Plate Number":plateNumber
                
               ]
               
        db.collection("users").addDocument(data: user) { (error) in
                   if let err = error {
                       print("Error when saving document")
                       print(err)
                       return
                   }
                   else {
                       print("document saved successfully")
                    
                       self.showSuccessAlert()
                    
                       self.tfName.text = ""
                       self.tfLName.text = ""
                       self.tfEmail.text = ""
                       self.tfPassword.text = ""
                       self.tfConfirmPassword.text = ""
                       self.tfCNumber.text = ""
                       self.tfplateNumber.text = ""
                    
                   }
               }

        }
   
    
    func showFailedAlert() {
        let alert = UIAlertController(title: "Alert", message: "Please enter the required fields", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Sign Up Successful", message: "Your account  has been created successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "Passwords did not match", message: "Please enter correctly", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    

}
