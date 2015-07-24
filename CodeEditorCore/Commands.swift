//
//  Commands.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

public enum CommandsType {
    case Normal, Undo, Redo
}

public class Commands : CustomStringConvertible {
    private(set) public var commands: [Command];
    private(set) public var generation: Int;
    private(set) public var isUndo: Bool;
    
    public var description: String;

    public init(generation: Int, description: String, commands: [Command], undo: Bool) {
        self.generation  = generation;
        self.commands    = commands;
        self.isUndo      = undo;
        self.description = description;
    }

    public init(generation: Int, commands: [Command], undo: Bool) {
        self.generation  = generation;
        self.commands    = commands;
        self.isUndo      = undo;
        self.description = "<no description>";
    }
}
