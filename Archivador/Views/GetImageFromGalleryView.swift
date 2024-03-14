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
    @Binding var image : UIImage? //Aqui se devuelve la imagen tomada
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            PhotosPicker("Abrir Galería...", selection: $selectedItem, matching: .images)
                .frame(width: 150 , height: 40)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)!
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
