//
//  ModelData.swift
//  Animations
//
//  Created by 최지웅 on 2/19/24.
//

import Foundation
import SwiftUI

final class ModelData:ObservableObject{
    @Published var photos:[Photo] = [.demo,.demo2,.demo3]
    @Published var path:NavigationPath = NavigationPath()
}
