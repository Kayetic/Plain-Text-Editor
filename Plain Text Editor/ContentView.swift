import SwiftUI

struct ContentView: View {
    @StateObject var documentViewModel: DocumentViewModel

    init(documentViewModel: DocumentViewModel) {
        self._documentViewModel = StateObject(wrappedValue: documentViewModel)
    }

    var body: some View {
        TextEditor(text: $documentViewModel.text)
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
                    if documentViewModel.hasUnsavedChanges {
                        Button(action: { self.documentViewModel.saveDocument() }) {
                            Image(systemName: "square.and.arrow.down")
                                .opacity(documentViewModel.hasUnsavedChanges ? 1.0 : 0.0)
                                .animation(.easeInOut, value: documentViewModel.hasUnsavedChanges)
                        }
                    }
                }
            }
            .onAppear {
                NSApp.windows.first?.makeKeyAndOrderFront(nil)
                self.documentViewModel.updateWindowTitleClosure = self.updateWindowTitle
            }
    }

    private func updateWindowTitle() {
        if let window = NSApplication.shared.windows.first {
            window.title = documentViewModel.currentFileURL?.lastPathComponent ?? "New Note"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(documentViewModel: DocumentViewModel())
    }
}
