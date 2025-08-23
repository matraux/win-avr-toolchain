using module "..\Toolchain.psm1"
using module "..\Utils\Message.psm1"

class MCU {
	hidden static [string[]] $ValidMemories = @("lfuse", "hfuse", "efuse", "lock", "flash", "eeprom")

	static [void] Read([string]$MCU, [string]$Programmer, [string]$Memory) {
		if ($Memory -notin [MCU]::ValidMemories) {
			[Message]::Error("Expected memory type [$([MCU]::ValidMemories -join ', ')], `"$Memory`" given.")
			throw
		}
		$AvrdudeArgs = @(
			"-c", $Programmer
			"-p", $MCU
			"-U", ("{0}:r:-:r" -f $Memory)
		)

		[Message]::Text("Reading $Memory memory")
		& ([Toolchain]::Avrdude) @AvrdudeArgs

		if ($LASTEXITCODE -ne 0) {
			[Message]::Error("$Memory memory reading failed")
			throw
		}
	}

	static [void] Write([string]$MCU, [string]$Programmer, [string]$Memory, [string]$Value) {
		if ($Memory -notin [MCU]::ValidMemories) {
			[Message]::Error("Expected memory type [$([MCU]::ValidMemories -join ', ')], `"$Memory`" given.")
			throw
		}
		$AvrdudeArgs = @(
			"-c", $Programmer
			"-p", $MCU
			"-U", ("{0}:w:`"{1}`":i" -f $Memory, $Value)
		)

		[Message]::Text("Writing $Memory memory")

		& ([Toolchain]::Avrdude) @AvrdudeArgs

		if ($LASTEXITCODE -ne 0) {
			[Message]::Error("Writing to $Memory memory failed")
			throw
		}

		[Message]::Success("Memory $Memory written")
	}
}
