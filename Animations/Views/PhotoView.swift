//
//  PhotoView.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

struct PhotoView: View {
    @State var blinking = false
    @State private var currentUrl: URL?
    let photo: Photo
    let size: ImageSize
    var body: some View {
        AsyncImage(url: currentUrl, scale: 1.0, content: {image in
            image.resizable()
        }, placeholder: {
            Rectangle()
                .fill(photo.avgColor)
                .opacity(blinking ? 1:0.5)
                .animation(.easeIn(duration: 0.8).repeatForever(autoreverses: true),value:blinking)
                
        })
        .onAppear{
            blinking = true
            currentUrl = size.url(photo)}
    }
}

#Preview {
    PhotoView(photo: .demo, size:.medium)
}
