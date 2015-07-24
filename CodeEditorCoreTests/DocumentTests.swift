//
//  CodeEditorCoreTests.swift
//  CodeEditorCoreTests
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import XCTest
import CodeEditorCore;

class DocumentTests : XCTestCase {
    func testInsertText(text: String) {
        let doc = Document(defaultTextStyle: NSDictionary());
        let controller = Controller(document: doc);
        
        doc.addController(controller, strong: false);
        defer { doc.removeController(controller); }
        
        do {
            try doc.modify() { (context: ModificationContext) -> Void in
                try doc.insertText(text, position: Position(line: 0, column: 0), context: context);
            }
        }
        catch {
        }
        
        XCTAssertEqual(doc.description, text);
    }

    func testInsertText() {
        testInsertText("first\nsecond\nthird\nfourth\nfifth");
        testInsertText("\nfirst\nsecond\nthird\nfourth\nfifth\n\n\n");
        testInsertText("first");
        testInsertText("\n");
        testInsertText("\n\n\n");
        testInsertText("");
    }
    
    func testRemoveText(text: String, _ range: PositionRange, _ result: String, _ removedText: String) {
        let doc = Document(defaultTextStyle: NSDictionary());
        let controller = Controller(document: doc);
        
        doc.addController(controller, strong: false);
        defer { doc.removeController(controller); }

        do {
            try doc.modify() { (context: ModificationContext) -> Void in
                try doc.insertText(text, position: Position(line: 0, column: 0), context: context);
                
                let extractedText = try doc.extractText(range, context: context);
                XCTAssertEqual(extractedText, removedText);
            }
            
            let maybeUndoCommands = try doc.modify() { (context: ModificationContext) -> Void in
                let optCommand = try doc.removeText(range, context: context);
             
                XCTAssertNotNil(optCommand);
                
                if let command = optCommand {
                    XCTAssertEqual(command.text, removedText);
                }
            }
            
            XCTAssertEqual(doc.description, result);
            
            var maybeRedoCommands: Commands?;
            
            if let undoCommands = maybeUndoCommands {
                maybeRedoCommands = try doc.undo(undoCommands);
            }
            
            XCTAssertEqual(doc.description, text);
            
            if let redoCommands = maybeRedoCommands {
                try doc.undo(redoCommands);
            }

            XCTAssertEqual(doc.description, result);
        }
        catch {
            XCTFail();
        }
    }
    
    func testRemoveText() {
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 1, 0, 2), "frst\nsecond\nthird\nfourth\nfifth", "i");
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 0, 1, 0), "second\nthird\nfourth\nfifth",       "first\n");
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 0, 1, 1), "econd\nthird\nfourth\nfifth",        "first\ns");
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 1, 1, 0), "fsecond\nthird\nfourth\nfifth",      "irst\n");
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 1, 1, 1), "fecond\nthird\nfourth\nfifth",       "irst\ns");

        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 0, 2, 0), "third\nfourth\nfifth",       "first\nsecond\n");
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 0, 2, 1), "hird\nfourth\nfifth",        "first\nsecond\nt");
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 1, 2, 0), "fthird\nfourth\nfifth",      "irst\nsecond\n");
        testRemoveText("first\nsecond\nthird\nfourth\nfifth", PositionRange(0, 1, 2, 1), "fhird\nfourth\nfifth",       "irst\nsecond\nt");
    }
}
