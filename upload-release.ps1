$vsixPath = "c:\Users\pawas\OneDrive\Documents\GitHub\VSercel\vsercel-1.0.0.vsix"
$owner = "Pradeep-gif-hub"
$repo = "VSercel"
$tag = "v1.0.0"

# Read the VSIX file
$vsixContent = [System.IO.File]::ReadAllBytes($vsixPath)

# Get release by tag
$releaseUrl = "https://api.github.com/repos/$owner/$repo/releases/tags/$tag"

Write-Host "Fetching release info..."
$releaseResponse = Invoke-WebRequest -Uri $releaseUrl -Headers @{"Accept" = "application/vnd.github.v3+json"} -UseBasicParsing
$releaseData = $releaseResponse.Content | ConvertFrom-Json
$releaseId = $releaseData.id
$uploadUrl = $releaseData.upload_url -replace '\{.*\}', ''

Write-Host "Uploading VSIX file to release $tag..."

$uploadUri = "$uploadUrl?name=vsercel-1.0.0.vsix"

Invoke-WebRequest -Uri $uploadUri `
  -Method Post `
  -InFile $vsixPath `
  -ContentType "application/octet-stream" `
  -Headers @{"Accept" = "application/vnd.github.v3+json"} `
  -UseBasicParsing

Write-Host "✅ Upload successful!"
Write-Host "Release: https://github.com/$owner/$repo/releases/tag/$tag"
