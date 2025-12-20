# IRIS Zed Extension

This extension provides comprehensive editor support for IRIS language files (`.iris`).
It expects an Iris source checkout in your workspace to run the language server.

## Features

### Syntax Highlighting
- Tree-sitter grammar for IRIS S-expressions
- Full syntax highlighting for keywords, types, functions, and literals
- Bracket matching and code folding

### Language Server (LSP)
- **Real-time diagnostics**: Parse errors and type errors as you type
- **Auto-completion**: Keywords, types, and IRIS constructs
- **Hover information**: Documentation for IRIS keywords
- **Code outline**: Navigate through functions, types, and constants

### Editor Features
- Comment toggling (`;;` for line comments)
- Smart indentation
- Bracket auto-pairing
- Symbol outline view

## Installation

### Prerequisites
- [Zed Editor](https://zed.dev/)
- **Rust installed via [rustup](https://rustup.rs/)** (required for Zed extensions)
  - If you have Rust from Homebrew or other sources, uninstall it first
  - Install rustup: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Node.js and npm installed (for the LSP server)
- IRIS repository cloned locally (for the language server)

### Install as Dev Extension

1. Navigate to the IRIS repository root and install dependencies:
   ```bash
   npm install
   ```

2. Open Zed and run the command palette (Cmd+Shift+P)

3. Select "Install Dev Extension"

4. Navigate to and select this repository (`iris-zed`)

5. The extension will be installed and activated automatically

6. If you make changes to the extension, reload it:
   - Open command palette (Cmd+Shift+P)
   - Select "Zed: Reload Extensions"
   - Or restart Zed

## Usage

Once installed, the extension will automatically activate for any `.iris` files.
Open the Iris repository as your workspace so the LSP can find:
- `dist/src/lsp-server.js` (preferred)
- `lsp-start.sh`
- `src/lsp-server.ts`

### LSP Features

The language server provides:
- **Parse error detection**: Unbalanced parentheses, syntax errors
- **Type checking**: Return type mismatches, argument type errors, effect system violations
- **Auto-completion**: Type `.` or `(` to trigger keyword and type suggestions

### Example

Open any `.iris` file (e.g., `examples/hello_full.iris` from the IRIS repo) to see:
- Syntax highlighting
- Real-time error diagnostics
- Code outline in the sidebar

## Development

The extension consists of:
- **Tree-sitter grammar**: `tree-sitter-iris/` (from the IRIS repo)
- **Language server**: `src/lsp-server.ts` (in the IRIS repo)
- **Extension config**: `extension.toml`

To modify the extension:
1. Make changes to the source files
2. Rebuild with `npm run build`
3. Reload the extension in Zed (Cmd+Shift+P → "Reload Extensions")

## Troubleshooting

**Extension fails to compile:**
- Ensure Rust is installed via rustup (not Homebrew)
- Run `rustup --version` to verify rustup is installed
- If you have Rust from Homebrew, uninstall it: `brew uninstall rust`
- Install rustup: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

**Language server doesn't start:**
- Ensure Node.js and npm are in your PATH
- Check that `npx ts-node` works from the command line
- Navigate to the IRIS repo root and run `npm install`
- View Zed logs: Help → View Logs

## License

Same as IRIS: MIT OR Apache-2.0
