//
//  EnvironmentValues.swift
//  Animations
//
//  Created by 최지웅 on 4/3/24.
//

import SwiftUI

extension EnvironmentValues {
    var modalTransitionPercent: CGFloat {
        get { return self[ModalTransitionKey.self] }
        set { self[ModalTransitionKey.self] = newValue }
    }
}


public struct ModalTransitionKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 0
}
