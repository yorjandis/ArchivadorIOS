//
//  testView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 28/2/24.
//

import SwiftUI
import WebKit

struct testView: View {
    
    @State var texto = ""
    @State var imagen : UIImage? = nil
    
    var body: some View {
       
        NavigationStack {
            VStack{
                
                GetImageFromCameraView(image: $imagen)
                
                GetImageFromGalleryView(image: $imagen)
                
                if let img = self.imagen {
                    Text(QRModel().readQR(image: img).joined())
                }

               
            }
            .navigationTitle("Pruebas")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 15)
        }
        
        
    }
}



#Preview {
    testView()
}
