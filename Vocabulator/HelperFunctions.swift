//
//  HelperFunctions.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation

func todo(_ msg: String..., _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if DEBUG
    let url = URL(fileURLWithPath: file)
    print("--- TODO: \"\(msg.joined(separator: " "))\", --- [ \(url.lastPathComponent):\(line) - \(function) ]")
    #endif
}
