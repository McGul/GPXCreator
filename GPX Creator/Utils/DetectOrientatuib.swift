//
//  DetectOrientatuib.swift
//  GPX Creator
//
//  Created by Maciej Gulda on 29/09/2023.
//

import SwiftUI

struct DetectOrientation: ViewModifier {
    
    @Binding var orientation: UIDeviceOrientation
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
    }
}
