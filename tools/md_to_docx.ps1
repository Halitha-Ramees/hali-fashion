param(
  [Parameter(Mandatory = $true)][string]$InputPath,
  [Parameter(Mandatory = $true)][string]$OutputPath
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

function XmlEscape([string]$Text) {
  if ($null -eq $Text) { return '' }
  return [System.Security.SecurityElement]::Escape($Text)
}

function CleanText([string]$Text) {
  if ($null -eq $Text) { return '' }
  return ($Text -replace '\*\*', '' -replace '`', '').TrimEnd()
}

function Para([string]$Text, [string]$Style = 'Normal', [string]$Size = '21', [bool]$Bold = $false, [string]$Jc = '') {
  $escaped = XmlEscape (CleanText $Text)
  $styleXml = if ($Style -ne 'Normal') { "<w:pStyle w:val=`"$Style`"/>" } else { '' }
  $jcXml = if ($Jc) { "<w:jc w:val=`"$Jc`"/>" } else { '' }
  $boldXml = if ($Bold) { '<w:b/>' } else { '' }
  return @"
<w:p>
  <w:pPr>$styleXml$jcXml<w:spacing w:after="60" w:line="240" w:lineRule="auto"/></w:pPr>
  <w:r><w:rPr>$boldXml<w:sz w:val="$Size"/><w:szCs w:val="$Size"/></w:rPr><w:t xml:space="preserve">$escaped</w:t></w:r>
</w:p>
"@
}

function TableXml($Rows) {
  $out = @()
  $out += '<w:tbl><w:tblPr><w:tblW w:w="0" w:type="auto"/><w:tblBorders><w:top w:val="single" w:sz="4" w:space="0" w:color="999999"/><w:left w:val="single" w:sz="4" w:space="0" w:color="999999"/><w:bottom w:val="single" w:sz="4" w:space="0" w:color="999999"/><w:right w:val="single" w:sz="4" w:space="0" w:color="999999"/><w:insideH w:val="single" w:sz="4" w:space="0" w:color="999999"/><w:insideV w:val="single" w:sz="4" w:space="0" w:color="999999"/></w:tblBorders></w:tblPr>'
  $rowIndex = 0
  foreach ($row in $Rows) {
    if ($row -match '^\|\s*-') { continue }
    $rowIndex++
    $cells = $row.Trim('|').Split('|') | ForEach-Object { CleanText $_.Trim() }
    $out += '<w:tr>'
    foreach ($cell in $cells) {
      $shade = if ($rowIndex -eq 1) { '<w:shd w:fill="D9EAF7"/>' } else { '' }
      $bold = if ($rowIndex -eq 1) { '<w:b/>' } else { '' }
      $out += "<w:tc><w:tcPr><w:tcW w:w=`"2400`" w:type=`"dxa`"/>$shade</w:tcPr><w:p><w:r><w:rPr>$bold<w:sz w:val=`"19`"/></w:rPr><w:t>$(XmlEscape $cell)</w:t></w:r></w:p></w:tc>"
    }
    $out += '</w:tr>'
  }
  $out += '</w:tbl>'
  return ($out -join "`n")
}

$lines = Get-Content -LiteralPath $InputPath
$body = New-Object System.Collections.Generic.List[string]
$inCode = $false
$i = 0

while ($i -lt $lines.Count) {
  $line = $lines[$i]

  if ($line.Trim().StartsWith('```')) {
    $inCode = -not $inCode
    $i++
    continue
  }

  if ($inCode) {
    $body.Add((Para $line 'Normal' '18' $false ''))
    $i++
    continue
  }

  if ($line.Trim() -eq '---') {
    $i++
    continue
  }

  if ($line -match '^\|') {
    $tableRows = New-Object System.Collections.Generic.List[string]
    while ($i -lt $lines.Count -and $lines[$i] -match '^\|') {
      $tableRows.Add($lines[$i])
      $i++
    }
    $body.Add((TableXml $tableRows))
    $body.Add((Para '' 'Normal' '21' $false ''))
    continue
  }

  if ($line -match '^#\s+(.+)$') {
    $body.Add((Para $matches[1] 'Title' '36' $true 'center'))
  } elseif ($line -match '^##\s+(.+)$') {
    $body.Add((Para $matches[1] 'Heading1' '26' $true ''))
  } elseif ($line -match '^###\s+(.+)$') {
    $body.Add((Para $matches[1] 'Heading2' '23' $true ''))
  } elseif ($line -match '^\s*-\s+(.+)$') {
    $body.Add((Para "- $($matches[1])" 'Normal' '21' $false ''))
  } elseif ([string]::IsNullOrWhiteSpace($line)) {
    $body.Add((Para '' 'Normal' '21' $false ''))
  } else {
    $body.Add((Para $line 'Normal' '21' $false ''))
  }

  $i++
}

$documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    $($body -join "`n")
    <w:sectPr>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="720" w:right="720" w:bottom="720" w:left="720" w:header="360" w:footer="360" w:gutter="0"/>
    </w:sectPr>
  </w:body>
</w:document>
"@

$stylesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:sz w:val="21"/></w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Title">
    <w:name w:val="Title"/>
    <w:basedOn w:val="Normal"/>
    <w:rPr><w:b/><w:sz w:val="36"/><w:color w:val="111111"/></w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:basedOn w:val="Normal"/>
    <w:rPr><w:b/><w:sz w:val="26"/><w:color w:val="111111"/></w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading2">
    <w:name w:val="heading 2"/>
    <w:basedOn w:val="Normal"/>
    <w:rPr><w:b/><w:sz w:val="23"/><w:color w:val="333333"/></w:rPr>
  </w:style>
</w:styles>
"@

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("docx_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot | Out-Null
New-Item -ItemType Directory -Path (Join-Path $tempRoot "_rels") | Out-Null
New-Item -ItemType Directory -Path (Join-Path $tempRoot "word") | Out-Null
New-Item -ItemType Directory -Path (Join-Path $tempRoot "word\_rels") | Out-Null

Set-Content -LiteralPath (Join-Path $tempRoot "[Content_Types].xml") -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>
'@

Set-Content -LiteralPath (Join-Path $tempRoot "_rels\.rels") -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
'@

Set-Content -LiteralPath (Join-Path $tempRoot "word\_rels\document.xml.rels") -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
'@

Set-Content -LiteralPath (Join-Path $tempRoot "word\document.xml") -Encoding UTF8 -Value $documentXml
Set-Content -LiteralPath (Join-Path $tempRoot "word\styles.xml") -Encoding UTF8 -Value $stylesXml

if (Test-Path -LiteralPath $OutputPath) {
  Remove-Item -LiteralPath $OutputPath -Force
}

[System.IO.Compression.ZipFile]::CreateFromDirectory($tempRoot, $OutputPath)
Remove-Item -LiteralPath $tempRoot -Recurse -Force

Write-Output $OutputPath
