# swift-icudata-slim

A lightweight Swift package providing a slimmed-down version of ICU (International Components for Unicode) data. This package is designed to reduce the size of ICU data for use in Swift projects where full ICU data is unnecessary, improving build size and performance.

## Overview

This package is especially useful for platforms that only support static linking, such as WebAssembly, or when using `swift build --static-swift-stdlib` on Linux to produce statically linked executables.


| ICU Data Variant      | Data Size | Description |
|:----------------------|----------:|---------------------------------------------|
| Default               |   29.3 MB | Full ICU data, all locales and features |
| `ICUDataSlim`         |    8.6 MB | Excludes some ICU features not used by Foundation; <br/> locale limited to `en_001` (see [default.json](./Scripts/filters/default.json)) |
| `ICUDataSlim_Minimal` |    1.5 MB | Excludes even more features for a smaller footprint; <br/> locale limited to `en_001` (see [minimal.json](./Scripts/filters/minimal.json)) |

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
.package(url: "https://github.com/GoodNotes/swift-icudata-slim.git", from: "0.2.0")
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

## FAQ

### Why is `en_001` used as the only available locale?

The slimmed-down variants include only the `en_001` locale.
On non-Apple platforms, the swift-foundation implementation *always* returns `en_001` by `Locale.current` regardless of environment variables or system locale settings.

For more details, you can refer to the relevant implementation in the [swift-foundation source code](https://github.com/swiftlang/swift-foundation/blob/swift-6.2-DEVELOPMENT-SNAPSHOT-2025-07-08-a/Sources/FoundationEssentials/Locale/Locale_Unlocalized.swift#L39).

### I want even smaller ICU data! What can I do?

If you want to make your ICU data even smaller and more tailored to your needs, you can use the `Scripts/package-icudata.py` script to generate a custom C source file. In most cases, it's easiest to specify the Swift version you are targeting. For example:

```sh
python3 Scripts/package-icudata.py --swift-version 6.2 --filter-json <YOUR_FILTER.json> --output <OUTPUT_C_FILE>
```

To get the most out of this, you can write your own filter JSON file to control exactly which locales and features are included. For details on how to write these filter files and what options are available, check out the official [ICU Data Build Tool documentation](https://unicode-org.github.io/icu/userguide/icu_data/buildtool.html).

Once you've generated your custom C file, simply include it in your project and link it as needed. This gives you full control over the ICU data size and contents.

> Advanced: If you need to target a specific ICU version instead, you can use `--icu-version <ICU_VERSION>`, but for most people, `--swift-version` is the way to go.

## Development

If you modify or add a filter in the `Scripts/filters/` directory, make sure to re-run the build script to regenerate the ICU data sources:

```sh
python3 Scripts/build-all.py
```

This will rebuild all ICU data variants using the updated filters.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
