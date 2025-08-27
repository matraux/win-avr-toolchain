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

**PowerShell toolchain for fast CLI development, memory analysis, and firmware upload for AVR microcontrollers on Windows 10/11.**<br>
Modular, easy to configure, and focused on efficient developer workflow.

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

## Requirements
| version | PowerShell | Windows | Note
|----|----|---|---
| 1.0.0 | 5.1+ | 10/11 | Initial release, modular OOP refactor
| 1.1.0 | 5.1+ | 10/11 | Improved OOP, separated commands

- Windows 10 or 11 with PowerShell 5.1+
- **AVR GCC toolchain** – Download the official [Atmel AVR 8-bit Toolchain for Windows](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers).
	- Recommended install path: `C:\AVR\avr-gcc\`
- **avrdude** programmer utility – Download from the [official avrdude GitHub releases](https://github.com/avrdudes/avrdude/releases).
	- Recommended install path: `C:\AVR\avrdude\`

## Installation

1. **Clone the repository** to any folder (recommended: `C:/AVR/win-avr-toolchain/`) or download release:
   ```powershell
   git clone https://github.com/matraux/win-avr-toolchain.git
   ```
2. **Install dependencies:**

   - Download and install [Atmel AVR 8-bit Toolchain for Windows](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers) (recommended: `C:/AVR/avr-gcc/`)
   - Download and install [avrdude](https://github.com/avrdudes/avrdude/releases) (recommended: `C:/AVR/avrdude/`)
3. **Copy and edit configuration:**
   - Copy `config/Config.json.dist` to `config/Config.json`.
   - Edit the file with absolute paths to your `avr-gcc.exe`, `avr-objcopy.exe`, `avr-size.exe`, and `avrdude.exe`.
   - Example:
     ```json
     {
       "AvrGcc": "C:/AVR/avr-gcc/bin/avr-gcc.exe",
       "AvrObjcopy": "C:/AVR/avr-gcc/bin/avr-objcopy.exe",
       "AvrSize": "C:/AVR/avr-gcc/bin/avr-size.exe",
       "Avrdude": "C:/AVR/avrdude/avrdude.exe"
     }
     ```
4. **(Optional) Set PowerShell Execution Policy**
   If you see an execution policy error, run PowerShell with bypass:

   ```powershell
   powershell -ExecutionPolicy Bypass
   ```
5. **Run a command!**
   See below for example workflows.

<br>

## Typical Project Structure

A typical project for firmware development might look like:

```
D:/AVR/Projects/YourProject/
├── includes/
│ ├── port.h
│ └── io.h
├── main.c
├── utils.c
├── ...
```

<br>

## Examples

### Build & Flash
```powershell
# Compile all C/C++ sources in YourProject, then flash firmware to an atmega16 MCU with a usbasp programmer:
.\src\Commands\Flash.ps1 -Source "D:\AVR\Projects\YourProject" -MCU atmega16 -Programmer usbasp
```

### Memory Usage
```powershell
# Analyze memory usage in an ELF file for atmega16:
.\src\Commands\MemoryUsage.ps1 -Elf "D:\AVR\Projects\YourProject\firmware.elf" -MCU atmega16
```

### Write MCU Memory
```powershell
# Write value 'DF' to MCU memory 'hfuse':
.\src\Commands\WriteMcu.ps1 -MCU atmega16 -Programmer usbasp -Memory hfuse -Value DF
```

### Read MCU Memory
```powershell
# Read value from MCU memory 'hfuse':
.\src\Commands\ReadMcu.ps1 -MCU atmega16 -Programmer usbasp -Memory hfuse
```

<br>

## Support
For bug reports and feature requests, please use the [issue tracker](https://github.com/matraux/win-avr-toolchain/issues).