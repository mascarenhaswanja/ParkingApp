//
//  AddParkingViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-22.
//

import UIKit
import CoreLocation
import FirebaseFirestore

class AddParkingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    // WOM
    let db = Firestore.firestore()
    
    // Variables
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    var selHours :  Int = 0
    let hours = ["1-hour or less", "4-hours", "12-hours", " 24-hours"]
    var isCurrentLocation = false
    let parkingController = ParkingController()
    var lat : Double = 0.0
    var lng : Double = 0.0
    
    // Outlets
    @IBOutlet weak var txCarPlate: UITextField!
    @IBOutlet weak var txAddress: UITextView!
    @IBOutlet weak var txBuildingCode: UITextField!
    @IBOutlet weak var txSlot: UITextField!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var hoursPicker: UIPickerView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hoursPicker.dataSource = self
        self.hoursPicker.delegate = self
        self.txAddress.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow item: Int, forComponent component: Int) -> String? {
        switch item {
        case 0:
            selHours = 1
        case 1:
            selHours = 4
        case 2:
            selHours = 12
        case 3:
            selHours = 24
        default:
            selHours = 1
        }
        print(#function,"Hours \(selHours) row: \(hours[item])")
        return hours[item]
    }

    @IBAction func btnAddParking(_ sender: UIButton) {
        if checkValidation() {
            print(#function,"Validate Okay")
            if isCurrentLocation {
                self.insertParking(lat: self.lat, lng: self.lng)
            }else{
                self.getLocation(address: "\(txAddress.text ?? "Toronto")")
            }
        }
    }
    func checkValidation() -> Bool{
        var isValid = false
     
        if (txCarPlate.text!.count < 2 || txCarPlate.text!.count > 8 || txCarPlate.text!.isEmpty) {
            isValid = false
            showAlert(title: "Error - Validate", message: "Car Plate: mininum 2 and maximum 8 character .")
        } else  if txBuildingCode.text?.count != 5 {
            isValid = false
            showAlert(title: "Error - Validate", message: "Building Code: exactly 5 character.")
        }
        else if (txSlot.text!.count < 2 || txSlot.text!.count > 5 || txSlot.text!.isEmpty){
            isValid = false
            showAlert(title: "Error - Validate", message: "Slot: mininum 2 and maximum 5 character.")
        }
        else if (txAddress.text == nil && txAddress.text!.isEmpty){
            isValid = false
            showAlert(title: "Error - Validate", message: "Address: Enter Street Address.")
        } else {
          isValid = true
        }
        return isValid
    }
    
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Validation", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func insertParking(lat:Double, lng:Double){
      isCurrentLocation = false

//        let email = UserDefaults.standard.value(forKey: "email") as! String
//        let currentUser = self.userController.searchProfile(email: email)
        
        let currentUser = "jack@gmail.com"

        let parkingToAdd = Park(id: nil, user: currentUser, carPlate: txCarPlate.text!, buildindCode: txBuildingCode.text!, suitHost: txSlot.text!, parkingLocation: txAddress.text!, numberHours: selHours, dateTime: Date())
 
        addParking(parking: parkingToAdd)
            print(#function,"Parking Added successfully")

            txCarPlate.text = ""
            txAddress.text = ""
            txBuildingCode.text = ""
            txSlot.text = ""
    }
    
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        isCurrentLocation = true
        print(#function,"current location click")
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    

// **** WOM Move to ParkingController
    func addParking(parking : Park)  {
            // save to firestore
            do {
                try db.collection("parking").addDocument(from: parking)
                print(#function, "Parking added to Firestore")
                showParkingAdd(title: "Parking Add", message: "Your parking successfully booked")
            }catch {
                print(error)
            }
        
//        if parkinkAdd {
//            parkingAddDialog(title: "\(currentUser?.first_name! ?? "")", message: "Parking successfully completed.")
//        self.navigationController?.popViewController(animated: true)
//        }
        
        
    }
    
    func showParkingAdd(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let successAction = UIAlertAction(title: "Success", style: .default) { (action:UIAlertAction!) in
            self.tabBarController!.selectedIndex = 0;
        }
        alert.addAction(successAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
} // end class

extension AddParkingViewController : CLLocationManagerDelegate{
    
    func getLocation(address: String)
     {
       self.geocoder.geocodeAddressString(address) { (placemark, error) in
         self.processGeoResponse(withPlacemarks: placemark, error: error)
       }
     }
    
     func processGeoResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?)
     {
       if (error != nil)
       {
         print(#function, error?.localizedDescription)
       }
       else
       {
         var currentLocation: CLLocation?
         if let placemark = placemarks, placemarks!.count > 0
         {
            currentLocation = placemark.first?.location
         }
         if let currentLocation = currentLocation
         {
            print("latitude : \(currentLocation.coordinate.latitude)")
            print("longitude : \(currentLocation.coordinate.longitude)")
            
            self.lat = currentLocation.coordinate.latitude
            self.lng = currentLocation.coordinate.longitude
            
            if isCurrentLocation {
                if error != nil{
                    self.txAddress.text = "Unable to recovery address."
                }else{
                    if let placemarks = placemarks, let placemark = placemarks.first{
                        let address = (placemark.locality! + ", " + placemark.administrativeArea! + ", " + placemark.country!)
                        self.txAddress.text = address
                        self.lat = currentLocation.coordinate.latitude
                        self.lng = currentLocation.coordinate.longitude
                    }else{
                        showAlert(title: "Error", message: "Address is not found. Please enter valid address")
                    }
                }
            }
            else{
                //  WOM  insert Latitude and Longitude
                print(#function,"Insert lat lon")
               // insertParking(lat: self.lat, lng: self.lng)//  If insert latitude and longitude
            }
            }
         else
         {
            print("Error - \(error)")
         }
       }
     }
    //methods for to get current location geoCoding
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myLocation : CLLocationCoordinate2D = manager.location?.coordinate
        else{ return }
        
//        print("\(myLocation.latitude)")
//        print("\(myLocation.longitude)")
        
        self.getAddress(location: CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude))
}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //to find address from geocoding(lat n long)
    
    func getAddress(location : CLLocation){
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
            self.processGeoResponse(withPlacemarks: placemark, error: error)
        })
    }
}


