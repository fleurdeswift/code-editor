//
//  Document+RemoveText.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Document {
    public func extractText(range: PositionRange, context: ReadContext) throws -> String {
        try throwPositionError(range.start, context: context);
        try throwPositionError(range.end, context: context);
        
        if range.start.line == range.end.line {
            return lines[range.start.line].text.mutableString.substringWithRange(NSRange(location: range.start.column, length: range.end.column - range.start.column));
        }
        
        var text = lines[range.start.line].text.mutableString.substringFromIndex(range.start.column);
        text.append(UnicodeScalar(10));
        
        for (var index = range.start.line + 1; index < range.end.line; ++index) {
            text += lines[index].text.string;
            text.append(UnicodeScalar(10));
        }
        
        text += lines[range.end.line].text.mutableString.substringToIndex(range.end.column);
        return text;
    }

    public func removeText(range: PositionRange, context: ModificationContext) throws -> DocumentCommand? {
        if range.isEmpty {
            return nil;
        }

        assert(range.isNormalized);

        try throwPositionError(range.start, context: context);
        try throwPositionError(range.end, context: context);
        
        var text: String;
        var line: Line;
        var rangeNS: NSRange;
        
        if range.start.line == range.end.line {
            line  = lines[range.start.line];
            rangeNS = NSRange(location: range.start.column, length: range.end.column - range.start.column);
            text  = line.text.mutableString.substringWithRange(rangeNS);
            
            line.text.deleteCharactersInRange(rangeNS);
            context.wasLineModified(line, number: range.start.line);
        }
        else if (range.start.column == 0) && (range.end.column == 0) {
            text = String();
        
            for (var index = range.start.line; index < range.end.line; ++index) {
                line = lines[index];
            
                text += lines[index].text.string;
                text.append(UnicodeScalar(10));
                context.wasLineRemoved(line, number: range.start.line);
            }
            
            lines.removeRange(Range(start: range.start.line, end: range.end.line));
        }
        else if range.start.column == 0 {
            text = String();
        
            for (var index = range.start.line; index < range.end.line; ++index) {
                line = lines[index];
            
                text += lines[index].text.string;
                text.append(UnicodeScalar(10));
                context.wasLineRemoved(line, number: range.start.line);
            }
            
            line  = lines[range.end.line];
            rangeNS = NSRange(location: 0, length: range.end.column);
            text += line.text.mutableString.substringToIndex(range.end.column);
            line.text.deleteCharactersInRange(rangeNS);
            context.wasLineModified(line, number: range.start.line);

            lines.removeRange(Range(start: range.start.line, end: range.end.line));
        }
        else if range.end.column == 0 {
            line  = lines[range.start.line];
            rangeNS = NSRange(location: range.start.column, length: line.length - range.start.column);
            text  = line.text.mutableString.substringFromIndex(range.start.column);
            text.append(UnicodeScalar(10));
            line.text.deleteCharactersInRange(rangeNS);
            line.text.appendAttributedString(lines[range.end.line].text);
            context.wasLineModified(line, number: range.start.line);
        
            for (var index = range.start.line + 1; index < range.end.line; ++index) {
                line = lines[index];
            
                text += lines[index].text.string;
                text.append(UnicodeScalar(10));
                context.wasLineRemoved(line, number: range.start.line + 1);
            }
            
            lines.removeRange(Range(start: range.start.line + 1, end: range.end.line + 1));
        }
        else {
            line  = lines[range.start.line];
            rangeNS = NSRange(location: range.start.column, length: line.length - range.start.column);
            text  = line.text.mutableString.substringFromIndex(range.start.column);
            text.append(UnicodeScalar(10));
            line.text.deleteCharactersInRange(rangeNS);
            
            for (var index = range.start.line + 1; index < range.end.line; ++index) {
                line = lines[index];
            
                text += lines[index].text.string;
                text.append(UnicodeScalar(10));
                context.wasLineRemoved(line, number: range.start.line + 1);
            }

            let lastLine = lines[range.end.line];

            line  = lines[range.start.line];
            rangeNS = NSRange(location: range.end.column, length: lastLine.length - range.end.column);
            text += lastLine.text.mutableString.substringToIndex(range.end.column);
            line.text.appendAttributedString(lastLine.text.attributedSubstringFromRange(rangeNS));
            context.wasLineModified(line, number: range.start.line);
            
            lines.removeRange(Range(start: range.start.line + 1, end: range.end.line + 1));
        }
        
        return context.addDocumentCommand(
             DocumentCommand(generation: generation,
                                   type: .Insert,
                                  range: range,
                                   text: text));
    }
}
