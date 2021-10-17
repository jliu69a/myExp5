//
//  MyExp5Tests.swift
//  MyExp5Tests
//
//  Created by Johnson Liu on 10/17/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import XCTest
@testable import MyExp_5_1

class MyExp5Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPreLoadingData() {
        let urlString = "http://www.mysohoplace.com/php_hdb/php_GL/prods/preload_data.php?date=2021-10-01"
        getDataFromLink(urlString: urlString)
    }
    
    func testExpenseData() {
        let urlString = "http://www.mysohoplace.com/php_hdb/php_GL/prods/expense_by_date.php?date=2021-10-01"
        getDataFromLink(urlString: urlString)
    }
    
    func getDataFromLink(urlString: String) {
        let manager = DatasManager()
        manager.testingForData(urlString: urlString)
        
        let expectation = XCTestExpectation(description: "Your expectation")
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(manager.testDataString.hasPrefix("[{\""))
        }
        else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
