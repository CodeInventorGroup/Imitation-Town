//
//  ImitationTownUITests.swift
//  ImitationTownUITests
//
//  Created by jiachenmu on 2016/10/17.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import XCTest

class ImitationTownUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let feedButton = app.buttons["FEED"]
        feedButton.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        app.buttons["i navi explore"].tap()
        app.buttons["i navi message"].tap()
        app.buttons["i navi my"].tap()
        app.buttons["i navi add"].tap()
        feedButton.tap()
        
        let townButton = app.buttons["TOWN"]
        townButton.tap()
        feedButton.tap()
        townButton.tap()
        
        let table = element.children(matching: .table).element
        table.swipeLeft()
        table.swipeRight()
        table.tap()
        table.press(forDuration: 0.6);
        table.tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["地点集"].tap()
        tablesQuery.buttons["城市故事"].swipeDown()
        
    }
    
}
