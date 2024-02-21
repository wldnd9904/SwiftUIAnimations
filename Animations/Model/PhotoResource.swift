//
//  PhotoResource.swift
//  Animations
//
//  Created by 최지웅 on 2/16/24.
//

import Foundation
import SwiftUI



public enum ImageSize {
    case original         // 오리지널 사이즈
    case large2x          // W 940px X H 650px DPR 1.
    case large            // W 940px X H 650px DPR 2
    case medium           // height: 350px
    case small            // height: 130px
    case portrait         // The image cropped to W 800px X H 1200px.
    case landscape        // The image cropped to W 1200px X H 627px.
    case tiny             // The image cropped to W 280px X H 200px.
    
    func width(_ photo: Photo) -> CGFloat? {
        switch(self){
        case .original:
            photo.width
        case .large2x:
            1880
        case .large:
            940
        case .medium:
            350
        case .small:
            130
        case .portrait:
            800
        case .landscape:
            1200
        case .tiny:
            280
        }
    }
    
    func height(_ photo: Photo) -> CGFloat? {
        switch(self){
        case .original:
            photo.height
        case .large2x:
            1300
        case .large:
            650
        case .medium:
            350
        case .small:
            130
        case .portrait:
            1200
        case .landscape:
            627
        case .tiny:
            200
        }
    }
    
    func url(_ photo: Photo)->URL {
        switch(self){
        case .original:
            URL(string: photo.imageSet.original)!
        case .large2x:
            URL(string: photo.imageSet.large2x)!
        case .large:
            URL(string: photo.imageSet.large)!
        case .medium:
            URL(string: photo.imageSet.medium)!
        case .small:
            URL(string: photo.imageSet.small)!
        case .portrait:
            URL(string: photo.imageSet.portrait)!
        case .landscape:
            URL(string: photo.imageSet.landscape)!
        case .tiny:
            URL(string: photo.imageSet.tiny)!
        }
    }
}

public struct ImageSet:Codable{
    let original:String         // 오리지널 사이즈
    let large2x:String          // W 940px X H 650px DPR 1.
    let large:String            // W 940px X H 650px DPR 2
    let medium:String           // height: 350px
    let small:String            // height: 130px
    let portrait:String         // The image cropped to W 800px X H 1200px.
    let landscape:String        // The image cropped to W 1200px X H 627px.
    let tiny:String             // The image cropped to W 280px X H 200px.
    static let demo = ImageSet(
        original: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg",
        large2x: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        large: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
        medium: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=350",
        small: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=130",
        portrait: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
        landscape: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
        tiny: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
    )
}

struct Photo: Identifiable {
    let id: Int
    let width:CGFloat
    let height: CGFloat
    let photographer: String
    let avgColor: Color
    let imageSet: ImageSet
    var liked: Bool
    let desc:String
    var image: Image? = nil
    static let demo = Photo(
        id: 2014422,
        width: 3024,
        height: 3024,
        photographer: "Joey Farina",
        avgColor: Color(hex:"#978E82"),
        imageSet: .demo,
        liked: false,
        desc: "Brown Rocks During Golden Hour"
    )
}
