//
//  Document+Undo.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Document {
    private func undoDocument(documentCommand: DocumentCommand, context: ModificationContext) throws -> DocumentCommand? {
        switch (documentCommand.type) {
        case .Insert:
            return try self.insertText(documentCommand.text, position: documentCommand.range.start, context: context);
        case .Remove:
            return try self.removeText(documentCommand.range, context: context);
        }
    }

    private func undoController(controllerCommand: ControllerCommand, context: ModificationContext) throws -> Command? {
        if (!controllers.contains { $0 === controllerCommand }) {
            return nil;
        }
    
        return try controllerCommand.controller.undo(controllerCommand, context: context);
    }

    private func undoView(viewCommand: ViewCommand, context: ModificationContext) throws -> Command? {
        if (!viewCommand.view.valid) {
            return nil;
        }
    
        return try viewCommand.view.undo(viewCommand, context: context);
    }
    
    private func undo(command: Command, context: ModificationContext) throws -> Command? {
        switch (command.category) {
        case .Document:
            return try undoDocument(command as! DocumentCommand, context: context);
        case .Controller:
            return try undoController(command as! ControllerCommand, context: context);
        case .View:
            return try undoView(command as! ViewCommand, context: context);
        }
    }
    
    public func undo(commands: Commands) throws -> Commands {
        let context = ModificationContext(document: self);
        var catchedError: ErrorType?;
        var redoCommands: Commands?;
        
        dispatch_barrier_sync(queue) {
            if (self.generation != commands.generation) {
                catchedError = StateError.InvalidState;
                return;
            }
        
            for command in commands.commands {
                do {
                    try self.undo(command, context: context);
                }
                catch {
                    catchedError = error;
                    return;
                }
            }
            
            if commands.isUndo {
                self.generation--;
            }
            else {
                self.generation++;
            }
            
            if context.commands.count > 0 {
                redoCommands = Commands(generation: self.generation, commands: context.commands, undo: !commands.isUndo);
            }
        }
        
        if let error = catchedError {
            reportErrorToDelegate(error);
            throw error;
        }
        
        if let d = delegate {
            d.commandsPerformed(redoCommands!, type: commands.isUndo ? CommandsType.Undo: CommandsType.Redo);
        }
        
        return redoCommands!;
    }
}
