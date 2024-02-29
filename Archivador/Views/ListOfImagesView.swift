//
//  ListOfImagesView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 24/2/24.
//

import SwiftUI

struct ListOfImagesView: View {
    
    @Environment(\.dismiss) var dimiss
    @Binding var image : String
    @State  var list : [String] = Utils().FilesListToArray()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(list, id: \.self){img in
                        Image(path: img)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .onTapGesture {
                                self.image = img
                                dimiss()
                            }
                    }
                }
                .padding([.horizontal, .top])
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .navigationTitle("Listado de imágines")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
}

#Preview {
    ListOfImagesView(image: .constant("beer"))
}
