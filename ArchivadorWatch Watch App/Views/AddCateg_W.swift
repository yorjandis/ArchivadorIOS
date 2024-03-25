//
//  AddCateg_W.swift
//  ArchivadorWatch Watch App
//
//  Created by Yorjandis Garcia on 20/3/24.
//

import SwiftUI
import CoreData

struct AddCateg_W: View {
    @State private var nombreCateg : String = ""
    @State private var icono : String = "document" //Pasado como binding
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
                    if AddCateg() {
                        self.alertMessaje = "Guardado!"
                        self.showAlert = true
                        dismissP()
                    }else{
                        self.alertMessaje = "Error al guardar!"
                        self.showAlert = true
                    }
                }
                .foregroundColor(.black).bold()
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .navigationTitle("Adicionar Categoría")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: self.$showAlert, content: {
                Alert(title: Text("Archivador"), message: Text(self.alertMessaje))
            })
        }
    }
    
    func AddCateg()->Bool{
        if nombreCateg.isEmpty {return false}
        let item : Categorias = Categorias(context: self.context)
        item.categoria = AESModel().aesGCMEnc(str: self.nombreCateg)
        item.icono = self.icono
        item.isfav = self.isfav
        do{
            try context.save()
            return true
        }catch{
            return false
        }
    }
}

#Preview {
    AddCateg_W()
}
