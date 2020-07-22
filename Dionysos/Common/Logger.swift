//
//  Log.swift
//  Dionysos
//
//  Created by Jercy on 2020/05/20.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

func logger<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    let value: T = object()
    let fileURL: String = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
    let queue: String = Thread.isMainThread ? "UI" : "BG"

    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"

    print("❤️<\(formatter.string(from: Date()))> <\(queue)> \(fileURL) \(function)[\(line)]: " + String(reflecting: value))
    #endif
}
