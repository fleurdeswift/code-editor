//
//  PositionTests.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import XCTest
import CodeEditorCore;

class PositionTests: XCTestCase {
    func testUnion() {
        XCTAssertEqual(union(PositionRange(0, 0, 0, 2), PositionRange(0, 5, 0, 6)), PositionRange(0, 0, 0, 6));
        XCTAssertEqual(union(PositionRange(0, 0, 0, 2), PositionRange(0, 0, 0, 2)), PositionRange(0, 0, 0, 2));
        XCTAssertEqual(union(PositionRange(0, 0, 0, 2), PositionRange(0, 1, 0, 1)), PositionRange(0, 0, 0, 2));
        XCTAssertEqual(union(PositionRange(0, 0, 0, 2), PositionRange.Invalid),     PositionRange(0, 0, 0, 2));
        XCTAssertEqual(union(PositionRange.Invalid,     PositionRange(0, 0, 0, 2)), PositionRange(0, 0, 0, 2));
    }
    
    func testIntersection() {
        XCTAssertEqual(intersection(PositionRange(0, 0, 0, 2), PositionRange(0, 5, 0, 6)), PositionRange.Invalid);
        XCTAssertEqual(intersection(PositionRange(0, 0, 0, 2), PositionRange(0, 1, 0, 1)), PositionRange(0, 1, 0, 1));
        XCTAssertEqual(intersection(PositionRange(0, 0, 0, 2), PositionRange(0, 0, 0, 1)), PositionRange(0, 0, 0, 1));
        XCTAssertEqual(intersection(PositionRange(0, 0, 0, 2), PositionRange(0, 1, 0, 2)), PositionRange(0, 1, 0, 2));
    }
    
    func testIntersects() {
        XCTAssertFalse(intersects(PositionRange(0, 0, 0, 2), PositionRange(0, 5, 0, 6)));
        XCTAssertTrue (intersects(PositionRange(0, 0, 0, 2), PositionRange(0, 1, 0, 1)));
        XCTAssertTrue (intersects(PositionRange(0, 0, 0, 2), PositionRange(0, 0, 0, 1)));
        XCTAssertTrue (intersects(PositionRange(0, 0, 0, 2), PositionRange(0, 1, 0, 2)));
        XCTAssertFalse(intersects(PositionRange(0, 0, 0, 2), PositionRange(0, 2, 0, 3)));
    }
    
    func testIntersectsOrContiguous() {
        XCTAssertFalse(intersectsOrContiguous(PositionRange(0, 0, 0, 2), PositionRange(0, 5, 0, 6)));
        XCTAssertTrue (intersectsOrContiguous(PositionRange(0, 0, 0, 2), PositionRange(0, 1, 0, 1)));
        XCTAssertTrue (intersectsOrContiguous(PositionRange(0, 0, 0, 2), PositionRange(0, 0, 0, 1)));
        XCTAssertTrue (intersectsOrContiguous(PositionRange(0, 0, 0, 2), PositionRange(0, 1, 0, 2)));
        XCTAssertTrue (intersectsOrContiguous(PositionRange(0, 0, 0, 2), PositionRange(0, 2, 0, 3)));
    }
}
