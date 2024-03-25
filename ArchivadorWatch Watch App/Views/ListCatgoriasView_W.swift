//
//  ListCatgoriasView_W.swift
//  ArchivadorWatch Watch App
//
//  Created by Yorjandis Garcia on 16/3/24.
//

import SwiftUI
import CoreData

struct ListCatgoriasView_W: View {
    
    @State private var listCateg : [Categorias] = []
    @State private var textFieldSearch = ""
    @State private var showSearch = false
    @State private var showSheetAddCateg = false
    
    
    
    var body: some View {
            VStack{
 

                List{
                    ForEach(listCateg, id: \.id){ categ in
                        NavigationLink{
                            ListEntradasViews_W(categoria: categ)
                        }label:{
                            HStack{
                                Image(path: categ.icono == "" ? "apple"  : categ.icono ?? "apple").imageIcono()
                                Text(AESModel().aesGCMDec(strEnc: categ.categoria ?? ""))
                            }
                        } 
                    }
                }
            }
            .foregroundColor(.white)
            .navigationTitle("Categorias")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                listCateg = CRUDModel().getListOfCateg()
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
                            self.showSheetAddCateg = true
                        }
                    
                    Image(systemName: "arrow.circlepath")
                        .font(.system(size: 20))
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation {
                                self.listCateg = CRUDModel().getListOfCateg()
                            }
                            
                        }
                }
            }
            .sheet(isPresented: $showSearch, content: {
                SearchViewCategoria(listCatg: self.$listCateg)
            })
            .sheet(isPresented: $showSheetAddCateg, content: {
                AddCateg_W()
            })
    }
}

//Para buscar en las categorias
struct SearchViewCategoria : View {
    @Binding var listCatg : [Categorias]
    @Environment(\.dismiss) var dismiss
    @State private var textFieldSearch : String = ""
    var body: some View {
        
        VStack{
            TextField("Buscar", text: $textFieldSearch)
                .onSubmit(of: .text) {
                    let list = CRUDModel().getListOfCateg()
                    if textFieldSearch.isEmpty {
                        listCatg = list
                    }else{
                        listCatg = list.filter{ item in
                            let texto = AESModel().aesGCMDec(strEnc: item.categoria ?? "")
                            if texto.localizedCaseInsensitiveContains(textFieldSearch.trimmingCharacters(in: .whitespacesAndNewlines)){return true}else{return false}
                        }
                    }
                    
                    dismiss()
                }
        }
        
    }
}


#Preview {
    ListCatgoriasView_W()
}
