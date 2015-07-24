//
//  Controller+DocumentCommand.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Controller {
    public class func movePositionsForward(range: PositionRange, inout position: Position) -> Bool {
        if position < range.start {
            return false;
        }
        
        if position == range.start {
            position = range.end;
            return false;
        }
        
        if position.line == range.start.line {
            position.line  += (range.end.line - range.start.line);
            position.column = (position.column - range.start.column) + range.end.column;
            return false;
        }

        position.line += (range.end.line - range.start.line);
        return false;
    }

    /// This function returns true if the operation of removing the text is going to move the
    /// position in a way, that performing the opposite operation won't give you back the operation.
    /// ie. If you didn't save the position passed in parameter, you won't get it back when undoing.
    public class func movePositionsBackward(range: PositionRange, inout position: Position) -> Bool {
        if position < range.start {
            return false;
        }

        if position == range.start {
            // movePositionsForward always move position on boundary collision.
            return true;
        }
        
        if (range.start.line == range.end.line) {
            if position.line == range.start.line {
                if position.column > range.start.column {
                    if position.column < range.end.column {
                        position = range.start;
                        return true;
                    }
                    else {
                        position.column -= (range.end.column - range.start.column);
                    }
                }
            }
            
            return false;
        }
        
        if position.line == range.end.line {
            if position.column >= range.end.column {
                position.column += range.start.column - range.end.column;
            }
            else {
                position = range.start;
                return true;
            }
        }
        else if position.line < range.end.line {
            position = range.start;
            return true;
        }
        
        position.line -= (range.end.line - range.start.line);
        return false;
    }
    
    /// Called in reaction to document inserting text.
    internal func movePositionsForward(range: PositionRange, context: ModificationContext) {
        assert(range.isNormalized);
        
        for cursor in cursors {
            if (Controller.movePositionsForward(range, position: &cursor.range.start) |
                Controller.movePositionsForward(range, position: &cursor.range.end)) {
                onCursorMoved(cursor);
            }
        }
    }

    /// Called in reaction to document removing text.
    internal func movePositionsBackward(documentCommand: DocumentCommand, range: PositionRange, context: ModificationContext) {
        assert(range.isNormalized);
        
        for cursor in cursors {
            let previousStart = cursor.range.start;
            let previousEnd   = cursor.range.end;
        
            if (Controller.movePositionsBackward(range, position: &cursor.range.start) |
                Controller.movePositionsBackward(range, position: &cursor.range.end)) {
                context.addCommand(ControllerCommand(controller: self, type: .MoveCursorEnd,   position: previousEnd,   object: cursor), after: documentCommand);
                context.addCommand(ControllerCommand(controller: self, type: .MoveCursorStart, position: previousStart, object: cursor), after: documentCommand);
                onCursorMoved(cursor);
            }
        }
    }
    
    public func onDocumentCommand(documentCommand: DocumentCommand, context: ModificationContext) -> Void {
        switch (documentCommand.type) {
        case .Remove:
            movePositionsForward(documentCommand.range, context: context);
            break;
        case .Insert:
            movePositionsBackward(documentCommand, range: documentCommand.range, context: context);
            break;
        }
    }
}

internal func | (left: Bool, right: Bool) -> Bool {
    return left || right;
}

internal func |= (inout left: Bool, right: Bool) -> Void {
    left = left || right;
}
