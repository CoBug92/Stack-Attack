import SwiftUI

extension View {
    func frame(equal lenght: CGFloat) -> some View {
        frame(width: lenght, height: lenght)
    }
}
