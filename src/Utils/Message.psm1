class Message {
	static [void] Block(
		[string]$Message,
		[string]$Prefix = "",
		[ConsoleColor]$BackgroundColor = [ConsoleColor]::Black,
		[ConsoleColor]$ForegroundColor = [ConsoleColor]::White
	) {
		$HostRef = $global:Host
		$prefixPad = if ($Prefix.Trim()) { " $($Prefix.Trim()) " } else { " " }
		$prefixLen = $prefixPad.Length
		$width = $HostRef.UI.RawUI.WindowSize.Width
		$padding = " " * $width

		Write-Host $padding -NoNewline -BackgroundColor $BackgroundColor

		$lines = ($Message -replace "`r", "") -split "`n"
		for ($i = 0; $i -lt $lines.Length; $i++) {
			$cleanLine = $lines[$i]
			if ($i -eq 0) {
				$fullLine = $prefixPad + $cleanLine
			}
			else {
				$fullLine = (" " * $prefixLen) + $cleanLine
			}
			Write-Host $fullLine.PadRight($width) -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor
		}

		Write-Host $padding -NoNewline -BackgroundColor $BackgroundColor
		Write-Host " "
	}

	static [void] Success([string]$Message) {
		[Message]::Block($Message, "[OK]", [ConsoleColor]::DarkGreen, [ConsoleColor]::White)
	}

	static [void] Error([string]$Message) {
		[Message]::Block($Message, "[ERROR]", [ConsoleColor]::DarkRed, [ConsoleColor]::White)
	}

	static [void] Caution([string]$Message) {
		[Message]::Block($Message, "[CAUTION]", [ConsoleColor]::DarkRed, [ConsoleColor]::White)
	}

	static [void] Warning([string]$Message) {
		[Message]::Block($Message, "[WARNING]", [ConsoleColor]::DarkYellow, [ConsoleColor]::White)
	}

	static [void] Info([string]$Message) {
		[Message]::Block($Message, "[INFO]", [ConsoleColor]::DarkCyan, [ConsoleColor]::White)
	}

	static [void] Text([string]$Message) {
		[Message]::Block($Message, "", [ConsoleColor]::Black, [ConsoleColor]::White)
	}
}
