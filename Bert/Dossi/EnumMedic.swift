//
//  EnumMedic.swift
//  Bert
//
//  Created by Ivan Dimitrov on 13.09.21.
//

import Foundation


enum Medic : String, Identifiable {
    case scanningAction
    case pdfAction
    case firebase
    var id : String { rawValue }
}
