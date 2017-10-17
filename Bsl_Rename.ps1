<#
    .SYNOPSIS
        This function will rename everything in your project you want to rename
#>

PARAM ( # the directory where your project exists
        [string]$targetDirectory, 
        # the word you want to replace
        [string]$wordToReplace, 
        # the word you want to repace with
        [string]$wordToReplaceWith)#PARAM

if (!$targetDirectory) {
    $targetDirectory = Read-Host 'Please enter the directory containing your project'
}

if (!$wordToReplace) {
   $wordToReplace = Read-Host 'What is your existing project namespace?' 
}

if (!$wordToReplaceWith) {
    $wordToReplaceWith = Read-Host 'What is your new project namespace?'
}
 
$wildcardName = "*"+$wordToReplace + "*"
If ($wordToReplaceWith -Match " ")
{
    "No spaces allowed"
    exit
}
Write-Host 'Please ensure you have backed up the files in' $targetDirectory
$confirm = Read-Host 'We will new into' $targetDirectory 'and replace all occurrences of' $wordToReplace 'with' $wordToReplaceWith '- continue? y/n'

if ($confirm -like 'y') {
    Get-ChildItem $targetDirectory -filter $wildcardName -Recurse | Rename-Item -NewName { $_.Name -replace $wordToReplace, $wordToReplaceWith } | where-object { $_.Name -notMatch "packages"  }
    $files=get-childitem $targetDirectory *.* -rec | where { ! $_.PSIsContainer }
    foreach ($file in $files)
    {
        If ($file.PSPath -Match ".ps1" -Or $file.PSPath -Match "packages" -Or $file.PSPath -Match "bin" -Or $file.PSPath -Match ".dll")
        {
            # Write-Host $file.PSPath ' is in the excluded list so ignoring it'
        }
        Else
        {
            Write-Host 'Processing ' $file.PSPath
            (Get-Content $file.PSPath) | Foreach-Object {$_ -replace $wordToReplace, $wordToReplaceWith} | Set-Content $file.PSPath
        }

    }
}