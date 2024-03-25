//
//  Utils.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 22/2/24.
//

import Foundation
import SwiftUI


struct Utils {
    
    //Constantes
    static let imgCategDef = "b_carpeta" //icono por defecto de categoría
    static let imgEntradagDef = "d_documento" //icono por defecto de entrada
    
    static let esPrimeraVez = "esPrimeraVez" //key de userDeafult para saber si es la primera véz que se ejecuta la app
    
    
    
    
    
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
            self.init(path: "\(Utils.imgEntradagDef)")
        }
        
    }
}


//Representa los iconos
extension Image {
    func imageIcono() -> some View {
        self
            .resizable()
            .scaledToFill()
            .padding(0.5)
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            .shadow(radius: 5)
    }
}


//Saber si iCloud esta habilitado
func isIcloudAvailable()async  ->  Bool{
    if FileManager.default.ubiquityIdentityToken != nil {
        return true
    } else {
        return false
    }
}


//Funciones de persistencia en UserDefault
func writeUserDefault(key : String, value : String){
    UserDefaults().set(value, forKey: key)
}
func readUserDefault(key : String)->String?{
    return UserDefaults().string(forKey: key)
}
