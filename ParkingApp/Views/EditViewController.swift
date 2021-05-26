////
////  EditViewController.swift
////  ParkingApp
////
////  Created by Muzammil  on 2021-05-25.
////
//
import UIKit
import FirebaseFirestore

class EditViewController: UIViewController {
//
    let db=Firestore.firestore()
//
//
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmNewPassword: UITextField!
    @IBOutlet weak var tfContact: UITextField!
    @IBOutlet weak var tfCarPlateNumber: UITextField!
//
//
    @IBOutlet weak var errorText: UILabel!

    var password:String = ""
    var userId = ""

    func fetchUser(documentId: String){
      let docRef = db.collection("user").document(documentId)
      docRef.getDocument { document, error in
        if let error = error as NSError? {
            self.errorText.text = "Error getting document: \(error.localizedDescription)"
        }
        else {
          if let document = document {
            do {
                let row = document.data()
                self.tfName.text = row?["name"] as! String
                self.tfEmail.text = row?["email"] as! String
                self.tfContact.text = row?["contactNo"] as! String
                self.tfCarPlateNumber.text = row?["carplate"] as! String
                self.password = row?["password"] as! String

            }
            catch {
              print(error)
            }
          }
        }
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userId = UserDefaults.standard.string(forKey: "ID")!
        fetchUser(documentId: userId)

        // Do any additional setup after loading the view.
    }


    @IBAction func deleteAccountPressed(_ sender: Any) {

        db.collection("users").document(userId).delete() { (error) in
            if let err = error {
                self.errorText.text = "Error when updating document"
                print(err)
                return
            }
            else {
                self.errorText.text = "Details deleted successfully"
                guard let loginPage = self.storyboard?.instantiateViewController(identifier: "login_page") as? SignInViewController else {
                            print("Cannot find Login  Page!")
                            return
                        }
                        self.show(loginPage, sender: self)
            }
        }


    }


    @IBAction func updateAccountPressed(_ sender: Any) {

        let carPlateNo=tfCarPlateNumber.text!
        let email=tfEmail.text!
        let contactNo=tfContact.text!
        let name=tfName.text!
        let lastName=tfLName.text!
        let newPassword=tfNewPassword.text!
        let confirmNewPassword=tfConfirmNewPassword.text!

        //         optional, but helpful
        if (carPlateNo.isEmpty || email.isEmpty || contactNo.isEmpty || name.isEmpty || lastName.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
            showFailedAlert()
            return
        }
        //         2. add it to firebase
        let user = [
            "name":name,
            "email":email,
            "contactNo":contactNo,
            "password":password,
            "carplate":carPlateNo,

        ]

        db.collection("users").document(userId).updateData(user) { (error) in
            if let err = error {
                self.errorText.text = "Error when updating document"
                print(err)
                return
            }
            else {
                self.errorText.text = "Details updated successfully"

            }
        }

    }
    
    func showFailedAlert() {
        let alert = UIAlertController(title: "Alert", message: "Please enter required fields", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Update Successful", message: "You have updated in successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
