import Foundation
import AppKit
import UniformTypeIdentifiers

class DocumentViewModel: ObservableObject {
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
            // Save directly to the existing file
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try self.text.write(to: url, atomically: true, encoding: .utf8)
                    DispatchQueue.main.async {
                        self.hasUnsavedChanges = false
                        self.updateWindowTitleClosure?()
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Failed to save document to existing file: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            // Show save panel to choose location
            DispatchQueue.main.async {
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

    // Add other methods related to document handling as needed.
}
