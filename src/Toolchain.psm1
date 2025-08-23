using module ".\Utils\Message.psm1"

class Toolchain {
	static [string]$AvrSize
	static [string]$AvrGcc
	static [string]$AvrObjcopy
	static [string]$Avrdude

	static [void] Init() {
		$ConfigFile = Join-Path $PSScriptRoot "..\Config\Config.json"
		$DefaultConfig = Join-Path $PSScriptRoot "..\Config\Config.json.dist"
		if (Test-Path $ConfigFile) {
			$json = Get-Content $ConfigFile -Raw
		}
		elseif (Test-Path $DefaultConfig) {
			$json = Get-Content $DefaultConfig -Raw
		}
		else {
			[Message]::Error("No configuration file found (Config.json or Config.json.dist).")
			throw
		}
		$obj = $json | ConvertFrom-Json

		[Toolchain]::AvrSize = [string]$obj.AvrSize
		[Toolchain]::AvrGcc = [string]$obj.AvrGcc
		[Toolchain]::AvrObjcopy = [string]$obj.AvrObjcopy
		[Toolchain]::Avrdude = [string]$obj.Avrdude
	}
}

[Toolchain]::Init()