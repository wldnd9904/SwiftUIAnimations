//
//  ContentView.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

public enum AnimationType:String,Hashable,CaseIterable {
    case plain = "Plain"
    case sharedElement = "SharedElement"
    case infiniteScroll = "InfiniteScroll"
    case paths = "Paths(AnimatedShape)"
    case keyFrameAnimation = "KeyFrameAnimation"
    var view: some View {
        switch(self){
        case .plain:
            return AnyView(Plain())
        case .sharedElement:
            return AnyView(SharedElement())
        case .infiniteScroll:
            return AnyView(InfiniteScroll())
        case .paths:
            return AnyView(Paths())
        case .keyFrameAnimation:
            return AnyView(KeyFrameAnimation())
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var modelData:ModelData
    var body: some View {
        NavigationStack(path:$modelData.path){
            List{
                ForEach(AnimationType.allCases, id:\.hashValue){ type in
                    NavigationLink(value:type){
                        Text(type.rawValue)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Animations")
            .navigationDestination(for: AnimationType.self){ dest in
                dest.view
                    .navigationTitle(AnimationType.plain.rawValue)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
        ContentView()
            .environmentObject(ModelData())
}
