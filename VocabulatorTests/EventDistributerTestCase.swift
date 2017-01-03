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
class TestTarget {
    var handlerTwo: (BogusEvent) -> Void = { _ in }
    var handler: (MockEvent) -> Void = { _ in}
}

class EventDistributerTestCase: XCTestCase {
    let distributer = EventDistributer()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
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
    
    func testHandlersAreCleanedUpWhenTargetDisappears() {
        var testTarget: TestTarget? = TestTarget()
        self.distributer.register(target: testTarget!, handler: testTarget!.handler)
        XCTAssert(self.distributer.registryCount == 1)
        
        testTarget = nil
        
        self.distributer.distribute(event: MockEvent())
        XCTAssert(self.distributer.registryCount == 0)
    }
    
    func testAllHandlersForATargetAreRemovedWhenTheTargetIsRemoved() {
        var testTarget: TestTarget? = TestTarget()
        
        self.distributer.register(target: testTarget!, handler: testTarget!.handler)
        self.distributer.register(target: testTarget!, handler: testTarget!.handlerTwo)
        self.distributer.register(target: self) { (event: MockEvent) in }
        XCTAssert(self.distributer.registryCount == 3)
        
        testTarget = nil
        self.distributer.distribute(event: MockEvent())
        XCTAssert(self.distributer.registryCount == 1)
        
    }
}

extension EventDistributer {
    var registryCount: Int {
        return self.registry.count
    }
}
