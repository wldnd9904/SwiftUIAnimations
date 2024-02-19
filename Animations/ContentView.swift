//
//  ContentView.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData:ModelData
    var body: some View {
        NavigationStack{
            List{
                NavigationLink{
                    Plain()
                        .navigationTitle("Plain")
                } label:{
                    Text("Plain")
                }
                .navigationTitle("Animations")
            }.listStyle(.inset)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
