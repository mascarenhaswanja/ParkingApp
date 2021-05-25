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
        lblCarPlate.text = "Car Plate: \(String(currentParking.carPlate))"
        lblAddress.text = "Address: \n\(currentParking.parkingLocation)"
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y, HH:mm E"
        lblDate.text = "Date: \(formatter.string(from: currentParking.dateTime))"
        lblHours.text = "Parking \(String(currentParking.numberHours)) hours"
        lblBuildingCode.text = "Building: \(currentParking.buildindCode)"
        lblSlot.text = "Slot: \(currentParking.suitHost)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapPark"{
            print("Parking Data latitude \(selectedParking!.parkingLocation)")
            let vc = segue.destination as! MapParkViewController
            vc.address = selectedParking!.parkingLocation
        }
        
    }

}
