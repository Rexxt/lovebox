﻿# LOVEBOX makes LÖVE gamedev easier
# Included:
# setup:
#   love-android: install LÖVE on your connected ADB-enabled device
#   project: prepare all project files
# build:
#   universal: build a LÖVE package
# -- platform-specific builds must be executed on the concerned platform except for Android builds
#   windows: build a windows executable
#   mac: build a mac executable
#   linux-bin: build a linux binary
#   linux-appimage: build an appimage
# install: simple package manager akin to luarocks
# remove: remove packages installed using the {install} command
# debug:
#   pc: start debugging the game on your computer
#   android: start debugging the game on your connected ADB-enabled device

function setup {
    param (
        $Object,
        $Version
    )
    switch($Object) {
        "love-android" {
            Invoke-WebRequest -Uri "https://github.com/love2d/love/releases/download/$version/love-$Version-android.apk" -OutFile 'org.love2d.android.apk'
            .\adb.exe install 'org.love2d.android.apk'
        }
        "project" {
            Set-Content 'main.lua' '-- generated using lovebox'
            Set-Content 'conf.lua' "-- generated using lovebox
function love.conf(t)
    t.identity = '$Version'
    t.appendidentity = true
    t.console = true
    t.window.title = '$Version (LOVEBOX game)'
    t.window.resizable = true
end"
            New-Item ".lbignore" -ItemType File
            New-Item "sounds/" -ItemType Directory
            New-Item "bgm/" -ItemType Directory
            New-Item "fonts/" -ItemType Directory
            New-Item "sprites/" -ItemType Directory
            New-Item "backgrounds/" -ItemType Directory
            New-Item "components/" -ItemType Directory
        }
        default {
            Write-Host("setup:
    love-android <version>: install LÖVE on your connected ADB-enabled device
    project: prepare all project files")
        }
    }
}

function build {
    param (
        $Platform
    )
    Compress-Archive -Path '.' -DestinationPath 'game.zip'
    Rename-Item 'game.zip' 'game.love'

    switch($Platform) {
        "universal" {}
        default {
            Write-Host("Platform unknown, build manually from here.")
        }
    }
}

$command = $args[0]
switch($command) {
    "setup" {
        $object = $args[1]
        $version = $args[2]
        setup -Object $object -Version $version
    }
    "build" {
        build -Platform = $args[1]
    }
    "install" {
        if (Get-Command git -errorAction SilentlyContinue) {
            Write-Host "can use git"
        } else {
            Write-Host("Installing git is required!")
        }
    }
    "remove" {

    }
    "debug" {

    }
    default {
        Write-Host("Usage: $PSCommandPath <setup/build/install/remove/debug> [parameters]")
        Write-Host("setup:
    love-android <version>: install LÖVE on your connected ADB-enabled device
    project <name>: prepare all project files

build:
    universal: build a LÖVE package
-- platform-specific builds must be executed on the concerned platform except for Android builds
    windows: build a windows executable
    mac: build a mac executable
    linux-bin: build a linux binary
    linux-appimage: build an appimage

install: simple package manager akin to luarocks

remove: remove packages installed using the {install} command

debug:
    pc: start debugging the game on your computer
    android: start debugging the game on your connected ADB-enabled device")
    exit 1
    }
}