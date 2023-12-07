import SwiftUI
import AppKit

@main
struct Plain_Text_EditorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(appDelegate: AppDelegate())
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        }
        .commands {
            CommandGroup(replacing: .saveItem) {
                Button(action: {
                    if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                        appDelegate.saveDocument()
                    }
                }) {
                    Text("Save...")
                }
                .keyboardShortcut("s", modifiers: .command)
            }
        }
    }
}