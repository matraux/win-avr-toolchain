using module "..\Utils\Message.psm1"
using module "..\Toolchain.psm1"

class Elf {
	hidden static [string[]] $ValidOptimizations = @('0', '1', '2', '3', 's', 'fast')

	static [string] Build([string]$Source, [string]$MCU, [string]$Optimization = "s") {
		if ($Optimization -notin [Elf]::ValidOptimizations) {
			[Message]::Error("Expected optimization level [$([Elf]::ValidOptimizations -join ', ')], `"$Optimization`" given.")
			throw
		}

		$CSources = Get-ChildItem -Path $Source -Filter *.c -Recurse -ErrorAction SilentlyContinue
		$CppSources = Get-ChildItem -Path $Source -Filter *.cpp -Recurse -ErrorAction SilentlyContinue
		$SourceFiles = @($CSources + $CppSources | ForEach-Object { "`"$($_.FullName)`"" })

		if (-not $SourceFiles -or $SourceFiles.Count -eq 0) {
			[Message]::Error("No such C/C++ files in `"$Source`"")
			throw
		}

		$ElfPath = Join-Path ([System.IO.Path]::GetTempPath()) ("firmware_{0}.elf" -f ([guid]::NewGuid().ToString('N')))

		$GccArgs = @(
			"-mmcu={0}" -f $MCU
			"-O{0}" -f $Optimization
			"-o", $ElfPath,
			$SourceFiles
		)

		[Message]::Text("Building ELF")

		$result = (& ([Toolchain]::AvrGcc) @GccArgs 2>&1) -join "`n"

		if ($LASTEXITCODE -ne 0) {
			[Message]::Error("ELF build failed `n$result")
			throw
		}

		[Message]::Success("ELF built")

		return $ElfPath
	}
}
