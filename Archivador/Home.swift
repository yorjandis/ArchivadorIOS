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

    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.green, .orange.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    ListCateg()
                        .padding(.top, 20)

                    Spacer()
                    TabButtonBar()
                }
                Spacer()
                
            }
            .navigationTitle("Archivador")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    


    
    struct TabButtonBar : View{
          
        @State  var tabs = ["book.pages.fill", "list.bullet","plus.circle.fill","text.viewfinder", "slider.vertical.3"]
        @State var showSheetAddCateg = false
        @State var showSheetAddEntrada = false
        var body: some View{
            
            //Creando La bottom Bar con los item del menu
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
            .sheet(isPresented: $showSheetAddCateg, content: {
                AddCategView()
            })
            .sheet(isPresented: $showSheetAddEntrada, content: {
                AddEntradaView()
            })
        }
        
        //Create UI for reusability
        func makeItemlabel(image : String)->some View{
            return Image(systemName: image)
                .renderingMode(.template)
                .foregroundColor( Color.black.opacity(0.4))
                .padding(10)
            
        }
        
    }
  
    
    
    
}




//Listado de categorias Home()
struct ListCateg : View {
    @Environment(\.colorScheme) var theme
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
                HStack{
                    Text("Categorías").bold().fontDesign(.serif)
                    Spacer()
                    Button{
                        withAnimation {
                            ShowtextFielSearch.toggle()
                            if !ShowtextFielSearch {
                                self.textFielSearch = ""
                                focuss = false
                            }
                            
                        }
                    }label: {
                        Image(systemName: "magnifyingglass")
                    }.padding(.trailing, 10)
                }.padding(.horizontal)
                if ShowtextFielSearch {
                        TextField("", text: $textFielSearch, prompt: Text(" 🔍 Buscar en categorias"))
                            .padding(.horizontal)
                            .focused($focuss)
                            .frame(maxWidth: .infinity)
                }
                
                    
            }
            
            ScrollView {
                ForEach(self.filtered){item in
                    VStack{
                        HStack{
                            NavigationLink{
                                ListEntradasView(categoria: item)
                            }label: {
                                Text(AESModel().aesGCMDec(strEnc: item.categoria ?? ""))
                                    .foregroundStyle(theme == .dark ? .white : .black)
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
                        .padding(15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                        
                    }
                }
            }
        }
        .sheet(item: $CategoriaTemp, content: { categ in
                AddEntradaView(selectedCateg: categ)
        })
    }
}





#Preview {
    Home()
}
