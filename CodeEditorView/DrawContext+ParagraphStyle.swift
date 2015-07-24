//
//  DrawContext+ParagraphStyle.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import CoreText

public extension DrawContext {
    public var defaultParagraphStyle: CTParagraphStyleRef {
        get {
            return _defaultParagraphStyle!;
        }
    }

    public var defaultTextStyle: NSDictionary {
        get {
            return NSDictionary(dictionary: [
                NSFontAttributeName: self.textFont,
                NSParagraphStyleAttributeName: self.defaultParagraphStyle,
                NSForegroundColorAttributeName: self.theme.textFontColor
            ]);
        }
    }

    public func paragraphStyleForIndent(indent: CGFloat) -> CTParagraphStyleRef {
        var tabWidth  = CGFloat(configuration.tabWidth) * spaceCharacterWidth;
        var newIndent = indent + (CGFloat(configuration.wrapExtraWidth) * CGFloat(spaceCharacterWidth));
        let settings: [CTParagraphStyleSetting] = [
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.TabStops,           valueSize: sizeof(NSArray), value: &_tabStops),
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.DefaultTabInterval, valueSize: sizeof(CGFloat), value: &tabWidth),
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.HeadIndent,         valueSize: sizeof(CGFloat), value: &newIndent)
        ];
    
        return CTParagraphStyleCreate(settings, 3);
    }
    
    internal func calculateParagraphStyles() {
        var tabWidth = CGFloat(self.spaceCharacterWidth) * CGFloat(configuration.tabWidth);
        
        _tabStops = NSArray(object: CTTextTabCreate(CTTextAlignment.Left, Double(tabWidth), nil));
        
        do {
            let settings: [CTParagraphStyleSetting] = [
                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.TabStops,           valueSize: sizeof(NSArray), value: &_tabStops),
                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.DefaultTabInterval, valueSize: sizeof(CGFloat), value: &tabWidth)
            ];
        
            _defaultParagraphStyle = CTParagraphStyleCreate(settings, 2);
        }
    }
}
