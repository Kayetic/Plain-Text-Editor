import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Check all window's view models for unsaved changes
        for window in NSApp.windows {
            if let contentView = window.contentView as? ContentView {
                if contentView.documentViewModel.hasUnsavedChanges {
                    let response = promptToSave()

                    switch response {
                    case .save:
                        contentView.documentViewModel.saveDocument()
                        return .terminateLater
                    case .cancel:
                        return .terminateCancel
                    case .discard:
                        continue // Check the next window
                    }
                }
            }
               contentView.documentViewModel.hasUnsavedChanges {
                let response = promptToSave()

                switch response {
                case .save:
                    contentView.documentViewModel.saveDocument()
                    return .terminateLater
                case .cancel:
                    return .terminateCancel
                case .discard:
                    continue // Check the next window
                }
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

    // Other app-wide logic if needed
}
