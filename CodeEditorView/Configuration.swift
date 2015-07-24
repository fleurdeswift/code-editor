//
//  Configuration.swift
//  CodeEditorView
//
//  Copyright © 2015 Fleur de Swift. All rights reserved.
//

import Foundation

public class Configuration : Hashable, Equatable {
    internal(set) public var showLineNumbers: Bool = true;
    internal(set) public var wrap: Bool = true;
    internal(set) public var tabWidth: Int = 4;
    internal(set) public var wrapExtraWidth: Int = 4;
    
    public init() {
    }
    
    public var hashValue: Int {
        get {
            return showLineNumbers.hashValue ^
                   wrap.hashValue ^
                   tabWidth.hashValue ^
                   wrapExtraWidth.hashValue;
        }
    }
}

public func == (left: Configuration, right: Configuration) -> Bool {
    return left.showLineNumbers == right.showLineNumbers &&
           left.wrap            == right.wrap &&
           left.tabWidth        == right.tabWidth &&
           left.wrapExtraWidth  == right.wrapExtraWidth;
}
