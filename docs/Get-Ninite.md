---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version:
schema: 2.0.0
---

# Get-Ninite

## SYNOPSIS
Downloads and executes a Ninite installer for the selected applications.

## SYNTAX

```
Get-Ninite [[-Apps] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get-NiniteInstaller queries the ninite.com website and provides a list of available applications. If valid application names are given, it then downloads and executes the installer for those applications.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-Ninite -Apps firefox,7zip
```

Downloads and installs firefox and 7zip.

## PARAMETERS

### -Apps
Comma separated list of applications to install

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: .net4.7.2, 7zip, aimp, air, audacity, avast, avg, avira, blender, cccp, cdburnerxp, chrome, classicstart, cutepdf, discord, dropbox, eclipse, essentials, evernote, everything, faststone, filezilla, firefox, foobar, foxit, gimp, glary, gom, googlebackupandsync, googleearth, greenshot, handbrake, imgburn, infrarecorder, inkscape, irfanview, itunes, java8, jdk8, jdkx8, keepass2, klitecodecs, krita, launchy, libreoffice, malwarebytes, mediamonkey, mozy, musicbee, notepadplusplus, nvda, onedrive, openoffice, operaChromium, paint.net, pdfcreator, peazip, pidgin, putty, python, qbittorrent, realvnc, revo, sharex, shockwave, silverlight, skype, spotify, spybot2, steam, sugarsync, sumatrapdf, super, teamviewer13, teracopy, thunderbird, trillian, vlc, vscode, winamp, windirstat, winmerge, winrar, winscp, xnview

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/LockstepGroup/CorkScrew](https://github.com/LockstepGroup/CorkScrew)

[https://www.powershellgallery.com/packages/CorkScrew](https://www.powershellgallery.com/packages/CorkScrew)

[Ninite](https://ninite.com)