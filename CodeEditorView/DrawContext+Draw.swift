//
//  DrawContext+Draw.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import CoreGraphics

public extension DrawContext {
    public func drawBackground(orect: CGRect, enabled: Bool) -> Void {
        let contextRef = self.contextRef!;
        var rect = orect;
        
        CGContextSaveGState(contextRef);
        
        if (enabled) {
            CGContextSetFillColorWithColor(contextRef, theme.breakpointEnabledFillColor);
        }
        else {
            CGContextSetFillColorWithColor  (contextRef, theme.breakpointDisabledFillColor);
            CGContextSetStrokeColorWithColor(contextRef, theme.breakpointDisabledStrokeColor);
            
            rect.origin.y    += 0.5;
            rect.size.height -= 1.0;
        }

        let w      = lineHeightD3;
        let right  = rect.origin.x + rect.size.width;
        let bottom = rect.origin.y + rect.size.height;
        
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint   (contextRef, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(contextRef, right - w,     rect.origin.y);
        CGContextAddLineToPoint(contextRef, right,         rect.origin.y + (rect.size.height / 2.0));
        CGContextAddLineToPoint(contextRef, right - w,     bottom);
        CGContextAddLineToPoint(contextRef, rect.origin.x, bottom);
        CGContextAddLineToPoint(contextRef, rect.origin.x, rect.origin.y);

        if (enabled) {
            CGContextFillPath(contextRef);
        }
        else {
            CGContextDrawPath(contextRef, CGPathDrawingMode.FillStroke);
        }
        
        CGContextRestoreGState(contextRef);
    }
    
    public func drawInstructionPointer(orect: CGRect) {
        let contextRef = self.contextRef!;
        var rect = orect;
        
        CGContextSaveGState(contextRef);
        CGContextSetLineWidth(contextRef, 1.0);
        CGContextSetFillColorWithColor  (contextRef, theme.instructionPointerFillColor);
        CGContextSetStrokeColorWithColor(contextRef, theme.instructionPointerStrokeColor);
        
        rect.origin.y    += 0.5;
        rect.size.height -= 1.0;
        
        let w      = lineHeightD3;
        let right  = rect.origin.x + rect.size.width;
        let bottom = rect.origin.y + rect.size.height;
        let left   = rect.origin.x + rect.size.width - w;
        
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint   (contextRef, left, rect.origin.y);
        CGContextAddLineToPoint(contextRef, right,     rect.origin.y);
        CGContextAddLineToPoint(contextRef, right + w, rect.origin.y + (rect.size.height / 2.0));
        CGContextAddLineToPoint(contextRef, right,     bottom);
        CGContextAddLineToPoint(contextRef, left,      bottom);
        CGContextAddLineToPoint(contextRef, left,      rect.origin.y);
        CGContextDrawPath(contextRef, CGPathDrawingMode.FillStroke);
        CGContextRestoreGState(contextRef);
    }

    public func draw(rect: CGRect, lineNumber: UInt, enabled: Bool) -> Void {
        let contextRef = self.contextRef!;
        
        let lineNumberAttributed = NSAttributedString(string: String(lineNumber), attributes:[
            kCTFontAttributeName            as String: lineNumberFont,
            kCTForegroundColorAttributeName as String: enabled ? theme.lineNumberSelectedColor: theme.lineNumberColor
        ]);
        
        let lineRef   = CTLineCreateWithAttributedString(lineNumberAttributed);
        let lineRect  = CTLineGetBoundsWithOptions(lineRef, CTLineBoundsOptions());
        let capHeight = CTFontGetCapHeight(lineNumberFont);
        let right     = rect.origin.x + rect.size.width - spaceCharacterWidth;

        var ascent:  CGFloat = 0;
        var descent: CGFloat = 0;
        var leading: CGFloat = 0;
        
        CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        CGContextSetTextPosition(contextRef, right - lineRect.size.width, rect.origin.y + rect.size.height - ((rect.size.height - capHeight) / 2));
        CTLineDraw(lineRef, contextRef);
    }
}
