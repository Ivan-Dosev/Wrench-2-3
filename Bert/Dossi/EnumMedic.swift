//
//  EnumMedic.swift
//  Bert
//
//  Created by Ivan Dimitrov on 13.09.21.
//

import SwiftUI


enum Medic : String, Identifiable {
    case scanningAction
    case pdfAction
    case firebase
    var id : String { rawValue }
}

struct ShadowedProgressViews: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(6)
//            ProgressView(value: 0.75)
        }
        .progressViewStyle(DarkBlueShadowProgressViewStyle())
    }
}

struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color(.green),radius: 5.0, x: 0, y: 5)
            .shadow(color: Color(.green),radius: 5.0, x: 0, y: 5)
            .shadow(color: Color(.green),radius: 5.0, x: 0, y: 5)
           
    }
}
