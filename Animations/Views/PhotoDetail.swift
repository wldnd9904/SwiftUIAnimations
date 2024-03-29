//
//  PhotoDetail.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

struct PhotoDetail: View {
    @Binding var photo:Photo
    let onClose: ()->Void
    var body: some View {
        VStack{
            HStack{
                Button(action:onClose){
                    Image(systemName: "chevron.left")
                }.padding()
                .foregroundStyle(.primary)
                Spacer()
            }
            AsyncImage(url: ImageSize.original.url(photo))  {image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
               ( photo.avgColor == .white ?
                .gray:
                    photo.avgColor)
                    .frame(idealWidth: photo.width, idealHeight:photo.height)
                    .scaledToFit()
            }
            HStack{
                Image(systemName: photo.liked ? "heart.fill":"heart")
                    .foregroundStyle(photo.liked ? .red : .black)
                    .onTapGesture {
                        photo.liked.toggle()
                    }
                Image(systemName: "message")
                Image(systemName: "paperplane")
                Spacer()
                Image(systemName: "bookmark")
            }
            .font(.system(size: 20))
            .padding(.horizontal, 10)
            Text(photo.desc)
                .padding(.horizontal)
                .padding(.vertical,5)
            HStack{
                Spacer()
                Text("by "+photo.photographer)
            }
            .padding(.horizontal)
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
    }
}
#Preview {
    ZStack{
        Color.black
        PhotoDetail(photo:.constant(.demo), onClose: {})
    }
}
