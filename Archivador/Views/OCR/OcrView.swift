//
//  OcrView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 9/3/24.
//Permite hacer OCR sobre una imagen

import SwiftUI


struct OcrView: View {
    @Environment(\.dismiss) var dimiss
    @State var imageSelected : UIImage? = nil
    @State private var texto : String = ""
    
    
    var body: some View {
        
        NavigationStack{
            VStack{
                //Obtener una imagen
                HStack(spacing: 30){
                    
                    NavigationLink("Galería..."){
                        GetImageFromGalleryView(image: $imageSelected)
                    }.buttonStyle(BorderedProminentButtonStyle()).foregroundColor(.black)
                    
                    NavigationLink("Cámara..."){
                        GetImageFromCameraView(image: $imageSelected )
                    }.buttonStyle(BorderedProminentButtonStyle()).foregroundColor(.black)
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
            .task {
                if let img = self.imageSelected {
                    self.texto = ImageToStringModel().ocr(image: img)
                }
            }
        }
    }
}





#Preview {
    OcrView()
}
