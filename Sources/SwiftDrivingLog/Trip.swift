//
//  Trip.swift
//  TrackDriving
//
//  Created by Grace Tay on 4/22/18.
//

import Foundation

struct Trip {
    // MARK: - Properties
    let driver: Driver
    let miles: Double
    let startTime: Date
    let endTime: Date
    
    // MARK: - Computed Properties
    var duration: Double {
        return endTime.timeIntervalSince(startTime)/3600
    }
    var isValid: Bool {
        let speed = miles/duration
        return (speed >= 5 && speed <= 100)
    }
    
    // MARK: - Initializer
    init?(driver: Driver?, miles: Double?, startTime: Date?, endTime: Date?) {
        guard let driver = driver, let miles = miles, let startTime = startTime, let endTime = endTime else {
            return nil
        }
        self.driver = driver
        self.miles = miles
        self.startTime = startTime
        self.endTime = endTime
    }
}
