//
//  ListCategView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//

import SwiftUI

struct ListCategView : View {
    @FocusState var focuss : Bool
    @State var listCatg = CRUDModel().getListOfCateg()
    @State var textFielSearch = ""
    @State var ShowtextFielSearch = false
    
    @State var ShowSheetAddNewEntrada = false
    @State var CategoriaTemp : Categorias? //Almacena jna categoria para adicionarle entrada
    
    private var filtered : [Categorias] {
        if textFielSearch.isEmpty {return self.listCatg}
        return self.listCatg.filter{AESModel().aesGCMDec(strEnc: $0.categoria ?? "").localizedStandardContains(self.textFielSearch) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("", text: $textFielSearch, prompt: Text(" 🔍 Buscar en categorias"))
                    .padding(.horizontal)
                    .focused($focuss)
                    .frame(maxWidth: .infinity)
                
                
                ScrollView {
                    ForEach(self.filtered){item in
                        VStack{
                            HStack{
                                NavigationLink{
                                    ListEntradasView(categoria: item)
                                }label: {
                                    Text(AESModel().aesGCMDec(strEnc: item.categoria ?? ""))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                                Spacer()
                                Menu{
                                    Button{
                                        self.CategoriaTemp = item
                                    }label: {
                                        Label("Adicionar entrada", systemImage: "plus")
                                    }
                                    
                                }label: {
                                    Image(systemName: "ellipsis")
                                        .frame(width: 30,  height: 20)
                                }
                            }
                            
                            
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                    }
                }
            }
            .background(LinearGradient(colors: [.blue,.green, .orange], startPoint: .top, endPoint: .bottom))
            .navigationTitle("Categorias")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $CategoriaTemp, content: { categ in
                AddEntradaView(selectedCateg: categ)
            })
        }
        
    }
}

#Preview {
    ListCategView()
}
