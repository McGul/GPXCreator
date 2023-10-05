//
//  UIView+Orientation.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 29/09/2023.
//

import Foundation
import SwiftUI

extension View {
    func detectOrientation(_ orientation: Binding<UIDeviceOrientation>) -> some View {
        modifier(DetectOrientation(orientation: orientation))
    }
}
