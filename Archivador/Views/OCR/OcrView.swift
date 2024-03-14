//
//  OcrView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 9/3/24.
//

import SwiftUI


struct OcrView: View {
    @Environment(\.dismiss) var dimiss
    @State private var imageSelected : UIImage? = nil
    @State private var texto : String = ""
    
    
    var body: some View {
        
        NavigationStack{
            VStack{
                //Obtener una imagen
                HStack(spacing: 30){
                        GetImageFromGalleryView(image: $imageSelected)
    
                        GetImageFromCameraView(image: $imageSelected ) 
                }
                
                //Visualizar el texto leido
                VStack{
                    HTMLView(txt: texto)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onChange(of: self.imageSelected) {
                    texto = ImageToStringModel().ocr(image: imageSelected)
                }
                
                //Opciones...
                HStack{
                    Button("Volver"){
                        dimiss()
                    }
                    
                }
                .buttonStyle(.bordered)
                
                
                Spacer()
                
            }
            .preferredColorScheme(.dark)
            .foregroundColor(.white)
            .navigationTitle("OCR")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}





#Preview {
    OcrView()
}
