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
    @State var grupo : Grupos = .otros
    @State  private var list : [String] = Utils().FilesListToArray()
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView(.horizontal) {
                    HStack{
                        Button("Otros"){ self.list = getListado(grupo: .otros)}
                        Button("Carpetas"){self.list = getListado(grupo: .carpeta)}
                        Button("Documentos"){self.list = getListado(grupo: .documento)}
                        Button("Símbolos"){self.list = getListado(grupo: .simbolos)}
                        Button("Web"){self.list = getListado(grupo: .web)}
                        Button("Targetas"){self.list = getListado(grupo: .targetas)}
                        Button("Social"){self.list = getListado(grupo: .social)}
                        Button("Targetas"){self.list = getListado(grupo: .targetas)}
                        Button("Personas"){self.list = getListado(grupo: .personas)}
                        Button("Empresas"){self.list = getListado(grupo: .empresa)}
                        Button("Animales"){self.list = getListado(grupo: .animales)}
                        Button("Compras"){self.list = getListado(grupo: .compra)}
                        Button("Graficos"){self.list = getListado(grupo: .grafico)}
                        Button("Hogar"){self.list = getListado(grupo: .hogar)}
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    .foregroundColor(.orange)
                }
                .scrollIndicators(.hidden)
                
                
                
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
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(.black)
            .navigationTitle("Listado de imágines")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                self.list = getListado(grupo: self.grupo)
            }
        }
    }
    
    
    //Obtiene el listado de imagines
    func getListado(grupo : Grupos)->[String]{
        var result : [String] = []
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasSuffix("png") {
                    if item.hasPrefix(grupo.rawValue){
                        result.append(item)
                    }
                }
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
        return result
    }
    
    
    //Grupos de imagines
    enum Grupos : String {
        case animales = "a_", carpeta = "b_", compra = "c_", documento = "d_", empresa = "e_"
        case grafico = "f_", hogar = "g_", mensajes = "h_", personas = "i_", simbolos = "k_"
        case social = "l_", targetas = "m_", web = "w_", otros = "o_"
    }
    
    
}

#Preview {
    ListOfImagesView(image: .constant("beer"))
}
