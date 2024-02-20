//
//  ContentView.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

private enum AnimationType:Hashable {
    case plain
    case sharedElement
}

struct ContentView: View {
    @EnvironmentObject var modelData:ModelData
    var body: some View {
        NavigationStack(path:$modelData.path){
            List{
                NavigationLink(value:AnimationType.plain){
                    Text("Plain")
                }
                NavigationLink(value:AnimationType.sharedElement){
                    Text("SharedElement")
                }
            }
            .listStyle(.inset)
            .navigationTitle("Animations")
            .navigationDestination(for: AnimationType.self){ dest in
                switch(dest){
                case .plain:
                    Plain()
                        .navigationTitle("Plain")
                        .navigationBarTitleDisplayMode(.inline)
                case .sharedElement:
                    SharedElement()
                        .navigationTitle("SharedElement")
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
