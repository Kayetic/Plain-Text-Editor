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
        // Perform file writing in the background
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.text.write(to: url, atomically: true, encoding: .utf8)
                
                // Switch back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.hasUnsavedChanges = false
                    self.updateWindowTitleClosure?()
                    NSApp.reply(toApplicationShouldTerminate: true)
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to save document to existing file: \(error.localizedDescription)")
                }
            }
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
                    NSApp.reply(toApplicationShouldTerminate: true)
                } catch {
                    print("Failed to save document: \(error.localizedDescription)")
                }
            }
        }
    }
}

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    if hasUnsavedChanges {
        let response = promptToSave()
        
        switch response {
        case .save:
            saveDocument()
            return .terminateLater
        case .cancel:
            return .terminateCancel
        case .discard:
            return .terminateNow
        }
    }

    return .terminateNow
}

    private func promptToSave() -> SaveResponse {
        let alert = NSAlert()
        alert.messageText = "Save changes?"
        alert.informativeText = "Do you want to save the changes made to the document?"
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Discard")
        
        let modalResult = alert.runModal()
        
        switch modalResult {
        case .alertFirstButtonReturn:
            return .save
        case .alertSecondButtonReturn:
            return .cancel
        case .alertThirdButtonReturn:
            return .discard
        default:
            return .cancel
        }
    }

    enum SaveResponse {
        case save, cancel, discard
    }


}
