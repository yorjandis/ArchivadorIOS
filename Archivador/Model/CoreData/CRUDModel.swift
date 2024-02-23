//
//  CRUDModel.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 23/2/24.
//

import Foundation
import CoreData

//Operaciones de la BD

struct CRUDModel {
    let context = PersistenceController.shared.context
 

    
    
    ///Adiciona una nueva categoria. Las categorias no pueden repetirse
    /// - Returns -  Devuelve la categoria recien creada, si falla devuelve nil
    func addCategoria(categoria: String, isfav : Bool = false, nota: String = "")->Categorias?{
        
        //Comprobando si existe una categoria igual en la BD CASE Insensitive
            let categEncript = AESModel().aesGCMEnc(str: categoria)//Encriptar el texto de la categoria
            if categEncript.isEmpty {return nil} //No se pudo encriptar el texto de la categoria...SALE!
            
            let arrayCatgTemp = getListOfCateg() //Obtiene el listado de categorias
            if !arrayCatgTemp.isEmpty { //Si el listado contiene algo...
                let temp = arrayCatgTemp.filter{ $0.categoria?.localizedCaseInsensitiveContains(categEncript) ?? false} //Filtra los item que tienen el campo categ
                if !temp.isEmpty {return nil} //Si el resultado contiene algo: SALE! porque la categoria es la misma
            }
        
        //Si la categoria no existe continua...
        
        let row : Categorias = Categorias(context: context)
        
        row.id = UUID().uuidString
        row.categoria = categEncript
        row.isfav = isfav
        row.nota = nota
        
        do{
            try context.save()
            return  row
        }catch{
            return nil
        }
    }
    
    ///Adiciona una nueva entrada
    /// - Returns - Devuelve true si la operación ha sido exitosa
    func AddEntrada(title : String, entrada : String, categoria : Categorias?, image : String = "", isfav : Bool = true)->Entrada?{
        let row : Entrada = Entrada(context: context)
        
        //Una entrada debe pertenecer a una categoria
        if let Categoria = categoria {
            row.id = UUID().uuidString
            row.title = AESModel().aesGCMEnc(str: title)
            row.categ = Categoria
            row.entrada = AESModel().aesGCMEnc(str: entrada)
            row.image = AESModel().aesGCMEnc(str: image)
            row.isfav = isfav
            
            do{
                try context.save()
                return  row
            }catch{
                return nil
            }
        }else{
            return nil
        }
    }
    
    
    ///Elimina todas las categorias
    
    
    ///Devuelve el listado de categorias
    func getListOfCateg()->[Categorias]{
        let fetchRequest : NSFetchRequest<Categorias> = Categorias.fetchRequest()
        
        do{
            return try self.context.fetch(fetchRequest)
        }catch{
            return []
        }
    }
    
    ///Devuelve el listado de Entradas para una categoria
    func getListOfEntradas(categoria : Categorias)->[Entrada]{
        let fetchRequest : NSFetchRequest<Entrada> = Entrada.fetchRequest()
        var result : [Entrada] = []
        
        do{
            let temp =  try context.fetch(fetchRequest)
            for i in temp{
                if i.categ == categoria {
                    result.append(i)
                }
            }
            return result
        }catch{
            return result
        }
    }
    
    
 
}
