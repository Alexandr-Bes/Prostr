//
//  PlannerPostMediaView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct PlannerPostMediaView<Placeholder: View>: View {
    let assetName: String?
    let imageData: Data?
    let placeholder: () -> Placeholder

    init(
        assetName: String?,
        imageData: Data?,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.assetName = assetName
        self.imageData = imageData
        self.placeholder = placeholder
    }

    var body: some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else if let assetName {
            Image(assetName)
                .resizable()
                .scaledToFill()
        } else {
            placeholder()
        }
    }
}

private extension PlannerPostMediaView {
    var uiImage: UIImage? {
        guard let imageData else {
            return nil
        }

        return UIImage(data: imageData)
    }
}
