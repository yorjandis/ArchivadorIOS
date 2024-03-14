//
//  QRModel.swift
//  Archivador
//
//  Created by Yorjandis Garcia on 12/3/24.
//


import SwiftUI
import CoreImage.CIFilterBuiltins
import AVFoundation

struct QRModel{
    ///Función que genera el QR de un texto
    /// - Parameters - text: El texto a convertir
    ///  - Returns - devuelve un objeto UIImage o nil si fracasa
    func generateQRCode(text: String) -> UIImage? {
        
        if text.count >= 4296  {return nil}
        
        let filter = CIFilter.qrCodeGenerator()
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return nil }
        filter.message = data
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        
        if let data = uiimage.pngData() {
            return UIImage(data: data)!
        }else{
            return nil
        }
    }
    
    ///Lee una imagen QR y Muestra el texto:image = generateQR()
    /// - Parameter - image : La imagen a leer
    func readQR(image : UIImage) -> [String] {
        guard let imagen = CIImage(image: image) else {
            return []
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        let features = detector?.features(in: imagen) ?? []
        
        return features.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }
    }
    
    
    
    
    
}








