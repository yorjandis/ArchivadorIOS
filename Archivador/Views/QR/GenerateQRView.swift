//
//  GenerateQRView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 12/3/24.
//Genera un QR de un texto

import SwiftUI

struct GenerateQRView: View {
    
    @State  var texto : String = ""
    @State private var showPass = false
    @State private var image : UIImage? = nil
    var body: some View {
        NavigationStack {
            VStack {
                
                //QR Image
                
                VStack{
                    Image(uiImage: self.image != nil ? self.image! : UIImage(systemName: "qrcode")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                }.padding(.top, 30)
                    .task {
                        self.image = generateQR()
                    }
               
                VStack {
                    HStack {
                        ZStack {
                            TextField("Texto de entrada", text: $texto, axis: .vertical)
                                .opacity(self.showPass ? 1 : 0)
                            SecureField("Texto de entrada", text: $texto)
                                .opacity(self.showPass ? 0 : 1)
                        }.frame(height: 150).foregroundColor(.white).font(.system(size: 24))
                        Button{
                            showPass.toggle()
                        }label: {
                            Image(systemName: showPass ? "eye.slash.fill"  : "eye.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.orange)
                        }.padding(.horizontal)
                    }
                }.padding(.top, 100)
                
                
                Spacer()
                
            }
            .navigationTitle("Generar QR")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar{
                Button("Generar"){
                        withAnimation {
                            self.image = generateQR()
                        }
                }.buttonStyle(.bordered)
            }
        }
    }
    
    func generateQR()->UIImage{
        if !self.texto.isEmpty {
            if let image = QRModel().generateQRCode(text: self.texto) {
                return image
            }else{
                return UIImage(systemName: "qrcode")!
            }
        }
        return UIImage(systemName: "qrcode")!
    }
    
}

#Preview {
    GenerateQRView(texto: "")
}
