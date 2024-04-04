//
//  TextPhotoDetail.swift
//  Animations
//
//  Created by 최지웅 on 4/4/24.
//

import SwiftUI

struct TestPhotoDetail: View {
    @Environment(\.modalTransitionPercent) var pct
    @Namespace var ns
    @State var toggle:Bool = true
    @State private var childRect: CGRect = .zero
    
    var body: some View {
        Color.clear
            .overlay{
                VStack(alignment: .leading){
                    Button(action:{}){
                        Image(systemName: "chevron.left")
                    }
                    .padding()
                    .foregroundStyle(.primary)
                    Image("sample")
                        .resizable()
                        .scaledToFit()
                        .overlay{
                            GeometryReader { geometry in
                                Color.clear.preference(key: MyRectPreference.self, value: geometry.frame(in:.global))
                                    .onPreferenceChange(MyRectPreference.self) { value in
                                        self.childRect = value
                                    }
                            }
                            .scaledToFit()
                        }
                    Group{
                        HStack{
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                            Image(systemName: "message")
                            Image(systemName: "paperplane")
                            Spacer()
                            Image(systemName: "bookmark")
                        }
                        .font(.system(size: 20))
                        .padding(.horizontal, 10)
                        Text("Sample Image")
                            .padding(.horizontal)
                            .padding(.vertical,5)
                        HStack{
                            Spacer()
                            Text("by me")
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                .background(Color(UIColor.systemBackground))
            }
            .mask(alignment:.topLeading){
                //마스크 기본 사이즈
                if(toggle){
                    Rectangle()
                        .transition(.modal)
                        .frame(width:.infinity, height:.infinity)
                        .matchedGeometryEffect(id: "ID",in: ns, properties: .frame)
                        .ignoresSafeArea()
                } else {
                    Rectangle()
                        .transition(.modal)
                        .matchedGeometryEffect(id: "ID",in: ns, properties: .frame)
                        .frame(width:childRect.width, height:childRect.height)
                        .position(x:childRect.origin.x+childRect.width/2, y:childRect.origin.y+childRect.height/2)
                        .ignoresSafeArea()
                }
            }
            .onTapGesture {
                withAnimation{
                    toggle.toggle()
                }
            }
    }
}

#Preview {
    TestPhotoDetail()
}
