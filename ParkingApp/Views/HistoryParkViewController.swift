//
//  HistoryParkViewController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-20.
//

import UIKit
import FirebaseFirestore

class HistoryParkViewController: UIViewController {
    // Outlets
    @IBOutlet weak var tableParkingView: UITableView!
    
    // Variables
    // WOM
    let db = Firestore.firestore()
    
    let parkingController = ParkingController()
    var row : Int = 0
    var listParking = [Park]()
    var selectedParking:Park?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableParkingView.delegate = self
        self.tableParkingView.dataSource = self
        self.tableParkingView.rowHeight = 150
        
        self.fetchParking()  // WOM Select .where(user)
        
//        if self.listParking.count <= 0 {
//            print(#function, "You don't have any booked Parking." )
//        }
        
//        let email = UserDefaults.standard.value(forKey: "email") as! String
    }
    
    
    //  WOM - Move to ParkingController
    func fetchParking() {
        db.collection("parking").order(by: "dateTime", descending: true).getDocuments {
            (queryResults, error) in
            if let err = error {
                print(#function,"Error occurred when fetching documents from Firestore \(err)")
                return
            }
            else {
                if (queryResults!.documents.count == 0) {
                    print(#function,"No Parking found")
                }
                else {
                    for result in queryResults!.documents {
                        do {
                            let parkingFirestore = try result.data(as: Park.self)
                            self.listParking.append(parkingFirestore!)
                        } catch {
                            print(error)
                        }
                    }
                    print(#function,"Number of tasks in array: \(self.listParking.count)")
                    self.tableParkingView.reloadData()
                }
            }
        }
    } //  end fetch

} // end class

extension HistoryParkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listParking.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableParkingView.dequeueReusableCell(withIdentifier: "parkCell") as? HistoryParkTableViewCell

        if cell != nil {
            cell?.lblCarPlate.text = "Car Plate Number : \(listParking[indexPath.row].carPlate)"
            cell?.lbladdress.text = "\(listParking[indexPath.row].parkingLocation)"
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d y, HH:mm E"
            cell?.lblDate.text = "\(formatter.string(from: listParking[indexPath.row].dateTime))"
            cell?.lblHours.text = "Parking for \(String(listParking[indexPath.row].numberHours)) hours"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedParking = listParking[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPark"{
              print(#function,"row \(self.row)")
            let vc = segue.destination as! DetailParkViewController
            let selectedParking = self.listParking[row]
                  vc.selectedParking = selectedParking
        }
    }
}
