//
//  DrawInfo.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public final class DrawContext {
    public static var Y_LIMIT: CGFloat = 10000;

    public var contextRef: CGContextRef?;
    public var configuration: Configuration;
    public var theme: Theme;
    
    /// Current frame visible on screen.
    public var frame = CGRect() {
        didSet {
            calculateTextFrame();
        }
    }
    
    private func calculateTextFrame() {
        if configuration.wrap {
            textFrame = CGRect(
                x:      leftSideBarWidth,
                y:      0,
                width:  frame.size.width - leftSideBarWidth - rightSideBarWidth,
                height: CGFloat.max);
        }
        else {
            textFrame = CGRect(
                x:      leftSideBarWidth,
                y:      0,
                width:  CGFloat.max,
                height: CGFloat.max);
        }
        
        calculateTextLayoutRect();
    }
    
    private func calculateTextLayoutRect() {
        textLayoutRect  = CGRect(x: 0, y: 0, width: textFrame.width, height: DrawContext.Y_LIMIT);
        _textLayoutPath = CGPathCreateWithRect(textLayoutRect, nil);
    }
    
    /// Frame for where text is located. height is always CGFLOAT_MAX.
    internal(set) public var textFrame = CGRect();
    
    internal(set) public var visibleAreaFrame = CGRect();

    /// Frame for layout computing. height is always CGFLOAT_MAX.
    public var textLayoutRect = CGRect();
    
    /// Equivalent of textLayoutRect, but in CGPathRef.
    public var textLayoutPath: CGPathRef {
        get {
            return _textLayoutPath!;
        }
    }
    
    internal var _textLayoutPath: CGPathRef?;
    
    internal(set) public var leftSideBarWidth: CGFloat = 0;
    internal(set) public var rightSideBarWidth: CGFloat = 0;
    
    internal(set) public var textFont: CTFontRef;
    
    internal func calculateLeftSideBar() {
        leftSideBarWidth =
            (lineHeight - 2) + // Space for an icon
            lineNumberWidth  + // Space for line numbers
            lineHeightD3M2;    // Breakpoint and/or instruction pointer bookmark
    }
        
    public init(configuration: Configuration, theme: Theme) {
        self.configuration  = configuration;
        self.theme          = theme;
        self.textFont       = CTFontCreateWithName(theme.textFontName, theme.textFontSize, nil);
        self.lineNumberFont = CTFontCreateWithName(theme.lineNumberFontName, theme.textFontSize - 2, nil);

        calculateSpaceCharacterWidth();
        calculateLineHeight();
        
        if configuration.wrap {
            lineNumberWidth = calculateLineNumberWidth();
        }

        calculateLeftSideBar();
        calculateParagraphStyles();
    }
    
    internal final func calculateSpaceCharacterWidth() {
        var ch:    UniChar = 20;
        var glyph: CGGlyph = 0;
        var size = CGSize();

        CTFontGetGlyphsForCharacters(textFont, &ch, &glyph, 1);
        CTFontGetAdvancesForGlyphs(textFont, CTFontOrientation.Default, &glyph, &size, 1);
        spaceCharacterWidth = size.width;
    }
    
    internal(set) public var spaceCharacterWidth: CGFloat = 0;
    
    //MARK: Paragraph Style Variables

    internal var _tabStops: NSArray?;
    internal var _defaultParagraphStyle: CTParagraphStyleRef?;

    //MARK: Line Variables

    internal(set) public var lineHeight: CGFloat = 0;
    
    /// Line height divided by 3.
    internal(set) public var lineHeightD3: CGFloat = 0;
    
    /// Line height divided by 3, multiplied by 2.
    internal(set) public var lineHeightD3M2: CGFloat = 0;
    
    internal var _lineCount: UInt = 0;

    internal(set) public var lineNumberWidth: CGFloat = 0;
    
    internal(set) public var lineNumberFont: CTFontRef;
}

