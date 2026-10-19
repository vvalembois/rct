//
//  DSFormat.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import Foundation

/// Formatting helpers shared by every screen so values always read the same way.
public enum DSFormat {

    /// Shown when a value is missing.
    public static let placeholder = "—"

    /// `0.374` → `374 ms`, `1.2` → `1.20 s`.
    public static func duration(_ seconds: Double?) -> String {
        guard let seconds, seconds.isFinite, seconds >= 0 else { return placeholder }
        if seconds < 1 {
            return "\(Int((seconds * 1000).rounded())) ms"
        }
        return String(format: "%.2f s", seconds)
    }

    /// `1214` → `1 KB` using the system file byte-count style.
    public static func byteCount(_ bytes: Int?) -> String {
        guard let bytes, bytes >= 0 else { return placeholder }
        return Int64(bytes).formatted(.byteCount(style: .file))
    }

    /// 24-hour time, `03:08:12.418` (or `03:08:12` without milliseconds).
    public static func time(_ date: Date?, milliseconds: Bool = true) -> String {
        guard let date else { return placeholder }
        return milliseconds ? timeWithMillisecondsFormatter.string(from: date) : timeFormatter.string(from: date)
    }

    /// Localized date followed by the precise time, `4 Oct 2025 03:08:12.418`.
    public static func dateTime(_ date: Date?) -> String {
        guard let date else { return placeholder }
        return "\(date.formatted(date: .abbreviated, time: .omitted)) \(time(date))"
    }

    /// `201` → `201 Created`.
    public static func httpStatus(_ code: Int) -> String {
        let reason = HTTPURLResponse.localizedString(forStatusCode: code).capitalized
        return reason.isEmpty ? "\(code)" : "\(code) \(reason)"
    }

    // DateFormatter is thread-safe for formatting; instances are cached because they are expensive.
    nonisolated(unsafe) private static let timeWithMillisecondsFormatter: DateFormatter = makeFormatter("HH:mm:ss.SSS")
    nonisolated(unsafe) private static let timeFormatter: DateFormatter = makeFormatter("HH:mm:ss")

    private static func makeFormatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }
}
