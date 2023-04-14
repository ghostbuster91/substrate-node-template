rustup install 1.68.0
rustup default 1.68.0

rustup toolchain install nightly-2023-01-30
rustup target add wasm32-unknown-unknown --toolchain nightly-2023-01-30
rustup override set nightly-2023-01-30
