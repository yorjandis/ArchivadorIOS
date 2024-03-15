//
//  VisorImagenView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 15/3/24.
//

import SwiftUI

//MARK: Para mostrar la imagen adjunta
struct VisorImagenView : View {
    @State var image : UIImage
    
    @State var currentScale: CGFloat = 1.0
    @State var previousScale: CGFloat = 1.0
    
    @State var currentOffset = CGSize.zero
    @State var previousOffset = CGSize.zero
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in // here you'll have size and frame
                Image(uiImage: self.image)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: self.currentOffset.width, y: self.currentOffset.height)
                    .scaleEffect(max(self.currentScale, 1.0)) // the second question
                    .gesture(DragGesture()
                        .onChanged { value in
                            let deltaX = value.translation.width - self.previousOffset.width
                            let deltaY = value.translation.height - self.previousOffset.height
                            self.previousOffset.width = value.translation.width
                            self.previousOffset.height = value.translation.height
                            
                            let newOffsetWidth = self.currentOffset.width + deltaX / self.currentScale
                            // question 1: how to add horizontal constraint (but you need to think about scale)
                            if newOffsetWidth <= geometry.size.width - 150.0 && newOffsetWidth > -150.0 {
                                self.currentOffset.width = self.currentOffset.width + deltaX / self.currentScale
                            }
                            
                            self.currentOffset.height = self.currentOffset.height + deltaY / self.currentScale }
                             
                        .onEnded { value in self.previousOffset = CGSize.zero })
                
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            let delta = value / self.previousScale
                            self.previousScale = value
                            self.currentScale = self.currentScale * delta
                        }
                        .onEnded { value in self.previousScale = 1.0 })
                
            }
            .navigationTitle("Visor de Imagen")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar(){
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink{
                            OcrView(imageSelected: self.image)
                        }label: {
                            Label("Extraer texto", systemImage: "qrcode.viewfinder")
                        }
                    }
                }
        }
        
        
    }
}

#Preview {
    VisorImagenView(image: UIImage(systemName: "photo")!)
}
