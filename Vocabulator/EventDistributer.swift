//
//  EventDistributer.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation

protocol Event {}

class EventDistributer {
    static let shared = EventDistributer()
}
