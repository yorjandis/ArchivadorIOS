//
//  PasswordGenerateView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 11/3/24.
//Genera una combinación de contraseñas

import SwiftUI

struct PasswordGenerateView: View {
    @State private var texto : String = ""
    @State private var length : Int8 = 16
    @State private var showPass = false
    
    
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                        ZStack{
                            Text(self.texto)
                                .opacity(showPass ? 1 : 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            SecureField("", text: $texto)
                                .opacity(showPass ? 0 : 1)
                        }
                    Spacer()
                    Button{
                        showPass.toggle()
                    }label: {
                        Image(systemName: showPass ? "eye.slash.fill"  : "eye.fill")
                    }.padding(.horizontal)
                    Button("Copiar"){
                            UIPasteboard.general.string = self.texto
                    }.buttonStyle(BorderedButtonStyle())
                     .background(.cyan)
                     .clipShape(RoundedRectangle(cornerRadius: 20))
                     .disabled(self.texto.isEmpty ? true : false)
                }
                
                HStack {
                    Button{
                        self.texto =  generatePassword(length: self.length)
                    }label:{
                        Image(systemName: "arrow.counterclockwise")
                            .frame(width:120, height: 40)
                            .background(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    
                    Spacer()
                    
                    Stepper("Longitud: \(self.length)", value: $length)
                        .frame(width: 210)
                    
                    
                }.padding(.horizontal)
                Spacer()
                    
            }
            .navigationTitle("Generador de contraseñas")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                self.texto = generatePassword(length: self.length)
            }
        }
        .preferredColorScheme(.dark)
    }  
}

#Preview {
    PasswordGenerateView()
}
