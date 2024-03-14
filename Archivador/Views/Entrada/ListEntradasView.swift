//
//  ListEntradasView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//

import SwiftUI
import CoreData

// HTMLView(txt: self.texto)

//Muestra el listado de entradas con a lista de categorias:
struct ListEntradasView: View {
    
    @Binding var updateHome : Int8 //Permite a Home() actuzalizar las categorias y su info
    @State var categoria : Categorias? = nil //Si es nil, se tiene que escoger una categoria
    @State var listCategorias : [Categorias] = []
    @State var listEntradas : [Entrada] = []
    
    @State  var refresListEntradas = false //Actualiza el listado de entradas
    
    
    
    @State private var showSheetModifEntrada = false //Permite modificar una entrada
    @State private var showSheetAddEntrada = false //Permite crear una nueva entrada

    @State  var textFielSearch = ""
    @State  var ShowtextFielSearch = false
    @FocusState var focus : Bool
    
   
    
     var filtered : [Entrada]{
         if let categ = self.categoria { //Si se ha dado una categoria
             if textFielSearch.isEmpty {return CRUDModel().getListOfEntradas(categoria: categ) }
             return listEntradas.filter{AESModel().aesGCMDec(strEnc: $0.title ?? "").localizedStandardContains(textFielSearch) }
             
         }else{//Si NO existe una categoria: se Ha listado todas las entradas
             if textFielSearch.isEmpty {return self.listEntradas}
             return listEntradas.filter{AESModel().aesGCMDec(strEnc: $0.title ?? "").localizedStandardContains(textFielSearch) }
         }

    }

    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack{
                    //Categorias
                    VStack{
                        HStack{
                            Menu{
                                Button("Todas las Entradas"){
                                    self.categoria = nil
                                    self.refresListEntradas.toggle()
                                    self.textFielSearch = ""
                                }
                                Button("Entradas sin Categoría"){
                                    self.categoria = nil
                                    self.listEntradas = CRUDModel().getEntradasSinCateg()
                                    self.textFielSearch = ""
                                }
                                ForEach(listCategorias){categ in
                                    Button{
                                        self.categoria = categ
                                        self.refresListEntradas.toggle()
                                        self.textFielSearch = ""
                                    }label: {
                                        Label {
                                            Text(AESModel().aesGCMDec(strEnc: categ.categoria ?? ""))
                                        } icon: {
                                            Image(path: categ.icono ?? "tags").imageIcono()
                                        }
                                        
                                    }
                                }
                            }label: {
                                if let categ = self.categoria {
                                    Image(path: categ.icono ?? "").imageIcono()
                                    Text(AESModel().aesGCMDec(strEnc: self.categoria?.categoria ?? ""))
                                        .frame(height: 40)
                                }else{
                                    Image(systemName: "line.3.horizontal.decrease")
                                        .font(.system(size: 25))
                                }
                            }
                            .padding(.leading,self.categoria == nil ? 170 : 130)
                            Spacer()
                            
                            Button{
                                showSheetAddEntrada = true
                            }label: {
                                Image(systemName: "plus").foregroundColor(.black)
                                    .frame(width: 40, height: 40)
                                    .background(.orange)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.horizontal)
                            }
                        
                            
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                    .onAppear{
                            self.refresListEntradas.toggle()
                    }
                }
                    
                    Spacer()
                    
                    
                    //Searchs
                    if !self.listEntradas.isEmpty {
                        VStack {
                            TextField("", text: $textFielSearch, prompt: Text(" 🔍 Buscar en entradas"))
                                .padding(.horizontal)
                                .focused($focus)
                                .frame(maxWidth: .infinity)
                        }
                        .task {
                            self.listEntradas = self.filtered
                        }
                    }else{
                        Button{
                            showSheetAddEntrada = true
                           // AddEntradaView(listCateg: $listCategorias, updateHome: $updateHome, refresListEntradas: self.$refresListEntradas)
                        }label: {
                            Label("Adicione una entrada", systemImage: "folder.badge.plus")
                                .foregroundColor(.black).bold().fontDesign(.serif)
                                .font(.system(size: 25))
                        }
                        .padding(.top, 250)
                        
                    }
                    
                    
                    //Entradas
                    VStack{
                        ScrollView{
                            ForEach(self.filtered){ entrada in
                                ///EntradaViewItem
                                EntradaViewItem(refresListEntradas: $refresListEntradas, updateHome: $updateHome, listEntradas: $listEntradas, listCategorias: $listCategorias, entrada: entrada, SelectedCategoria: self.categoria)
                            }
                        }
                        
                    }
                    .onChange(of: refresListEntradas){
                        if self.categoria != nil {
                            listEntradas = CRUDModel().getListOfEntradas(categoria: self.categoria!)
                        }else{
                            //Si categoria es nil se listan todas las entradas
                            self.listEntradas = CRUDModel().getAllListOfEntradas()
                        }
                    }
                    
                }
 
            }
            .task {
                self.listCategorias = CRUDModel().getListOfCateg()
            }
            .background(
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity)
            )
            .navigationTitle("Lista de Entradas")
            .navigationBarTitleDisplayMode(.inline)

            .sheet(isPresented: self.$showSheetAddEntrada) {
                AddEntradaView(listCateg: self.$listCategorias, updateHome: $updateHome, refresListEntradas: self.$refresListEntradas, selectedCateg: self.categoria )
                
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            
        }.preferredColorScheme(.dark)
        
    }
    
    

    
}


