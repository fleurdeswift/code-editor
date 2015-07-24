//
//  Controller+Selection.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Controller {
    public func select(type: CursorType, range: PositionRange, merge: Bool = false, context: ModificationContext) -> Cursor {
        var newRange = range;
        
        self.normalize(&newRange.start, context: context);
        self.normalize(&newRange.end,   context: context);
        
        if merge {
            for cursor in cursors {
                if cursor.type != type {
                    continue;
                }
            
                if intersectsOrContiguous(newRange, cursor.range) {
                    let unionOfBoth = union(newRange, cursor.range);
                    
                    if (unionOfBoth == cursor.range) {
                        // noop.
                        return cursor;
                    }
                    
                    cursor.range = unionOfBoth;
                    onCursorMoved(cursor);
                    return cursor;
                }
            }
        }
        
        let newCursor = Cursor(type: type, range: range);

        cursors.append(newCursor);
        onCursorMoved(newCursor);
        return newCursor;
    }
    
    public func removeSelectedText(type: CursorType = .Edit, context: ModificationContext) throws -> DocumentCommand? {
        if cursors.count == 0 {
            return nil;
        }
    
        let sorted = cursors.filter({ $0.type == type }).sort({ $0.range.end > $1.range.end });
        var command: DocumentCommand?;
    
        for selection in sorted {
            command = try document.removeText(selection.range.normalized, context: context);
        }
        
        return command;
    }
}
