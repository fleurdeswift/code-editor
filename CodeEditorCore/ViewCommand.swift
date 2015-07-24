//
//  ViewCommand.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public class ViewCommand : Command {
    private(set) public var view: View;

    public init(view: View) {
        self.view = view;
        super.init(category: .View);
    }
}
