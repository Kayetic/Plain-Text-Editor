import Foundation
import AppKit
import UniformTypeIdentifiers

struct FileHandler {
    static func saveTextToFile(_ text: String, currentFileURL: URL?, completion: @escaping (Bool, URL?) -> Void) {
        DispatchQueue.main.async {
            let panel = NSSavePanel()
            panel.allowedContentTypes = [UTType.plainText]
            
            if let currentFileURL = currentFileURL {
                panel.directoryURL = currentFileURL.deletingLastPathComponent()
                panel.nameFieldStringValue = currentFileURL.lastPathComponent
            }
            
            panel.begin { result in
                if result == .OK, let url = panel.url {
                    do {
                        try text.write(to: url, atomically: true, encoding: .utf8)
                        completion(true, url) // Return the URL of the saved file
                    } catch {
                        print(error.localizedDescription)
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
            }
        }
    }
}