//Item que representa una entrada
struct EntradaViewItem : View {
    @Binding var refresListEntradas : Bool
    @Binding var updateHome : Int8
    @Binding var listEntradas : [Entrada]
    @Binding var listCategorias : [Categorias]
    
    @State  var entrada : Entrada
    @State  var SelectedCategoria : Categorias? //Categoria actualmente seleccionada, nil significa listar todas las entradas
    
    @State private var entradaForModif : Entrada? = nil //La entrada a modificar
    @State private var selectedEntradaForDelete : Entrada? //carga la entrada que se eliminará
    
    
    @State private var expandContent = false
    @State private var showConfirmDialogDelete = false
    
    //Devuele la lista de imágines de una entrada como un arreglo
    private var getListOfImages : [UIImage]{
        return []
    }
    
    var body: some View {
        VStack{
            HStack{
                //icono
                VStack{
                    Image(path: entrada.icono ?? "tags").imageIcono()
                }
                
                Spacer()
                
                //entrada & Categoría
                VStack(alignment: .leading){
                    Button{
                        //EntradaContentView(entrada: entrada)
                        withAnimation {
                            expandContent.toggle()
                        }
                        
                    }label:{
                        Text(AESModel().aesGCMDec(strEnc: entrada.title ?? ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    
                    
                    //Categoria:
                    if entrada.categ != nil {
                        Text(AESModel().aesGCMDec(strEnc: entrada.categ?.categoria ?? ""))
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .fontDesign(.serif)
                    }else{ //Si la categoria es nil permitir ponerle una entrada a la categoría
                        HStack{
                            //Text("Sin Categría")
                            Menu("Asignar Categoria"){
                                
                                ForEach  (CRUDModel().getListOfCateg(), id:\.categoria) { i in
                                    Button{
                                        if  CRUDModel().modifEntrada(entrada: entrada, categoria: i, title: nil, entradaText: nil, image: nil, isfav: nil, icono: nil){
                                            withAnimation {
                                                self.refresListEntradas.toggle()
                                            }
                                            
                                        }
                                    }label: {
                                        HStack{
                                            Image(path: i.icono ?? "")
                                            Text("\(AESModel().aesGCMDec(strEnc: i.categoria ?? ""))")
                                        }
                                        
                                    }
                                }
                                
                            }
                            .padding(.bottom, 5)
                            .buttonStyle(.bordered)
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, 8)
                
                Spacer()
                
                //Menu:
                VStack{
                    Menu{
                        
                        Button("Modificar"){
                            self.entradaForModif = entrada
                        }
                        Button("Eliminar entrada"){
                            self.selectedEntradaForDelete = entrada
                            showConfirmDialogDelete = true
                        }
                    }label:{
                        Image(systemName: "ellipsis")
                            .frame(width: 30  ,height: 30)
                    }
                }
            }.padding(.horizontal, 10)
            
            //Mostrando el contenido de la entrada
            if self.expandContent {
                HTMLView(txt: AESModel().aesGCMDec(strEnc: entrada.entrada ?? ""))
                    .frame(height: 250)
                
                //Mostrando Galeria de imagines de la entrada
                if self.getListOfImages.count > 0 {
                    ScrollView(.horizontal){
                        HStack(spacing: 30) {
                            ForEach (self.getListOfImages, id: \.self){i in
                                Image(uiImage: i).imageIcono()
                                    .onTapGesture {
                                        //Mostrar la imagen a tamaño completo
                                    }
                            }
                        }.padding(.horizontal)
                    }
                }
                

            }
            

            
            
            
        }
        .confirmationDialog("Eliminar una Entrada", isPresented: $showConfirmDialogDelete) {
            Button("Eliminar entrada", role: .destructive){
                
                if let entrada = self.selectedEntradaForDelete {
                    if  CRUDModel().DeleteRecord(record: entrada){
                        print("Se ha eliminado la entrada")
                        withAnimation {
                            if let categ = SelectedCategoria {
                                self.listEntradas = CRUDModel().getListOfEntradas(categoria: categ)
                            }else{
                                self.listEntradas = CRUDModel().getAllListOfEntradas()
                            }
                        }
                        self.updateHome += 1
                        
                    }
                }
            }
        }message: {
            Text("¿Seguro que desea eliminar la entrada? \n Esta acción no puede deshacerse")
        }
        .sheet(item: self.$entradaForModif) { entrada2 in //Modificar la entrada: hay que dar el parámetro entradaForModif
            AddEntradaView(listCateg: self.$listCategorias, updateHome: $updateHome, refresListEntradas: $refresListEntradas, entradaForModif: entrada2 )
                
        }
        .background(Color("yor"))
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal,10)
    }
}






#Preview {
    ListEntradasView(updateHome: .constant(1), categoria: CRUDModel().getListOfCateg().randomElement())
}
