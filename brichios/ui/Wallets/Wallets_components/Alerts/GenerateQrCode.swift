//
//  GenerateQrCode.swift
//  brichios
//
//  Created by Mac Mini 2 on 9/12/2024.
//
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRGeneratorView: View {
    var text: String
       @Environment(\.presentationMode) var presentationMode // To handle the dismissal of the view
       
       var body: some View {
           VStack {
               // Title with Scanner Icon
               HStack {
                   Image(systemName: "qrcode")
                       .font(.largeTitle)
                       .foregroundColor(.blue)
                   Text("Receive Funds")
                       .font(.title)
                       .fontWeight(.bold)
               }
               .padding()

               // QR Code Image
               if let qrCodeImage = generateQRCode(text: text) {
                   Image(uiImage: qrCodeImage)
                       .resizable()
                       .interpolation(.none)
                       .scaledToFit()
                       .frame(width: 200, height: 200)
                       .background(Color.white)
                       .cornerRadius(10)
                       .overlay(
                           RoundedRectangle(cornerRadius: 10)
                               .stroke(Color.blue, lineWidth: 2)
                       )
               } else {
                   Text("Unable to generate QR Code")
                       .foregroundColor(.red)
               }
               
               // Descriptive Text
               Text("Scan this QR code to send funds.")
                   .font(.headline)
                   .multilineTextAlignment(.center)
                   .padding()
               
               // Done Button
               Button(action: {
                   presentationMode.wrappedValue.dismiss() // Dismiss the view when tapped
               }) {
                   Text("Done")
                       .fontWeight(.semibold)
                       .padding()
                       .frame(maxWidth: .infinity)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(8)
               }
               .padding()
           }
           .padding()
       }
    
    func generateQRCode(text: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        // Use UTF-8 encoding instead of ASCII
        guard let data = text.data(using: .utf8) else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let ciImage = filter.outputImage else { return nil }
        
        // Scale up the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciImage.transformed(by: transform)
        
        // Convert to UIImage with higher quality
        guard let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
