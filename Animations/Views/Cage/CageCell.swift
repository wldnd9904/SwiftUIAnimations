//
//  CageCell.swift
//  Animations
//
//  Created by 최지웅 on 3/21/24.
//

import SwiftUI


struct CageCell: View {
    
    let sideCount:Int
    let size:Double
    let offset: Double
    let texture: String
    let pokemonCnt:Int = Int.random(in: 0..<10)
    var body: some View {
            GeometryReader{ geometry in
                ZStack{
                    Image("texture/\(texture)")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(size*1.5)
                        .mask{
                            CellShape(sides: sideCount, scale:size)
                        }
                        .overlay{
                            CellShape(sides: sideCount, scale:size)
                                .stroke(.brown, lineWidth: 5)
                        }
                    ForEach(0..<pokemonCnt){ i in
                        KeyFrameAnimation()
                            .scaleEffect(x:(i&1 == 0) ? 1 : -1)
                            .frame(width:30,height:30)
                            .offset(x:geometry.size.width  * (CGFloat.random(in:0..<0.6)-0.3),y:geometry.size.width * (CGFloat.random(in:0..<0.6) - 0.3))
                    }
                }
                    .offset(x:geometry.size.width * offset)
            }
    }
}


struct CellShape: Shape {
    var sides: Int
    var scale: Double
    private var sidesAsDouble: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { return AnimatablePair(sidesAsDouble, scale) }
        set {
            sidesAsDouble = newValue.first
            scale = newValue.second
        }
    }
    
    init(sides: Int, scale:Double) {
        self.sides = sides
        self.sidesAsDouble = Double(sides)
        self.scale = scale
    }
    
    func path(in rect: CGRect) -> Path {
        let h = Double(min(rect.size.width, rect.size.height)) / sqrt(sidesAsDouble / 2)
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        var path = Path()
        let extra: Int = sidesAsDouble != Double(Int(sidesAsDouble)) ? 1 : 0
        
        var vertex: [CGPoint] = []
        
        for i in 0..<Int(sidesAsDouble) + extra {
            let angle = Double.pi/sidesAsDouble + (Double(i) * (360.0 / sidesAsDouble)) * (Double.pi / 180)
            // Calculate vertex
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            vertex.append(pt)
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        path.closeSubpath()
        return path
    }
}

struct CageCellPreview:View {
    @State var sideCount:Int = 4
    @State var size:Double = 1
     var body: some View{
        VStack{
            CageCell(sideCount:sideCount, size:size, offset:0.5,texture: "wood")
            HStack{
                ForEach([1,2,3,4,5,6,10,20],id:\.self){ i in
                    VStack{
                        Button("\(i)"){
                            withAnimation{
                                sideCount=i
                            }
                        }
                        Button("\(i)"){
                            withAnimation{
                                size=Double(i)/3
                            }
                        }
                        .tint(.green)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(width:200,height:200)
    }
}
#Preview {
    CageCellPreview()
}
