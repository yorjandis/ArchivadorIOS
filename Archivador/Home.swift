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
    @State var updateHome : Int8 = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{
                    ListCategHome(listCategoria: $listCategorias, updateHome: $updateHome)
                      .padding(.top, 20)
                    
                    Spacer()
                    TabButtonBar(listCategorias: $listCategorias, updateHome: $updateHome)
                }
                Spacer()
                
            }
            .background(
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
            .navigationTitle("Archivador")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }

        
        

    struct TabButtonBar : View{
            @Binding var listCategorias : [Categorias]
            @Binding var updateHome : Int8
            @State var categoriaTemp : Categorias? //No hace nada yor
            @State  var tabs = ["book.pages.fill", "list.bullet","plus.circle.fill","text.viewfinder", "slider.vertical.3"]
            @State var showSheetAddCateg = false
            @State var showSheetAddEntrada = false

                //Creando La bottom Bar con los item del menu
        var body : some View {
            HStack{
                ForEach (tabs, id: \.self ){ image in
                    
                    switch image{
                    case "plus.circle.fill":
                        Menu{
                            Button("Nueva Entrada"){showSheetAddEntrada = true}
                            Button("Nueva Categoria"){showSheetAddCateg = true}
                            
                        }label: {
                            makeItemlabel(image: image)
                                .font(.system(size: 30))
                        }
                    case "text.viewfinder":
                        NavigationLink{ testView()}label: {
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
                AddCategView(updateHome: $updateHome)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $showSheetAddEntrada) {
                AddEntradaView(listCateg: $listCategorias, updateHome: $updateHome)
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
            @Binding var listCategoria : [Categorias]
            @Binding var updateHome : Int8  //Permite actualizar toda la informacion de categorias
            @State var categoriaTemp : Categorias?
            @FocusState var focus : Bool
            @State var textFielSearch = ""
            @State var ShowtextFielSearch = false
            
            @State var ShowSheetAddNewEntrada = false
            @State var CategoriaParaAdicionar : Categorias? //Almacena una categoria para adicionarle entrada
            @State var CategoriaParaEliminar : Categorias? //Almacena una categoria para eliminarla
            @State var selectionNavigation = false
            @State  var showConfirmDialogDeleteNota = false
            @State  var ShowSheetListEntradas = false
            
             var filtered : [Categorias] {
                if textFielSearch.isEmpty {return listCategoria}
                return listCategoria.filter{AESModel().aesGCMDec(strEnc: $0.categoria ?? "").localizedStandardContains(textFielSearch) }
            }

            var body : some View {
                NavigationStack {

                    //Searchs
                    if !self.listCategoria.isEmpty {
                        VStack {
                               TextField("", text: $textFielSearch, prompt: Text(" 🔍 Buscar en categorías"))
                                .padding(.horizontal)
                                .focused($focus)
                                .frame(maxWidth: .infinity)
                        }
                        .task {
                            listCategoria = CRUDModel().getListOfCateg()
                        }
                    }else{
                        NavigationLink{
                            AddCategView(updateHome: $updateHome)
                        }label: {
                            Label("Adicione una categoría", systemImage: "folder.badge.plus")
                                .foregroundColor(.black).bold().fontDesign(.serif)
                                .font(.system(size: 25))
                        }
                        .padding(.top, 250)
                        
                    }
                    
                    
                    ScrollView{
                        ForEach(filtered){categ in
                            VStack{
                                HStack{
                                    Image(path: categ.icono == "" ? "apple"  : categ.icono ?? "apple").imageIcono()
                                    
                                    NavigationLink{
                                        ListEntradasView(updateHome: self.$updateHome, categoria: categ)
                                    }label: {
                                        Text(AESModel().aesGCMDec(strEnc: categ.categoria ?? "")).bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .contentShape(Rectangle())
                                    }

                                    
                                    
                                    Spacer()
                                    Circle()
                                        .fill(.orange)
                                        .frame(height: 35)
                                        .overlay {
                                            Text("\(CRUDModel().getListOfEntradas(categoria: categ).count)").fontDesign(.serif).bold().foregroundStyle(.black)
                                        }
                                        .onTapGesture {
                                            CategoriaParaAdicionar = categ
                                        }
                                    VStack {
                                        Menu{
                                            Button("Eliminar Categoría"){
                                                CategoriaParaEliminar = categ
                                                showConfirmDialogDeleteNota = true
                                            }
                                        }label:{
                                            Image(systemName: "ellipsis")
                                                .frame(width: 30  ,height: 30)
                                        }
                                    }.padding(.horizontal, 3)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 5)
  
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color("yor"))
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal,5)
                            
                            
                            
                            
                            
                            
                        }
                    }
                    //.frame(maxWidth: .infinity)
                    //.scrollContentBackground(.hidden)
                    .onChange(of: self.updateHome){ //Yorj! Aqui se actualiza toda la info
                        //Carga la lista de categorias
                        self.listCategoria = CRUDModel().getListOfCateg()
                    }
                    .confirmationDialog("Eliminar una Categoría", isPresented: $showConfirmDialogDeleteNota) {
                        Button("Eliminar categoría", role: .destructive){
                            
                            if let cat = CategoriaParaEliminar {
                                if  CRUDModel().DeleteRecord(record: cat){
                                    print("Se ha eliminado la categoría y todas sus entradas")
                                    withAnimation {
                                        self.listCategoria = CRUDModel().getListOfCateg()
                                    }
                                }
                            }
                        }
                    }message: {
                        Text("Al eliminar una categoría las entradas asociadas no se eliminan. Utilice el filtro en la lista de entradas para asignarle una nueva categoría")
                    }
                    .sheet(item: $CategoriaParaAdicionar){ categ in
                        AddEntradaView(listCateg: $listCategoria, updateHome: $updateHome, selectedCateg: categ)
                    }
                    .sheet(isPresented: $ShowSheetListEntradas) {
                        ListEntradasView(updateHome: self.$updateHome, categoria: self.categoriaTemp)
                    }
                }
            }
                
            }
    
    
    
    
  
    
}
    
    
    


    


#Preview {
    Home()
}
