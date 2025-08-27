using module '.\..\Compiler\Compiler.psm1'
using module '.\..\Avrdude\Avrdude.psm1'

[CmdletBinding()]
param(
	[Parameter(Mandatory, HelpMessage = "Path to C/C++ files source")]
	[string]$Source,

	[Parameter(Mandatory, HelpMessage = "MCU (e.g. atmega16, attiny25, atmega88)")]
	[string]$MCU,

	[Parameter(Mandatory, HelpMessage = "Programmer (e.g. usbasp, ft232h)")]
	[string]$Programmer,

	[Parameter(HelpMessage = "Optimization compiled code (e.g. 0, 1, 2, 3, s, fast)")]
	[string]$Optimization = "s"
)

# Build ELF
$Elf = $null
try {
	$Elf = [Compiler]::BuildElf($Source, $MCU, $Optimization)
}
catch {
	[Compiler]::RemoveFile($Elf)
	throw
}

# Memory usage
try {
	[Compiler]::MemoryUsage($Elf, $MCU)
}
catch {
	throw
}

# Build HEX
$Hex = $null
try {
	$Hex = [Compiler]::BuildHex($Elf)
}
catch {
	[Compiler]::RemoveFile($Hex)
	throw
}
finally {
	[Compiler]::RemoveFile($Elf)
}

# Write MCU
try {
	[Avrdude]::Write($MCU, $Programmer, 'flash', $Hex)
}
catch {
	throw
}
finally {
	[Compiler]::RemoveFile($Hex)
}