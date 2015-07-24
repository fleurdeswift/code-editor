//
//  View.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public protocol View : class {
    var valid: Bool { get }

    func undo(viewCommand: ViewCommand, context: ModificationContext) throws -> Command?;
}
