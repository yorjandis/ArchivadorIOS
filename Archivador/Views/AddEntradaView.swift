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
    @Binding var refresListEntradas: Bool //Permite actualizar la lista de entrada
    @State var selectedCateg : Categorias? //Si viene de Home() tendrá una categoria
    @State var entradaForModif : Entrada? = nil //Si se da es para modificar la entrada
    @State private var textFieldTitulo = ""
    @State private var textFieldEntrada = ""
    @State private var icono : String = "apple"
    @State private var fav = false
    @State private var colorText : Color = .primary
    @State private var showSheetAddCateg = false
    @State private var showSheetSelectIcono = false
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30){
                //Categoría
                VStack{
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
                                            Text( "\(AESModel().aesGCMDec(strEnc: self.selectedCateg?.categoria ?? ""))...")

                                    } icon: {
                                        Image(path: self.selectedCateg?.icono ?? "tags").imageIcono()
                                    }
                                    
                                }else{
                                    Text("Seleccione Categoría...")
                                }
                                
                            }.frame(maxWidth: .infinity, alignment: .center)
                        }
                        else{ //Si la lista de categoria está vacia: hay que crear nueva Categoría
                            NavigationLink{
                                AddCategView(updateHome: $updateHome, categoria: $selectedCateg)
                            }label: {
                                Label("Crear Nueva Categoría", systemImage: "folder.badge.plus")
                            }.frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                        Spacer()
                        //Mostrando el menu de tres puntos si existe categorias a seleccionar
                        if !self.listCateg.isEmpty {
                                Button{
                                    showSheetAddCateg = true
                                }label: {
                                    Image(systemName: "plus").foregroundColor(.black)
                                        .frame(width: 20)
                                        .background(.orange)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(.horizontal)
                                }
                        }
                        
                    }
                }
                .task {
                    self.listCateg = CRUDModel().getListOfCateg()
                }

                    
                //Título, icono y favorito
                VStack {
                    HStack(spacing: 10){
                        Button{
                            showSheetSelectIcono = true
                        }label: {
                            Image(path: self.icono).imageIcono()
                        }
                        TextField("⚠️ Nuevo título", text: $textFieldTitulo, axis: .vertical)
                        Toggle("Favorito", isOn: $fav).frame(maxWidth: 120)
                    }.padding(.horizontal, 5)
                }

                
                //Texto de la entrada
                VStack{
                    TextField("⚠️ Texto de la entrada", text: $textFieldEntrada, axis: .vertical)
                        .font(.title)
                        .padding(.horizontal)
                        
                }

                Spacer()
                
                Divider()
                
                //Boton
                HStack{
                    Spacer()
                    Button(entradaForModif == nil ? "Guardar" : "Actualizar"){
                        
                        if entradaForModif == nil { //Guardar...Crear nueva entrada
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
                        }else{ //Actualizar entrada
                           if  CRUDModel().modifEntrada(entrada: entradaForModif,
                                categoria: self.selectedCateg,
                                title: self.textFieldTitulo,
                                entradaText: self.textFieldEntrada,
                                image: "",
                                isfav: self.fav,
                                icono: self.icono){
                               
                               print("Se ha actualizado la entrada")
                               self.updateHome += 1 //Actualizando home()
                               self.refresListEntradas.toggle()//Actualizando la lista de Entradas
                               dimiss()
                           }else{
                               print("Ha ocurrido un error al actualizar la entrada")
                           }
                            
                        }
                        
                        
                        
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                    
                }
                
            }
            .navigationTitle(entradaForModif == nil ? "Crear nueva Entrada" : "Actualizar Entrada")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSheetAddCateg, content: {
                AddCategView(updateHome: $updateHome, categoria: self.$selectedCateg)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $showSheetSelectIcono) {
                ListOfImagesView(image: $icono)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            .task { //Para modificar la entrada
                if let entrada = self.entradaForModif {
                    self.selectedCateg = entrada.categ
                    self.textFieldTitulo =  AESModel().aesGCMDec(strEnc: entrada.title ?? "")
                    self.textFieldEntrada = AESModel().aesGCMDec(strEnc: entrada.entrada ?? "")
                    self.icono = entrada.icono ?? ""
                    self.fav = entrada.isfav
                    
                }
            }
            
        }.preferredColorScheme(.dark)
    }
    
}







#Preview {
    AddEntradaView(listCateg: .constant([Categorias]()), updateHome: .constant(1), refresListEntradas: .constant(true))
}
