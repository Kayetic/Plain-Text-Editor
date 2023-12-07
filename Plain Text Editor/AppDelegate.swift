import SwiftUI
import AppKit
import UniformTypeIdentifiers

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, ObservableObject {
    @Published var text: String = "" {
        didSet {
            hasUnsavedChanges = true
        }
    }
    @Published var hasUnsavedChanges = false
    var currentFileURL: URL?
    var updateWindowTitleClosure: (() -> Void)?

    func saveDocument() {
        if let url = currentFileURL {
            // Save directly if there is an existing file URL
            do {
                try text.write(to: url, atomically: true, encoding: .utf8)
                hasUnsavedChanges = false
                updateWindowTitleClosure?()
            } catch {
                print("Failed to save document to existing file: \(error.localizedDescription)")
            }
        } else {
            // If no file URL, show save panel to choose location
            let panel = NSSavePanel()
            panel.allowedContentTypes = [UTType.plainText]
            
            panel.begin { result in
                if result == .OK, let url = panel.url {
                    do {
                        try self.text.write(to: url, atomically: true, encoding: .utf8)
                        self.currentFileURL = url
                        self.hasUnsavedChanges = false
                        self.updateWindowTitleClosure?()
                    } catch {
                        print("Failed to save document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }


}
