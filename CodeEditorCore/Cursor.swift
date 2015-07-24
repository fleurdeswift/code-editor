//
//  Cursor.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

public enum CursorType {
    case Edit, Find
}

public class Cursor : CustomStringConvertible {
    public let type: CursorType;
    internal(set) public var range: PositionRange;
    
    public init(type: CursorType, position: Position) {
        self.type  = type;
        self.range = PositionRange(position, position);
    }

    public init(type: CursorType, range: PositionRange) {
        self.type  = type;
        self.range = range;
    }
    
    public var description: String {
        get {
            return "\(type): \(range)";
        }
    }
}
