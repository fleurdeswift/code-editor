//
//  CGColorRef+Hashable.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import CoreGraphics

extension CGColorRef : Hashable, Equatable {
    public var hashValue: Int {
        get {
            return Int(CFHash(self));
        }
    }
}

public func == (left: CGColorRef, right: CGColorRef) -> Bool {
    return CGColorEqualToColor(left, right);
}

