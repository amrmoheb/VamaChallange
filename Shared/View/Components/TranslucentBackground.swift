//
//  TranslucentBackground.swift
//  Cronica (iOS)
//
//  Created by Alexandre Madeira on 19/11/22.
//

import SwiftUI
import NukeUI

@available(watchOS 10.0, *)
struct TranslucentBackground: View {
    var image: URL?
    @AppStorage("disableTranslucentBackground") private var disableTranslucent = false
    var useLighterMaterial = false
    var body: some View {
        if !disableTranslucent && image != nil {
            ZStack {
                LazyImage(url: image) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle()
                            .fill(.background)
                            .ignoresSafeArea()
                            .padding(.zero)
                    }
                }
                .ignoresSafeArea()
                .padding(.zero)
                .transition(.opacity)
#if os(watchOS)
                Rectangle()
                    .fill(.thickMaterial)
                    .ignoresSafeArea()
                    .padding(.zero)
#elseif os(macOS) || os(iOS)
                Rectangle()
                    .fill(useLighterMaterial ? .regularMaterial : .ultraThickMaterial)
                    .ignoresSafeArea()
                    .padding(.zero)
#else
                Rectangle()
                    .fill(.thickMaterial)
                    .ignoresSafeArea()
                    .padding(.zero)
#endif
            }
        }
    }
}
