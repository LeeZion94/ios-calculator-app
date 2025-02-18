//
//  CalculatorItemQueueTests.swift
//  CalculatorItemQueueTests
//
//  Created by Hyungmin Lee on 2023/05/30.
//

import XCTest
@testable import Calculator

final class CalculatorItemQueueTests: XCTestCase {
    var systemUnderTest: CalculatorItemQueue<Double>!
    
    override func setUpWithError() throws {
        systemUnderTest = CalculatorItemQueue<Double>()
    }

    override func tearDownWithError() throws {
        systemUnderTest = nil
    }
}

// MARK: - Enqueue Tests
extension CalculatorItemQueueTests {
    func test_3을_enqueue했을때_queue의Element를_확인한다() {
        //given
        let input = 3.0
        
        //when
        systemUnderTest.enqueue(element: input)
        let result = systemUnderTest.returnListValue()
        
        //then
        XCTAssertEqual(result, [3.0])
    }
    
    func test_3_4를_enqueue했을때_queue의Element를_확인한다() {
        //given
        let input1 = 3.0
        let input2 = 4.0
        
        //when
        systemUnderTest.enqueue(element: input1)
        systemUnderTest.enqueue(element: input2)
        let result = systemUnderTest.returnListValue()
        
        //then
        XCTAssertEqual(result, [3.0, 4.0])
    }
    
    func test_3_4_5_를_enqueue했을때_queue의Element를_확인한다() {
        //given
        let input1 = 3.0
        let input2 = 4.0
        let input3 = 5.0
        
        //when
        systemUnderTest.enqueue(element: input1)
        systemUnderTest.enqueue(element: input2)
        systemUnderTest.enqueue(element: input3)
        let result = systemUnderTest.returnListValue()
        
        //then
        XCTAssertEqual(result, [3.0, 4.0, 5.0])
    }
}

// MARK: - Dequeue Tests
extension CalculatorItemQueueTests {
    func test_3_4를_dequeue했을때_queue의Element를_확인한다() {
        //given
        let input1 = 3.0
        let input2 = 4.0
        
        //when
        systemUnderTest.enqueue(element: input1)
        systemUnderTest.enqueue(element: input2)
        let result = systemUnderTest.dequeue()
        let remainListArray = systemUnderTest.returnListValue()
        
        //then
        XCTAssertEqual(result, 3.0)
        XCTAssertEqual(remainListArray, [4.0])
    }
    
    func test_3를_dequeue했을때_queue의Element를_확인한다() {
        //given
        let input = 3.0
        
        //when
        systemUnderTest.enqueue(element: input)
        let result = systemUnderTest.dequeue()
        let remainListArray = systemUnderTest.returnListValue()
        
        //then
        XCTAssertEqual(result, input)
        XCTAssertEqual(remainListArray, nil)
    }
    
    func test_빈List를_dequeue했을때_queue의Element를_확인한다() {
        //given
        
        //when
        let result = systemUnderTest.dequeue()
        
        //then
        XCTAssertNil(result)
    }
}
