//
//  CageHoneyComb.swift
//  Animations
//
//  Created by 최지웅 on 3/21/24.
//

import SwiftUI



struct CageHoneyComb: View {
    @State var cellType:Bool = false
    var cellSideCount:Int { cellType ? 4 : 6 }
    var cellOffset:CGFloat { cellType ? 0: 0.54}
    var cellSize:CGFloat { cellType ? 1: 0.8}
    var body: some View {
        VStack{
            Button("Toggle"){
                withAnimation(.bouncy){
                    cellType.toggle()
                }
            }
            Spacer()
            ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing:0){
                        Image("texture/grass").resizable()
                            .frame(width:200,height:250)
                            .clipShape(RoundedRectangle(cornerRadius:30))
                            .overlay{
                                RoundedRectangle(cornerRadius:30)
                                    .stroke(Color.gray, lineWidth: 5)
                                KeyFrameAnimation()
                                    .frame(width:30,height:30)
                            }
                            .padding()
                        ForEach(0..<10){ _ in
                            VStack(spacing: cellType ? 0: -15){
                                ForEach(0..<3){ i in
                                    CageCell(sideCount: cellSideCount, size: cellSize, offset: (i & 1 == 1) ? cellOffset : 0, texture: "wood")
                                        .frame(width:100,height:100)
                                }
                            }
                        }
                }
                .padding()
            }
            Spacer()
        }
    }
}

#Preview {
    CageHoneyComb()
}
