//
//  Document+Read.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension Document {
    public func read(closure: (context: ReadContext) -> Void) -> Void {
        let context = ReadContext();
        
        dispatch_sync(queue) {
            closure(context: context);
        }
    }

    public func read<RT>(closure: (context: ReadContext) -> RT) -> RT {
        let context = ReadContext();
        var returnValue: RT?;
        
        dispatch_sync(queue) {
            returnValue = closure(context: context);
        }
        
        return returnValue!;
    }

    public func read<RT>(closure: (context: ReadContext) -> RT?) -> RT? {
        let context = ReadContext();
        var returnValue: RT?;
        
        dispatch_sync(queue) {
            returnValue = closure(context: context);
        }
        
        return returnValue;
    }
}
