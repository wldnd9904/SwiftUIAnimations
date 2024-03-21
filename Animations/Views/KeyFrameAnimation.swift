//
//  ContentView.swift
//  KeyFrameAnimationTest
//
//  Created by 최지웅 on 1/24/24.
//

import SwiftUI


struct KeyFrameAnimation: View {
    @State var walkIndex: Int = 1
    @State var blinkIndex: Int = 0
    @State var positionX: Double = 0
    var Character: String {
        "blink/\(blinkIndex)/walk1_\(walkIndex)"
    }
    func animationTimer(){
        _ = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
            walkIndex += 1
            
            if (walkIndex > 4){
                walkIndex = 1
            }
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            var blinkTime:Int = Int.random(in: 1...2)
            _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { innerTimer in
                blinkIndex += 1
                if (blinkIndex > 2){
                    blinkIndex = 0
                    blinkTime -= 1
                    if(blinkTime == 0){
                        innerTimer.invalidate()
                    }
                }
            }
            
        }
    }
    var body: some View {
        VStack(alignment:.center){
            Image(Character)
                .frame(alignment: .center)
                .onAppear(perform: animationTimer)
        }
    }
}

#Preview {
    KeyFrameAnimation()
}


