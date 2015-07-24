//
//  Document+InsertText.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Document {
    public func insertText(text: String, position: Position, context: ModificationContext) throws -> DocumentCommand? {
        if text.isEmpty {
            return nil;
        }
    
        let parts = text.componentsSeparatedByString("\n");
        
        if parts.count == 0 {
            return nil;
        }
        
        try throwPositionError(position, context: context);
        let firstLine = lines[position.line];
        
        if (parts.count == 1) {
            let newPart = toAttributedString(parts[0]);
        
            if (position.column == firstLine.length) {
                firstLine.text.appendAttributedString(newPart);
            }
            else {
                firstLine.text.insertAttributedString(newPart, atIndex: position.column);
            }
            
            context.wasLineModified(firstLine, number: position.line);
            return context.addDocumentCommand(
                 DocumentCommand(generation: generation,
                                       type: .Remove,
                                      range: PositionRange(position, position + newPart.length),
                                       text: text));
        }
        
        var newLines = [Line]();
        let lastLine = firstLine.split(position.column);
        
        newLines.append(firstLine);
        firstLine.text.appendAttributedString(toAttributedString(parts[0]))
        context.wasLineModified(firstLine, number: position.line);
        
        for (var index = 1; index < (parts.count - 1); ++index) {
            newLines.append(Line(attributedString: toAttributedString(parts[index])));
            context.wasLineInserted(newLines[1], number: position.line + index);
        }
        
        newLines.append(lastLine);
        
        let lastPart = toAttributedString(parts.last!);
        
        lastLine.text.insertAttributedString(lastPart, atIndex: 0);
        context.wasLineInserted(lastLine, number: position.line + parts.count - 1);
        
        lines.replaceRange(Range(start: position.line, end: position.line + 1), with: newLines);
        
        return context.addDocumentCommand(
             DocumentCommand(generation: generation,
                                   type: .Remove,
                                  range: PositionRange(position, Position(line: position.line + parts.count - 1, column: lastPart.length)),
                                   text: text));
    }
}
