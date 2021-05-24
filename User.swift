//
//  User.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-24.
//

import Foundation
import FirebaseFirestoreSwift

struct User:Codable {
        @DocumentID var id:String?
        var firstName : String
        var lastName : String
        var email : String

}
