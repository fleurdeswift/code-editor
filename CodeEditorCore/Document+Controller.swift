//
//  Document+Controller.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Document {
    public func addController(controller: Controller, strong: Bool) -> Void {
        dispatch_barrier_sync(queue) {
            self.controllers.add(controller, strong: strong);
        }
    }
    
    public func removeController(controller: Controller) -> Void {
        dispatch_barrier_sync(queue) {
            self.controllers.remove(controller);
        }
    }

}
