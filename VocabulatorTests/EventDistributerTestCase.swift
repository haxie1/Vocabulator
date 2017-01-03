//
//  EventDistributerTestCase.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/3/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import XCTest
@testable import Vocabulator

struct MockEvent: Event {}
struct BogusEvent: Event {}

class EventDistributerTestCase: XCTestCase {
    let distributer = EventDistributer()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.distributer.unregisterAll()
        super.tearDown()
        
    }
    
    func testRegisteringAHandler() {
        XCTAssert(self.distributer.registryCount == 0)
       self.distributer.register(target: self) { (event: MockEvent) in }
        XCTAssert(self.distributer.registryCount == 1)
    }
    
    func testUnregistringAHandler() {
        let uuid = self.distributer.register(target: self) { (event: MockEvent) in }
        XCTAssert(self.distributer.registryCount == 1)
        self.distributer.unregister(uuid: uuid)
        XCTAssert(self.distributer.registryCount == 0)
    }
    
    func testUnregistringAllHandlers() {
        self.distributer.register(target: self) { (event: MockEvent) in }
        self.distributer.register(target: self) { (event: MockEvent) in }
        XCTAssert(self.distributer.registryCount == 2)
        self.distributer.unregisterAll()
        XCTAssert(self.distributer.registryCount == 0)
    }
    
    func testDistributingAEvent() {
        var called = false
        self.distributer.register(target: self) { (event: MockEvent) in
            called = true
        }
        
        self.distributer.distribute(event: MockEvent())
        XCTAssertTrue(called)
    }
    
    func testDistributedEventGoesToCorrectHandler() {
        self.distributer.register(target: self) { (bogus: BogusEvent) in
            XCTFail("This handler shouldn't have been called")
        }
        var called = false
        self.distributer.register(target: self) { (event: MockEvent) in
            called = true
        }
        
        self.distributer.distribute(event: MockEvent())
        XCTAssertTrue(called)
    }
}

extension EventDistributer {
    var registryCount: Int {
        return self.registry.count
    }
}
