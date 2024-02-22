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
    @State var loaded = false
    @Binding var photo: Photo
    let size: ImageSize
    var body: some View {
        AsyncImage(url: currentUrl, scale: 1.0, content: {image in
            Rectangle()
                .fill(photo.avgColor)
                .overlay{
                    image
                        .resizable()
                        .scaledToFill()
                        .opacity(loaded ? 1:0)
                        .onAppear{
                            withAnimation{
                                loaded = true
                                photo.image = image
                            }
                        }
                }
        }) {
            Rectangle()
                .fill(photo.avgColor)
                .opacity(blinking ? 1:0.5)
                .animation(.easeIn(duration: 0.8).repeatForever(autoreverses: true),value:blinking)
                .onAppear{
                    DispatchQueue.main.async{
                        withAnimation{
                            blinking = true
                        }
                        currentUrl = size.url(photo)
                    }
                }
        }
    }
}

#Preview {
    PhotoView(photo: .constant(.demo), size:.medium)
}
