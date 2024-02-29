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
    @Binding var updateHome : Int8
    @State var textFieldCateg = ""
    @State var textFieldNota = ""
    @State var icono : String = "apple"
    @State var fav = false
    @State var showSheetIconList = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Form{
                    Section("Nueva Categoria"){
                        HStack{
                            VStack(alignment: .leading){
                                TextField("Nueva Categoria", text: $textFieldCateg, axis: .vertical)
                                
                                Text("\(textFieldCateg.isEmpty ? "⚠️" : "✅") Nombre de la categoria")
                                    .font(.footnote)
                                    .padding(.top, 5)
                                    .foregroundColor(textFieldCateg.isEmpty ? .red : .primary)
                            }
                            Spacer()
                            VStack{
                                Button{
                                    showSheetIconList = true
                                }label: {
                                    VStack{
                                        Image(path: self.icono).imageIcono()
                                        Text("Icono")
                                    }
                                    
                                }
                            }
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
                        
                        
                        if let categ =  CRUDModel().addCategoria(categoria: self.textFieldCateg, isfav: self.fav, nota: self.textFieldNota, icono: self.icono){
                            //Actualizar home() sale
                            self.updateHome += 1
                        }
                        
                        dismiss()
                        
                    }
                    .buttonStyle(.bordered)
                    //.buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 50)
            }
            .sheet(isPresented: $showSheetIconList){
                ListOfImagesView(image: $icono)
            }
            
            
        }
    }
}

#Preview {
    AddCategView(updateHome: .constant(1))
}
