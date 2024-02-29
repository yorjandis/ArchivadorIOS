//
//  AddEntradaView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//

import SwiftUI
import CoreData

struct AddEntradaView: View {
    
    @Environment(\.dismiss) var dimiss
    @Binding var listCateg : [Categorias]
    @Binding var updateHome : Int8 //Permite actualizar la home()
    @State var selectedCateg : Categorias? //Si viene de Home() tendrá una categoria
    @State var textFieldTitulo = ""
    @State var textFieldEntrada = ""
    @State var icono : String = "apple"
    @State var fav = false
    @State var colorText : Color = .primary
    @State var showSheetAddCateg = false
    
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Form{
                    Section("Categoría de la Entrada"){
                        HStack{
                                HStack{
                                    //Construir un menu para escoger las categorias
                                    if !listCateg.isEmpty {
                                        Menu{
                                            ForEach(listCateg){ categ in
                                                Button{
                                                    self.selectedCateg = categ
                                                }label: {
                                                    Label {
                                                        Text(AESModel().aesGCMDec(strEnc: categ.categoria ?? ""))
                                                    } icon: {
                                                        Image(path: categ.icono ?? "tags").imageIcono()
                                                    }
                                                    
                                                }
                                            }
                                        }label: {
                                            if self.selectedCateg != nil {
                                                Label {
                                                    Text( AESModel().aesGCMDec(strEnc: self.selectedCateg?.categoria ?? ""))
                                                } icon: {
                                                    Image(path: self.selectedCateg?.icono ?? "tags").imageIcono()
                                                }
                                                
                                            }else{
                                                Text("Seleccione Categoría...")
                                            }
                                            
                                        }
                                    }
                                    else{ //Si la lista de categoria está vacia: hay que crear nueva Categoría
                                        
                                        NavigationLink{
                                            AddCategView(updateHome: $updateHome)
                                        }label: {
                                            Label("Crear Nueva Categoría", systemImage: "folder.badge.plus")
                                        }
                                        
                                    }
                                   
                                }
                                
                                Spacer()
                                if !self.listCateg.isEmpty {
                                    Menu{
                                        Button{
                                            showSheetAddCateg = true
                                        }label: {
                                            Label {
                                                Text("Nueva Categoría")
                                            } icon: {
                                                Image(systemName: "plus")
                                            }
                                            
                                            
                                        }
                                    }label: {
                                        Image(systemName: "ellipsis")
                                            .frame(width: 50, height: 45)
                                    }
                                    .padding(.top, 10)
                                }
    
                        }
                        .task {
                            self.listCateg = CRUDModel().getListOfCateg()
                        }
                    }
                    
                    Section("Título de la Entrada"){
                        VStack(alignment: .leading){
                            TextField("Nuevo título", text: $textFieldTitulo, axis: .vertical)
                                .onChange(of: textFieldTitulo) {
                                    if !textFieldTitulo.isEmpty {colorText = .primary}
                                }
                            
                            Text("\(textFieldTitulo.isEmpty ? "⚠️" : "✅") Título que tendrá la categoría")
                                .font(.footnote)
                                .padding(.top, 5)
                                .foregroundColor(textFieldTitulo.isEmpty ? .red : .primary)
                        }
                        
                    }
                    
                    Section("Icono"){
                        HStack(spacing: 25){
                            Image(path: self.icono).imageIcono()
                            
                            NavigationLink("Seleccionar icono"){
                                ListOfImagesView(image: $icono)
                            }
                        }
                        
                        
                    }
                    
                    Section("Texto de la entrada"){
                        VStack(alignment: .leading){
                            TextField("Contenido de la entrada", text: $textFieldEntrada, axis: .vertical)
                                .onChange(of: textFieldEntrada) {
                                    if !textFieldEntrada.isEmpty {colorText = .primary}
                                }
                            
                            Text("\(textFieldEntrada.isEmpty ? "⚠️" : "✅") Contenido útil de la entrada")
                                .font(.footnote)
                                .padding(.top, 5)
                                .foregroundColor(textFieldEntrada.isEmpty ? .red : .primary)
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
                    
                    
                }
                .navigationTitle("Crear nueva Entrada")
                .navigationBarTitleDisplayMode(.inline)
                
                VStack() {
                    Button("Guardar"){
                        if let categ = self.selectedCateg {
                            if textFieldTitulo.isEmpty {return}
                            if textFieldEntrada.isEmpty {return}
                            
                            if CRUDModel().AddEntrada(title: textFieldTitulo, entrada: textFieldEntrada, categoria: categ, image: "", isfav: self.fav, icono: self.icono) != nil{
                                self.updateHome += 1 //Actualizando home()
                                dimiss()
                            }else{
                                print("Error al guardar la entrada")
                            }
                            
                        }
                        
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom, 50)
            }
            .sheet(isPresented: $showSheetAddCateg, content: {
                AddCategView(updateHome: $updateHome)
            })
            
        }
    }
    
}







#Preview {
    AddEntradaView(listCateg: .constant([Categorias]()), updateHome: .constant(1))
}
