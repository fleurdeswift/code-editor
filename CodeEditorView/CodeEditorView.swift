//
//  CodeEditorView.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Cocoa
import CodeEditorCore;


public class CodeEditorView : BlinkingView {
    internal(set) public var lines = [LineCell]();

    public var configuration: Configuration {
        willSet {
            if (self.configuration === newValue) {
                return;
            }

            if (self.configuration == newValue) {
                return;
            }
            
            drawContext.configuration = newValue;
        }
    }

    public var theme: Theme {
        willSet {
            if (self.theme === newValue) {
                return;
            }

            if (self.theme == newValue) {
                return;
            }
            
            drawContext.theme = newValue;
        }
    }
    
    public var document: Document {
        didSet {
            if (self.document === document) {
                return;
            }
            
            documentWasChanged();
        }
    }
    
    internal func documentWasChanged() {
        lines = [LineCell]();
        lines.reserveCapacity(document.lines.count);
        
        for line in document.lines {
            lines.append(LineCell(line: line));
        }
        
        calculateLineLayouts(LayoutChanges.Document);
        
        if controller.document === document {
            return;
        }
        
        document.removeController(controller);
        controller = Controller(document: document);
        document.addController(controller, strong: false);
    }

    internal(set) public var controller: Controller;
    internal(set) public var drawContext: DrawContext;
    
    public override init(frame frameRect: NSRect) {
        self.configuration = Configuration();
        self.theme         = Theme(.Dark);
        self.drawContext   = DrawContext(configuration: configuration, theme: theme);
        self.document      = Document(defaultTextStyle: self.drawContext.defaultTextStyle);
        self.controller    = Controller(document: self.document);

        do {
            try self.controller.type("// This is a test\n// This is the second line");
        }
        catch {
        }
        
        super.init(frame: frameRect);
        
        self.drawContext.frame = self.bounds;
        documentWasChanged();
    }
    
    public required init?(coder: NSCoder) {
        self.configuration = Configuration();
        self.theme         = Theme(.Dark);
        self.drawContext   = DrawContext(configuration: configuration, theme: theme);
        self.document      = Document(defaultTextStyle: self.drawContext.defaultTextStyle);
        self.controller    = Controller(document: self.document);

        do {
            try self.controller.type("// This is a test\n// This is the second line\n// Third\n// Fourth\n// Fifth\n// Sixth");
        }
        catch {
        }
        
        super.init(coder: coder);
        
        self.drawContext.frame = self.bounds;
        documentWasChanged();
    }
    
    public override func frameDidChange() {
        drawContext.frame = self.bounds;

        if let scrollView = self.enclosingScrollView {
            drawContext.visibleAreaFrame = scrollView.documentVisibleRect;
        }
        
        calculateLineLayouts(LayoutChanges.Frame);
        self.needsDisplay = true;
    }

    public override func boundsDidChange() {
        drawContext.frame = self.bounds;
        
        if let scrollView = self.enclosingScrollView {
            drawContext.visibleAreaFrame = scrollView.documentVisibleRect;
        }
    }
    
    public override var flipped: Bool {
        get {
            return true;
        }
    }
    
    internal(set) public var _contentSize = CGSize();
    
    override public var contentSize: CGSize {
        get {
            var s = _contentSize;
        
            s.width += drawContext.leftSideBarWidth + drawContext.rightSideBarWidth;
            return s;
        }
    }
    
    internal var layoutGroup: dispatch_group_t = dispatch_group_create();
}
