//
//  GetImageFromCameraView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 9/3/24.
//

import SwiftUI
import PhotosUI

struct GetImageFromCameraView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var image : UIImage? //Aqui se devuelve la imagen tomada
    @State private var showCamera = false
    @State private var selectedImage: UIImage? = UIImage(systemName: "photo")!

    var body: some View {
        VStack {
            Text("Tap en la imagen para volver").foregroundStyle(.orange).font(.footnote)
            Image(uiImage: (self.selectedImage)!)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 20)
                .shadow(color: .white,  radius: 3)
                .onTapGesture {
                    dismiss()
                }
            
            
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
