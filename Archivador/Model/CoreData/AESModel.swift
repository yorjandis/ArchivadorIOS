//
//  AESModel.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 22/2/24.
//

import Foundation
import CryptoSwift


struct AESModel{
    
    private let key = "bbC2H19lkVbQDfakxcrtNMQdd0FloLy6" // length == 32
    private var iv  = "gqLOHUioQ0QjhuvI" // length == 16

    
   
    
    
    ///Cifrado con GCM
    ///  - Parameter - str : Cadena a cifrar
    ///  - Returns - Devuelve la cadena cifrada, si falla devuelve una cadena vacia
    func aesGCMEnc(str: String)->String{
        do {
            // In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: self.iv.bytes, mode: .combined)
            let aes = try AES(key: key.bytes, blockMode: gcm, padding: .noPadding)
            let encrypted = try aes.encrypt(Array(str.utf8))
           // let tag = gcm.authenticationTag
            return encrypted.toBase64()
        } catch {
            // failed
            return ""
        }
    }
    
    
    ///Descifrado con GCM
    ///  - Parameter - str : Cadena cifrada
    ///  - Returns - Devuelve la cadena descifrada, si falla devuelve una cadena vacia
    func aesGCMDec(strEnc : String)->String{
        
        do {
            // In combined mode, the authentication tag is appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: iv.bytes, mode: .combined)
            let cypher = try AES(key: key.bytes, blockMode: gcm, padding: .noPadding)
            let decrypted = try cypher.decrypt(Array(base64: strEnc))
            return String(data: Data(decrypted), encoding: .utf8) ?? "" //pasando los datos a cadena
            
        } catch {
            // failed
            return ""
        }
        
    }
    
    
    //----------------------------------------------  Mismas funciones pero dando una clave ----------------------------------
   
    ///Encriptar con una clave dada (para las funciones de QR):
    ///La clave dada es el vector IV. debe tener como máximo 16 caracteres
    ///
    func aesGCMEncWitdPass(str: String, pass iv : String)->String{
        do {
            // In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: iv.bytes, mode: .combined)
            let aes = try AES(key: key.bytes, blockMode: gcm, padding: .noPadding)
            let encrypted = try aes.encrypt(Array(str.utf8))
            // let tag = gcm.authenticationTag
            return encrypted.toBase64()
        } catch {
            // failed
            return ""
        }
    }
    
    
    ///Des encriptar con una clave dada (para las funciones de QR):
    ///La clave dada es el vector IV. debe tener como máximo 16 caracteres
    ///
    func aesGCMDecWitdPass(strEnc : String, pass iv : String)->String{
        
        do {
            // In combined mode, the authentication tag is appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: iv.bytes, mode: .combined)
            let cypher = try AES(key: key.bytes, blockMode: gcm, padding: .noPadding)
            let decrypted = try cypher.decrypt(Array(base64: strEnc))
            return String(data: Data(decrypted), encoding: .utf8) ?? "" //pasando los datos a cadena
            
        } catch {
            // failed
            return ""
        }
        
    }
    
    
}





