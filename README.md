# swift-icudata-slim

A lightweight Swift package providing a slimmed-down version of ICU (International Components for Unicode) data. This package is designed to reduce the size of ICU data for use in Swift projects where full ICU data is unnecessary, improving build size and performance.

## Overview

This package is especially useful for platforms that only support static linking, such as WebAssembly, or when using `swift build --static-swift-stdlib` on Linux to produce statically linked executables.


| ICU Data Variant      | Data Size | Description |
|:----------------------|----------:|---------------------------------------------|
| Default               |   29.3 MB | Full ICU data, all locales and features |
| `ICUDataSlim`         |    8.5 MB | Excludes some ICU features not used by Foundation; <br/> locale limited to `en_US` (see [default.json](./Scripts/filters/default.json)) |
| `ICUDataSlim_Minimal` |    1.2 MB | Excludes even more features for a smaller footprint; <br/> locale limited to `en_US` (see [minimal.json](./Scripts/filters/minimal.json)) |

## When to use minimal

The `ICUDataSlim_Minimal` variant further reduces binary size by disabling additional ICU features. Use this variant **only if your application does not require** the following Foundation APIs or ICU features, which will not work due to the exclusions.

### Additional features excluded in `ICUDataSlim_Minimal`

Compared to the standard `ICUDataSlim`, the minimal variant also excludes:

| Excluded Feature      | Affected Foundation APIs / Impact |
|---------------------- |-----------------------------------|
| `region_tree`, `locales_tree` | `Locale` |
| `zone_*`              | `TimeZone` |
| `conversion_mappings` | `String.data(using:)`, `String.init(data:encoding:)` for non-unicode encodings may fail |
| `curr_tree`           | `NumberFormatter` with `.currency` style, `Locale.currencyCode`, `Locale.currencySymbol` |
| `translit`            | `NSMutableString.applyTransform(_:reverse:)` |
| `coll_ucadata`, `coll_tree` | `NSString.compare(_:options:range:locale:)`, `String.localizedStandardCompare(_:)` |
| `normalization`       | `NSString.decomposedStringWithCanonicalMapping`, `NSString.precomposedStringWithCanonicalMapping`, `NSString.decomposedStringWithCompatibilityMapping`, `NSString.precomposedStringWithCompatibilityMapping` |

If you are unsure whether your app relies on any of these features or APIs, use the standard `ICUDataSlim` variant instead of `ICUDataSlim_Minimal`.

## Installation

Add `swift-icudata-slim` to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/GoodNotes/swift-icudata-slim.git", from: "1.0.0")
```

Then add it as a dependency to your **executable** target:

```swift
.executableTarget(
    name: "YourTarget",
    dependencies: [
        .product(name: "ICUDataSlim", package: "swift-icudata-slim")
    ]
)
```

See the [`Example`](./Example) directory for a complete setup.

> [!WARNING]
> The pre-compiled ICU data included in this package assumes a little endian platform. Big endian platforms are not supported. (Swift does not officially support big endian platforms though)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
