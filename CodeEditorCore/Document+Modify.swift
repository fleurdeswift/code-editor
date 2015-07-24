//
//  Document+Modify.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Document {
    public func modify<RT>(closure: (context: ModificationContext) throws -> RT) throws -> (result: RT, commands: Commands?) {
        return try modify(NSLocalizedString("<no description>", comment: ""), closure: closure);
    }
    
    public func modify<RT>(description: String, closure: (context: ModificationContext) throws -> RT) throws -> (result: RT, commands: Commands?) {
        let context = ModificationContext(document: self);
        var commands:   Commands?;
        var maybeError: ErrorType?;
        var result:     RT?;
    
        dispatch_barrier_sync(queue) {
            do {
                result = try closure(context: context);
            
                if context.commands.count > 0 {
                    self.generation++;
                    commands = Commands(generation: self.generation, description: description, commands: context.commands, undo: true);
                }
            }
            catch {
                maybeError = error;
            }
        }
        
        if let error = maybeError {
            reportErrorToDelegate(error);
            throw error;
        }
        
        if let d = delegate, c = commands {
            d.commandsPerformed(c, type: CommandsType.Normal);
        }
        
        return (result: result!, commands: commands);
    }
    
    public func modify(closure: (context: ModificationContext) throws -> Void) throws -> Commands? {
        return try modify(NSLocalizedString("<no description>", comment: ""), closure: closure);
    }
    
    public func modify(description: String, closure: (context: ModificationContext) throws -> Void) throws -> Commands? {
        let context = ModificationContext(document: self);
        var commands:   Commands?;
        var maybeError: ErrorType?;
    
        dispatch_barrier_sync(queue) {
            do {
                try closure(context: context);
            
                if context.commands.count > 0 {
                    self.generation++;
                    commands = Commands(generation: self.generation, description: description, commands: context.commands, undo: true);
                }
            }
            catch {
                maybeError = error;
            }
        }
        
        if let error = maybeError {
            reportErrorToDelegate(error);
            throw error;
        }
        
        if let d = delegate, c = commands {
            d.commandsPerformed(c, type: CommandsType.Normal);
        }
        
        return commands;
    }
}
