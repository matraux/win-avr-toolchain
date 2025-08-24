using module "..\Toolchain.psm1"
using module "..\Utils\Message.psm1"
using module "..\Utils\Table.psm1"

class Memory {
	static [void] Usage([string]$Elf, [string]$MCU) {
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
}
