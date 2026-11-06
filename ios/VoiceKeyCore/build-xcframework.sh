#!/bin/bash
# crates/core → VoiceKeyCoreFFI.xcframework（真机 arm64 + 模拟器 arm64/x86_64）
set -euo pipefail
cd "$(dirname "$0")"
export IPHONEOS_DEPLOYMENT_TARGET=17.0
export RUSTFLAGS="--remap-path-prefix=$HOME=~ --remap-path-prefix=$(cd ../.. && pwd)=."
export CFLAGS="-ffile-prefix-map=$HOME=~"
LIB=libvoicekey_ffi.a
T=rust/target
# CI/真机重签只需要 arm64 设备切片：跳过模拟器架构，磁盘占用减半
cargo build --manifest-path rust/Cargo.toml --release --target aarch64-apple-ios
rm -rf VoiceKeyCoreFFI.xcframework
xcodebuild -create-xcframework \
    -library "$T/aarch64-apple-ios/release/$LIB" -headers include \
    -output VoiceKeyCoreFFI.xcframework
