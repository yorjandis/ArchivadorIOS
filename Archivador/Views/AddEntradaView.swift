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
    
    var body: some View {
        NavigationStack {
            VStack{
                Form{
                    Section("Categoría de la Entrada"){
                        VStack(alignment: .leading){
                            //Construir un menu para escoger las categorias
                            if !listCateg.isEmpty {
                                Menu("Seleccione una categoría...") {
                                    ForEach(listCateg){ i in
                                        Button(AESModel().aesGCMDec(strEnc: i.categoria ?? "")){
                                            self.selectedCateg = i
                                        }
                                    }
                                }
                            }
                            Text("\( selectedCateg != nil ? AESModel().aesGCMDec(strEnc: self.selectedCateg?.categoria ?? ""): "⚠️")")
                                .foregroundStyle(.orange).bold()
                                
                                
                                
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
                    
                    Section("Texto de la entrada"){
                        VStack(alignment: .leading){
                            TextField("Contenido de la entrada", text: $textFieldEntrada, axis: .vertical)
                                .onChange(of: textFieldEntrada) {
                                    if !textFieldEntrada.isEmpty {colorText = .primary}
                                }
                            
                            Text("\(textFieldEntrada.isEmpty ? "⚠️" : "✅") Nombre de la categoría")
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
                            
                            if CRUDModel().AddEntrada(title: textFieldTitulo, entrada: textFieldEntrada, categoria: categ) != nil{
                                //OKOKOKOK
                                
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
            .background(.black)
            .foregroundStyle(.white)
            .sheet(isPresented: $showSheetAddCateg, content: {
                AddCategView(listado: $listCateg)
            })
            
        }
    }
    
}







#Preview {
    AddEntradaView()
}
