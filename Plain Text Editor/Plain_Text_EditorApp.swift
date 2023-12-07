import SwiftUI
import AppKit

@main
struct Plain_Text_EditorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate)
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        }
        .commands {
            CommandGroup(replacing: .saveItem) {
                Button(action: appDelegate.saveDocument) {
                    Text("Save...")
                }
                .keyboardShortcut("s", modifiers: .command)
            }
        }
    }
}
