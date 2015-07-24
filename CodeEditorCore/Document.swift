//
//  Document.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation
import ExtraDataStructures

public enum PositionError : ErrorType {
    case InvalidPosition
}

public enum StateError : ErrorType {
    case InvalidState
}

@objc
public class Document : CustomStringConvertible {
    internal var controllers = ReferenceArray<Controller>();
    internal(set) public var lines = [Line]();
    internal(set) public var generation: Int = 0;
    internal(set) public weak var delegate: DocumentDelegate?;
    public var defaultTextAttributes: NSDictionary;
    
    public let queue = dispatch_queue_create("CodeEditorCode.Document", DISPATCH_QUEUE_CONCURRENT);
    
    public init(defaultTextStyle: NSDictionary) {
        self.defaultTextAttributes = defaultTextStyle;
        lines.append(Line(mutableAttributedString: NSMutableAttributedString()));
    }

    public func verifyPosition(position: Position, context: ReadContext) -> Bool {
        let lineCount = lines.count;
    
        if (position.line >= lineCount) {
            return false;
        }
        
        return position.column <= lines[position.line].length;
    }
    
    public func throwPositionError(position: Position, context: ReadContext) throws {
        if !verifyPosition(position, context: context) {
            throw PositionError.InvalidPosition;
        }
    }
    
    internal func toAttributedString(string: String) -> NSAttributedString {
        return CFAttributedStringCreate(kCFAllocatorDefault, string, defaultTextAttributes);
    }
    
    internal func reportErrorToDelegate(error: ErrorType) {
        if let d = delegate {
            d.errorRaised(error);
        }
    }
    
    private func internalDescription(context: ReadContext) -> String {
        var text  = String();
        var first = true;
        
        for line in self.lines {
            if !first {
                text.append(UnicodeScalar(10));
            }
            else {
                first = false;
            }
            
            text += line.text.string;
        }
        
        return text;
    }
    
    public func description(context: ReadContext) -> String {
        return internalDescription(context);
    }
    
    public var description: String {
        get {
            return read(internalDescription);
        }
    }
    
    public var beginPosition: Position {
        get {
            return Position(line: 0, column: 0);
        }
    }

    private func _endPosition() -> Position {
        assert(self.lines.count > 0);
        return Position(line: self.lines.count - 1, column: self.lines.last!.length);
    }

    public var endPosition: Position {
        get {
            var pos = Position(line: 0, column: 0);
        
            dispatch_sync(queue) {
                pos = self._endPosition();
            }
            
            return pos;
        }
    }
    
    public func endPosition(context: ReadContext) -> Position {
        return _endPosition();
    }
}
