import SwiftUI

extension AnyTransition {
    static var modal: AnyTransition {
        AnyTransition.modifier(
            active: ThumbnailExpandedModifier(pct: 0),
            identity: ThumbnailExpandedModifier(pct: 1)
        )
    }
    
    struct ThumbnailExpandedModifier: AnimatableModifier {
        var pct: CGFloat
        
        var animatableData: CGFloat {
            get { pct }
            set { pct = newValue }
        }
        
        func body(content: Content) -> some View {
            return content
                .environment(\.modalTransitionPercent, pct)
                .opacity(1)
        }
    }
}
