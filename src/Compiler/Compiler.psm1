using module "..\Toolchain\Toolchain.psm1"
using module "..\Utils\Message.psm1"
using module "..\Utils\Table.psm1"

class Compiler {

	hidden static [string[]] $ValidOptimizations = @('0', '1', '2', '3', 's', 'fast')

	static [string] BuildElf([string]$Source, [string]$MCU, [string]$Optimization = "s") {
		if ($Optimization -notin [Compiler]::ValidOptimizations) {
			[Message]::Error("Expected optimization level [$([Compiler]::ValidOptimizations -join ', ')], `"$Optimization`" given.")
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

	static [void] MemoryUsage([string]$Elf, [string]$Mcu) {
		if (!(Test-Path $Elf)) {
			[Message]::Error("No such file `"$Elf`"")
			throw
		}

		$SizeArgs = @(
			("--mcu={0}" -f $MCU),
			"-C", $Elf
		)

		$result = (& ([Toolchain]::AvrSize) @SizeArgs 2>&1) -join "`n"

		if ($LASTEXITCODE -ne 0) {
			[Message]::Error("Memory usage failed `n$result")
			throw
		}

		$pattern = '(Program|Data):\s*(\d+)\s*bytes\s*\(([^%]*)'
		$table = [Table]::new()
		$table.SetHeader(@('Memory type', 'Usage bytes', 'Usage %'), "Cyan")

		foreach ($item in [regex]::Matches($result, $pattern)) {
			$type = $item.Groups[1].Value
			$bytes = $item.Groups[2].Value
			$percent = [double]$item.Groups[3].Value.Trim()

			$row = $table.AddRow(@($type, $bytes, $percent))

			if ($percent -ge 95) {
				$row.SetFgColor([ConsoleColor]::DarkRed)
				[Message]::Caution("Memory `"$type`" usage $percent% ($bytes bytes)")
			}
			elseif ($percent -ge 90) {
				$row.SetFgColor([ConsoleColor]::DarkYellow)
				[Message]::Warning("Memory `"$type`" usage $percent% ($bytes bytes)")
			}
		}

		$table.Draw()
	}

	static [string] BuildHex([string]$Elf) {
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

	static [void] RemoveFile([string] $File) {
		if (Test-Path $File) {
			Remove-Item $File -ErrorAction SilentlyContinue
		}
	}

}
