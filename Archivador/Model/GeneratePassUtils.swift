//
//  GeneratePassUtils.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 15/3/24.
//

import Foundation


///Genera una contraseña segura
func generatePassword(length : Int8)->String{
let space : [String] = [".","8","+","A","a","b","$","2","#","5","3", "c","-", "d","O", "e","T", "f","1","7", "g","4", "h","X", "i", "j",";","M", "k","Z","H", "l", "S","m","U", "n", "ñ", "o","B", "p","¿","C","N","Y", ",","(", "q","G", "r","9", "s","?", "t","V", ")","E", ":", "u","K","%","D", "*","v","6","L","_", "w","&", "x","I","P", "y","0", "z","J","Q","R"]
    
    var result = ""
    for _ in 1...length {
        result += space.randomElement()!
    }
    return result
    
}
