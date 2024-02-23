//
//  AddEntradaView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//

import SwiftUI
import CoreData

struct AddEntradaView: View {

    @State var listCateg = CRUDModel().getListOfCateg()
    @State var selectedCateg : Categorias?
    @State var textFieldTitulo = ""
    @State var textFieldEntrada = ""
    @State var fav = false
    @State var colorText : Color = .primary
    @State var showSheetAddCateg = false
    @State var showSheetListCateg = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Form{
                    Section("Categoria de la Entrada"){
                        VStack(alignment: .leading){
                            Button{
                                showSheetListCateg = true
                            }label: {
                                Text("Categoria...  \(AESModel().aesGCMDec(strEnc: selectedCateg?.categoria ?? ""))")
                                    .foregroundColor(selectedCateg == nil ? .red : .primary)
                            }
                        }
                    }
                    
                    
                    
                    Section("Título de la Entrada"){
                        VStack(alignment: .leading){
                            TextField("Nuevo título", text: $textFieldTitulo, axis: .vertical)
                                .onChange(of: textFieldTitulo) {
                                    if !textFieldTitulo.isEmpty {colorText = .primary}
                                }
                            
                            Text("Título que tendrá la categoria")
                                .font(.footnote)
                                .padding(.top, 5)
                                .foregroundColor(textFieldTitulo.isEmpty ? .red : .primary)
                        }
                        
                    }
                    
                    Section("Texto de la entrada"){
                        VStack(alignment: .leading){
                            TextField("Nuevo título", text: $textFieldEntrada, axis: .vertical)
                                .onChange(of: textFieldEntrada) {
                                    if !textFieldEntrada.isEmpty {colorText = .primary}
                                }
                            
                            Text("Nombre de la categoria")
                                .font(.footnote)
                                .padding(.top, 5)
                                .foregroundColor(textFieldEntrada.isEmpty ? .red : .primary)
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
                    
                    
                }
                .navigationTitle("Crear nueva Entrada")
                .navigationBarTitleDisplayMode(.inline)
                
                VStack() {
                    Button("Guardar"){
                        if let categ = self.selectedCateg {
                            
                            if textFieldTitulo.isEmpty {return}
                            if textFieldEntrada.isEmpty {return}
                            
                            if let _ = CRUDModel().AddEntrada(title: textFieldTitulo, entrada: textFieldEntrada, categoria: categ){
                                print("Todo OK")
                            }else{
                                print("algo ha salido mal")
                            }
                            
                        }
                        
                    }
                    .buttonStyle(.bordered)
                    //.buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 50)
            }
            .sheet(isPresented: $showSheetAddCateg, content: {
                AddCategView()
            })
            .sheet(isPresented: $showSheetListCateg, content: {
                listadoCategorias(listCateg: $listCateg, selectedCateg: $selectedCateg)
            })
        }
    }
    
}


//Muestra el listado de categorias y permite seleccionar una
struct listadoCategorias : View {
    @Environment(\.dismiss) var dimiss
    @Binding var listCateg : [Categorias]
    @Binding var selectedCateg : Categorias?
    @State private var showSheeAddCateg = false
    var body: some View {
        NavigationStack {
            VStack{

                List(listCateg, id:\.id){ item in
                    
                    Button(AESModel().aesGCMDec(strEnc: item.categoria ?? "")){
                        selectedCateg = item
                        dimiss()
                    }
                    
                }
            }
            .toolbar{
                Button{
                    listCateg = CRUDModel().getListOfCateg()
                }label: {
                    Image(systemName: "arrow.circlepath")
                }
                
                Button{
                    self.showSheeAddCateg = true
                }label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Seleccionar una Categoria")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSheeAddCateg, content: {
                AddCategView()
            })
        }
    }
}



#Preview {
    AddEntradaView()
}
