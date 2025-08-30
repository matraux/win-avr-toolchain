using module '.\..\Avrdude\Avrdude.psm1'

[CmdletBinding()]
param(
	[Parameter(Mandatory, HelpMessage = "MCU (e.g. atmega16, attiny25, atmega88, ...)")]
	[string]$MCU,

	[Parameter(Mandatory, HelpMessage = "Programmer (e.g. usbasp, FT232H, FT245R, ...)")]
	[string]$Programmer,

	[Parameter(Mandatory, HelpMessage = "Memory (e.g. lfuse, hfuse, efuse, lock, flash, eeprom)")]
	[string]$Memory
)

# Read MCU
try {
	[Avrdude]::Read($MCU, $Programmer, $Memory)
}
catch {
	throw
}