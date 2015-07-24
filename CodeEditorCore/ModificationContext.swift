//
//  ModificationContext.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public class ReadContext {
    internal init() {
    }
}

public class ModificationContext : ReadContext {
    internal(set) var commands = [Command]();
    internal(set) var document: Document;
    
    internal init(document: Document) {
        self.document = document;
    }
    
    public func addCommand(command: Command) -> Command {
        commands.insert(command, atIndex:0);
        return command;
    }

    public func addCommand(command: Command, after: Command) -> Command {
        let maybeIndex = commands.indexOf { $0 === after }
    
        if let index = maybeIndex {
            commands.insert(command, atIndex:index);
        }
        else {
            commands.append(command);
        }
        
        return command;
    }
    
    public func addDocumentCommand(command: DocumentCommand) -> DocumentCommand {
        commands.insert(command, atIndex:0);
        
        for controller in document.controllers {
            controller.onDocumentCommand(command, context: self);
        }
        
        return command;
    }
    
    internal func wasLineModified(line: Line, number: Int) -> Void {
    }

    internal func wasLineInserted(line: Line, number: Int) -> Void {
    }

    internal func wasLineRemoved(line: Line, number: Int) -> Void {
    }
};
