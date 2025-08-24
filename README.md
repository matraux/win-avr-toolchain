# MATRAUX Windows AVR Toolchain
[![Latest Release](https://img.shields.io/github/v/release/matraux/win-avr-toolchain?display_name=tag&logo=github&logoColor=white)](https://github.com/matraux/win-avr-toolchain/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?logo=open-source-initiative&logoColor=white)](LICENSE)
[![Platform](https://img.shields.io/badge/Windows-PowerShell-blue?logo=windows&logoColor=white)](#requirements)
[![Security Policy](https://img.shields.io/badge/Security-Policy-blue?logo=bitwarden&logoColor=white)](./.github/SECURITY.md)
[![Contributing](https://img.shields.io/badge/Contributing-Disabled-lightgrey?logo=github&logoColor=white)](CONTRIBUTING.md)
[![Issues](https://img.shields.io/github/issues/matraux/win-avr-toolchain?logo=github&logoColor=white)](https://github.com/matraux/win-avr-toolchain/issues)
[![Last Commit](https://img.shields.io/github/last-commit/matraux/win-avr-toolchain?logo=git&logoColor=white)](https://github.com/matraux/win-avr-toolchain/commits)

<br>

## Introduction
A Windows-only PowerShell toolkit for orchestrating compilation, memory analysis, and uploading firmware for AVR microcontrollers.<br>
Designed for fast, automated CLI development workflows on Windows 10/11.<br>

<br>

## Features
- AVR GCC compiler, objcopy, avrdude, and size analysis
- Simple CLI workflow: build, analyze, flash, fuse/lock manipulation
- Strong PowerShell OOP: every function as a class, easy to extend
- Modern, modular code organization
- Colored and structured output (incl. tables, status blocks)
- Auto-discovery of toolchain paths via JSON config
- Full error reporting and feedback
- Clear, readable command-line interface (PowerShell only)
- **Platform:** Windows 10/11 only (PowerShell 5.1+)

<br>

## Installation
Clone the repository anywhere on your computer, configure `Config.json` to match your tool paths, and run scripts via PowerShell.

```bash
git clone https://github.com/matraux/win-avr-toolchain.git
```

<br>

## Requirements
| version | PowerShell | Windows | Note
|----|----|---|---
| 1.0.0 | 5.1+ | 10/11 | Initial release, modular OOP refactor

- **AVR GCC toolchain** (e.g., [Atmel AVR Toolchain for Windows](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers))
- **avrdude** utility (e.g., [official builds](https://github.com/avrdudes/avrdude/releases))

<br>

## Configuration

All tool paths are stored in `./config/Config.json` (or fallback `./config/Config.json.dist`).
```json
{
	"AvrGcc": "D:/AVR/avr-gcc/bin/avr-gcc.exe",
	"AvrObjcopy": "D:/AVR/avr-gcc/bin/avr-objcopy.exe",
	"AvrSize": "D:/AVR/avr-gcc/bin/avr-size.exe",
	"Avrdude": "D:/AVR/avrdude/avrdude.exe"
}
```

<br>

## Examples
Build & Flash
```powershell
"D:\AVR\Compiler\src\Build-Flash.ps1" -Source "D:\AVR\Projects\YourProject" -MCU atmega16 -Programmer usbasp
```

<br>

## Support
For bug reports and feature requests, please use the [issue tracker](https://github.com/matraux/win-avr-toolchain/issues).