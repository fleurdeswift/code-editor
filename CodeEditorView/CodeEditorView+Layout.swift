//
//  CodeEditorView+Layout.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation
import ExtraDataStructures

private let ASYNC_LAYOUT: Bool = true;

public extension CodeEditorView {
    internal func calculateLineLayouts(changes: LayoutChanges) {
        var size = CGSize(width: 0, height: 0);
        
        for line in lines {
            if ASYNC_LAYOUT {
                dispatch_group_async(layoutGroup, document.queue) {
                    let s = line.layout(self.drawContext, changes: changes);
                    
                    AtomicMax(&size.width,  s.width);
                    AtomicAdd(&size.height, s.height);
                }
            }
            else {
                let s = line.layout(drawContext, changes: changes);
                
                size.width   = max(size.width, s.width);
                size.height += s.height;
            }
        }
        
        dispatch_group_wait(layoutGroup, DISPATCH_TIME_FOREVER);
        _contentSize = size;
    }
}
