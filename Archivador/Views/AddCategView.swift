//
//  AddCategView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//

import SwiftUI
import CoreData

struct AddCategView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var listado : [Categorias]  //Listado que será actualizado una vez se adicione la categoria
    @State var textFieldCateg = ""
    @State var textFieldNota = ""
    @State var fav = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Form{
                    Section("Nueva Categoria"){
                        VStack(alignment: .leading){
                            TextField("Nueva Categoria", text: $textFieldCateg, axis: .vertical)
                            
                            Text("\(textFieldCateg.isEmpty ? "⚠️" : "✅") Nombre de la categoria")
                                .font(.footnote)
                                .padding(.top, 5)
                                .foregroundColor(textFieldCateg.isEmpty ? .red : .primary)
                        }
                        
                    }
                    
                    Section("Favorito"){
                        VStack(alignment: .leading){
                            Toggle("Favorito", isOn: $fav)
                            Text("Marque la nueva categoria como favorito")
                                .font(.footnote)
                                .padding(.top, 5)
                        }
                        
                    }
                    Section("Añada una nota"){
                        VStack(alignment : .leading){
                            TextField("Nota", text: $textFieldNota, axis: .vertical)
                            Text("Opcionalmente puede añadir una nota")
                                .font(.footnote)
                                .padding(.top, 5)
                        }
                        
                    }
                    
                }
                .navigationTitle("Nueva Categoría")
                .navigationBarTitleDisplayMode(.inline)
                
                VStack() {
                    Button("Guardar"){
                        if textFieldCateg.isEmpty {return}
                        
                        if  CRUDModel().addCategoria(categoria: self.textFieldCateg, isfav: self.fav, nota: self.textFieldNota) != nil {
                            //Actualiza el listado y sale
                            listado = CRUDModel().getListOfCateg()
                        }
                        
                        dismiss()
                        
                    }
                    .buttonStyle(.bordered)
                    //.buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 50)
            }
            .background(.black)
            .foregroundColor(.white)
            
            
        }
    }
}

#Preview {
    AddCategView(listado: .constant([Categorias]()))
    
}
