import XCTest
@testable import SwiftDrivingLog

class SwiftDrivingLogTests: XCTestCase {
    let dateFormatter = DateFormatter()
    
    func test_createDriver() {
        let parser = Parser(dateFormatter: dateFormatter)
        
        let c1 = parser.determineCommand(from: "Driver Dan")
        XCTAssertEqual(c1.type, .driver)
        let result = parser.createDriver(from: c1.components)
        XCTAssertEqual(Driver(name: "Dan").name, result.name)
        
        //Driver should not equal driver if more than two words
        let c2 = parser.determineCommand(from: "Driver Dan Stan")
        XCTAssertNotEqual(c2.type, .driver)
    }
    
    func test_driverDescription() {
        let driver = Driver(name: "Test")
        XCTAssertEqual("Test: 0 miles", driver.description)
        
        let trip = Trip(driver: driver, miles: 100.0, startTime: Date(timeIntervalSince1970: 18000), endTime: Date(timeIntervalSince1970: 21600))
        driver.trips.append(trip!)
        let result = trip?.duration
        
        XCTAssertEqual(1.0, result)
        XCTAssertEqual("Test: 100 miles @ 100 mph", driver.description)
    }
    
    func test_createDriverWithTrip() {
        let driverCommand = "Driver John"
        let tripCommand = "Trip John 06:12 06:32 21.8"
        let falseCommand = "Lorem"
        let testArray = "\(driverCommand)\n\(tripCommand)\n\(falseCommand)"
        
        let parser = Parser(dateFormatter: dateFormatter)
        
        let test = parser.createLog(from: testArray)
        //Test Driver name is successfully logged
        XCTAssertEqual(test[0].name, "John")
        
        //Test Trip is successfully logged
        XCTAssertEqual(test[0].totalMilesDriven, 21.8)
        
        //If Lorem is ignored, only John will appear
        XCTAssertEqual(test.count, 1)
    }
    
    func test_exampleData() {
        
        let testData = "Driver Dan\nDriver Alex\nDriver Bob\nTrip Dan 07:15 07:45 17.3\nTrip Dan 06:12 06:32 21.8\nTrip Alex 12:01 13:16 42.0"
        let parser = Parser(dateFormatter: dateFormatter)
        let testLog = parser.createLog(from: testData)
        let sortedLog = testLog.sorted(by: { $0.totalMilesDriven > $1.totalMilesDriven})
        var driverOutput = ""
        let expectedOutput = "Alex: 42 miles @ 34 mph Dan: 39 miles @ 47 mph Bob: 0 miles "
        
        sortedLog.forEach { driver in
            driverOutput.append(contentsOf: driver.description + " ")
        }
        
        XCTAssertEqual(driverOutput, expectedOutput)
    }
    
    static var allTests = [
        ("test_createDriver", test_createDriver), ("test_driverDescription", test_driverDescription), ("test_createDriverWithTrip", test_createDriverWithTrip), ("test_exampleData", test_exampleData)
    ]
}
