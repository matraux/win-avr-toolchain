using module "..\Toolchain.psm1"
using module "..\Utils\Message.psm1"

class Hex {
	static [string] Build([string]$Elf) {
		if (!(Test-Path $Elf)) {
			[Message]::Error("No such file `"$Elf`"")
			throw
		}

		$TempDir = [System.IO.Path]::GetTempPath()
		$HexPath = Join-Path $TempDir ("firmware_{0}.hex" -f ([guid]::NewGuid().ToString('N')))

		$ObjcopyArgs = @(
			"-O", "ihex",
			$Elf,
			$HexPath
		)

		[Message]::Text("Building HEX")

		$result = (& ([Toolchain]::AvrObjcopy) @ObjcopyArgs 2>&1) -join "`n"

		if ($LASTEXITCODE -ne 0) {
			[Message]::Error("HEX build failed `n$result")
			throw
		}

		[Message]::Success("HEX built")

		return $HexPath
	}
}
