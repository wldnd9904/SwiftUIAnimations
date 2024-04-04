//
//  SharedElement2.swift
//  Animations
//
//  Created by 최지웅 on 4/3/24.
//

import SwiftUI

struct SharedElement2: View {
    @EnvironmentObject var modelData:ModelData
    @State var selectedIdx:Int?
    @State var blur = false
    @State var searching:Bool = false
    @Namespace private var sharedElement
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    PlainSearchBar(searching:$searching){ query in
                        searchPhotos(query:query)
                    }
                    .padding()
                    SharedElement2Grid(photos: $modelData.photos, namespace: sharedElement){ idx in
                        tapThumbnail(idx)
                    }
                }
            }
            if blur {
                Color.clear
                    .background(.thinMaterial)
                    .ignoresSafeArea()
                    .zIndex(2)
                    .onTapGesture {
                        tapBackdrop()
                    }
                    .transition(.opacity)
            }
            if selectedIdx != nil {
                Color.clear.overlay{
                    SharedElement2PhotoDetail(
                        photo: $modelData.photos[selectedIdx!],
                        onClose:tapBackdrop)
                    .matchedGeometryEffect(id: selectedIdx!, in: sharedElement, properties: .position)
                    .mask{
                        Rectangle()
                            .matchedGeometryEffect(id: selectedIdx!, in: sharedElement, properties: .frame)
                    }
                }
                .zIndex(3)
                .transition(.modal)
                //@Environment는 얘가 속한 환경에 있어야함
            }
        }
    }
    
    struct SharedElement2Grid: View {
        @Binding var photos: [Photo]
        let namespace: Namespace.ID
        let onSelect: (Int)->Void
        var body: some View {
            LazyVGrid(columns:.init(repeating: .init(.flexible(),spacing: 2), count: 3),alignment: .center,spacing:2){
                ForEach(photos, id:\.id){ photo in
                    PhotoView(photo:$photos[photo.idx], size: .small)
                        .aspectRatio( contentMode: .fill)
                        .clipped()
                        .onTapGesture {
                            onSelect(photo.idx)
                        }
                        .matchedGeometryEffect(id: photo.idx, in: namespace, properties: .position)
                }
            }
        }
    }
    
    
    struct SharedElement2PhotoDetail: View {
        @Environment(\.modalTransitionPercent) var pct: CGFloat
        @Binding var photo:Photo
        @State var backgroundHidden = false
        @State var imageLoaded = false
        let onClose: ()->Void
        var body: some View {
            
            Color.clear
                .overlay{
                    VStack(alignment: .leading){
                        Button(action:onClose){
                            Image(systemName: "chevron.left")
                        }
                        .padding()
                        .foregroundStyle(.primary)
                        (photo.image?.resizable())
                            .scaledToFit()
                        
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
                            Spacer()
                        }
                    }
                    .background(Color(UIColor.systemBackground))
                    .scaleEffect(pct)
                }
//                .overlay(alignment:.top){photo.image?.resizable().scaledToFit().offset(y: pct * 40)}
        }
    }
    
    func searchPhotos(query:String) {
        searching=true
        Task{
            let result = await DataFetcher.searchPhotos(query: query, perPage: 20)
            DispatchQueue.main.async{
                switch result {
                case .success(let pexelAPI):
                    modelData.photos = pexelAPI.photos.map{$0.toPhoto()}
                    searching=false
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    searching=false
                }
            }
        }
    }
    
    func tapBackdrop() {
        withAnimation { self.blur = false }
        DispatchQueue.main.async {
            withAnimation { self.selectedIdx = nil }
        }
    }
    
    func tapThumbnail(_ idx: Int) {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.25)) { self.selectedIdx = idx }
        DispatchQueue.main.async {
            withAnimation { self.blur = true }
        }
    }
}
#Preview {
    SharedElement2()
        .environmentObject(ModelData())
}
