//
//  InfiniteScroll.swift
//  Animations
//
//  Created by 최지웅 on 2/22/24.
//

import SwiftUI

struct InfiniteScroll: View {
    @EnvironmentObject var modelData:ModelData
    @State var cachedQuery:String = ""
    @State var page:Int = 1
    @State var searching:Bool = false
    func searchPhotos(query:String) async {
        var clearIdx = false
        if(cachedQuery == "" || cachedQuery != query){
            clearIdx = true
            modelData.photos = []
            self.page = 1
        }
        cachedQuery = query
        let result = await DataFetcher.searchPhotos(query: query, page:page, perPage: 18, clearIdx: clearIdx)
        switch result {
        case .success(let pexelAPI):
            DispatchQueue.main.async{
                modelData.photos.append(contentsOf: pexelAPI.photos.map{$0.toPhoto()})
                self.page +=  1
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            cachedQuery = ""
        }
    }
    
    var body: some View {
        RefreshableScrollView(searching:$searching, onRefresh:{
            searching = true
            Task{
                await searchPhotos(query:cachedQuery)
                DispatchQueue.main.async{
                    searching=false
                }
            }}){
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
            .padding(.horizontal, 2)
            .scrollIndicators(.hidden)
        }
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
    @State var rotation:Angle = .zero
    @State var opacity: CGFloat = 0
    @State var update:Bool = false
    @Binding var searching:Bool
    let onRefresh: ()->Void
    
    init( searching:Binding<Bool>, onRefresh:@escaping ()->Void,@ViewBuilder content: () -> Content) {
        self.content = content()
        self._searching = searching
        self.onRefresh = onRefresh
    }
    var body: some View {
        GeometryReader{geometry in
            ScrollView {
                VStack{
                    content
                        .anchorPreference(key: MyAnchorPreference.self, value: .top,transform:{[$0]})
                    Group{
                        if (update) { ProgressView() }else{
                            Image(systemName: "arrow.down")
                        }
                    }.frame(height:50)
                        .opacity(update ? 1 : opacity)
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
                DispatchQueue.main.async{
                    rotation = .degrees(min((min(geometry[value[1]].y -  geometry[value[0]].y ,geometry[value[2]].y) - geometry[value[1]].y) * 3.0, 180.0))
                    opacity = CGFloat((min(geometry[value[1]].y -  geometry[value[0]].y ,geometry[value[2]].y) - geometry[value[1]].y)) /  30.0
                    if(opacity > 3){
                        update = true
                    }
                    if(update && opacity<=0){
                        if(!searching){
                            onRefresh()
                        }
                        update = false
                    }
                }
            })
        }
    }
}
#Preview {
    InfiniteScroll()
        .environmentObject(ModelData())
}
