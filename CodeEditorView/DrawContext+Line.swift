//
//  DrawContext+Line.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

private func lineNumberTemplate(count: UInt) -> String {
    if (count < 10) {
        return "0";
    }
    else if (count < 20) {
        return "10";
    }
    else if (count < 100) {
        return "00";
    }
    else if (count < 1000) {
        return "000";
    }
    else if (count < 10000) {
        return "0000";
    }
    else if (count < 100000) {
        return "00000";
    }
    
    return "000000";
}

public extension DrawContext {
    public var lineCount: UInt {
        get {
            return _lineCount;
        }
        
        set {
            if (_lineCount == newValue) {
                return;
            }
            
            _lineCount = newValue;
            lineNumberWidth = calculateLineNumberWidth();
        }
    }
    
    internal func calculateLineNumberWidth() -> CGFloat {
        let lineAttributes: [String: AnyObject] = [kCTFontAttributeName as String: self.lineNumberFont];
        let lineString = NSAttributedString(string: lineNumberTemplate(_lineCount), attributes: lineAttributes);
        let lineNumber = CTLineCreateWithAttributedString(lineString);
        
        return CGFloat(CTLineGetTypographicBounds(lineNumber, nil, nil, nil));
    }
    
    internal func calculateLineHeight() {
        lineHeight     = theme.textFontSize;
        lineHeightD3   = lineHeight / 3.0;
        lineHeightD3M2 = lineHeight * 2.0 / 3.0;
    }
}
