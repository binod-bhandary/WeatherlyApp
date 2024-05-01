//
//  Extensions.swift
//  Weatherly
//
//  Created by iMac on 29/4/2024.
//

import Foundation
// Extension on the Double type to add a method for rounding doubles to a string format.
import SwiftUI
extension Double {
    // Converts a Double to a String formatted to zero decimal places.
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

// Extension on the View type to allow corner rounding on specific corners.
extension View {
    // Applies a corner radius to specific corners of a View.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        // Uses a custom shape, RoundedCorner, to apply the radius only to specified corners.
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
// Custom shape to enable selective corner rounding.
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity // The radius of the curve.
    var corners: UIRectCorner = .allCorners // The corners to which the radius will be applied.
    // Creates a path for the shape, rounding only the specified corners.
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
