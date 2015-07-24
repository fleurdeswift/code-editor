//
//  Command.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

public class Command {
    public enum Category {
        case Document, Controller, View
    }
    
    private(set) var category: Category;
    
    public init(category: Category) {
        self.category = category;
    }
    
    public func canMerge(otherCommand: Command) -> Bool {
        return false;
    }
    
    public func merge(otherCommand: Command) -> Bool {
        return false;
    }
}
