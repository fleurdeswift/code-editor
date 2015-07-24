//
//  ScrollableView.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Cocoa

/// This class make sure that it always uses all the possible space inside it's
/// NSClipView container.
public class ScrollableView : NSView {
    private var lastReportedIntrinsicContentSize = NSSize(width: -1, height: -1);

    public var contentSize: CGSize {
        get {
            return NSSize(width: 0, height: 0);
        }
    }

    internal func invalidateContentSize() {
        if hasIntrinsicContentSizeChanged() {
            invalidateIntrinsicContentSize();
        }
    }

    internal func setupScrollView() {
        if let clipView = self.superview as? NSClipView {
            clipView.postsBoundsChangedNotifications = true;
            clipView.postsFrameChangedNotifications = true;
            
            let center = NSNotificationCenter.defaultCenter();
            
            center.addObserver(self, selector: Selector("clipViewBoundDidChange:"), name: NSViewBoundsDidChangeNotification, object: clipView);
            center.addObserver(self, selector: Selector("clipViewFrameDidChange:"), name: NSViewFrameDidChangeNotification,  object: clipView);
        }
    }

    private func hasIntrinsicContentSizeChanged() -> Bool {
        let calculatedSize = calculateIntrinsicContentSize();
    
        if abs(lastReportedIntrinsicContentSize.width  - calculatedSize.width)  > 0.9 ||
           abs(lastReportedIntrinsicContentSize.height - calculatedSize.height) > 0.9 {
           return true;
        }
        
        return false;
    }

    @objc
    private func clipViewFrameDidChange(notification: NSNotification) -> Void {
        if hasIntrinsicContentSizeChanged() {
            invalidateContentSize();
            frameDidChange();
        }
    }

    @objc
    private func clipViewBoundDidChange(notification: NSNotification) -> Void {
        boundsDidChange();
    }
    
    internal func frameDidChange() {
    }
    
    internal func boundsDidChange() {
    }
    
    private func calculateIntrinsicContentSize() -> NSSize {
        if let clipView = self.superview as? NSClipView {
            let contentSize = self.contentSize;
            let clipBounds  = clipView.bounds;
            
            return  NSSize(width:  max(contentSize.width,  clipBounds.size.width),
                           height: max(contentSize.height, clipBounds.size.height));
        }
        else {
            return self.contentSize;
        }
    }
    
    @objc
    public override var intrinsicContentSize: NSSize {
        get {
            lastReportedIntrinsicContentSize = calculateIntrinsicContentSize();
            return lastReportedIntrinsicContentSize;
        }
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        setupScrollView();
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder);
        setupScrollView();
    }
}