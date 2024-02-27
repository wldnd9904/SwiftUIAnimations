//
//  ContentView.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

private enum AnimationType:String,Hashable,CaseIterable {
    case plain = "Plain"
    case sharedElement = "SharedElement"
    case infiniteScroll = "InfiniteScroll"
    case paths = "Paths(AnimatedShape)"
}

struct ContentView: View {
    @EnvironmentObject var modelData:ModelData
    var body: some View {
        NavigationStack(path:$modelData.path){
            List{
                ForEach(AnimationType.AllCases(), id:\.hashValue){ type in
                    NavigationLink(value:type){
                        Text(type.rawValue)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Animations")
            .navigationDestination(for: AnimationType.self){ dest in
                switch(dest){
                case .plain:
                    Plain()
                        .navigationTitle(AnimationType.plain.rawValue)
                        .navigationBarTitleDisplayMode(.inline)
                case .sharedElement:
                    SharedElement()
                        .navigationTitle(AnimationType.sharedElement.rawValue)
                        .navigationBarTitleDisplayMode(.inline)
                case .infiniteScroll:
                    InfiniteScroll()
                        .navigationTitle(AnimationType.infiniteScroll.rawValue)
                        .navigationBarTitleDisplayMode(.inline)
                case .paths:
                    Paths()
                        .navigationTitle(AnimationType.paths.rawValue)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
