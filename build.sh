#!/bin/bash
set -e

echo "Building IRIS Zed extension..."
cargo build --release --target wasm32-wasip1

echo "Converting to WASM component..."
# Download adapter if not present
if [ ! -f /tmp/wasi_snapshot_preview1.reactor.wasm ]; then
    curl -L https://github.com/bytecodealliance/wasmtime/releases/download/v14.0.0/wasi_snapshot_preview1.reactor.wasm -o /tmp/wasi_snapshot_preview1.reactor.wasm
fi

wasm-tools component new target/wasm32-wasip1/release/iris.wasm -o extension.wasm --adapt /tmp/wasi_snapshot_preview1.reactor.wasm

echo "✓ Extension built successfully: extension.wasm"
echo "Restart Zed to load the updated extension."
