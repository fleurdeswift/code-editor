//
//  Theme.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public class Theme : Hashable, Equatable {
    public enum Base {
        case Dark
    }
    
    public let base: Base;
    public let customized: Bool = false;
    
    internal(set) public var backgroundDraw: Bool;
    internal(set) public var backgroundColor: CGColorRef;
    
    internal(set) public var leftSidebarBackgroundColor: CGColorRef;
    internal(set) public var leftSidebarBorderColor: CGColorRef;
    
    internal(set) public var lineNumberColor: CGColorRef;
    internal(set) public var lineNumberSelectedColor: CGColorRef;
    internal(set) public var lineNumberFontName: String;
    
    internal(set) public var textFontName: String;
    internal(set) public var textFontSize: CGFloat;
    internal(set) public var textFontColor: CGColorRef;

    internal(set) public var breakpointEnabledFillColor: CGColorRef;
    internal(set) public var breakpointDisabledFillColor: CGColorRef;
    internal(set) public var breakpointDisabledStrokeColor: CGColorRef;

    internal(set) public var instructionPointerFillColor: CGColorRef;
    internal(set) public var instructionPointerStrokeColor: CGColorRef;
    
    public init(_ base: Base) {
        self.base = base;
    
        switch (base) {
        case .Dark:
            backgroundDraw  = true;
            backgroundColor = CGColorCreateGenericRGB(30.0 / 255.0, 32.0 / 255.0, 40.0 / 255.0, 1.0);
            
            leftSidebarBackgroundColor = CGColorCreateGenericRGB(48.0 / 255.0, 49.0 / 255.0, 57.0 / 255.0, 1.0);
            leftSidebarBorderColor     = CGColorCreateGenericRGB(64.0 / 255.0, 66.0 / 255.0, 73.0 / 255.0, 1.0);
            
            lineNumberColor         = CGColorCreateGenericGray(0.5, 1.0);
            lineNumberSelectedColor = CGColorCreateGenericGray(1.0, 1.0);
            lineNumberFontName      = "Arial Narrow";
            
            textFontName  = "Menlo";
            textFontSize  = 11.0;
            textFontColor = CGColorCreateGenericGray(1, 1);
            
            breakpointEnabledFillColor    = CGColorCreateGenericRGB( 63.0 / 255.0, 112.0 / 255.0, 181.0 / 255.0, 1.0);
            breakpointDisabledFillColor   = CGColorCreateGenericRGB(161.0 / 255.0, 186.0 / 255.0, 328.0 / 255.0, 1.0);
            breakpointDisabledStrokeColor = CGColorCreateGenericRGB(181.0 / 255.0, 201.0 / 255.0, 224.0 / 255.0, 1.0);

            instructionPointerFillColor   = CGColorCreateGenericRGB(183.0 / 255.0, 216.0 / 255.0, 169.0 / 255.0, 1.0);
            instructionPointerStrokeColor = CGColorCreateGenericRGB(140.0 / 255.0, 161.0 / 255.0, 126.0 / 255.0, 1.0);
        }
    }
        
    public var hashValue: Int {
        get {
            return backgroundDraw.hashValue ^
                   backgroundColor.hashValue ^
                   leftSidebarBackgroundColor.hashValue ^
                   leftSidebarBorderColor.hashValue ^
                   lineNumberColor.hashValue ^
                   lineNumberSelectedColor.hashValue ^
                   lineNumberFontName.hashValue ^
                   textFontName.hashValue ^
                   textFontSize.hashValue ^
                   breakpointEnabledFillColor.hashValue ^
                   breakpointDisabledFillColor.hashValue ^
                   breakpointDisabledStrokeColor.hashValue ^
                   instructionPointerFillColor.hashValue ^
                   instructionPointerStrokeColor.hashValue;
        }
    }
}

public func == (left: Theme, right: Theme) -> Bool {
    return left.backgroundDraw                 == right.backgroundDraw &&
           left.backgroundColor                == right.backgroundColor &&
           left.leftSidebarBackgroundColor     == right.leftSidebarBackgroundColor &&
           left.leftSidebarBorderColor         == right.leftSidebarBorderColor &&
           left.lineNumberColor                == right.lineNumberColor &&
           left.lineNumberSelectedColor        == right.lineNumberSelectedColor &&
           left.lineNumberFontName             == right.lineNumberFontName &&
           left.textFontName                   == right.textFontName &&
           left.textFontSize                   == right.textFontSize &&
           left.breakpointEnabledFillColor     == right.breakpointEnabledFillColor &&
           left.breakpointDisabledFillColor    == right.breakpointDisabledFillColor &&
           left.breakpointDisabledStrokeColor  == right.breakpointDisabledStrokeColor &&
           left.instructionPointerFillColor    == right.instructionPointerFillColor &&
           left.instructionPointerStrokeColor  == right.instructionPointerStrokeColor;
}

