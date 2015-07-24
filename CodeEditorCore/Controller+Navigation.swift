//
//  Controller+Navigation.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Controller {
    private func moveCursors(block: (inout position: Position, context: ModificationContext) -> Bool, extendsSelection: Bool) -> Bool {
        do {
            return try document.modify({ (context: ModificationContext) -> Bool in
                return self.moveCursors(block, extendsSelection: extendsSelection, context: context);
            }).result;
        }
        catch {
            return false;
        }
    }
    
    private func moveCursors(block: (inout position: Position, context: ModificationContext) -> Bool, extendsSelection: Bool, context: ModificationContext) -> Bool {
        var modified = false;
    
        for cursor in cursors {
            if cursor.type != .Edit {
                continue;
            }
        
            modified |= moveCursor(block, cursor: cursor, extendsSelection: extendsSelection, context: context);
        }
    
        return modified;
    }
    
    private func moveCursor(block: (inout position: Position, context: ModificationContext) -> Bool, cursor: Cursor, extendsSelection: Bool, context: ModificationContext) -> Bool {
        if block(position: &cursor.range.end, context: context) {
            if !extendsSelection {
                cursor.range.start = cursor.range.end;
            }
            
            onCursorMoved(cursor);
            return true;
        }
        
        return false;
    }
    
    public func normalize(inout position: Position, context: ReadContext) -> Bool {
        if position.line >= document.lines.count {
            position = document.endPosition(context);
            return true;
        }
        else if position.line < 0 {
            position = document.beginPosition;
            return true;
        }
        
        let line   = document.lines[position.line];
        let length = line.length;
        
        if position.column > length {
            position.column = length;
            return true;
        }
        else if position.column < 0 {
            assert(false);
            position.column = 0;
            return true;
        }
        
        return false;
    }

    public func moveBackward(inout position: Position, context: ModificationContext) -> Bool {
        if (normalize(&position, context: context)) {
            return true;
        }
    
        if position.column == 0 {
            if position.line == 0 {
                return false;
            }
        
            position.line--;
            position.column = document.lines[position.line].length;
        }
        else {
            position.column--;
        }
        
        return true;
    }

    public func moveBackward(inout position: Position, characterIterator: (ch: Character) -> Bool, context: ModificationContext) -> Bool {
        if (normalize(&position, context: context)) {
            return true;
        }
    
        while true {
            let ch = document.lines[position.line].charAt(position.column);
        
            if characterIterator(ch: ch) {
                break;
            }
        
            if position.column == 0 {
                if position.line == 0 {
                    return false;
                }
                
                position.line--;
                position.column = document.lines[position.line].length;
            }
            else {
                position.column--;
            }
        }
        
        return true;
    }
    
    public func moveCursorBackward(cursor: Cursor, extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursor(moveBackward, cursor: cursor, extendsSelection: extendsSelection, context: context);
    }
    
    public func moveCursorsBackward(extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursors(moveBackward, extendsSelection: extendsSelection, context: context);
    }

    public func moveCursorsBackward(extendsSelection: Bool) -> Bool {
        return moveCursors(moveBackward, extendsSelection: extendsSelection);
    }

    public func moveForward(inout position: Position, context: ModificationContext) -> Bool {
        if (normalize(&position, context: context)) {
            return true;
        }
        
        let line = document.lines[position.line];
        
        if position.column < line.length {
            position.column++;
            return true;
        }
        
        if (document.lines.count - 1) == position.line {
            return false;
        }
        
        position.line++;
        position.column = 0;
        return true;
    }

    public func moveForward(inout position: Position, characterIterator: (ch: Character) -> Bool, context: ModificationContext) -> Bool {
        if (normalize(&position, context: context)) {
            return true;
        }
        
        while true {
            let ch = document.lines[position.line].charAt(position.column);
        
            if characterIterator(ch: ch) {
                break;
            }
        
            let line = document.lines[position.line];
            
            if position.column < line.length {
                position.column++;
                continue;
            }
            
            if (document.lines.count - 1) == position.line {
                return false;
            }
            
            position.line++;
            position.column = 0;
        }
        
        return true;
    }

    public func moveCursorForward(cursor: Cursor, extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursor(moveForward, cursor: cursor, extendsSelection: extendsSelection, context: context);
    }

    public func moveCursorsForward(extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursors(moveForward, extendsSelection: extendsSelection, context: context);
    }

    public func moveCursorsForward(extendsSelection: Bool) -> Bool {
        return moveCursors(moveForward, extendsSelection: extendsSelection);
    }

    public func moveToEndOfLine(inout position: Position, context: ModificationContext) -> Bool {
        if (normalize(&position, context: context)) {
            return true;
        }
        
        let line = document.lines[position.line];
        
        if position.column != line.length {
            position.column = line.length;
            return true;
        }
        
        return true;
    }
    
    public func moveCursorToEndOfLine(cursor: Cursor, extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursor(moveToEndOfLine, cursor: cursor, extendsSelection: extendsSelection, context: context);
    }

    public func moveCursorsToEndOfLine(extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursors(moveToEndOfLine, extendsSelection: extendsSelection, context: context);
    }

    public func moveCursorsToEndOfLine(extendsSelection: Bool) -> Bool {
        return moveCursors(moveToEndOfLine, extendsSelection: extendsSelection);
    }

    public func moveToStartOfLine(inout position: Position, context: ModificationContext) -> Bool {
        if (normalize(&position, context: context)) {
            return true;
        }
        
        if position.column != 0 {
            position.column = 0;
            return true;
        }
        
        return true;
    }
    
    public func moveCursorToStartOfLine(cursor: Cursor, extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursor(moveToStartOfLine, cursor: cursor, extendsSelection: extendsSelection, context: context);
    }

    public func moveCursorsToStartOfLine(extendsSelection: Bool, context: ModificationContext) -> Bool {
        return moveCursors(moveToStartOfLine, extendsSelection: extendsSelection, context: context);
    }

    public func moveCursorsToStartOfLine(extendsSelection: Bool) -> Bool {
        return moveCursors(moveToStartOfLine, extendsSelection: extendsSelection);
    }
}
