# RCTUI — design system

`RCTUI` is the design system used by the RCT screens. It is built **on top of
Apple's native components** (`List`, `Form`, `Table`, `LabeledContent`,
`ContentUnavailableView`, toolbars, menus, SF Symbols) and only adds what
SwiftUI does not provide out of the box. It follows the Human Interface
Guidelines on iOS, iPadOS and macOS.

## Principles

1. **Native first.** If a system component exists, use it. Layout metrics,
   separators, selection, Liquid Glass toolbars and tab bars come from the OS.
2. **System colors only.** Status colors come from `DSTone`, which maps to
   `.green`, `.orange`, `.red`… so light/dark mode and Increase Contrast work.
3. **Text styles only.** Fonts use Dynamic Type text styles; monospaced
   variants (`Font.dsCode`) are reserved for technical content.
4. **Color is never the only signal.** A status always has a text (code,
   level) or a symbol shape in addition to its color.

## Content

| Folder | What | Main types |
|---|---|---|
| `Tokens` | Semantic values | `DSTone`, `DSSpacing`, `Font.dsCode` / `.dsMetric` |
| `Formatting` | Shared value formatting | `DSFormat`, `DSSyntaxHighlighter` |
| `Components` | Reusable views | `DSListRow`, `DSKeyValueRow`, `DSStatusText`, `DSToneIcon`, `DSCodeBlock`, `DSEmptyState`, `DSFilterMenu`, `DSFilterPicker`, `DSWebView`, `DSPasteboard` |
| `Modifiers` | View modifiers | `dsCopyable`, `dsNavigationTitle`, `dsOnChange` |
| `Catalog` | Previews | `DSCatalogView` (light, dark, accessibility sizes) |

## Tones

| Tone | System color | SF Symbol | Used for |
|---|---|---|---|
| `neutral` | `.secondary` | `minus.circle.fill` | Unknown |
| `info` | `.blue` | `info.circle.fill` | Info logs |
| `success` | `.green` | `checkmark.circle.fill` | 2xx |
| `notice` | `.cyan` | `arrow.triangle.turn.up.right.circle.fill` | 3xx |
| `warning` | `.orange` | `exclamationmark.triangle.fill` | 4xx, warnings, slow requests (≥ 1 s) |
| `critical` | `.red` | `xmark.octagon.fill` | 5xx, failures, errors |

## Platform mapping used by RCT

| Need | iPhone | iPad | Mac |
|---|---|---|---|
| Navigation | `TabView` + `NavigationStack` | `NavigationSplitView` (3 columns) | `NavigationSplitView` + `.inspector` |
| Collections | `List` (`.insetGrouped`) | `List` with selection | `Table` (sortable) |
| Details | `Form` (`.grouped`) | `Form` (`.grouped`) | `Form` (`.grouped`) in the inspector |
| Filters | `DSFilterMenu` in the toolbar | `DSFilterMenu` | `DSFilterPicker` (segmented) |
| Search | `.searchable` | `.searchable` | `.searchable(placement: .toolbar)` |
| Sharing | `ShareLink` in a `Menu` | same | same |
