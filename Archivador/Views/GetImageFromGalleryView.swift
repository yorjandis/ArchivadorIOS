//
//  GetImageFromGalleryView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 9/3/24.
//

import SwiftUI
import PhotosUI

//Toma una image de la galeria y la devuelve
struct GetImageFromGalleryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var image : UIImage?  //Aqui se devuelve la imagen tomada
    @State private var imageSlected : UIImage = UIImage(systemName: "photo")!
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Text("Tap en la imagen para volver").foregroundStyle(.orange).font(.footnote)
            Image(uiImage: (self.imageSlected))
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 20)
                .shadow(color: .white,  radius: 3)
                .onTapGesture {
                    dismiss()
                }
            PhotosPicker("Abrir Galería...", selection: $selectedItem, matching: .images)
                .frame(width: 150 , height: 40)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            let img = UIImage(data: data)!
                            self.imageSlected = img
                            image = img
                        }else{
                            print("Failed to load the image. Sale y no devuelve nada")
                        }
                    }
                }
        }
        .preferredColorScheme(.dark)
        .foregroundStyle(.black)
        .padding()
    }
}

#Preview {
    GetImageFromGalleryView(image: .constant(UIImage(systemName: "heart")!))
}
