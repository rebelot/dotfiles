return {
    cmd = { "ccls" },
    init_options = {
        cache = {
            directory = "/tmp/ccls",
        },
        clang = {
            -- run: clang -print-resource-dir
            resourceDir = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/14.0.0",
            extraArgs = {
                -- run: clang -xc++ -fsyntax-only -v /dev/null
                "-isystem/usr/local/include",
                "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/v1",
                "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/14.0.0/include",
                "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include",
                "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
                "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks",
                "-std=c++17",
                "-Wall",
                "-Wextra",
            },
        },
    },
}
