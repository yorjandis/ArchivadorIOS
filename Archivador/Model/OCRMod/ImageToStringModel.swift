//
//  ImageToStringModel.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 8/3/24.
//
 

import SwiftUI
import Vision


struct ImageToStringModel{

    
    ///OCR sobre una imagen
    /// - Parameters -  image: La imagen a escanear
    ///  - Returns - Devuelve el texto de la imagen
    func ocr(image : UIImage?)->String {
        var resultado : String = ""
        
        if let cgImage = image?.cgImage {
            
            // Request handler
            let handler = VNImageRequestHandler(cgImage: cgImage)
            
            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                
                // Parse the results as text
                guard let result = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                
                // Extract the data
                let stringArray = result.compactMap { result in
                    result.topCandidates(1).first?.string
                    
                }
                
                resultado = stringArray.joined(separator: "\n")
                
                // Update the UI
                // DispatchQueue.main.async {
                //    let  recognizedText = stringArray.joined(separator: "\n")
                // }
            }
            
            // Process the request
            recognizeRequest.recognitionLevel = .accurate
            do {
                try handler.perform([recognizeRequest])
            } catch {
                print(error)
            }
            
        }
        
        return resultado
        
    }
    
   

}






