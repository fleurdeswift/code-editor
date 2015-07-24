//
//  NSAttributedString+Heading.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

internal extension NSAttributedString {
    internal var firstNonWhitespaceCharacter: Int {
        get {
            let count  = self.length;
            
            if count == 0 {
                return 0;
            }
            
            let string = CFAttributedStringGetString(self);
            var buffer = CFStringInlineBuffer();
            
            CFStringInitInlineBuffer(string, &buffer, CFRange(location: 0, length: 0));
            
            for (var index = 0; index < count; index++) {
                let ch = CFStringGetCharacterFromInlineBuffer(&buffer, index);
                
                switch (ch) {
                case UniChar(9):  // tab
                    break;
                case UniChar(20): // space
                    break;
                default:
                    return index;
                }
            }
            
            return count;
        }
    }

    internal func headSpaces(tabStop: Int) -> Int {
        let count  = self.length;
        
        if count == 0 {
            return 0;
        }
        
        let string = CFAttributedStringGetString(self);
        var buffer = CFStringInlineBuffer();
        var space  = 0;
        
        CFStringInitInlineBuffer(string, &buffer, CFRange(location: 0, length: 0));
        
        for (var index = 0; index < count; index++) {
            let ch = CFStringGetCharacterFromInlineBuffer(&buffer, index);
            
            switch (ch) {
            case UniChar(9):  // tab
                space += (tabStop - (space % tabStop));
                break;
            case UniChar(20): // space
                space++;
                break;
            default:
                return space;
            }
        }
        
        return space;
    }
}
