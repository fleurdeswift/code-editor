//
//  ControllerCommand.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public class ControllerCommand : Command {
    public enum Type {
        case MoveCursorStart, MoveCursorEnd
    }

    public let controller: Controller;
    public let type: Type;
    public let position: Position;
    public let object: AnyObject;

    public init(controller: Controller, type: Type, position: Position, object: AnyObject) {
        self.controller = controller;
        self.type       = type;
        self.position   = position;
        self.object     = object;
        super.init(category: .Controller);
    }
}
