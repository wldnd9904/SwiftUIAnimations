//
//  Paths.swift
//  Animations
//
//  Created by 최지웅 on 2/27/24.
//

import SwiftUI

struct Paths: View {
    @State var sideCount:Int = 3
    @State var size:Double = 1
    var body: some View {
        VStack{
            PolygonShape(sides: sideCount, scale:size)
                .stroke(Color.blue, lineWidth:3)
                .animation(.bouncy,value:sideCount)
            Text("\(sideCount) sides")
            HStack{
                ForEach([1,3,7,10,20,30],id:\.self){ i in
                    Button("\(i)"){
                        withAnimation{
                            sideCount=(i)
                            size=(1)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .padding()
    }
}

struct PolygonShape: Shape {
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
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0 * scale
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = sidesAsDouble != Double(Int(sidesAsDouble)) ? 1 : 0
        
        var vertex: [CGPoint] = []
        
        for i in 0..<Int(sidesAsDouble) + extra {
            
            let angle = (Double(i) * (360.0 / sidesAsDouble)) * (Double.pi / 180)
            
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
        
        // Draw vertex-to-vertex lines
        drawVertexLines(path: &path, vertex: vertex, n: 0)
        
        return path
    }
    func drawVertexLines(path: inout Path, vertex: [CGPoint], n: Int) {
        
        if (vertex.count - n) < 3 { return }
        
        for i in (n+2)..<min(n + (vertex.count-1), vertex.count) {
            path.move(to: vertex[n])
            path.addLine(to: vertex[i])
        }
        
        drawVertexLines(path: &path, vertex: vertex, n: n+1)
    }
}

#Preview {
    Paths()
}
