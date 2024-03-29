//
//  Plain.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

struct Plain: View {
    @EnvironmentObject var modelData:ModelData
    @State var searching:Bool = false
    func searchPhotos(query:String) async {
            let result = await DataFetcher.searchPhotos(query: query, perPage: 20)
            switch result {
            case .success(let pexelAPI):
                DispatchQueue.main.async{
                    modelData.photos = pexelAPI.photos.map{$0.toPhoto()}
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                PlainSearchBar(searching:$searching){ query in
                    searching = true
                    Task{
                        await searchPhotos(query:query)
                        DispatchQueue.main.async{
                            searching=false
                        }
                    }
                }
                .padding()
                PlainGrid(photos: $modelData.photos){ idx in
                    modelData.path.append(idx)
                }
                .navigationDestination(for: Int.self){idx in
                    PhotoDetail(photo:$modelData.photos[idx]){
                        modelData.path.removeLast()
                    }
                    .navigationBarBackButtonHidden()
                }
            }
        }
        .padding(.horizontal, 2)
        .scrollIndicators(.hidden)
    }
}

struct PlainSearchBar: View {
    @State var query:String = "Cat"
    @Binding var searching:Bool
    let onSubmit:(String)->Void
    var body: some View {
        TextField("query", text: $query)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
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
                    .disabled(searching)
                }
                .padding(.trailing)
            }
            .onSubmit {
                onSubmit(query)
            }
            .opacity(searching ? 0.5:1)
            .disabled(searching)
            .animation(.easeInOut,value:searching)
    }
}

struct PlainGrid: View {
    @Binding var photos: [Photo]
    let onSelect: (Int)->Void
    var body: some View {
        LazyVGrid(columns:.init(repeating: .init(.flexible(),spacing: 2), count: 3),alignment: .center,spacing:2){
            ForEach(photos, id:\.id){ photo in
                Button(action:{onSelect(photo.idx)}){
                    Color.clear
                        .scaledToFill()
                        .overlay(
                            PhotoView(photo: $photos[photo.idx], size: .portrait).aspectRatio( contentMode: .fill)
                        )
                        .clipShape(Rectangle())
                }
            }
        }
    }
}

struct Plain_Preview:PreviewProvider{
    static var previews:some View {
            Plain()
            .environmentObject(ModelData())
    }
}
