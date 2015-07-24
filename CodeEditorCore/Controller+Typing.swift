//
//  Controller+Typing.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Controller {
    public func type(char: Character) throws -> Commands? {
        return try document.modify(NSLocalizedString("Typing", comment: "")) { (context: ModificationContext) in
            try self.type(String(char), context: context);
        }
    }

    public func type(string: String) throws -> Commands? {
        return try document.modify(NSLocalizedString("Typing", comment: "")) { (context: ModificationContext) in
            try self.type(string, context: context);
        }
    }
    
    public func type(string: String, context: ModificationContext) throws -> DocumentCommand? {
        var command: DocumentCommand? = try removeSelectedText(context: context);
        let sorted = cursors.sort { $0.range.end > $1.range.end };
        let doc    = document;
        
        for cursor in sorted {
            command = try doc.insertText(string, position: cursor.range.end, context: context);
        }
        
        return command;
    }
    
    public func deleteBackward(context: ModificationContext) throws -> Void {
        let removeCommands = try removeSelectedText(.Edit, context: context);
    
        if removeCommands == nil {
            moveCursorsBackward(true, context: context);
            try removeSelectedText(.Edit, context: context);
        }
    }

    public func deleteBackward() throws -> Commands? {
        return try document.modify(self.deleteBackward);
    }

    public func deleteForward(context: ModificationContext) throws -> Void {
        let removeCommands = try removeSelectedText(.Edit, context: context);
    
        if removeCommands == nil {
            moveCursorsForward(true, context: context);
            try removeSelectedText(.Edit, context: context);
        }
    }

    public func deleteForward() throws -> Commands? {
        return try document.modify(self.deleteForward);
    }
}
