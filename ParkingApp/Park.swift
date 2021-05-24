//
//  Park.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-24.
//

import Foundation
import FirebaseFirestoreSwift

struct Park:Codable {
        @DocumentID var id:String?
        var user : String
        var carPlate : String
        var buildindCode : String
        var suitHost : String
        var parkingLocation : String  // street address, latitude and longitude
//        var latitude: Double
//        var longitude: Double
        var numberHours : Int
        var dateTime : Date
}
