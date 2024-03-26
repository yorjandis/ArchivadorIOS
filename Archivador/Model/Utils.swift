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



//Almacenamiento en KeyChain (Llavero)
struct KeychainManager{
    
    static let label : String = "Yorjandis" //Para localizar la contraseña dentro del llavero

    func addPass(pass : String)->Bool{
        if pass.isEmpty {return false}
        
        let password = pass.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String : KeychainManager.label,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Se Almacenó la contraseña")
            return true
        }else{//error
            print("Ocurrió un error al almacenar la contraseña")
            return false
        }
    }
    
    
    func getPass()->String{
        //Diccionario de consulta:
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: KeychainManager.label,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true, //No se devuelve el atributo label en el resultado
                                    kSecReturnData as String: true]
        
        
        //Iniciando la consulta....
        var item: CFTypeRef? //Donde se almacenará el resultado
        
       let status =  SecItemCopyMatching(query as CFDictionary, &item)
        
        if  status != errSecItemNotFound {
            //OKOKOOK
            
            //Extrayendo los resultados
            guard let existingItem = item as? [String : Any],
                  let passwordData = existingItem[kSecValueData as String] as? Data,
                  let password = String(data: passwordData, encoding: String.Encoding.utf8)//,
                  //let account = existingItem[kSecAttrLabel as String] as? String
                    
            else {
                print("Ocurrio un error al extraer la contaseña")
                return ""
              
            }
            print("Devolviendo la contraseña...\(password)")
            return password //Devolviendo la Contraseña
            
            
        }else{//No se encontró la clave...La clave no existe en la BD
            print("No se encontró la clave: \(status)")
        }
        
        
        //Otra verificación de errores....
        if status == errSecSuccess {
            //OKOKOKOK
        }else{
            //Error sin manejar
            print("Error no manejable: \(status)")
        }
        
        
        return ""
    }
    
    
    
    func modifPass( oldPass : String ,newPass: String)->Bool{
        //Verificando que la contraseña antigua sea la correcta
        let oldPassTemp = getPass()
        if oldPass == oldPassTemp {
            //okokok
            print("La contraseña antigua coincide! pasando a actualizar...")
            
            //info: Para actualizar un elemento del llavero primero debe encontrarlo...
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrLabel as String: KeychainManager.label]
            
            let newPassword = newPass.data(using: String.Encoding.utf8)!
            let attributes: [String: Any] = [kSecAttrAccount as String: KeychainManager.label,
                                             kSecValueData as String: newPassword]
            
            //Actualizando....
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            
            //Verificando la operacion
            if status != errSecItemNotFound {
                //OKKOKOO
                print("la contraseña se cambió correctamente")
                return true
            }else{
                //Error al actualizar la contraseña
                print("Error al actualizar la contraseña")
                return false
            }
            
            //Otra verificación de errores...No es necesaria
            //if  status == errSecSuccess {
                //okokokook
            //}else{
                ///Error...
            //}
            
            
        }else{
            print("La contraseña antigua no es válida")
            return false
        }
    }
    
    
    func deletePass()->Bool{
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: KeychainManager.label]
        
        let status = SecItemDelete(query as CFDictionary)
        
        //Verificando la operacion
        if status != errSecItemNotFound {
            //OKKOKOO
            print("la contraseña se eliminó correctamente")
            return true
        }else{
            //Error al actualizar la contraseña
            print("Error al eliminar la contraseña")
            return false
        }

    }
    
}


