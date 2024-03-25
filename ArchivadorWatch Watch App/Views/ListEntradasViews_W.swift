//
//  ListEntradasViews_W.swift
//  ArchivadorWatch Watch App
//
//  Created by Yorjandis Garcia on 16/3/24.
//
//Lista todas las entradas, sin tener en cuenta la categoria

import SwiftUI
import CoreData

struct ListEntradasViews_W: View {

    @State  var categoria : Categorias? //Categoria de la
    @State private var listEntradas : [Entrada] = []
    @State private var showSearch = false
    @State private var showSheetAddEntrada = false
   

    var body: some View {
        NavigationStack{
                List{
                    ForEach(listEntradas, id: \.id){ entrada in
                            NavigationLink{
                                entradaContent(entrada: entrada)
                            }label:{
                                HStack{
                                    Image(path: entrada.icono == "" ? "document"  : entrada.icono ?? "document").imageIcono()
                                    VStack{
                                        Text(AESModel().aesGCMDec(strEnc: entrada.title ?? ""))
                                        //Texto de la categoria de la entrada O permitir modificarla si es huérfana
                                        if entrada.categ != nil {
                                            Text(AESModel().aesGCMDec(strEnc: (entrada.categ?.categoria)!))
                                                .font(.footnote).foregroundStyle(.black)
                                        }else{//Si es una entrada huérfana: permitir modificarla
                                            Text("Sin categoría")
                                                .font(.footnote).foregroundStyle(.orange)
                                        }
                                    }
                                }
                            }
                    }
                }
            .foregroundColor(.white)
            .navigationTitle("Entradas")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if self.categoria != nil {
                    listEntradas = CRUDModel().getListOfEntradas(categoria: self.categoria!)
                }else{
                    listEntradas = CRUDModel().getAllListOfEntradas()
                }
            }
            .preferredColorScheme(.dark)
            .toolbar{
                HStack{
                    Image(systemName: "text.magnifyingglass")
                        .font(.system(size: 20))
                        .padding(.horizontal)
                        .onTapGesture {
                            self.showSearch = true
                        }
                    Spacer()
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .padding(.horizontal)
                        .onTapGesture {
                            self.showSheetAddEntrada = true
                        }
                    
                    Image(systemName: "arrow.circlepath")
                        .font(.system(size: 20))
                        .padding(.horizontal)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            self.listEntradas.removeAll()
                            withAnimation {
                                if let categ = self.categoria{
                                    self.listEntradas = CRUDModel().getListOfEntradas(categoria: categ)
                                }else{
                                    self.listEntradas = CRUDModel().getAllListOfEntradas()
                                }
                            }
                        }
                }.padding(.horizontal, 15)
            }
            .sheet(isPresented: $showSearch, content: {
                SearchViewEntrada(listEntrada: self.$listEntradas, categoria: self.$categoria)
            })
            .sheet(isPresented: $showSheetAddEntrada, content: {
                if self.categoria == nil {
                    AddEntrada_W()
                }else{
                    AddEntrada_W(categ: self.categoria)
                }
            })
        }
    }
    
    //Visualiza el contenido de una entrada, más opciones
    struct entradaContent : View {
        @State var entrada : Entrada?
        @State var showSheet = false
        var body: some View {
            NavigationStack {
                VStack{
                    HStack{
                        Image(systemName: "square.and.pencil")
                            .onTapGesture {
                                self.showSheet = true
                            }.padding([.horizontal, .vertical], 10)
                        Spacer()
                    }.padding(.horizontal)
                    
                    Text(AESModel().aesGCMDec(strEnc: entrada?.entrada ?? ""))
                    
                    Spacer()
                }
                .navigationTitle(AESModel().aesGCMDec(strEnc: self.entrada?.title ?? ""))
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showSheet, content: {
                    ModifEntradaView_W(entrada: $entrada)
                })
            }
        }
    }
    
}





//Para buscar
struct SearchViewEntrada : View {
    @Binding var listEntrada : [Entrada]
    @Binding var categoria : Categorias?
    @Environment(\.dismiss) var dismiss
    @State private var textFieldSearch : String = ""
    var body: some View {
        
        VStack{
            TextField("Buscar", text: $textFieldSearch)
                .onSubmit(of: .text) {
                    var list : [Entrada] = []
                    if self.categoria != nil {
                         list = CRUDModel().getListOfEntradas(categoria: categoria!)
                    }else{
                         list = CRUDModel().getAllListOfEntradas()
                    }
                    
                    if textFieldSearch.isEmpty {
                        listEntrada = list
                    }else{
                        listEntrada = list.filter{ item in
                            let texto = AESModel().aesGCMDec(strEnc: item.title ?? "")
                            if texto.localizedCaseInsensitiveContains(textFieldSearch.trimmingCharacters(in: .whitespacesAndNewlines)){return true}else{return false}
                        }
                    }
                    
                    dismiss()
                }
        }
        
    }
}

#Preview {
    ListEntradasViews_W()
}
