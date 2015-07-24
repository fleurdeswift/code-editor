//
//  ControllerTests.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import XCTest
import CodeEditorCore;

class ControllerTests : XCTestCase {
    func testMovePositionsForward(range: PositionRange, position: Position) -> Position {
        var p = position;
        
        XCTAssertFalse(Controller.movePositionsForward(range, position: &p));
        return p;
    }

    func testMovePositionsForward() {
        XCTAssertEqual(testMovePositionsForward(PositionRange(0, 0, 0, 1), position: Position(line: 0, column: 0)), Position(line: 0, column: 1));
        XCTAssertEqual(testMovePositionsForward(PositionRange(0, 0, 1, 0), position: Position(line: 0, column: 0)), Position(line: 1, column: 0));
        XCTAssertEqual(testMovePositionsForward(PositionRange(0, 0, 1, 0), position: Position(line: 2, column: 0)), Position(line: 3, column: 0));
        XCTAssertEqual(testMovePositionsForward(PositionRange(1, 0, 2, 0), position: Position(line: 0, column: 0)), Position(line: 0, column: 0));
        XCTAssertEqual(testMovePositionsForward(PositionRange(1, 1, 2, 0), position: Position(line: 1, column: 0)), Position(line: 1, column: 0));
        XCTAssertEqual(testMovePositionsForward(PositionRange(1, 1, 1, 2), position: Position(line: 1, column: 3)), Position(line: 1, column: 4));
        XCTAssertEqual(testMovePositionsForward(PositionRange(1, 1, 1, 2), position: Position(line: 1, column: 2)), Position(line: 1, column: 3));
    }

    func testMovePositionsBackward(range: PositionRange, position: Position) -> Position {
        var p          = position;
        let willDiffer = Controller.movePositionsBackward(range, position: &p);
        var np         = p;
        
        Controller.movePositionsForward(range, position: &np);
        
        if willDiffer {
            XCTAssertNotEqual(position, np);
        }
        else {
            XCTAssertEqual(position, np);
        }
        return p;
    }

    func testMovePositionsBackward() {
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 0, 0, 1), position: Position(line: 0, column: 0)), Position(line: 0, column: 0));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 1, 0, 2), position: Position(line: 0, column: 0)), Position(line: 0, column: 0));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 1, 0, 2), position: Position(line: 0, column: 2)), Position(line: 0, column: 1));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 1, 0, 8), position: Position(line: 0, column: 4)), Position(line: 0, column: 1));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 0, 1, 0), position: Position(line: 2, column: 0)), Position(line: 1, column: 0));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 0, 1, 8), position: Position(line: 1, column: 8)), Position(line: 0, column: 0));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 0, 1, 8), position: Position(line: 1, column: 9)), Position(line: 0, column: 1));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 1, 1, 8), position: Position(line: 1, column: 9)), Position(line: 0, column: 2));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 0, 2, 0), position: Position(line: 1, column: 0)), Position(line: 0, column: 0));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 1, 2, 1), position: Position(line: 1, column: 1)), Position(line: 0, column: 1));
        XCTAssertEqual(testMovePositionsBackward(PositionRange(0, 1, 2, 2), position: Position(line: 2, column: 1)), Position(line: 0, column: 1));
    }
    
    func testMoveBackward() {
        let doc = Document(defaultTextStyle: NSDictionary());
        let controller = Controller(document: doc);
        
        doc.addController(controller, strong: false);
        defer { doc.removeController(controller); }
        
        do {
            try doc.modify() { (context: ModificationContext) in
                try controller.type("a", context: context);
                try controller.type("b", context: context);
                try controller.type("c", context: context);
                try controller.type("d", context: context);
                
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 4));
                controller.moveCursorsBackward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 3));
                controller.moveCursorsBackward(false, context: context);
                controller.moveCursorsBackward(false, context: context);
                controller.moveCursorsBackward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 0));
                controller.moveCursorsBackward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 0));
                
                controller.createCursor(.Edit, position: Position(line: 0, column: 0), context: context);
                XCTAssertEqual(controller.cursors.count, 1);
                controller.createCursor(.Edit, position: Position(line: 0, column: 1), context: context);
                controller.createCursor(.Edit, position: Position(line: 0, column: 2), context: context);
                controller.createCursor(.Edit, position: Position(line: 0, column: 3), context: context);
                controller.createCursor(.Edit, position: Position(line: 0, column: 4), context: context);
                XCTAssertEqual(controller.cursors.count, 5);
                
                try controller.type("1", context: context);
                
                XCTAssertEqual(doc.description(context), "1a1b1c1d1");
            }
        }
        catch {
            XCTFail();
        }
    }

    func testMoveForward() {
        let doc = Document(defaultTextStyle: NSDictionary());
        let controller = Controller(document: doc);
        
        doc.addController(controller, strong: false);
        defer { doc.removeController(controller); }
        
        do {
            try doc.modify() { (context: ModificationContext) in
                try controller.type("a", context: context);
                try controller.type("b", context: context);
                try controller.type("c", context: context);
                try controller.type("d", context: context);
                
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 4));
                controller.moveCursorsBackward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 3));
                controller.moveCursorsForward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 4));
                controller.moveCursorsForward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 4));

                try controller.type("\n", context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 1, column: 0));
                controller.moveCursorsBackward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 0, column: 4));
                controller.moveCursorsForward(false, context: context);
                XCTAssertEqual(controller.cursors[0].range.end, Position(line: 1, column: 0));

                try controller.type("a", context: context);
                try controller.type("b", context: context);
                try controller.type("c", context: context);
                try controller.type("d", context: context);
                XCTAssertEqual(doc.description(context), "abcd\nabcd");
                
                controller.setCursorPosition(Position(line: 0, column: 0), context: context);
                controller.createCursor(.Edit, position: Position(line: 1, column: 0), context: context);
                try controller.type(">", context: context);

                XCTAssertEqual(doc.description(context), ">abcd\n>abcd");
                
                controller.moveCursorsBackward(true, context: context);
                try controller.type("@", context: context);
                XCTAssertEqual(doc.description(context), "@abcd\n@abcd");
            }
        }
        catch {
            XCTFail();
        }
    }

    func testDeleteDirectional() {
        let doc = Document(defaultTextStyle: NSDictionary());
        let controller = Controller(document: doc);
        
        doc.addController(controller, strong: false);
        defer { doc.removeController(controller); }
        
        do {
            try doc.modify() { (context: ModificationContext) in
                try controller.type("a", context: context);
                try controller.type("b", context: context);
                try controller.type("c", context: context);
                try controller.type("d", context: context);
                
                controller.moveCursorsBackward(false, context: context);
                controller.moveCursorsBackward(false, context: context);
                try controller.deleteBackward(context);
                try controller.deleteForward(context);
                XCTAssertEqual(doc.description(context), "ad");
            };
        }
        catch {
            XCTFail();
        }
    }
}
