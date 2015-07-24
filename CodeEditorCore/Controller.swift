//
//  Controller.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public class Controller {
    internal(set) public var cursors = [Cursor]();
    
    public let document: Document;

    public init(document: Document) {
        self.document = document;
        cursors.append(Cursor(type: .Edit, position: Position(line: 0, column: 0)));
    }
    
    public func undo(controllerCommand: ControllerCommand, context: ModificationContext) throws -> Command? {
        assert(false);
        return nil;
    }
}
