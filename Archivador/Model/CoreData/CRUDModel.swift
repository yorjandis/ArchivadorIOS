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
    func addCategoria(categoria: String, isfav : Bool = false, nota: String = "", icono: String = "")->Categorias?{
        
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
        row.icono = icono
        
        do{
            try context.save()
            return  row
        }catch{
            return nil
        }
    }

    ///Adiciona una nueva entrada
    /// - Returns - Devuelve true si la operación ha sido exitosa
    func AddEntrada(title : String, entrada : String, categoria : Categorias?, image : String = "", isfav : Bool = true, icono:String = "")->Entrada?{
        let row : Entrada = Entrada(context: context)
        
        //Una entrada debe pertenecer a una categoria
        if let Categoria = categoria {
            row.id = UUID().uuidString
            row.title = AESModel().aesGCMEnc(str: title)
            row.categ = Categoria
            row.entrada = AESModel().aesGCMEnc(str: entrada)
            row.image = AESModel().aesGCMEnc(str: image) //Imagen en formato String64 para guardar
            row.isfav = isfav
            row.icono = icono
            
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
    
    
    ///Elimina un registro
    /// - Returns - Devuelve true si la operación ha sido exitosa
    func DeleteRecord(record : NSManagedObject)->Bool{
        do{
            context.delete(record)
            try context.save()
            return true
        }catch{
            return false
        }
    }
    
    ///Elimina las entradas sin categoria
    /// - Returns - Devuelve true si la operación ha sido exitosa
    func DeleteAllEntradasSinCateg()->Bool{
        let fetchRequest : NSFetchRequest<Entrada> = Entrada.fetchRequest()
        let arrayForDelete : [Entrada] = getEntradasSinCateg()
        
        if !arrayForDelete.isEmpty { //Si el arreglo contiene elementos a eliminar
            do{
                try context.save()
                return true
            }catch{
                return false
            }
        }else{
            return false
        }
    }
  
    ///Elimina todas las entradas para una categoria dada
    /// - Returns - Devuelve true si la operación ha sido exitosa
    func DeleteAllEntradasForCateg(categoria: Categorias)->Bool {
        let fetchRequest : NSFetchRequest<Entrada> = Entrada.fetchRequest()
        var arrayForDelete : [Entrada] = getListOfEntradas(categoria: categoria)
         
        if !arrayForDelete.isEmpty { //Si el arreglo contiene elementos a eliminar
            do{
                try context.save()
                return true
            }catch{
                return false
            }
        }else{
            return false
        }
    }
    
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
    
    ///Devuelve todas las entradas de la tabla
    func getAllListOfEntradas()->[Entrada]{
        let fetchRequest : NSFetchRequest<Entrada> = Entrada.fetchRequest()
        
        do{
            return try self.context.fetch(fetchRequest)
        }catch{
            return []
        }
    }
    
    ///Devuelve solo las entradas sin categorias
    func getEntradasSinCateg()->[Entrada]{
        let fetchRequest : NSFetchRequest<Entrada> = Entrada.fetchRequest()
        var result : [Entrada] = []
        
        do{
            let temp =  try context.fetch(fetchRequest)
            for i in temp{
                if i.categ == nil {
                    result.append(i)
                }
            }
            return result
        }catch{
            return result
        }
    }
    
    ///Modificar una categoría
    func modifCategoria(categoria: Categorias, categoriaLabel: String?, isfav : Bool?, nota: String?, icono: String?)->Bool{
        if categoriaLabel != nil {categoria.categoria = AESModel().aesGCMEnc(str: categoriaLabel ?? "")}
        if isfav != nil { categoria.isfav = isfav ?? false}
        if nota != nil {categoria.nota = AESModel().aesGCMEnc(str: nota ?? "")}
        if icono != nil { categoria.icono = icono ?? "tags"}
        
        do{
            try context.save()
            return true
        }catch{
            return false
        }
    }
    
    
    
    ///Modificar una entrada
    func modifEntrada(entrada: Entrada, title : String?, entradaText : String?, categoria : Categorias?, image : String?, isfav : Bool?, icono:String?)->Bool{
        if title != nil { entrada.title = AESModel().aesGCMEnc(str: title ?? "")}
        if entradaText != nil { entrada.entrada = AESModel().aesGCMEnc(str: entradaText ?? "")}
        if categoria != nil { entrada.categ = categoria}
        if image != nil {print("Yorjandis hacer la función para almacenar una imagen en formato cadena")}
        if isfav != nil {entrada.isfav = isfav ?? false}
        if icono != nil {entrada.icono = icono ?? "documents"}
        do{
            try context.save()
            return true
        }catch{
            return false
        }
    }
}
