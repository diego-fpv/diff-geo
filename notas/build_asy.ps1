Set-Location figuras

Get-ChildItem *.asy | ForEach-Object {
    $asy = $_
    $base = $asy.BaseName          
    $prc = Get-Item "$base+0.prc" -ErrorAction `
    SilentlyContinue
    $pdf = Get-Item "$base.pdf" -ErrorAction `
    SilentlyContinue

    # if figure exists but has been modified, or does not exist altogether
    if ((-not ($null -eq $pdf) -and $asy.LastWriteTime -gt $pdf.LastWriteTime) -or (-not ($null -eq $prc) -and $asy.LastWriteTime -gt $prc.LastWriteTime) -or ($null -eq $prc -and $null -eq $pdf)) {
        Write-Host "Processing $base..."
        asy -v $asy.Name
         Get-ChildItem "$base*.tex" | ForEach-Object {
            (Get-Content $_.FullName) `
                -replace '\\jobname', $base `
                -replace "\{$base", "{./figuras/$base" `
            | Set-Content $_.FullName
        }
    } 
    # if figure exists and has not been modified
    else {
        Write-Host "Up to date $base"
    }
}

Set-Location ..