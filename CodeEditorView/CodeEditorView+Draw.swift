//
//  CodeEditorView+Draw.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public extension CodeEditorView {
    private func drawLines() {
        let drawContext = self.drawContext;
        let context     = drawContext.contextRef!;
        
        var lineNumber     = 0;
        var firstLineDrawn = NSNotFound;
        let frame          = drawContext.frame;
        var lineRect       = CGRect(x: 0, y: 0, width: frame.size.width, height: 0);
        var lineDrawn      = 0;
        
        for line in lines {
            lineNumber++;
            lineRect.origin.y += lineRect.size.height;
            lineRect.size.height = line.size.height;
            
            if !frame.intersects(lineRect) {
                if firstLineDrawn != NSNotFound {
                    break;
                }
                
                continue;
            }
            else if firstLineDrawn == NSNotFound {
                firstLineDrawn = lineNumber;
                CGContextTranslateCTM(context, drawContext.leftSideBarWidth, lineRect.origin.y);
            }
            
            line.draw(drawContext);
            CGContextTranslateCTM(context, 0, lineRect.size.height);
            lineDrawn++;
        }
    }
    
    private func drawLeftSideBar() {
        var rect = self.bounds;
        
        rect.size.width = drawContext.leftSideBarWidth - drawContext.lineHeightD3;
        
        let context = drawContext.contextRef!;
        
        CGContextSetFillColorWithColor(context, theme.leftSidebarBackgroundColor);
        CGContextFillRect(context, rect);
        
        var points = [CGPoint]();
        
        points.reserveCapacity(2);
        points.append(CGPoint(x: rect.size.width, y: 0));
        points.append(CGPoint(x: rect.size.width, y: rect.size.height));
        
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, theme.leftSidebarBorderColor);
        CGContextStrokeLineSegments(context, points, 2);
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1));
        
        var lineNumber: Int = 0;

        for line in lines {
            ++lineNumber;
            line.drawLeftBar(drawContext, lineNumber: lineNumber);
            CGContextTranslateCTM(context, 0, line.size.height);
        }
    }
        
    @objc
    public override func drawRect(dirtyRect: NSRect) {
        let contextRef = NSGraphicsContext.currentContext()!.CGContext;
        
        CGContextClipToRect(contextRef, dirtyRect);
        
        if theme.backgroundDraw {
            CGContextSetFillColorWithColor(contextRef, theme.backgroundColor);
            CGContextFillRect(contextRef, self.bounds);
        }
        
        drawContext.contextRef = contextRef;
        
        dispatch_sync(document.queue) {
            CGContextSaveGState(contextRef);
            self.drawLines();
            CGContextRestoreGState(contextRef);
            CGContextSaveGState(contextRef);
            self.drawLeftSideBar();
            CGContextRestoreGState(contextRef);
        }

        drawContext.contextRef = nil;
    }
}
