//
//  ViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-12.
//

import UIKit
import FirebaseFirestore

class SignInViewController: UIViewController {
    
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
    
    func showFailedAlert() {
        let alert = UIAlertController(title: "Alert", message: "Invalid Email and/or Password", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Login Successful", message: "You have logged in successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let unwrappedEmail = email.text, let unwrappedPassword = password.text else {
                return
        }
        db.collection("users").getDocuments {
            (queryResults, error) in
            if let err = error {
                print("Error getting documents from Users collection")
                print(err)
                return
            }
            else {
                // we were successful in getting the documents
                if (queryResults!.count == 0) {
                    print("No users found")
                }
                else {
                    // we found some results, so let's output it to the screen
                    for result in queryResults!.documents {
                        print(result.documentID)
                        // output the contents of that documents
                        let row = result.data()
                        if (row["email"] as? String) == unwrappedEmail && (row["password"] as? String) == unwrappedPassword{
                            print("User Found")
                            
                            //self.goToAddParking()
                            self.showSuccessAlert()
                            break
                        }
                        else {
                            print("Incorrect Email/Password")
                            self.showFailedAlert()
                        }
                        break
                    }
                }
                
            }
        }
    }
    
//    func goToAddParking() {
//        guard let listParking = storyboard?.instantiateViewController(identifier: "addParking") as? AddParkingViewController else {
//                print("Cannot find Parking List!")
//                return
//        }
//        //listAtt.user = userAtu
//        show(listParking, sender: self)
//    }
    
}
    
    


