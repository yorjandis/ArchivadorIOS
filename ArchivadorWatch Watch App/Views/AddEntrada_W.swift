//
//  AddEntrada_W.swift
//  ArchivadorWatch Watch App
//
//  Created by Yorjandis Garcia on 20/3/24.
//

import SwiftUI
import CoreData

struct AddEntrada_W: View {
    @State private var title : String = ""
    @State private var texto : String = ""
    @State var categ : Categorias?
    @State private var icono : String = "document" //Pasado como binding
    @State private var isfav : Bool = false //Pasado como binding
    private let context = PersistenceController.shared.context
    @State private var showAlert = false
    @State private var alertMessaje = ""
    @Environment(\.dismiss) var dismissP
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    //Título y icono de la entrada
                    HStack{
                        TextField("Título", text: self.$title)
                        NavigationLink{
                            ListOfImagesView(image: self.$icono)
                        }label: {
                            Image(path: self.icono).imageIcono()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 40)
                    }
                    
                    //Texto de la entrada
                    TextField("Texto", text: self.$texto, axis: .vertical)
                    
                    //Categoría de la entrada
                    NavigationLink{
                        listCate(categ: self.$categ)
                    }label:{
                        if CRUDModel().getListOfCateg().isEmpty { //Si no hay categorias disponibles: Crear una
                            NavigationLink("Crear Categoría"){
                                AddCateg_W()
                            }
                        }else{ //Si existe categorias disponibles
                            if self.categ == nil {//Si no se ha pasado una categoría se permite escoger una...
                                Text(self.categ == nil ? "Seleccione Categ..." : self.categ?.categoria ?? "")
                            }else{//Si se ha dado una categoría se coloca su icono e imagen:
                                HStack{
                                    Image(path: self.categ?.icono ?? "").imageIcono()
                                    Text(AESModel().aesGCMDec(strEnc: self.categ?.categoria ?? ""))
                                }
                            }
                        }
                    }
                    
                    //Favorito
                    HStack{
                        Toggle("Favorito", isOn: self.$isfav)
                            .frame(width: 120)
                        Spacer()
                    }
                    
                    //Boton Adicionar
                    Button("Adicionar"){
                        if AddEntr() {
                            self.alertMessaje = "Guardado!"
                            self.showAlert = true
                            dismissP()
                        }else{
                            self.alertMessaje = "Error al guardar!"
                            self.showAlert = true
                        }
                        
                    }
                    .foregroundColor(.black).bold()
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    //Boton para salir
                    Button("Salir"){
                        dismissP()
                    }
                    .foregroundColor(.black).bold()
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
            }
            .navigationTitle("Adicionar Entrada")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: self.$showAlert, content: {
                Alert(title: Text("Archivador"), message: Text(self.alertMessaje))
            })
        }
    }
    
    func AddEntr()->Bool{
        if self.title.isEmpty {return false}
        if self.texto.isEmpty {return false}
        if self.categ == nil {return false}
        
        let item = Entrada(context: self.context)
        
        item.categ = self.categ
        item.title = AESModel().aesGCMEnc(str: self.title)
        item.entrada = AESModel().aesGCMEnc(str: self.texto)
        item.icono = self.icono
        item.isfav = self.isfav
        
        do{
            try context.save()
            return true
        }catch{
            return false
        }
        
    }
    
    //Aux: Lista de categorías para seleccionar
    struct listCate : View {
        @Binding var categ : Categorias?
        @Environment(\.dismiss) var dismiss
        @State private var listateg : [Categorias] = []
        var body: some View {
            NavigationStack {
                VStack{
                    List(self.listateg){ catego in
                        HStack{
                            Image(path: catego.icono ?? "").imageIcono()
                            Button( AESModel().aesGCMDec(strEnc: catego.categoria ?? "")){
                                self.categ = catego
                                dismiss()
                            }
                        }
                    }
                }
                .task {
                    self.listateg = CRUDModel().getListOfCateg()
                }
            }
        }
    }
}

#Preview {
    AddEntrada_W()
}
