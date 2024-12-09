//
//  GenerateQrCode.swift
//  brichios
//
//  Created by Mac Mini 2 on 9/12/2024.
//

import Foundation
import SwiftUI

import SwiftUI

struct QRGeneratorView: View {
    var text: String // Propriété pour recevoir le texte
    var body: some View {
        VStack {
            if let qrCodeData = getQRCodeData(text: text), // Générer les données QR
               let qrCodeImage = UIImage(data: qrCodeData) { // Créer l'image QR
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Text("Invalid input") // Message d'erreur si l'entrée est invalide
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    func getQRCodeData(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciImage.transformed(by: transform)
        return UIImage(ciImage: scaledCIImage).pngData() // Renvoie les données PNG de l'image générée.
    }
}
