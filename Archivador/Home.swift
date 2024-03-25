//
//  Home.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 22/2/24.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct Home: View {
    
    @State var CategoriaActual : Categorias?
    @State var listCategorias = CRUDModel().getListOfCateg()
    @State var updateHome : Int8 = 0
    @State var HabilitarContenido = false
    
    @Environment(\.scenePhase) var scenePhase //Para dectectar si la app esta en sengundo plano
    
    //Autenticaxción segura
    let contextLA = LAContext()
    
    var body: some View {
        NavigationStack {

            ZStack {
                
                if self.HabilitarContenido {
                    VStack{
                        ListCategHome(listCategoria: $listCategorias, updateHome: $updateHome)
                            .padding(.top, 20)
                        
                        Spacer()
                        TabButtonBar(listCategorias: $listCategorias, updateHome: $updateHome)
                    }
                    Spacer()
                }else{
                    VStack(spacing: 30){
                        Text("Toque el ícono para acceder")
                            .font(.title2)
                            .foregroundColor(.black).bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Image(systemName: "faceid")
                            .font(.system(size: 50)).foregroundColor(.black).bold()
                            .onTapGesture {
                                autent()
                            }
                        Spacer()
                            
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .task {
                            autent()
                        }
                        .onChange(of: scenePhase) { oldPhase, newPhase in
                            if newPhase == .active {
                                print("Active")
                            } else if newPhase == .inactive {
                                print("Inactive")
                            } else if newPhase == .background {
                                print("background")
                            }
                        }
                }

            }
            .background(
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity)
            )
            .navigationTitle("Archivador")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }

    func autent(){
        var error : NSError?
        if contextLA.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            contextLA.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Por favor autentícate para tener acceso a su información") { success, error in
                if success {
                    //Habilitación del contenido
                    withAnimation {
                        self.HabilitarContenido = true
                    }
                   
                } else {
                    print("Error en la autenticación biométrica")
                    self.HabilitarContenido = false
                }
            }
            
            
        }else{ //El Dispositivo no soporta autenticación biométrica
            print("El Dispositivo no soporta autenticación biométrica")
        }
    }
    
    //Listado de categorias Home()
    struct ListCategHome : View {
        @Binding var listCategoria : [Categorias]
        @Binding var updateHome : Int8  //Permite actualizar toda la informacion de categorias
        
        @FocusState var focus : Bool
        @State  var textFielSearch = ""
        @State  var ShowtextFielSearch = false
        
        @State private var ShowSheetAddNewEntrada = false
        
        @State var categoriaTemp            : Categorias? //Almacena una categoria para operaciones
        @State var CategoriaParaAdicionar   : Categorias? //Almacena una categoria para adicionarle entrada
        @State var CategoriaParaEliminar    : Categorias? //Almacena una categoria para eliminarla
        @State var CategoriaParaModificar   : Categorias? //Almacena una categoria para eliminarla
        
        
        @State   var selectionNavigation = false
        @State   var showConfirmDialogDeleteNota = false
        @State   var ShowSheetListEntradas = false
        @State   var ShowSheetModifCateg = false
        
        var filtered : [Categorias] {
            print("Filtered...")
            if textFielSearch.isEmpty {return listCategoria}
            return listCategoria.filter{AESModel().aesGCMDec(strEnc: $0.categoria ?? "").localizedStandardContains(textFielSearch) }
        }
        
        var body : some View {
            NavigationStack {
                
                //Searchs
                if !self.listCategoria.isEmpty {
                    VStack {
                        HStack{
                            TextField("", text: $textFielSearch, prompt: Text(" 🔍 Buscar en categorías"))
                                .padding(.horizontal)
                                .focused($focus)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            Menu{
                                Button("Todas las Categorías"){
                                    self.listCategoria = CRUDModel().getListOfCateg()
                                }
                                if !CRUDModel().getListOfCategFav().isEmpty { //Solo muestra esta opción si existe categorias favoritas
                                    Button("Favoritos"){
                                        self.listCategoria = CRUDModel().getListOfCategFav()
                                    }
                                }
                                
                            }label: {
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                        }.padding(.horizontal)
                        
                    }
                    .task{
                        //Carga la lista de categorias
                        self.listCategoria = CRUDModel().getListOfCateg()
                    }
                    
                }else{
                    NavigationLink{
                        AddCategView(updateHome: $updateHome, categoria: $categoriaTemp) //Yorj: $categoriaTemp no tiene aqui ningun significado
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
                                Image(path: categ.icono == "" ? "\(Utils.imgCategDef)"  : categ.icono ?? "\(Utils.imgCategDef)").imageIcono()
                                
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
                                        self.CategoriaParaAdicionar = categ
                                        
                                    }
                                    
                                VStack {
                                    Menu{
                                        Button("Modificar..."){
                                            self.CategoriaParaModificar = categ
                                        }
                                        Button("Eliminar Categoría..."){
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
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal,5)
                    }
                }
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
                .sheet(item: self.$CategoriaParaAdicionar){ categ in
                    AddEntradaView(listCateg: $listCategoria, updateHome: $updateHome, refresListEntradas: .constant(false), selectedCateg: categ)
                    
                }
                .sheet(isPresented: $ShowSheetListEntradas) {
                    ListEntradasView(updateHome: self.$updateHome, categoria: self.categoriaTemp)
                    
                    
                }
                .sheet(item: $CategoriaParaModificar) { categ in
                    AddCategView(updateHome: self.$updateHome, categoria: $categoriaTemp, categoriaForModif: categ)
                    
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.hidden)
                }
            }
        }
        
    }

    
    
    
    struct TabButtonBar : View{
        @Binding var listCategorias : [Categorias]
        @Binding var updateHome : Int8
        @State private var categoria : Categorias? = nil
        @State var showSheetAddCateg = false
        @State var showSheetAddEntrada = false
        @State var showSheetListEntradas = false
        
        //Creando La bottom Bar con los item del menu
        var body : some View {
            HStack{
                Spacer()
                
                Menu{
                    Button("Lista de Entradas"){showSheetListEntradas = true }
                    Button("Nueva Entrada..."){showSheetAddEntrada = true}
                    Button("Nueva Categoría..."){showSheetAddCateg = true}
                    
                }label: {
                    Circle()
                        .fill(Color("yor"))
                        .frame(height: 60)
                        .overlay {
                            Image(systemName: "plus").bold().font(.system(size: 24)).foregroundColor(.black)
                        }
                        .padding(.trailing, 50)
                }
                
                
            }
            .sheet(isPresented: $showSheetAddCateg){
                AddCategView(updateHome: $updateHome, categoria: $categoria)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $showSheetAddEntrada) {
                AddEntradaView(listCateg: $listCategorias, updateHome: $updateHome, refresListEntradas: .constant(false))
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $showSheetListEntradas) {
                ListEntradasView(updateHome: $updateHome)
            }
        }
        
        
    }
  

}
    
    
    


    


#Preview {
    Home()
}
