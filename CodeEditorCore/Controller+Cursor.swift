//
//  Controller+Cursor.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Controller {
    public func clearExtrasCursors(type: CursorType, context: ModificationContext) {
        if cursors.count <= 1 {
            return;
        }
        
        var removed = cursors.filter { $0.type == type }
        cursors = cursors.filter { $0.type != type }
        
        if (type == .Edit) {
            cursors.insert(removed.removeAtIndex(0), atIndex:0);
        }
        
        for cursor in removed {
            cursors = cursors.filter { $0 !== cursor }
            onCursorRemoved(cursor);
        }
    }
    
    public func createCursor(type: CursorType, position: Position, context: ModificationContext) -> Cursor {
        var pos = position;
    
        self.normalize(&pos, context: context);
    
        for cursor in cursors {
            if (cursor.type == type) && (cursor.range.end == pos) {
                return cursor;
            }
        }
        
        let cursor = Cursor(type: type, position: pos);
        
        cursors.append(cursor);
        return cursor;
    }
    
    public func setCursorPosition(position: Position, context: ModificationContext) -> Cursor {
        clearExtrasCursors(.Edit, context: context);
        
        var newPosition = position;
        let cursor      = cursors[0];
        
        normalize(&newPosition, context: context);
        
        if cursor.range.end != newPosition {
            cursor.range.start = newPosition;
            cursor.range.end   = newPosition;
            onCursorMoved(cursor);
        }
        
        return cursor;
    }
    
    public func hasCursorOfType(type: CursorType) -> Bool {
        return cursors.contains { $0.type == type }
    }

    public func onCursorMoved(cursor: Cursor) {
    }
    
    public func onCursorRemoved(cursor: Cursor) {
    }
}
