//
//  PhotoView.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

struct PhotoView: View {
    @State var blinking = false
    let photo: Photo
    let size: ImageSize
    var body: some View {
        AsyncImage(url: size.url(photo), scale: 1.0, content: {image in
            image
        }, placeholder: {
            photo.avgColor
                .frame(width:size.width(photo), height:size.height(photo))
                .opacity(blinking ? 0.8:1)
                .onAppear{
                    withAnimation {
                        blinking = false
                    }
                }
                .animation(
                    .easeInOut(duration: 1).repeatForever(autoreverses: true),value: blinking)
        })
    }
}

#Preview {
    PhotoView(photo: .demo, size:.medium)
}
