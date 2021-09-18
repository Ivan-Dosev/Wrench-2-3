//
//  PdfKit.swift
//  QR
//
//  Created by Ivan Dimitrov on 12.09.21.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    var url: URL
    @Environment(\.presentationMode) var pMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                PDFKitRepresentedView(url, geo: geometry)
                Button(action: {
                    pMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .frame(width: UIScreen.main.bounds.width / 1.2  , height: 100)
                        .modifier(PrimaryButton())
                }
                
            }
//            .edgesIgnoringSafeArea(.all)
        }


           
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    var geometry : GeometryProxy
    init(_ url: URL, geo: GeometryProxy) {
        self.url = url
        self.geometry = geo
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)

        let page =  pdfView.document!.page(at: 0)
        let pageBounds = page!.bounds(for: pdfView.displayBox)
        
        pdfView.scaleFactor =    geometry.size.width /  pageBounds.width
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}


struct PrimaryButton: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)

                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -8.0, y: -8.0) })

            .foregroundColor(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255), radius: 5, x: 5.0  , y:  5.0)
            .shadow(color: Color.white, radius: 50, x: -50.0 , y: -50.0)

    }
}
