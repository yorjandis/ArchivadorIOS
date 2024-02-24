//
//  ListEntradasView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//

import SwiftUI


//Muestra el listado de entradas con a lista de categorias:
struct ListEntradasView: View {
    @State var  listCateg : [Categorias] = CRUDModel().getListOfCateg()
    @State var  categoria : Categorias? = CRUDModel().getListOfCateg().randomElement()
    @State private var listEntradas : [Entrada] = []
    @FocusState var focuss : Bool
    @State var textFielSearch = ""
    @State var showSheetListCateg = false
    private var filtered : [Entrada] {
        if textFielSearch.isEmpty {return self.listEntradas}
        return self.listEntradas.filter{AESModel().aesGCMDec(strEnc: $0.title ?? "").localizedStandardContains(self.textFielSearch) }
    }
    var body: some View {
        
        NavigationStack {
                
                VStack{
                  
                    
                    //Permite escoger una categoria
                    VStack(alignment: .leading){
                        HStack{
                            Button{
                                showSheetListCateg = true
                            }label: {
                                Text("Seleccionar Categoria...")
                                    .foregroundColor(.primary)
                            }
                            .buttonStyle(.bordered)
                            .onChange(of: self.categoria) {
                                if let categ = self.categoria {
                                    listEntradas = CRUDModel().getListOfEntradas(categoria: categ)
                                }
                            }
                            .padding(.horizontal)
                            Spacer()
                            
                            NavigationLink{
                                AddEntradaView(selectedCateg: self.categoria)
                            }label: {
                                Image(systemName: "plus")
                            }
                            .padding(.trailing, 40)
                            
                        }
                        
                        
                        Text(AESModel().aesGCMDec(strEnc: self.categoria?.categoria ?? "" ))
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    VStack {
                        if self.listEntradas.count > 0 { //Si hay entradas muestra la barra de búsqueda
                            HStack{
                                TextField("", text: $textFielSearch, prompt: Text(" 🔍 Buscar en entradas").bold())
                                    .padding(.horizontal)
                                    .focused($focuss)
                                
                                Spacer()
                                
                            }.padding(.horizontal)
                        }
                    }
                    
                    ScrollView{
                        ForEach(self.filtered, id: \.id){item in
                            cardEntrada(item: item)
                        }
                    }
                    
                    Spacer()
                }
                .navigationTitle("Entradas")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    if let categ = self.categoria {
                        listEntradas = CRUDModel().getListOfEntradas(categoria: categ)
                    }
                }
                .sheet(isPresented: $showSheetListCateg, content: {
                    listadoCategorias(listCateg: $listCateg, selectedCateg: $categoria)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.hidden)
                })
                
                
            }
    }
    
    struct cardEntrada : View {
        let item : Entrada
        @State var expandText : Bool = false
        
        var body: some View {
            VStack{
                HStack{
                    Text(AESModel().aesGCMDec(strEnc: item.title ?? ""))
                    Spacer()
                }
                if self.expandText {
                    HStack{
                        Text(AESModel().aesGCMDec(strEnc: item.entrada ?? ""))
                        Spacer()
                    }.padding(.top, 5)
                   
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture{
                withAnimation {
                    expandText.toggle()
                }
            }
        }
    }
    
    
    
    //Pedrmite escoger una categoria
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
                    AddCategView(listado: $listCateg)
                })
            }
        }
    }
    
}

#Preview {
    ListEntradasView()
}
