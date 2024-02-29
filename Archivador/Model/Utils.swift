//
//  Utils.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 22/2/24.
//

import Foundation
import SwiftUI


struct Utils {
    
    ///Devuelve un arreglo de String con los nombres de ficheros txt dentro del bundle según un prefijo (el prefijo se extrae de parametro de entrada)
    /// - Parameter type : Tipo de contenido a indexar. Se toma de un enum
    func  FilesListToArray()-> [String] {
        var result = [String]()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasSuffix("png") {
                    if item.hasPrefix("AppIcon") {continue}
                    result.append(item)
                }
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
        return result
        
    }
}

//Extensión de imagen para cargar una imagen desde el bundle
//forma de utilizar: Image(path: "apple")
extension Image {
    init(path: String) {
        if !path.isEmpty{
            self.init(uiImage: UIImage(named: path)!)
        }else{
            self.init(systemName: "blank")
        }
        
    }
}


extension Image {
    
    func imageIcono() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(height: 30)
    }
}
