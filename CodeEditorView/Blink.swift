//
//  Blink.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

private var sharedBlink = Blink();
private var blinkOn:  Double = Double.infinity;
private var blinkOff: Double = Double.infinity;

private func secondToNano(s: Double) -> UInt64 {
    return UInt64(s * Double(NSEC_PER_SEC));
}

private func secondToNano(s: Double) -> Int64 {
    return Int64(s * Double(NSEC_PER_SEC));
}

public protocol Blinkable : class {
    func blink(val: Bool);
};

public final class Blink : NSObject {
    public override init() {
        super.init();
    
        let userDefaults = NSUserDefaults.standardUserDefaults();
        let blinkOnMS    = userDefaults.doubleForKey("NSTextInsertionPointBlinkPeriodOn");
        let blinkOffMS   = userDefaults.doubleForKey("NSTextInsertionPointBlinkPeriodOff");
            
        if blinkOnMS == 0 {
            blinkOn = 0.56;
        }
        else {
            blinkOn = blinkOnMS / 1000.0;
        }

        if blinkOffMS == 0 {
            blinkOff = 0.56;
        }
        else {
            blinkOff = blinkOffMS / 1000.0;
        }
        
        dispatch_source_set_event_handler(on,  self.tickOn);
        dispatch_source_set_event_handler(off, self.tickOff);
        
        let center = NSNotificationCenter.defaultCenter();
        
        center.addObserver(self,
            selector: Selector("applicationDidBecomeActive:"),
            name:     NSApplicationDidBecomeActiveNotification,
            object:   NSApp);

        center.addObserver(self,
            selector: Selector("applicationDidResignActive:"),
            name:     NSApplicationDidResignActiveNotification,
            object:   NSApp);
    }

    public static var shared: Blink {
        get {
            return sharedBlink;
        }
    }
    
    private var blinking = [Blinkable]();
    
    public func start(blinkable: Blinkable) {
        blinking.append(blinkable);
        
        if blinking.count == 1 && NSApp.active {
            start();
        }
    }
    
    public func stop(blinkable: Blinkable) -> Void {
        if blinking.count == 0 {
            return;
        }
        
        blinking = blinking.filter { return $0 !== blinkable };
        
        if blinking.count == 0 {
            kill();
        }
    }
    
    private var ticking = false;
    private var on  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    private var off = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    private func start() -> Void {
        if ticking {
            return;
        }
    
        ticking = true;
        let blinkTotal = blinkOn + blinkOff;
        let precision: UInt64 = secondToNano(blinkTotal / 20);
        
        dispatch_source_set_timer(on, dispatch_time(DISPATCH_TIME_NOW, secondToNano(blinkOff)), secondToNano(blinkTotal), precision);
        dispatch_resume(on);

        dispatch_source_set_timer(off, dispatch_time(DISPATCH_TIME_NOW, secondToNano(blinkTotal)), secondToNano(blinkTotal), precision);
        dispatch_resume(off);
    }
    
    private func kill() -> Void {
        if !ticking {
            return;
        }
    
        ticking = false;
        dispatch_suspend(on);
        dispatch_suspend(off);
    }
    
    private func tickOn() -> Void {
        for blink in blinking {
            blink.blink(true);
        }
    }

    private func tickOff() -> Void {
        for blink in blinking {
            blink.blink(false);
        }
    }
    
    @objc
    private func applicationDidBecomeActive(notification: NSNotification) {
        if blinking.count > 0 {
            start();
        }
    }
    
    @objc
    private func applicationDidResignActive(notification: NSNotification) {
        kill();
    }
}
