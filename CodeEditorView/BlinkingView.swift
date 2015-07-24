//
//  BlinkingView.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Cocoa

public class BlinkingView : ScrollableView, Blinkable {
    public override var acceptsFirstResponder: Bool {
        get {
            return true;
        }
    }
    
    public override func becomeFirstResponder() -> Bool {
        Blink.shared.start(self);
        return super.becomeFirstResponder();
    }
    
    public override func resignFirstResponder() -> Bool {
        Blink.shared.stop(self);
        return super.resignFirstResponder();
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow();
        Blink.shared.stop(self);
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview();
        Blink.shared.stop(self);
    }
    
    public func blink(value: Bool) {
        if value {
            Swift.print("On");
        }
        else {
            Swift.print("Off");
        }
    }
}

