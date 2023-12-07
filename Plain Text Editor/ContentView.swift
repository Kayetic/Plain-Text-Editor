import SwiftUI

struct ContentView: View {
    @StateObject var appDelegate: AppDelegate

    init(appDelegate: AppDelegate) {
        self._appDelegate = StateObject(wrappedValue: appDelegate)

    }

    var body: some View {
        TextEditor(text: $appDelegate.text)
            .font(.custom("SFMono-Regular", size: 14))
            .padding()
            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        // Your toolbar content here
                    }
                    .background(Color.white)
                }
                ToolbarItem(placement: .navigation) {
                    if appDelegate.hasUnsavedChanges {
                        Button(action: { self.appDelegate.saveDocument() }) {
                            Image(systemName: "square.and.arrow.down")
                                .opacity(appDelegate.hasUnsavedChanges ? 1.0 : 0.0)
                                .animation(.easeInOut, value: appDelegate.hasUnsavedChanges)
                        }
                    }
                }
            }
            .onAppear {
                NSApp.windows.first?.makeKeyAndOrderFront(nil)
                self.appDelegate.updateWindowTitleClosure = self.updateWindowTitle
            }
    }

    private func updateWindowTitle() {
        if let window = NSApplication.shared.windows.first {
            window.title = appDelegate.currentFileURL?.lastPathComponent ?? "New Note"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appDelegate: AppDelegate())
    }
}
