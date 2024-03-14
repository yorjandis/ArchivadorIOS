//
//  GetImageFromCameraView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 9/3/24.
//

import SwiftUI
import PhotosUI

struct GetImageFromCameraView: View {
    @Binding var image : UIImage? //Aqui se devuelve la imagen tomada
    @State private var showCamera = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            Button("Abrir la Cámara...") {
                self.showCamera.toggle()
            }
            .frame(width: 150 , height: 40)
            .background(.orange)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            
            .fullScreenCover(isPresented: self.$showCamera) {
                accessCameraView(selectedImage: self.$selectedImage)
            }
        }
        .preferredColorScheme(.dark)
        .foregroundStyle(.black)
        .onChange(of: selectedImage) {
            if let img = self.selectedImage {
                image = img
            }
        }
        
    }
}

#Preview {
    GetImageFromCameraView(image: .constant(UIImage(systemName: "heart")!))
}
