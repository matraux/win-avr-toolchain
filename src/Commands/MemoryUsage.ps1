using module '.\..\Compiler\Compiler.psm1'

[CmdletBinding()]
param(
	[Parameter(Mandatory, HelpMessage = "Path to ELF file")]
	[string]$Elf,

	[Parameter(Mandatory, HelpMessage = "MCU (e.g. atmega16, attiny25, atmega88, ...)")]
	[string]$MCU
)

try {
	[Compiler]::MemoryUsage($Elf, $MCU)
}
catch {
	throw
}