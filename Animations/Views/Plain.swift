//
//  Plain.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

struct Plain: View {
    @EnvironmentObject var modelData:ModelData
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    SearchBar{ query in
                        DataFetcher.searchPhotos(query: query, perPage: 20) { result in
                            switch result {
                            case .success(let pexelAPI):
                                modelData.photos = pexelAPI.photos.map{$0.toPhoto()}
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    .padding()
                    PlainGrid(photos: $modelData.photos)
                }
            }
            .padding(.horizontal, 2)
            .scrollIndicators(.hidden)
        }
    }
}

struct SearchBar: View {
    @State var query:String = "Nature"
    let onSubmit:(String)->Void
    var body: some View {
        TextField("query", text: $query)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay{
                HStack{
                    Spacer()
                    Button(action:{
                        onSubmit(query)
                    }, label:{Image(systemName: "magnifyingglass")})
                    .foregroundStyle(!query.isEmpty ? .black : .gray)
                    .scaleEffect(!query.isEmpty ? 1.2 : 1.0)
                    .animation(.easeInOut,value:query)
                }
                .padding(.trailing)
            }
            .onSubmit {
                onSubmit(query)
            }
    }
}

struct PlainGrid: View {
    @Binding var photos: [Photo]
    func columns(_ columnSize: CGFloat)->[GridItem]{
        [
            GridItem(.fixed(columnSize), spacing: 2, alignment: nil),
            GridItem(.fixed(columnSize), spacing: 2, alignment: nil),
            GridItem(.fixed(columnSize), spacing: 2, alignment: nil),
        ]
    }
    var body: some View {
        LazyVGrid(columns:.init(repeating: .init(.flexible(),spacing: 2), count: 3),alignment: .center,spacing:2){
            ForEach($photos){ $photo in
                NavigationLink{
                    PhotoDetail(photo: $photo)
                } label:{
                    PhotoView(photo: photo, size: .portrait)
                        .aspectRatio(1, contentMode: .fill)
                }
            }
        }
    }
    //        LazyVGrid(columns: columns(130 - 1), spacing: 2){
    //            ForEach($photos){ $photo in
    //                NavigationLink{
    //                    PhotoDetail(photo: $photo)
    //                } label:{
    //                    PhotoView(photo: photo, size: .portrait)
    //                        .frame(width:130 - 1,height:130 - 1)
    //                }
    //            }
    //        }
}

#Preview {
    Plain()
        .environmentObject(ModelData())
}
