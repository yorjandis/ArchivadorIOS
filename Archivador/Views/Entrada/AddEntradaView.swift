//
//  AddEntradaView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//Crea y Modifica una entrada

import SwiftUI
import CoreData

struct AddEntradaView: View {
    
    @Environment(\.dismiss) var dimiss
    @Binding var listCateg : [Categorias]
    @Binding var updateHome : Int8 //Permite actualizar la home()
    @Binding var refresListEntradas: Bool //Permite actualizar la lista de entrada
    @State var selectedCateg : Categorias? //Si viene de Home() tendrá una categoria
    @State var entradaForModif : Entrada? = nil //Si se da es para modificar la entrada
    @State private var textFieldTitulo = ""
    @State private var textFieldEntrada = ""
    @State private var icono : String = "apple"
    @State private var fav = false
    
    @State private var img1 : UIImage? //Imagen adjunta opcional
    @State private var img2 : UIImage? //Imagen adjunta opcional
    @State private var img3 : UIImage? //Imagen adjunta opcional
    @State private var img4 : UIImage? //Imagen adjunta opcional
    
    @State private var colorText : Color = .primary
    @State private var showSheetAddCateg = false
    @State private var showSheetSelectIcono = false
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing:30){
                //Categoría
                VStack{
                    HStack{
                        //Construir un menu para escoger las categorias
                        if !listCateg.isEmpty {
                            Menu{
                                ForEach(listCateg){ categ in
                                    Button{
                                        self.selectedCateg = categ
                                    }label: {
                                        Label {
                                            Text(AESModel().aesGCMDec(strEnc: categ.categoria ?? ""))
                                        } icon: {
                                            Image(path: categ.icono ?? "tags").imageIcono()
                                        }
                                        
                                    }
                                }
                                //Opción de crear nueva categoria
                                Button("Crear Nueva categoría..."){
                                    showSheetAddCateg = true
                                }
                            }label: {
                                if self.selectedCateg != nil {
                                    Label {
                                        Text( "\(AESModel().aesGCMDec(strEnc: self.selectedCateg?.categoria ?? ""))...")
                                        
                                    } icon: {
                                        Image(path: self.selectedCateg?.icono ?? "tags").imageIcono()
                                    }
                                    
                                }else{
                                    Text("Seleccione Categoría...")
                                }
                                
                            }.frame(maxWidth: .infinity, alignment: .center)
                        }else{ //Si la lista de categoria está vacia: hay que crear nueva Categoría
                            NavigationLink{
                                AddCategView(updateHome: $updateHome, categoria: $selectedCateg)
                            }label: {
                                Label("Crear Nueva Categoría", systemImage: "folder.badge.plus")
                            }.frame(maxWidth: .infinity, alignment: .center).padding(.top, 15)
                            
                        }
                        Spacer()
                        
                        
                    }
                }
                .task {
                    self.listCateg = CRUDModel().getListOfCateg()
                }
                
                
                //Título, icono y favorito
                VStack {
                    HStack(spacing: 10){
                        Button{
                            showSheetSelectIcono = true
                        }label: {
                            Image(path: self.icono).imageIcono()
                        }
                        TextField("⚠️ Nuevo título", text: $textFieldTitulo, axis: .vertical)
                        Toggle("Favorito", isOn: $fav).frame(maxWidth: 120)
                    }.padding(.horizontal, 5)
                }
                
                
                //Texto de la entrada
                VStack{
                    TextField("⚠️ Texto de la entrada", text: $textFieldEntrada, axis: .vertical)
                        .font(.title)
                        .padding(.horizontal)
                }
                
                //Imagen Adjunta:
                HStack{
                    
                    Menu{
                        if let img = self.img1 {
                            NavigationLink("Mostrar..."){
                                VisorImagenView(image: img)
                            }
                        }
                        NavigationLink("Cargar De Galería..."){
                            GetImageFromGalleryView(image: self.$img1)
                        }
                        NavigationLink("Cargar De Cámara..."){
                            GetImageFromCameraView(image: self.$img1)
                        }
                        
                        
                        //Permite hacer ocr sobre la imagen
                        if let img = self.img1 {
                            NavigationLink("Entraer Texto..."){
                                OcrView(imageSelected: img)
                            }
                        }
                        
                        //Permitir almacenar la imagen en la galeria
                        if let img = self.img1 {
                            ShareLink(item:Image(uiImage: img), preview: SharePreview("Archivador", image: Image(uiImage: img)))
                        }
                        
                        //Guardar en galeria:
                        if let img = self.img1 {
                            Button("Guardar en Galeria"){
                                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                            }
                        }
                        if self.img1 != nil {
                            Button{
                                self.img1 = nil
                            }label:{
                                Text("Eliminar Imagen").foregroundStyle(.red)
                            }
                        }
                        
                        
                    }label: {
                        Image(uiImage: (self.img1 != nil ? self.img1 : UIImage(systemName: "photo")!) ?? UIImage(systemName: "photo")! )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .white, radius: 2)
                            .padding(.horizontal)
                    }
                    
                    //-----------
                    
                    Menu{
                        if let img = self.img2 {
                            NavigationLink("Mostrar..."){
                                VisorImagenView(image: img)
                            }
                        }
                        NavigationLink("Cargar De Galería..."){
                            GetImageFromGalleryView(image: self.$img2)
                        }
                        NavigationLink("Cargar De Cámara..."){
                            GetImageFromCameraView(image: self.$img2)
                        }
                        
                        
                        //Permite hacer ocr sobre la imagen
                        if let img = self.img2 {
                            NavigationLink("Entraer Texto..."){
                                OcrView(imageSelected: img)
                            }
                        }
                        
                        //Permitir almacenar la imagen en la galeria
                        if let img = self.img2 {
                            ShareLink(item:Image(uiImage: img), preview: SharePreview("Archivador", image: Image(uiImage: img)))
                        }
                        
                        //Guardar en galeria:
                        if let img = self.img2 {
                            Button("Guardar en Galeria"){
                                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                            }
                        }
                        
                        if self.img2 != nil {
                            Button{
                                self.img2 = nil
                            }label:{
                                Text("Eliminar Imagen").foregroundStyle(.red)
                            }
                        }
                        
                    }label: {
                        Image(uiImage: (self.img2 != nil ? self.img2 : UIImage(systemName: "photo")!) ?? UIImage(systemName: "photo")! )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .white, radius: 2)
                            .padding(.horizontal)
                    }
                    
                    //-------------
                    
                    Menu{
                        if let img = self.img3 {
                            NavigationLink("Mostrar..."){
                                VisorImagenView(image: img)
                            }
                        }
                        NavigationLink("Cargar De Galería..."){
                            GetImageFromGalleryView(image: self.$img3)
                        }
                        NavigationLink("Cargar De Cámara..."){
                            GetImageFromCameraView(image: self.$img3)
                        }
                        
                        
                        //Permite hacer ocr sobre la imagen
                        if let img = self.img3 {
                            NavigationLink("Entraer Texto..."){
                                OcrView(imageSelected: img)
                            }
                        }
                        
                        //Permitir almacenar la imagen en la galeria
                        if let img = self.img3 {
                            ShareLink(item:Image(uiImage: img), preview: SharePreview("Archivador", image: Image(uiImage: img)))
                        }
                        
                        //Guardar en galeria:
                        if let img = self.img3 {
                            Button("Guardar en Galeria"){
                                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                            }
                        }
                        
                        if self.img3 != nil {
                            Button{
                                self.img3 = nil
                            }label:{
                                Text("Eliminar Imagen").foregroundStyle(.red)
                            }
                        }
                        
                    }label: {
                        Image(uiImage: (self.img3 != nil ? self.img3 : UIImage(systemName: "photo")!) ?? UIImage(systemName: "photo")! )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .white, radius: 2)
                            .padding(.horizontal)
                    }
                    
                    //-------------
                    
                    Menu{
                        if let img = self.img4 {
                            NavigationLink("Mostrar..."){
                                VisorImagenView(image: img)
                            }
                        }
                        NavigationLink("Cargar De Galería..."){
                            GetImageFromGalleryView(image: self.$img4)
                        }
                        NavigationLink("Cargar De Cámara..."){
                            GetImageFromCameraView(image: self.$img4)
                        }
                        
                        
                        //Permite hacer ocr sobre la imagen
                        if let img = self.img4 {
                            NavigationLink("Entraer Texto..."){
                                OcrView(imageSelected: img)
                            }
                        }
                        
                        //Permitir almacenar la imagen en la galeria
                        if let img = self.img4 {
                            ShareLink(item:Image(uiImage: img), preview: SharePreview("Archivador", image: Image(uiImage: img)))
                        }
                        
                        //Guardar en galeria:
                        if let img = self.img4 {
                            Button("Guardar en Galeria"){
                                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                            }
                        }
                        
                        if self.img4 != nil {
                            Button{
                                self.img4 = nil
                            }label:{
                                Text("Eliminar Imagen").foregroundStyle(.red)
                            }
                        }
                        
                    }label: {
                        Image(uiImage: (self.img4 != nil ? self.img4 : UIImage(systemName: "photo")!) ?? UIImage(systemName: "photo")! )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .white, radius: 2)
                            .padding(.horizontal)
                    }
                    
                    //------- fin de imagen Adjunta
                    
                    
                    Spacer()
                }
                
                
                Spacer()
                
            }
            .foregroundStyle(.white)
            .navigationTitle(entradaForModif == nil ? "Crear nueva Entrada" : "Actualizar Entrada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Menu{
                        NavigationLink{
                            OcrView()
                        }label:{
                            Label("Extraer Texto de imagen", systemImage: "text.viewfinder")
                        }
                        NavigationLink{
                            QRReadView()
                        }label:{
                            Label("Leer QR", systemImage: "qrcode.viewfinder")
                        }
                        
                        NavigationLink{
                            GenerateQRView(texto: "\(self.textFieldTitulo) \n \(self.textFieldEntrada)")
                        }label:{
                            Label("Generar QR", systemImage: "qrcode")
                            
                        }
                    }label: {
                        Image(systemName: "ellipsis").foregroundStyle(.white)
                    }
                }
                
                //Botón Adicionar Entrada / Actualizar Entrada
                ToolbarItem(placement: .bottomBar) {
                    Button(entradaForModif == nil ? "Guardar" : "Actualizar"){
                        if entradaForModif == nil { //Guardar...Crear nueva entrada
                            if let categ = self.selectedCateg {
                                if CRUDModel().AddEntrada(title: textFieldTitulo,
                                                          entrada: textFieldEntrada,
                                                          categoria: categ,
                                                          imageData: CRUDModel().GenerateImageDataArray(img1: self.img1, img2: self.img2, img3: self.img3, img4: self.img4),
                                                          isfav: self.fav,
                                                          icono: self.icono) != nil{
                                    self.updateHome += 1 //Actualizando home()
                                    self.refresListEntradas.toggle()//Actualizando la lista de Entradas
                                    dimiss()
                                }else{
                                    print("Error al guardar la entrada")
                                }
                            }
                        }else{ //Actualizar entrada
                            if  CRUDModel().modifEntrada(entrada: entradaForModif,
                                                         categoria: self.selectedCateg,
                                                         title: self.textFieldTitulo,
                                                         entradaText: self.textFieldEntrada,
                                                         imageData: CRUDModel().GenerateImageDataArray(img1: self.img1, img2: self.img2, img3: self.img3, img4: self.img4),
                                                         isfav: self.fav,
                                                         icono: self.icono){
                                
                                print("Se ha actualizado la entrada")
                                self.updateHome += 1 //Actualizando home()
                                self.refresListEntradas.toggle()//Actualizando la lista de Entradas
                                dimiss()
                            }else{
                                print("Ha ocurrido un error al actualizar la entrada")
                            }
                            
                        }
                    }
                    .foregroundStyle(.white)
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                    .disabled(self.textFieldTitulo.isEmpty || self.textFieldEntrada.isEmpty ? true : false)
                    
                }
                
                
                
            }
            .sheet(isPresented: $showSheetAddCateg, content: {
                AddCategView(updateHome: $updateHome, categoria: self.$selectedCateg)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $showSheetSelectIcono) {
                ListOfImagesView(image: $icono)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
            .task { //Para modificar la entrada...Cargando los valores
                if let entrada = self.entradaForModif {
                    self.selectedCateg = entrada.categ
                    self.textFieldTitulo =  AESModel().aesGCMDec(strEnc: entrada.title ?? "")
                    self.textFieldEntrada = AESModel().aesGCMDec(strEnc: entrada.entrada ?? "")
                    self.icono = entrada.icono ?? ""
                    self.fav = entrada.isfav
                    //Cargar el listado de imagenes adjunta
                    let array = CRUDModel().getListImage(entrada: entrada)
                    if !array.isEmpty {
                        for i in 0...array.count-1{
                            if i == 0 {
                                if self.img1 == nil {self.img1 = array[0] }
                            }
                            if i == 1 {
                                if self.img2 == nil {self.img2 = array[1] }
                            }
                            if i == 2 {
                                if self.img3 == nil {self.img3 = array[2] }
                            }
                            if i == 3 {
                                if self.img4 == nil {self.img4 = array[3] }
                            }
                        }
                    }
                }
                
            }.preferredColorScheme(.dark)
        } 
    }
    
}





#Preview {
    AddEntradaView(listCateg: .constant([Categorias]()), updateHome: .constant(1), refresListEntradas: .constant(true))
}
