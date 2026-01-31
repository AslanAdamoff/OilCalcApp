#!/bin/bash

# Convert source to true PNG
sips -s format png "source.jpg" --out "Icon-App-1024x1024.png"

SOURCE="Icon-App-1024x1024.png"

# Helper function
generate() {
    sips -s format png -z $1 $1 "$SOURCE" --out "$2"
}

# iPhone
generate 40 "Icon-App-20x20@2x.png"
generate 60 "Icon-App-20x20@3x.png"
generate 58 "Icon-App-29x29@2x.png"
generate 87 "Icon-App-29x29@3x.png"
generate 80 "Icon-App-40x40@2x.png"
generate 120 "Icon-App-40x40@3x.png"
generate 120 "Icon-App-60x60@2x.png"
generate 180 "Icon-App-60x60@3x.png"

# iPad
generate 20 "Icon-App-20x20@1x.png"
generate 29 "Icon-App-29x29@1x.png"
generate 40 "Icon-App-40x40@1x.png"
generate 76 "Icon-App-76x76@1x.png"
generate 152 "Icon-App-76x76@2x.png"
generate 167 "Icon-App-83.5x83.5@2x.png"
