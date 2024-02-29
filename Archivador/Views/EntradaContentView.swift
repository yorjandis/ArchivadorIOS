//
//  EntradaContentView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 28/2/24.
//

import SwiftUI
import CoreData
import WebKit

struct EntradaContentView: View {
    
    @State var entrada : Entrada?
    
    var body: some View {
        VStack{
            
            if let entra = self.entrada {
                
                    Image(path: entra.icono ?? "").imageIcono()
                    Text( "\(AESModel().aesGCMDec(strEnc: entra.title ?? ""))"  )
                    Text( "(\(AESModel().aesGCMDec(strEnc: entra.categ?.categoria ?? "")))")
                VStack{
                    HTMLView(txt: AESModel().aesGCMDec(strEnc: entra.entrada ?? "") )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }else{
                Text("Nada que mostrar!").fontDesign(.serif)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .background(
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
        //.ignoresSafeArea()
    }
}


struct HTMLView: UIViewRepresentable {
    var txt: String
    var fontSize : CGFloat = 60
    var lineBreak = "&&" //define un caracter como salto de linea intercalado
    
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        var temp = "\(lineBreak)\(self.txt)"
        temp = temp.replacingOccurrences(of: "\n", with: "\(lineBreak)")
        
        //Convierte el texto en parrafos con saltos de lineas en cada ocurrencia de &&
        let temp2 = temp.replacingOccurrences(of: "\(self.lineBreak)", with: "<p style='font-size:\(self.fontSize);'>" )
        uiView.loadHTMLString(temp2, baseURL: nil)
    }
}


#Preview {
    EntradaContentView()
}
