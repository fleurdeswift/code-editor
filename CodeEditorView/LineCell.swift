//
//  LineCell.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import CodeEditorCore;
import Foundation;

public struct LayoutChanges : OptionSetType {
    public let rawValue: Int;
    
    public init(rawValue: Int) {
        self.rawValue = rawValue;
    }

    public init() {
        self.rawValue = 0;
    }
    
    public static let None          = LayoutChanges();
    public static let Frame         = LayoutChanges(rawValue: 1);
    public static let Configuration = LayoutChanges(rawValue: 2);
    public static let Theme         = LayoutChanges(rawValue: 4);
    public static let Document      = LayoutChanges(rawValue: Int.max);
}

public final class LineCell : CustomStringConvertible, CustomDebugStringConvertible {
    internal(set) public var line: Line;
    internal(set) public var text: NSMutableAttributedString?;
    internal(set) public var size = CGSize();
    
    internal(set) public var textFramesetter: CTFramesetterRef?;
    internal(set) public var textFrammed:     CTFrameRef?;

    public init(line: Line) {
        self.line = line;
    }
    
    public var description: String {
        get {
            return line.description;
        }
    }
    
    public var debugDescription: String {
        get {
            return line.debugDescription;
        }
    }
    
    public func invalidate() {
        textFramesetter = nil;
        textFrammed     = nil;
    }
    
    public func layout(drawContext: DrawContext, changes ochanges: LayoutChanges) -> CGSize {
        var changes = ochanges;
    
        if self.textFrammed != nil {
            if changes == LayoutChanges.None {
                return self.size;
            }
        }
        else {
            changes = LayoutChanges.Document;
        }
        
        var attr: NSMutableAttributedString;
        var length: Int;
        
        if changes.contains(LayoutChanges.Configuration) || changes.contains(LayoutChanges.Theme) {
            textFramesetter = nil;
            textFrammed     = nil;
            
            attr       = line.text.mutableCopy() as! NSMutableAttributedString;
            self.text  = attr;
            var i      = 0;

            length = attr.length;

            if (drawContext.configuration.wrap) {
                i = attr.headSpaces(drawContext.configuration.tabWidth);
            }

            if (i > 0) {
                let paraStyleRef = drawContext.paragraphStyleForIndent(CGFloat(i) * drawContext.spaceCharacterWidth);
                
                attr.addAttribute(kCTParagraphStyleAttributeName as String,
                             value:paraStyleRef,
                             range:NSMakeRange(0, length));
            }
            else {
                attr.addAttribute(kCTParagraphStyleAttributeName as String,
                             value:drawContext.defaultParagraphStyle,
                             range:NSMakeRange(0, length));
            }

            textFramesetter = CTFramesetterCreateWithAttributedString(attr);
        }
        else {
            attr        = self.text!;
            length      = attr.length;
            textFrammed = nil;
        }
        
        textFrammed = CTFramesetterCreateFrame(textFramesetter!, CFRange(location: 0, length: length), drawContext.textLayoutPath, nil);
        
        var size = CGSize();
        let lines     = CTFrameGetLines(textFrammed!) as NSArray;
        let lineCount = CFArrayGetCount(lines);

        if lineCount > 0 {
            for (var lineIndex = 0; lineIndex < lineCount; lineIndex++) {
                let lineRef  = lines[lineIndex] as! CTLineRef;
                let lineRect = CTLineGetBoundsWithOptions(lineRef, CTLineBoundsOptions());
                
                size.width   = max(size.width, lineRect.size.width);
                size.height += lineRect.size.height;
            }
        }
        else {
            size.height = drawContext.lineHeight;
        }
        
        self.size = size;
        return size;
    }
    
    public func draw(drawContext: DrawContext) -> Void {
        let context = drawContext.contextRef!;
    
        CGContextSaveGState(context);
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -DrawContext.Y_LIMIT);
        CTFrameDraw(textFrammed!, context);
        CGContextRestoreGState(context);
    }
    
    public func drawLeftBar(drawContext: DrawContext, lineNumber: Int) -> Void {
        let rect = CGRect(x: 0, y: 0, width: drawContext.leftSideBarWidth, height: size.height);
        
        drawContext.draw(rect, lineNumber: UInt(lineNumber), enabled:false);
    }
}
