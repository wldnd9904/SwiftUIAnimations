//
//  SharedElement.swift
//  Animations
//
//  Created by 최지웅 on 2/20/24.
//

import SwiftUI

import SwiftUI

struct SharedElement: View {
    @EnvironmentObject var modelData:ModelData
    @State var selectedIdx:Int?
    @State var lenderImage:Bool = false
    @Namespace private var sharedElement
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    PlainSearchBar{ query in
                        DataFetcher.searchPhotos(query: query, perPage: 20) { result in
                            switch result {
                            case .success(let pexelAPI):             DispatchQueue.main.async{
                                modelData.photos = pexelAPI.photos.map{$0.toPhoto()}
                            }
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    .padding()
                    SharedElementGrid(photos: $modelData.photos, namespace: sharedElement){ idx in
                        withAnimation{
                            selectedIdx = idx
                        } completion: {
                            withAnimation{
                                lenderImage = true;
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            .scrollIndicators(.hidden)
            
            if((selectedIdx) != nil){
                SharedElementPhotoDetail(photo: $modelData.photos[selectedIdx!], lenderImage: $lenderImage, namespace:sharedElement){
                    selectedIdx = nil
                    lenderImage = false
                }
                .navigationBarBackButtonHidden()
                .background(ignoresSafeAreaEdges:.all)
                .navigationTitle("")
            }
        }
    }
}

struct SharedElementPhotoDetail: View {
    @Binding var photo:Photo
    @Binding var lenderImage:Bool
    @State var backgroundHidden = false
    let namespace: Namespace.ID
    let onClose: ()->Void
    var body: some View {
        //asyncimage 내부에서 onappear로 바인딩한 imagefullyloaded 참으로 바꾸면 썸네일이미지 사라짐
        ZStack{
//            //백그라운드
//            Color.black
//                .ignoresSafeArea()
//                .opacity(backgroundHidden ? 0.5:0)
//                .onAppear{
//                    withAnimation{
//                        backgroundHidden = true
//                    }
//                }
            //디테일 뷰
            VStack{
                HStack{
                    Button(action:onClose){
                        Image(systemName: "chevron.left")
                    }.padding()
                        .foregroundStyle(.primary)
                    Spacer()
                }
                AsyncImage(url: lenderImage ? ImageSize.original.url(photo) : nil)  {image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    (photo.image?.resizable())
                    .frame(idealWidth: photo.width, idealHeight:photo.height)
                    .scaledToFit()
                    .matchedGeometryEffect(id: photo.id, in: namespace)
                }
                if lenderImage {
                    Group{
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
                    }
                    .transition(.opacity)
                }
                Spacer()
            }//디테일 뷰 끝
        }//ZStack
    }
}

struct SharedElementGrid: View {
    @Binding var photos: [Photo]
    let namespace: Namespace.ID
    let onSelect: (Int)->Void
    var body: some View {
        LazyVGrid(columns:.init(repeating: .init(.flexible(),spacing: 2), count: 3),alignment: .center,spacing:2){
            ForEach(0..<$photos.count, id:\.self){ idx in
                Button(action:{onSelect(idx)}){
                    Color.clear
                        .scaledToFill()
                        .overlay(
                            PhotoView(photo:$photos[idx], size: .small)
                                .aspectRatio( contentMode: .fill)
                                .matchedGeometryEffect(id: photos[idx].id, in: namespace)
                        )
                        .mask{
                            Rectangle()
                        }
                }
            }
        }
    }
}

#Preview {
    SharedElement()
        .environmentObject(ModelData())
}
