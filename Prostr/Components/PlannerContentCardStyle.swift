//
//  PlannerContentCardStyle.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import SwiftUI

struct PlannerContentCardPalette {
    let gradientStartColor: Color
    let gradientEndColor: Color
    let statusBackgroundColor: Color
    let statusTextColor: Color
    let primaryTextColor: Color
    let secondaryTextColor: Color
    let metaTextColor: Color
    let tagBackgroundColor: Color
    let tagTextColor: Color
    let placeholderTopColor: Color
    let placeholderBottomColor: Color
    let borderColor: Color
    let shadowColor: Color

    static let draft = PlannerContentCardPalette(
        gradientStartColor: Color(hex: "FBFBFE"),
        gradientEndColor: Color(hex: "EDEFFF"),
        statusBackgroundColor: Color(hex: "A9B0D9"),
        statusTextColor: .white,
        primaryTextColor: Color(hex: "1F1C1B"),
        secondaryTextColor: Color(hex: "4F4B54"),
        metaTextColor: Color(hex: "6B7290"),
        tagBackgroundColor: Color(hex: "DEE3FF"),
        tagTextColor: Color(hex: "48537A"),
        placeholderTopColor: Color(hex: "F0F2FF"),
        placeholderBottomColor: Color(hex: "DCE0FF"),
        borderColor: Color.white.opacity(0.75),
        shadowColor: Color(hex: "20213D", opacity: 0.10)
    )

    static let scheduled = PlannerContentCardPalette(
        gradientStartColor: Color(hex: "D4EDFF"),
        gradientEndColor: Color(hex: "F1F9FF"),
        statusBackgroundColor: Color(hex: "5D98C2"),
        statusTextColor: .white,
        primaryTextColor: Color(hex: "1F1C1B"),
        secondaryTextColor: Color(hex: "48515B"),
        metaTextColor: Color(hex: "557B99"),
        tagBackgroundColor: Color(hex: "D6EEF9"),
        tagTextColor: Color(hex: "315A71"),
        placeholderTopColor: Color(hex: "E5F5FF"),
        placeholderBottomColor: Color(hex: "C9E9FF"),
        borderColor: Color.white.opacity(0.72),
        shadowColor: Color(hex: "1F5E84", opacity: 0.10)
    )

    static let planned = PlannerContentCardPalette(
        gradientStartColor: Color(hex: "C9EFF1"),
        gradientEndColor: Color(hex: "F3FEFF"),
        statusBackgroundColor: Color(hex: "6A9B97"),
        statusTextColor: .white,
        primaryTextColor: Color(hex: "1F1C1B"),
        secondaryTextColor: Color(hex: "475453"),
        metaTextColor: Color(hex: "568988"),
        tagBackgroundColor: Color(hex: "C9F0C9"),
        tagTextColor: Color(hex: "2E6C49"),
        placeholderTopColor: Color(hex: "DDF8F8"),
        placeholderBottomColor: Color(hex: "C5ECEF"),
        borderColor: Color.white.opacity(0.72),
        shadowColor: Color(hex: "286467", opacity: 0.10)
    )
}

extension PlannerCardState {
    var iconAssetName: String {
        switch self {
        case .draft:
            return "draftIcon"
        case .planned:
            return "plannedIcon"
        case .scheduled:
            return "scheduledIcon"
        }
    }

    var palette: PlannerContentCardPalette {
        switch self {
        case .draft:
            return .draft
        case .planned:
            return .planned
        case .scheduled:
            return .scheduled
        }
    }
}
