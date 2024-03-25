//
//  ModifCategView.swift
//  ArchivadorWatch Watch App
//
//  Created by Yorjandis Garcia on 22/3/24.
//

import SwiftUI
import CoreData

struct ModifCategView_W: View {
    @Binding var categoria : Categorias? //esta es la categoria a modificar
    @State private var nombreCateg : String = ""
    @State private var icono : String = "\(Utils.imgEntradagDef)" //Pasado como binding
    @State private var isfav : Bool = false //Pasado como binding
    private let context = PersistenceController.shared.context
    @State private var showAlert = false
    @State private var alertMessaje = ""
    @Environment(\.dismiss) var dismissP
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    TextField("Nombre", text: self.$nombreCateg)
                    NavigationLink{
                        ListOfImagesView(image: self.$icono)
                    }label: {
                        Image(path: self.icono).imageIcono()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 40)
                }
                
                HStack{
                    Toggle("Favorito", isOn: self.$isfav)
                        .frame(width: 120)
                    Spacer()
                }
                Button("Adicionar"){
                    if modif_Categ() {
                        self.alertMessaje = "Modificado!"
                        self.showAlert = true
                        dismissP()
                    }else{
                        self.alertMessaje = "Error al modificar!"
                        self.showAlert = true
                    }
                }
                .foregroundColor(.black).bold()
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .navigationTitle("Modificar Categoría")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: self.$showAlert, content: {
                Alert(title: Text("Archivador"), message: Text(self.alertMessaje))
            })
        }
    }
    
    func modif_Categ()->Bool{
        if self.categoria == nil {return false}
        if nombreCateg.isEmpty {return false}
        
        self.categoria!.categoria = AESModel().aesGCMEnc(str: self.nombreCateg)
        self.categoria!.icono = self.icono
        self.categoria!.isfav = self.isfav
        do{
            try context.save()
            return true
        }catch{
            return false
        }
    }
}

#Preview {
    ModifCategView_W(categoria: .constant(nil))
}
