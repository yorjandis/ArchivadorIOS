//
//  QRReadView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 12/3/24.
//

import SwiftUI

struct QRReadView: View {
    @State private var text : String = ""
    @State private var imagen : UIImage? = nil

    var body: some View {
        NavigationStack {
            VStack{
                
                HStack{
                    GetImageFromGalleryView(image: $imagen)
                    GetImageFromCameraView(image: $imagen)
                }
                
                HTMLView(txt: self.imagen != nil ? QRModel().readQR(image: self.imagen!).joined() : "")
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                Button("Copiar todo"){
                    UIPasteboard.general.string = self.text
                }.buttonStyle(BorderedButtonStyle())
                Spacer()
                
            }
            .navigationTitle("Leer QR")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            
        }
    }
}

#Preview {
    QRReadView()
}
