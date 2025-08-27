class TableRowStyle {
	[string]$ForegroundColor = "White"
	[string]$BackgroundColor = "Black"
}

class TableRow {
	[object[]]$Values
	[TableRowStyle]$Style

	TableRow([object[]]$values) {
		$this.Values = $values
		$this.Style = [TableRowStyle]::new()
	}

	[TableRow] SetBgColor([string]$bg) {
		$this.Style.BackgroundColor = $bg
		return $this
	}
	[TableRow] SetFgColor([string]$fg) {
		$this.Style.ForegroundColor = $fg
		return $this
	}
}

class Table {
	[string[]]$Header
	[string]$HeaderColor = "Cyan"
	[TableRow[]]$Rows = @()

	Table() {
		$this.Rows = @()
	}

	[void] SetHeader([string[]]$header, [string]$color = "Cyan") {
		$this.Header = $header
		$this.HeaderColor = $color
	}

	[TableRow] AddRow([object[]]$row) {
		$rowObj = [TableRow]::new($row)
		$this.Rows += $rowObj
		return $rowObj
	}

	[void] Draw() {
		if (-not $this.Header -or $this.Header.Count -eq 0) {
			Write-Host "No header set!"
			return
		}
		$colWidths = @()
		for ($i = 0; $i -lt $this.Header.Count; $i++) {
			$headerLen = $this.Header[$i].Length
			$maxDataLen = ($this.Rows | ForEach-Object { "$($_.Values[$i])".Length } | Measure-Object -Maximum).Maximum
			$colWidths += [Math]::Max($headerLen, $maxDataLen)
		}

		$top = "┌" + (($colWidths | ForEach-Object { "─" * ($_ + 2) }) -join "┬") + "┐"
		$sep = "├" + (($colWidths | ForEach-Object { "─" * ($_ + 2) }) -join "┼") + "┤"
		$bottom = "└" + (($colWidths | ForEach-Object { "─" * ($_ + 2) }) -join "┴") + "┘"

		Write-Host $top -ForegroundColor Gray
		# Header row
		Write-Host -NoNewline "│" -ForegroundColor Gray
		for ($i = 0; $i -lt $this.Header.Count; $i++) {
			$text = ("{0}" -f $this.Header[$i]).PadRight($colWidths[$i])
			Write-Host -NoNewline " $text " -ForegroundColor $this.HeaderColor
			Write-Host -NoNewline "│" -ForegroundColor Gray
		}
		Write-Host ""
		Write-Host $sep -ForegroundColor Gray

		# Data rows
		foreach ($row in $this.Rows) {
			Write-Host -NoNewline "│" -ForegroundColor Gray
			$fg = $row.Style.ForegroundColor
			$bg = $row.Style.BackgroundColor
			for ($i = 0; $i -lt $this.Header.Count; $i++) {
				$text = ("{0}" -f $row.Values[$i]).PadRight($colWidths[$i])
				Write-Host -NoNewline " $text " -ForegroundColor $fg -BackgroundColor $bg
				Write-Host -NoNewline "│" -ForegroundColor Gray
			}
			Write-Host ""
		}
		Write-Host $bottom -ForegroundColor Gray
	}
}
