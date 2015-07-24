//
//  Position.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

public struct Position : Equatable, Hashable, Comparable, CustomStringConvertible {
    public var line: Int;
    public var column: Int;
    
    public init(line: Int, column: Int) {
        self.line   = line;
        self.column = column;
    }
    
    public var hashValue: Int {
        get {
            return line.hashValue ^ column.hashValue;
        }
    }
    
    public var description: String {
        get {
            return "(\(line),\(column))";
        }
    }
    
    public var isValid: Bool {
        get {
            return line >= 0;
        }
    }
    
    public static var Invalid: Position {
        get {
            return Position(line: -1, column: -1);
        }
    }
}

public func + (left: Position, right: Int) -> Position {
    return Position(line: left.line, column: left.column + right);
}

public func == (left: Position, right: Position) -> Bool {
    return  (left.line == right.line) && (left.column == right.column);
}

public func != (left: Position, right: Position) -> Bool {
    return  (left.line != right.line) || (left.column != right.column);
}

public func > (left: Position, right: Position) -> Bool {
    if (left.line == right.line) {
        return left.column > right.column;
    }
    
    return left.line > right.line;
}

public func >= (left: Position, right: Position) -> Bool {
    if (left.line == right.line) {
        return left.column >= right.column;
    }
    
    return left.line >= right.line;
}

public func < (left: Position, right: Position) -> Bool {
    if (left.line == right.line) {
        return left.column < right.column;
    }
    
    return left.line < right.line;
}

public func <= (left: Position, right: Position) -> Bool {
    if (left.line == right.line) {
        return left.column <= right.column;
    }
  
    return left.line <= right.line;
}

public struct PositionRange : Equatable, Hashable, CustomStringConvertible {
    public var start: Position;
    public var end: Position;
    
    public init(_ start: Position, _ end: Position) {
        self.start = start;
        self.end   = end;
    }

    public init(_ startLine: Int, _ startColumn: Int, _ endLine: Int, _ endColumn: Int) {
        self.start = Position(line: startLine, column: startColumn);
        self.end   = Position(line: endLine,   column: endColumn);
    }
    
    public var isValid: Bool {
        get {
            return start.isValid || end.isValid;
        }
    }
    
    public var isEmpty: Bool {
        get {
            return start == end;
        }
    }
    
    public var isNormalized: Bool {
        get {
            return start <= end;
        }
    }
    
    public var hashValue: Int {
        get {
            return start.hashValue ^ end.hashValue;
        }
    }
    
    public var description: String {
        get {
            return "\(start)-\(end)";
        }
    }
    
    public var normalized: PositionRange {
        if (start > end) {
            return PositionRange(end, start);
        }
        
        return self;
    }
    
    public static var Invalid: PositionRange {
        get {
            return PositionRange(Position.Invalid, Position.Invalid);
        }
    }
}

public func == (left: PositionRange, right: PositionRange) -> Bool {
    return (left.start == right.start) && (left.end == right.end);
}

public func intersects(left: PositionRange, _ right: PositionRange) -> Bool {
    if (right.start <= left.start) && (left.start < right.end) {
        return true;
    }
    else if (left.start <= right.start) && (right.start < left.end) {
        return true;
    }
    
    return false;
}

public func intersectsOrContiguous(left: PositionRange, _ right: PositionRange) -> Bool {
    if (right.start <= left.start) && (left.start < right.end) {
        return true;
    }
    else if (left.start <= right.start) && (right.start < left.end) {
        return true;
    }
    
    return (left.start == right.end) || (right.start == left.end);
}

public func intersection(left: PositionRange, _ right: PositionRange) -> PositionRange {
    if (right.start <= left.start) && (left.start < right.end) {
        return PositionRange(left.start, min(left.end, right.end));
    }
    else if (left.start <= right.start) && (right.start < left.end) {
        return PositionRange(right.start, min(left.end, right.end));
    }
    
    return PositionRange(Position.Invalid, Position.Invalid);
}

public func union(left: PositionRange, _ right: PositionRange) -> PositionRange {
    if !left.isValid {
        return right;
    }
    else if !right.isValid {
        return left;
    }

    return PositionRange(min(left.start, right.start), max(left.end, right.end));
}

