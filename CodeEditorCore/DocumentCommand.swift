//
//  DocumentCommand.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

public class DocumentCommand : Command {
    public enum Type {
        case Insert, Remove;
    }
    
    private(set) public var generation: Int;
    private(set) public var type:       Type;
    private(set) public var range:      PositionRange;
    private(set) public var text:       String;
    
    public init(generation: Int, type: Type, range: PositionRange, text: String) {
        self.generation = generation;
        self.type       = type;
        self.range      = range;
        self.text       = text;
        super.init(category: .Document);
    }
}
