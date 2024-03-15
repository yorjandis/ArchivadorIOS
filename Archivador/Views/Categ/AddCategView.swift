//
//  AddCategView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//
//Permite adicionar y mnodificar una categoría

import SwiftUI
import CoreData

struct AddCategView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var updateHome : Int8
    @Binding var categoria : Categorias? //Para devolver la categoria recien creada al llamador
    @State var categoriaForModif : Categorias?
    @State private var textFieldCateg = ""
    @State private var textFieldNota = ""
    @State private var icono : String = "apple"
    @State private var fav = false
    @State private var showSheetIconList = false
    
   
    
    var body: some View {
        NavigationStack {
            VStack{
                Form{
                    Section("Categoría"){
                        HStack{
                            VStack(alignment: .leading){
                                TextField("Nombre de la Categoría", text: $textFieldCateg, axis: .vertical)
                                
                                Text("\(textFieldCateg.isEmpty ? "⚠️" : "✅") Nombre de la categoría")
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
                            Text("Marque la nueva categoría como favorito")
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
                .navigationTitle(self.categoriaForModif == nil ? "Nueva Categoría" : "Actualizar Categoría")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    if let categ = self.categoriaForModif {
                        self.textFieldCateg = AESModel().aesGCMDec(strEnc: categ.categoria ?? "")
                        self.textFieldNota = AESModel().aesGCMDec(strEnc: categ.nota ?? "")
                        self.fav = categ.isfav
                        self.icono = categ.icono ?? ""
                    }
                }
                
                VStack() {
                    Button(self.categoriaForModif == nil ? "Guardar" : "Actualizar"){
                        
                        if self.categoriaForModif == nil { //Guardar la nueva categoría
                            if let categ =  CRUDModel().addCategoria(categoria: self.textFieldCateg, isfav: self.fav, nota: self.textFieldNota, icono: self.icono){
                                //Actualizar home() sale
                                self.categoria = categ //Devolviendo la categoria
                                self.updateHome += 1
                                dismiss()
                            }
                        }else{ //Modificar Categoría
                            
                            if  CRUDModel().modifCategoria(categoria: self.categoriaForModif!, categoriaLabel: self.textFieldCateg, isfav: self.fav, nota: textFieldNota, icono: self.icono) {
                                //print("Se ha actualziado la categoría")
                                self.updateHome += 1
                                dismiss()
                            }else{
                                print("Error al actualizar la categoría")
                            }
                            
                        }
                        
                        
                        
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.primary)
                    .disabled(self.textFieldCateg.isEmpty ? true : false)
                }
                .padding(.bottom, 50)
            }
            .sheet(isPresented: $showSheetIconList){
                ListOfImagesView(image: $icono)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            
            
        }.preferredColorScheme(.dark)
    }
}




