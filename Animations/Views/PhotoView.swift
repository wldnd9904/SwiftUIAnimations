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
                .resizable()
        }, placeholder: {
            Rectangle()
                .fill(photo.avgColor)
        })
    }
}

#Preview {
    PhotoView(photo: .demo, size:.medium)
        .frame(width:300,height:300)
}
