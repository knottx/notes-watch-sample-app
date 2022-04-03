//
//  Note.swift
//  Notes WatchKit Extension
//
//  Created by Visarut Tippun on 3/4/22.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
    
    init(text: String) {
        self.id = .init()
        self.text = text
    }
}
