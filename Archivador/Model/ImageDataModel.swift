//
//  ImageDataMNodel.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 15/3/24.
//Util para convertir una imagen a data y viceversa


import SwiftUI


struct ImageDataModel{
    ///Convertir una UUImage a Data:
    func UIIMageToData(image : UIImage?)->Data?{
        if let img = image {
            //Añadienfo un byte al inicio para hacer ilegible el contenido en Core Data
            let prefix : [UInt8] = [6] //Prefijo que será añadido
            var temp = img.jpegData(compressionQuality: 0.2)!.bytes //obtiene el arreglo de bytes
            temp.insert(contentsOf: prefix, at: 0) //insertando el prefijo
            
            //Devolviendo el resultado:
            return Data(bytes: temp, count: temp.count)
        }else{
            return nil
        }
    }
    
    //Convertir un Data a UIImage
    func DataToUIImage(data : Data)->UIImage?{
        //Eliminando el primer byte que se ha añadido para volver hacer legible el contenido
        var temp = data.bytes //Obtiene el arreglo de bytes
        temp.removeFirst() //Elimina el primer byte (es un relleno que se puesto para hacer ilegible el contenido)
        let dataTemp = Data(bytes: temp, count: temp.count) //obteniendo el Data legible
        
        //Convirtiendo el data en UIimage:
        let imgTemp = UIImage(data: dataTemp)
        if let img = imgTemp {
            return img
        }else{
            return nil
        }
    }
    
    
    
    
    
    
}
