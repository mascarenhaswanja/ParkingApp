//
//  ParkingController.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-23.
//

import Foundation
import UIKit
import FirebaseFirestore
import CoreLocation

class ParkingController{
    
//    init()
//
//    self.
//
    let db = Firestore.firestore()
    var listParking : [Park] = []
//
//
//    func addParking(parking : Park) -> Bool {
//        // save to firestore
//        do {
//            try db.collection("parking").addDocument(from: parking)
//            print(#function, "Parking added to Firestore")
//            return true
//        }catch {
//            print(error)
//            return false
//        }
//    }
    
    func fetchParking() {
        db.collection("parking").order(by: "date", descending: true).getDocuments {
            (queryResults, error) in
            if let err = error {
                print(#function,"Error occurred when fetching documents from Firestore \(err)")
                return
            }
            else {
                if (queryResults!.documents.count == 0) {
                    print(#function,"No Orders found")
                }
                else {
                    for result in queryResults!.documents {
                        do {
                            let parkingFirestore = try result.data(as: Park.self)

                            // add order to List Orders
                            self.listParking.append(parkingFirestore!)
                        } catch {
                            print(error)
                        }
                    }

                    // 4. orderlist now contains object
                    print(#function,"Number of tasks in array: \(self.listParking.count)")
                    //self.listParkingTable.reloadData()
                }
            }
        }
    } //  end fetch
   
    
} // end class
