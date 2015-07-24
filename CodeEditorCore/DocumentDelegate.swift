//
//  DocumentDelegate.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public protocol DocumentDelegate : class {
    func commandsPerformed(commands: Commands, type: CommandsType);
    func errorRaised(error: ErrorType);
}
