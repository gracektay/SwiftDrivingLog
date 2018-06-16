//
//  Parser.swift
//  TrackDrivingPackageDescription
//
//  Created by Grace Tay on 4/22/18.
//

import Foundation

struct Parser {
    private let dateFormatter: DateFormatter
    
    let count = 21
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    enum OptionType: String {
        case driver = "Driver"
        case trip = "Trip"
        case unknown
        
        init?(value: String) {
            switch value {
            case "Driver":
                self = .driver
            case "Trip":
                self = .trip
            default:
                self = .unknown
            }
        }
    }
    
    // MARK: - Functions
    func createLog(from file: String) -> [Driver] {
        let data = file.components(separatedBy: CharacterSet.newlines)
        var driverLog: [Driver] = []
        
        data.forEach { line in
            let command = determineCommand(from: line)
            
            switch command.type {
            case .driver:
                driverLog.append(createDriver(from: command.components))
            case .trip:
                driverLog.forEach { driver in
                    if let trip = createTrip(from: command.components, driver: driver) {
                        if trip.isValid { driver.trips.append(trip) }
                    }
                }
            default:
                break
            }
        }
        
        return driverLog
    }
    
    func determineCommand(from line: String) -> (type: OptionType, components: [String]) {
        let components = line.components(separatedBy: " ")
        if components.count == 2 || components.count == 5 {
            return (OptionType(value: components[0])!, components)
        }
        
        return (OptionType(value: "")!, components)
    }
    
    func createDriver(from line: [String]) -> Driver {
        return Driver(name: line[1])
    }
    
    func createTrip(from lines: [String], driver: Driver) -> Trip? {
        dateFormatter.dateFormat = "HH:mm"
        
        let miles = Double(lines[4])
        let startTime = dateFormatter.date(from: lines[2])
        let endTime = dateFormatter.date(from: lines[3])
        
        guard let trip = Trip(driver: driver, miles: miles, startTime: startTime, endTime: endTime) else {
            return nil
        }
        
        if lines[1] == driver.name {
            return trip
        }
        
        return nil
    }
}
