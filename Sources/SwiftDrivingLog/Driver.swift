//
//  Driver.swift
//  TrackDrivingPackageDescription
//
//  Created by Grace Tay on 4/22/18.
//

import Foundation

class Driver: CustomStringConvertible {
    // MARK: - Properties
    let name: String
    var trips: [Trip] = []
    
    // MARK: - Computed Properties
    var description: String {
        if totalMilesDriven > 0 {
            return "\(name): \(totalMilesDriven.roundedInt) miles @ \(averageSpeed.roundedInt) mph"
        }
        return "\(name): \(totalMilesDriven.roundedInt) miles"
    }

    var totalMilesDriven: Double {
        var miles = 0.0
        trips.forEach { trip in
            miles += trip.miles
        }
        return miles
    }
    
    var averageSpeed: Double {
        var timeLogged = 0.0
        trips.forEach { trip in
            timeLogged += trip.duration
        }
        return totalMilesDriven/timeLogged
    }
    
    // MARK: - Initializer
    init(name: String) {
        self.name = name
    }
}
