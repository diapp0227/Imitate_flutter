import SwiftUI

extension View {
    func logScreenAppeared(file: String = #fileID) -> some View {
        self.onAppear {
            AppLogger.shared.screenAppeared(file: file)
        }
    }
}
