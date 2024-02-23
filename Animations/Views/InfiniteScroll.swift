//
//  InfiniteScroll.swift
//  Animations
//
//  Created by 최지웅 on 2/22/24.
//

import SwiftUI

struct InfiniteScroll: View {
    @EnvironmentObject var modelData:ModelData
    var body: some View {
        RefreshableScrollView{
            VStack{
                PlainSearchBar{ query in
                    DataFetcher.searchPhotos(query: query, perPage: 18) { result in
                        switch result {
                        case .success(let pexelAPI):
                            DispatchQueue.main.async{
                                    modelData.photos = pexelAPI.photos.map{$0.toPhoto()}
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
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

struct MyAnchorPreference:PreferenceKey {
    typealias Value = [Anchor<CGPoint>]
    static var defaultValue:Value = []
    static func reduce(value: inout [Anchor<CGPoint>], nextValue: () -> [Anchor<CGPoint>]) {
        value.append(contentsOf: nextValue())
    }
}

struct RefreshableScrollView<Content:View>: View {
    let content:Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    @State var rotation:Angle = .zero
    @State var opacity: CGFloat = 0
    var body: some View {
        GeometryReader{geometry in
            ScrollView {
                VStack{
                    content
                        .anchorPreference(key: MyAnchorPreference.self, value: .top,transform:{[$0]})
                    Image(systemName: "arrow.down")
                        .opacity(opacity)
                        .rotationEffect(rotation)
                        .padding(.top)
                        .transformAnchorPreference(key: MyAnchorPreference.self, value: .bottom, transform: {
                            $0.append($1)
                        })
                }
            }
            .transformAnchorPreference(key: MyAnchorPreference.self, value: .bottom, transform: {
                $0.append($1)
            })
            .onPreferenceChange(MyAnchorPreference.self, perform: { value in
                rotation = .degrees(min((min(geometry[value[1]].y -  geometry[value[0]].y ,geometry[value[2]].y) - geometry[value[1]].y) * 3.0, 180.0))
                opacity = CGFloat((min(geometry[value[1]].y -  geometry[value[0]].y ,geometry[value[2]].y) - geometry[value[1]].y)) /  30.0
            })
        }
    }
}

#Preview {
    InfiniteScroll()
        .environmentObject(ModelData())
}



