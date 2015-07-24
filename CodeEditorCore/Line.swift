//
//  Line.swift
//  CodeEditorCore
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public class Line : CustomStringConvertible, CustomDebugStringConvertible {
    public var text: NSMutableAttributedString;
    
    public init(mutableAttributedString: NSMutableAttributedString) {
        self.text = mutableAttributedString;
    }

    public init(attributedString: NSAttributedString) {
        self.text = NSMutableAttributedString(attributedString: attributedString);
    }
    
    public func split(index: Int) -> Line {
        assert(index <= text.length);
    
        if (index == 0) {
            let newLine = Line(mutableAttributedString: text);
        
            self.text = NSMutableAttributedString();
            return newLine;
        }
    
        let endRange = NSRange(location: index, length: (text.length - index));
        let endPart  = Line(attributedString: text.attributedSubstringFromRange(endRange));
        
        text.deleteCharactersInRange(endRange)
        return endPart;
    }
    
    public func charAt(index: Int) -> Character {
        return Character(UnicodeScalar(self.text.mutableString.characterAtIndex(index)));
    }
    
    public var description: String {
        get {
            return self.text.string;
        }
    }
    
    public var debugDescription: String {
        get {
            return self.text.string;
        }
    }
    
    public var length: Int {
        get {
            return self.text.length;
        }
    }
}
