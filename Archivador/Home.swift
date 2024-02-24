//
//  Home.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 22/2/24.
//

import SwiftUI
import CoreData

struct Home: View {
    
    @State var CategoriaActual : Categorias?
    @State var listCategorias = CRUDModel().getListOfCateg()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue,.green, .orange.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    ListCategHome(listCategorias: $listCategorias)
                      .padding(.top, 20)
                    
                    Spacer()
                    TabButtonBar(listCategorias: $listCategorias)
                }
                Spacer()
                
            }
            .navigationTitle("Archivador")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }

        
        

    struct TabButtonBar : View{
            @Binding var listCategorias : [Categorias]
            @State  var tabs = ["book.pages.fill", "list.bullet","plus.circle.fill","text.viewfinder", "slider.vertical.3"]
            @State var showSheetAddCateg = false
            @State var showSheetAddEntrada = false

                //Creando La bottom Bar con los item del menu
        var body : some View {
            HStack{
                ForEach (tabs, id: \.self ){ image in
                    
                    switch image{
                    case "book.pages.fill":
                        NavigationLink{ ListEntradasView() }label: {
                            makeItemlabel(image: image)
                        }
                        
                    case "list.bullet":
                        NavigationLink{ListCategView() }label: {
                            makeItemlabel(image: image)
                        }
                        
                    case "plus.circle.fill":
                        Menu{
                            Button("Nueva Entrada"){showSheetAddEntrada = true}
                            Button("Nueva Categoria"){showSheetAddCateg = true}
                            
                        }label: {
                            makeItemlabel(image: image)
                                .font(.system(size: 30))
                        }
                    case "text.viewfinder":
                        Button{}label: {
                            makeItemlabel(image: image)
                        }
                        
                    case "slider.vertical.3":
                        Button{}label: {
                            makeItemlabel(image: image)
                        }
                        
                    default: EmptyView()
                        
                    }
                    
                    //Insertando un espaciado para mantener la distancia entre los items
                    if image != tabs.last {
                        Spacer(minLength: 0)
                    }
                    
                }//ForEach
                
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 2)
            .background(LinearGradient(colors: [.gray, .cyan], startPoint: .top, endPoint: .bottom))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .sheet(isPresented: $showSheetAddCateg){
                AddCategView(listado: $listCategorias)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $showSheetAddEntrada) {
                AddEntradaView()
            }
        }
        
        //Create UI for reusability
        func makeItemlabel(image : String)->some View{
            return Image(systemName: image)
                .renderingMode(.template)
                .foregroundColor( Color.black.opacity(0.4))
                .padding(10)
        }
                
    }
            

        
    
    
    
        //Listado de categorias Home()
       struct ListCategHome : View {
            @Binding var listCategorias : [Categorias]
            @FocusState var focuss : Bool
            @State var textFielSearch = ""
            @State var ShowtextFielSearch = false
            
            @State var ShowSheetAddNewEntrada = false
            @State var CategoriaParaAdicionar : Categorias? //Almacena una categoria para adicionarle entrada
            @State var CategoriaParaEliminar : Categorias? //Almacena una categoria para eliminarla
            
            @State  var showConfirmDialogDeleteNota = false
            
             var filtered : [Categorias] {
                if textFielSearch.isEmpty {return listCategorias}
                return listCategorias.filter{AESModel().aesGCMDec(strEnc: $0.categoria ?? "").localizedStandardContains(textFielSearch) }
            }

            var body : some View {
                NavigationStack {
                    //Searchs
                    VStack {
                        TextField("", text: $textFielSearch, prompt: Text(" 🔍 Buscar en categorias"))
                            .padding(.horizontal)
                            .focused($focuss)
                            .frame(maxWidth: .infinity)
                    }
                    .task {
                        listCategorias = CRUDModel().getListOfCateg()
                    }
                    
                    ScrollView {
                        ForEach(filtered){categ in
                            VStack{
                                HStack{
                                    NavigationLink{
                                        ListEntradasView(categoria: categ)
                                    }label: {
                                        Text(AESModel().aesGCMDec(strEnc: categ.categoria ?? ""))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .contentShape(Rectangle())
                                    }
                                    Spacer()
                                    Button{
                                        
                                        CategoriaParaAdicionar = categ
                                    }label: {
                                        Label("", systemImage: "plus")
                                    }
                                    Menu{
                                        Button("Eliminar Categoria"){
                                            CategoriaParaEliminar = categ
                                            showConfirmDialogDeleteNota = true
                                        }
                                        
                                    }label: {
                                        Image(systemName: "ellipsis")
                                            .frame(width: 30,  height: 20)
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
                    .confirmationDialog("Eliminar una Categoría", isPresented: $showConfirmDialogDeleteNota) {
                        Button("Eliminar categoría", role: .destructive){
                            
                            if let cat = CategoriaParaEliminar {
                                if  CRUDModel().DeleteRecord(record: cat){
                                    print("Se ha eliminado la categoría y todas sus entradas")
                                }
                            }
                        }
                    }message: {
                        Text("Al eliminar una categoría se eliminan todas las entradas asociadas. Esta acción no puede deshacerse")
                    }
                    .sheet(item: $CategoriaParaAdicionar){ categ in
                        AddEntradaView(selectedCateg: categ)
                    }
                }
            }
                
            }
    
    
    
    
  
    
}
    
    
    


    


#Preview {
    Home()
}
