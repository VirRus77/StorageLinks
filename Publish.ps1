param (
  [string] $RootPath,
  [string] $PublishName = "_Publish_"
)

if( [string]::IsNullOrWhiteSpace($RootPath) ){
  throw "RootPath is empty"
}

if( [string]::IsNullOrWhiteSpace($PublishName) ){
  throw "PublishName is empty"
}

[string] $publishPath = [System.IO.Path]::Combine($RootPath, $PublishName)

Write-Host "Root:         $RootPath"
Write-Host "Publish Path: $publishPath"
if ( [System.IO.Directory]::Exists($publishPath) ) {
  Write-Host "Clear: $publishPath"
  Remove-Item -Path "$publishPath\*" -Recurse -Force
} else {
  Write-Host "Make: $publishPath"
  New-Item -Path $publishPath -ItemType "directory" | Out-Null
}

# models (*.mtl, *.obj)
Write-Host "Copy models"
[string] $destDirectory = "models"
[string] $destination = [System.IO.Path]::Combine($publishPath, $destDirectory)
[string[]] $files = [System.IO.Directory]::GetFiles("$RootPath/$destDirectory", "*.mtl") + [System.IO.Directory]::GetFiles("$RootPath/$destDirectory", "*.obj")
Write-Host "Make: $destination"
New-Item -Path $destination -ItemType "directory" | Out-Null
$files | ForEach-Object { 
  [string] $destinationFile = [System.IO.Path]::Combine($destination, [System.IO.Path]::GetFileName($_) )
  Write-Host "Copy: $_ to $destinationFile"
  Copy-Item -Path $_ -Destination $destinationFile
}

# textures (*.png, *.jpg)
Write-Host "Copy textures"
[string] $destDirectory = "textures"
[string] $destination = [System.IO.Path]::Combine($publishPath, $destDirectory)
[string[]] $files = [System.IO.Directory]::GetFiles("$RootPath/$destDirectory", "*.png") + [System.IO.Directory]::GetFiles("$RootPath/$destDirectory", "*.jpg")
Write-Host "Make: $destination"
New-Item -Path $destination -ItemType "directory" | Out-Null
$files | ForEach-Object { 
  [string] $destinationFile = [System.IO.Path]::Combine($destination, [System.IO.Path]::GetFileName($_) )
  Write-Host "Copy: $_ to $destinationFile"
  Copy-Item -Path $_ -Destination $destinationFile
}

# ExampleGame
Write-Host "Copy ExampleGame"
[string] $destDirectory = "ExampleGame"
[string] $destination = [System.IO.Path]::Combine($publishPath, $destDirectory)
Copy-Item -Path "$RootPath/$destDirectory" -Destination $destination -Recurse

# Join multi lua files
Write-Host "Join lua files"
[string] $sourcePath = "$RootPath/LuaScripts";
[string[]] $fileNames = [System.IO.File]::ReadAllLines("$sourcePath/_Order", [System.Text.Encoding]::UTF8) | Where-Object { -not $_.TrimStart().StartsWith("#") }
[string] $destination = [System.IO.Path]::Combine($publishPath, "Storage Link 2.0.lua")
$fileNames | Where-Object { -not [string]::IsNullOrEmpty($_) } | ForEach-Object {
  [string] $fileContent = [System.IO.File]::ReadAllText("$sourcePath/$_")
  $fileContent = "----- $([System.IO.Path]::GetFileName($_)) -----`n`n" + $fileContent + "`n"
  Add-Content -Path $destination -Value $fileContent -Encoding "utf8"
}

# Copy steamModID
Write-Host "Copy steamModID"
[string] $fileName = "steamModID"
Copy-Item -Path ([System.IO.Path]::Combine($RootPath, $fileName)) -Destination ([System.IO.Path]::Combine($publishPath, $fileName))