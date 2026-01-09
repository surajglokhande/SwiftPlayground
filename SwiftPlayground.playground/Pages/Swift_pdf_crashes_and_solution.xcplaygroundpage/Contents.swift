//: [Previous](@previous)
/*:
 10+ iOS Crashes Every iOS Engineer Must Know
 (Swift + SwiftUI)
 (How to identify them & how to fix them)
 */
import PlaygroundSupport
import PDFKit
import UIKit // Use AppKit for macOS playgrounds

// 1. Find the URL for your PDF file in the playground's resources bundle
guard let fileURL = Bundle.main.url(forResource: "iOS_crashes_every_iOS_engineer_must_know", withExtension: "pdf") else {
    fatalError("Could not find the PDF file in the Resources folder.")
}

// 2. Create a PDFDocument from the URL
if let document = PDFDocument(url: fileURL) {
    // 3. Create a PDFView to display the document
    let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 600, height: 800))
    pdfView.document = document
    pdfView.autoScales = true // Fit the content to the view size

    // 4. Assign the PDFView to the playground's live view
    PlaygroundPage.current.liveView = pdfView
}else{
    print("pdf not found!")
}

//: [Next](@next)
