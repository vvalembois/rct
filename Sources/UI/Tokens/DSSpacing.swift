//
//  DSSpacing.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import CoreGraphics

/// Spacing scale based on Apple's 4 pt grid.
///
/// Native containers (List, Form, Table, toolbars) already apply the
/// platform metrics: only use these values inside custom row content.
public enum DSSpacing {
    public static let xxSmall: CGFloat = 2
    public static let xSmall: CGFloat = 4
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let xLarge: CGFloat = 20
    public static let xxLarge: CGFloat = 24
}
