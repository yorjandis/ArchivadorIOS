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
    @State private var refresListEntradas = false //Permite crear la lista de entrada de nuevo
    
    @State var showConfirmDialogDelete = false
    @State var selectedEntradaForDelete : Entrada?

    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack{
                    //Categorias
                    VStack{
                        Menu{
                            Button("Todas las Entradas"){
                                self.categoria = nil
                                self.refresListEntradas.toggle()
                            }
                            Button("Entradas sin Categorías"){
                                self.categoria = nil
                                self.listEntradas = CRUDModel().getEntradasSinCateg()
                            }
                            ForEach(listCategorias){categ in
                                Button{
                                    self.categoria = categ
                                    self.refresListEntradas.toggle()
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
                    .padding(.top, 8)
                    .onAppear{
                            self.refresListEntradas.toggle()
                    }
                    
                }
                    
                    Spacer()
                    
                    //Entradas
                    VStack{
                        ScrollView{
                            ForEach(listEntradas){ entrada in
                                VStack{
                                    HStack{
                                        //icono
                                        VStack{
                                            Image(path: entrada.icono ?? "tags").imageIcono()
                                        }
                                        
                                        Spacer()
                                        
                                        //entrada & Categoría
                                        VStack(alignment: .leading){
                                            NavigationLink{
                                                EntradaContentView(entrada: entrada)
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
                                                    Button("Asignar Categoria"){
                                                        
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
                                                
                                                Button("Modificar"){}
                                                
                                                Button("Cambiar de Categoría"){}
                                                
                                                Button("Eliminar entrada"){
                                                    self.selectedEntradaForDelete = entrada
                                                    showConfirmDialogDelete = true
                                                }
                                            }label:{
                                                Image(systemName: "ellipsis")
                                                    .frame(width: 30  ,height: 30)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 10)

                                }
                                .background(Color("yor"))
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .padding(.horizontal,10)
                            }
                        }
                        .confirmationDialog("Eliminar una Entrada", isPresented: $showConfirmDialogDelete) {
                            Button("Eliminar entrada", role: .destructive){
                                
                                if let entrada = self.selectedEntradaForDelete {
                                    if  CRUDModel().DeleteRecord(record: entrada){
                                        print("Se ha eliminado la entrada")
                                        withAnimation {
                                            if let categ = self.categoria {
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
                            Text("Esta acción no puede deshacerse")
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
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
            .navigationTitle("Lista de Entradas")
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
    }
    
}






#Preview {
    ListEntradasView(updateHome: .constant(1), categoria: CRUDModel().getListOfCateg().randomElement())
}
