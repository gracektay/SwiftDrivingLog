//
//  TrackDriving.swift
//  TrackDriving
//
//  Created by Grace Tay on 4/22/18.
//

import Foundation

let dateFormatter = DateFormatter()

public struct TrackDriving {
    public static func run(fileName: String) {
        do {
            let parser: Parser = Parser(dateFormatter: dateFormatter)
            let file = try String(contentsOfFile: fileName)
            let driverLog = parser.createLog(from: file)
            let sortedLog = driverLog.sorted(by: { $0.totalMilesDriven > $1.totalMilesDriven})
            
            sortedLog.forEach { driver in
                print(driver)
            }
        } catch {
            print("Error reading driver log")
        }
    }
}
