// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "whisper",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "whisper", targets: ["whisper"]),
    ],
    targets: [
        .target(
            name: "whisper",
            path: ".",
            exclude: [
               "bindings",
               "cmake",
               "examples",
               "extra",
               "models",
               "samples",
               "tests",
               "CMakeLists.txt",
               "Makefile"
            ],
            sources: [
                "ggml/src/ggml.c",
                "src/whisper.cpp",
                "ggml/src/ggml-alloc.c",
                "ggml/src/ggml-backend.c",
                "ggml/src/ggml-quants.c",
                "ggml/src/ggml-metal.m",
                "src/coreml/whisper-decoder-impl.h",
                "src/coreml/whisper-decoder-impl.m",
                "src/coreml/whisper-encoder-impl.h",
                "src/coreml/whisper-encoder-impl.m",
                "src/coreml/whisper-encoder.h",
                "src/coreml/whisper-encoder.mm"
            ],
            resources: [.process("ggml-metal.metal")],
            publicHeadersPath: "spm-headers",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3", "-DNDEBUG"]),
                .define("GGML_USE_ACCELERATE"),
                .unsafeFlags(["-fno-objc-arc"]),
                .define("WHISPER_USE_COREML"),
                .define("WHISPER_COREML_ALLOW_FALLBACK"),
                // NOTE: NEW_LAPACK will required iOS version 16.4+
                // We should consider add this in the future when we drop support for iOS 14
                // (ref: ref: https://developer.apple.com/documentation/accelerate/1513264-cblas_sgemm?language=objc)
                // .define("ACCELERATE_NEW_LAPACK"),
                // .define("ACCELERATE_LAPACK_ILP64")
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        )
    ],
    cxxLanguageStandard: .cxx11
)
