<#
	.SYNOPSIS
	Compiles sources and flashes firmware to an AVR microcontroller in one step.

	.EXAMPLE
	Build-Flash.ps1 -Source .\src -MCU atmega16 -Programmer usbasp
#>

using module '.\Compiler\Elf.psm1'
using module '.\Compiler\Memory.psm1'
using module '.\Compiler\Hex.psm1'
using module '.\MCU\MCU.psm1'

[CmdletBinding()]
param(
	[Parameter(Mandatory)]
	[string]$Source,

	[Parameter(Mandatory, HelpMessage = "MCU (e.g. atmega16, attiny25, atmega88)")]
	[string]$MCU,

	[Parameter(Mandatory, HelpMessage = "Programmer (e.g. usbasp, ft232h)")]
	[string]$Programmer,

	[Parameter(HelpMessage = "Optimization compiled code (e.g. 0, 1, 2, 3, s, fast)")]
	[string]$Optimization = "s"
)

$Elf = $null
$Hex = $null

# Build ELF
try {
	$Elf = [Elf]::Build($Source, $MCU, $Optimization)
}
catch {
	if ($Elf -and (Test-Path $Elf)) { Remove-Item $Elf -ErrorAction SilentlyContinue }
	throw
}

# Memory usage
try {
	[Memory]::Usage($Elf, $MCU)
}
catch {
	throw
}

# Build HEX
try {
	$Hex = [Hex]::Build($Elf)
}
catch {
	if ($Hex -and (Test-Path $Hex)) { Remove-Item $Hex -ErrorAction SilentlyContinue }
	throw
}
finally {
	if ($Elf -and (Test-Path $Elf)) { Remove-Item $Elf -ErrorAction SilentlyContinue }
}

# Write MCU
try {
	[MCU]::Write($MCU, $Programmer, 'flash', $Hex)
}
catch {
	throw
}
finally {
	if ($Hex -and (Test-Path $Hex)) { Remove-Item $Hex -ErrorAction SilentlyContinue }
}