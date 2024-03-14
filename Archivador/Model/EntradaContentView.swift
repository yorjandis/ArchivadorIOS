//
//  EntradaContentView.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 28/2/24.
//
//Visualiza texto en un formato HTML. Opcionalmente se puede dar un tamaño al texto y especificar un caracter separador de linea (por defecto es &&)

import SwiftUI
import WebKit



struct HTMLView: UIViewRepresentable {
    var txt: String //Texto a mostrar
    var fontSize : CGFloat = 60 //Tamaño de letra
    var lineBreak = "&&" //define un caracter como salto de linea intercalado (opcional en el texto a mostrar)
    
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        var temp = "\(lineBreak)\(self.txt)"
        temp = temp.replacingOccurrences(of: "\n", with: "\(lineBreak)")
        
        //Convierte el texto en parrafos con saltos de lineas en cada ocurrencia de &&
        let temp2 = temp.replacingOccurrences(of: "\(self.lineBreak)", with: "<p style='font-size:\(self.fontSize);'>" )
        let temp3 = setText(text: temp2)
        uiView.loadHTMLString(temp3, baseURL: nil)
    }
    
    //Formatea el texto para ser mostrado
    private func setText(text : String)->String{
        let result = "<html <body style=\"background-color:lightgrey\"> \(text)</body> </html>"
        return result
    }
}

