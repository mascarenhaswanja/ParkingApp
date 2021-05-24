//
//  DetailParkViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-22.
//

import UIKit

class DetailParkViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var lblCarPlate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblBuildingCode: UILabel!
    @IBOutlet weak var lblSlot: UILabel!
    
    // Variables
    var selectedParking:Park?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentParking = selectedParking else {
            print(#function,"Parking is null")
            return
        }
        print("\(currentParking )")
        lblCarPlate.text = "Car Plate: \(String(currentParking.carPlate))"
        lblAddress.text = "Address: \n \(currentParking.parkingLocation)"
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y, HH:mm E"
        lblDate.text = "Date - Hour: \(formatter.string(from: currentParking.dateTime))"
        lblHours.text = "Hours \(String(currentParking.numberHours))"
        lblBuildingCode.text = "Building: \(currentParking.buildindCode)"
        lblSlot.text = "Slot: \(currentParking.suitHost)"
        
        // navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapPark"
        {
            print("Parking Data latitude \(selectedParking!.parkingLocation)")
            let vc = segue.destination as! MapParkViewController
            
            //  WOM, Save Latitude and Longitude in a Park Table?
//            vc.lat = selectedParking!.latitude
//            vc.lng = selectedParking!.longitude
            vc.address = selectedParking!.parkingLocation
        }
        
    }

}
