#!/bin/sh

# ------------------------------------------------------------------------------
# Reference(s):
# Uses Fred's ImageMagick Scripts
# http://www.fmwconcepts.com/imagemagick/
#   - graytoning
# ------------------------------------------------------------------------------


declare debug=0

declare -i -r CANVAS_DEFAULT=1
declare -i -r CANVAS_BIG=2
declare -i -r CANVAS_BIGGER=3
declare -i -r CANVAS_LARGE=4
declare -i -r CANVAS_HUGE=5
declare -i -r CANVAS_SQUARE=6
declare -i -r CANVAS_SQUARE_BIG=7
declare -i -r CANVAS_SQUARE_LARGE=8
declare -i -r CANVAS_TALL=9
declare -i -r CANVAS_TALLER=10
declare -i -r CANVAS_TOWER=11

declare -r FONT_DEFAULT="Roboto-Condensed"

declare -r OUTPUT_FILE="out_0.png"



function show_usage {
    get_canvas_width "$CANVAS_DEFAULT"
    get_canvas_height "$CANVAS_DEFAULT"
    local -r dimension_default="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_BIG"
    get_canvas_height "$CANVAS_BIG"
    local -r dimension_big="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_BIGGER"
    get_canvas_height "$CANVAS_BIGGER"
    local -r dimension_bigger="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_LARGE"
    get_canvas_height "$CANVAS_LARGE"
    local -r dimension_large="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_HUGE"
    get_canvas_height "$CANVAS_HUGE"
    local -r dimension_huge="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_SQUARE"
    get_canvas_height "$CANVAS_SQUARE"
    local -r dimension_square="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_SQUARE_BIG"
    get_canvas_height "$CANVAS_SQUARE_BIG"
    local -r dimension_square_big="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_SQUARE_LARGE"
    get_canvas_height "$CANVAS_SQUARE_LARGE"
    local -r dimension_square_large="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_SQUARE_TALL"
    get_canvas_height "$CANVAS_SQUARE_TALL"
    local -r dimension_tall="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_SQUARE_TALLER"
    get_canvas_height "$CANVAS_SQUARE_TALLER"
    local -r dimension_taller="${width_temp}x${height_temp}"

    get_canvas_width "$CANVAS_SQUARE_TOWER"
    get_canvas_height "$CANVAS_SQUARE_TOWER"
    local -r dimension_tower="${width_temp}x${height_temp}"

    echo "ci - Compose Image script version 0.6"
    echo "Copyright (C) 2016 Ricky Maicle rmaicle@gmail.com"
    echo "This is free software; see the source for copying conditions."
    echo "There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
    echo ""
    echo "Create a PNG image file composed of text and images."
    echo "Usage:"
    echo ""
    echo "Options:"
    echo "  --help                              Show usage"
    echo "  --debug                             Debug mode"
    echo "  --canvas                            Define working canvas"
    echo "    [size]                              pre-defined dimensions:"
    echo "                                          default      ${dimension_default}"
    echo "                                          big          ${dimension_big}"
    echo "                                          bigger       ${dimension_bigger}"
    echo "                                          large        ${dimension_large}"
    echo "                                          huge         ${dimension_huge}"
    echo "                                          square       ${dimension_square}"
    echo "                                          square-big   ${dimension_square_big}"
    echo "                                          square-large ${dimension_square_large}"
    echo "                                          tall         ${dimension_tall_large}"
    echo "                                          taller       ${dimension_taller_large}"
    echo "                                          tower        ${dimension_tower_large}"
    echo "    [-c <color>]                        canvas color or first gradient color"
    echo "    [-c2 <color>]                       canvas second gradient color"
    #echo "    [-c3 <color>]                       canvas third gradient color"
    echo "    [-g                                 gravity"
    echo "      <gravity |                          constants"
    echo "       northsouth |                       north and south"
    echo "       eastwest |                         east and west"
    echo "       custom                             custom rotation and color string"
    echo "         <-r <rotation>>                    rotation (0-360), 0=south"
    echo "         <-cs <color string>>>]             color string (ex. \"red yellow 33 blue 66 red\")"
    echo "  --image                             Define image properties"
    echo "    <filename>                          image file"
    echo "    [-g <gravity>]                      where the image position gravitates to"
    echo "    [-o <position>]                     offset position relative to gravity"
    echo "    [-blur                              blur image"
    echo "      <-simple> |                         simple blurring"
    echo "      [-r <radius>]                       radius, default is 0"
    echo "      <-s <sigma>>]                       sigma, default is 4"
    echo "    [-border                            draw border"
    echo "        <color>                           color"
    echo "        <[-w <pixels>] |                   width in pixels, default is 3,"
    echo "        [-r <pixels>]>]                    radius in pixels for rounded corner"
    echo "    [-color                             change color"
    echo "      -f <color>                          source color"
    echo "      [-t <color> | -x]                   destination color or transparent"
    echo "      [-n | -ng]]                         -n replaces each pixel with complementary color,"
    echo "                                          -ng replaces grayscale pixels with complementary color,"
    echo "    [-corner                            round image corner"
    echo "      [-r <radius>]                       corner radius in pixels"
    echo "    [-cut                               cut image"
    echo "      [-circle                            circle"
    echo "        <-r>                                radius"
    echo "        <-px>                               x position"
    echo "        <-py>                               y position"
    echo "        [-bw <width>]                       border width"
    echo "        [-bc <color>]                       border color"
    echo "      [-side                              side"
    echo "        <gravity>                           where to cut"
    echo "        <pixels>]]                          number of pixels to cut"
    echo "    [-flip]                             flip image horizontally"
    echo "    [-gradient                          transparent gradient"
    echo "      <[gravity | northwest | eastwest]   constants"
    echo "       -c1 <color>                        first gradient color"
    echo "       -c2 <color>> |                     second gradient color"
    echo "      <custom                             custom rotation and color string"
    echo "         <-r <rotation>>                    rotation (0-360), 0=south"
    echo "         <-cs <color string>>>]             color string (ex. \"red yellow 33 blue 66 red\")"
    echo "    [-rotate -a <angle>]                rotate image"
    echo "    [-size                              resize image to dimension"
    echo "      <-s <size>>                         dimension"
    echo "      [-a <adjustment>]]                  size adjustment"
    echo "                                            ^ resize using the smallest fitting dimension"
    echo "                                            < enlarge to fit canvas"
    echo "                                            > shrink to fit canvas (default)"
    echo "    [-tint                              tint image using color"
    echo "      [-c <color>]                        tint color, default is black"
    echo "      [-a <amount>]]                      tint amount, default is 10"
    echo "      <-rgb                               Use RGB colors, default is 29.9, 58.7, 11.4"
    echo "          [-default | <r> <g> <b>]] |       RGB values, default is 29.9, 58.7, 11.4"
    echo "       -bc                                Use gray brightness and contrast,"
    echo "          <brightness>                      gray brightness, -100<=float<=100, default is 0"
    echo "          <contrast>                        gray contrast, -100<=float<=100, default is 0"
    echo "          [-m <mode>]>                      mode of tinting, default is all"
    echo "                                              a - all"
    echo "                                              m - midtones"
    echo "                                              h - highlights"
    echo "                                              s - shadows"
    echo "    [-vignette                          vignette"
    echo "      [-c <color>]                        color, default is black"
    echo "      [-s <amount>]                       amount, default is 10"
    echo "      [-d <xy>]]                          xy radius, default is +10+10%"
    echo "                                            larger values decrease the radius and"
    echo "                                            smaller values increase the radii"
    echo "  --rectangle                         Define rectangular area"
    echo "    [-w <width>]                        width in pixels, defaults to canvas width"
    echo "    [-h <height>]                       height in pixels, defaults to canvas height"
    echo "    [-c <color>]                        fill color or first gradient color"
    echo "    [-p <percentage>]                   opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-g <gravity>]                      gravity"
    echo "    [-p <position>]                     position, defaults to +0+0"
    echo "    [-c2 <color>]                       second gradient color"
    echo "    [-gg                                gradient gravity"
    echo "      <gravity |                          constants"
    echo "       northsouth |                       north and south"
    echo "       eastwest |                         east and west"
    echo "       custom                             custom rotation and color string"
    echo "         <-gr <rotation>>                   rotation (0-360), 0=south"
    echo "         <-gcs <color string>>>]            color string (ex. \"red yellow 33 blue 66 red\")"
    echo "    [-r <pixels>]                         rounded corner diameter"
    echo "    [-o <filename>]                     output image filename"
    echo "  --hbar                              Define a horizontal bar"
    echo "    [-h <height>]                       height in pixels"
    echo "    [-c <color>]                        fill color or first color of gradient"
    echo "    [-p <percentage>]                   opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-g <gravity>]                      gravity"
    echo "    [-y <y position>]                   y position from top"
    echo "    [-c2 <color>]                       second color of gradient"
    echo "    [-gg                                gradient gravity"
    echo "      <gravity |                          constants"
    echo "       northsouth |                       north and south"
    echo "       eastwest |                         east and west"
    echo "       custom                             custom rotation and color string"
    echo "         <-gr <rotation>>                   rotation (0-360), 0=south"
    echo "         <-gcs <color string>>>]            color string (ex. \"red yellow 33 blue 66 red\")"
    echo "  --bottombar                         Create the fixed-sized bottom bar"
    echo "    [-h <height>]                       height in pixels, default is 50"
    echo "    [-c <color>]                        fill color"
    echo "    [-p <percentage>]                   opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-c2 <color>]                       second color of gradient"
    echo "    [-gg                                gradient gravity"
    echo "      <gravity |                          constants"
    echo "       northsouth |                       north and south"
    echo "       eastwest |                         east and west"
    echo "       custom                             custom rotation and color string"
    echo "         <-gr <rotation>>                   rotation (0-360), 0=south"
    echo "         <-gcs <color string>>>]            color string (ex. \"red yellow 33 blue 66 red\")"
    echo "  --logo                              Define logo properties"
    echo "    [-c <color>]                        color"
    echo "    [-s <size>]                         size in pixels, defaults to 30x30"
    echo "    [-ox <x position>]                  x position, defaults to 11"
    echo "    [-oy <y position>]                  y position, defaults to 9"
    echo "    [-g <gravity>]                      gravity, defaults to southeast"
    echo "    [-l <text>]                         optional label before logo"
    echo "  --text                              Define text properties"
    echo "    [-W <width>]                        Global text area width"
    echo "    [-Wo <width>]                       Offset, value is subtracted from W"
    echo "    [-Px <x position>]                  Global x position"
    echo "    [-Py <y position>]                  Global y position"
    echo "    [-t <text>]                         text"
    echo "    [-f <font>]                         font"
    echo "    [-s <point size>]                   font size"
    echo "    [-c <color>]                        text color"
    echo "    [-bc <color>]                       background color"
    echo "    [-g <gravity>]                      gravity"
    echo "    [-i <inter-line spacing>]           inter-line spacing"
    echo "    [-w <width>]                        text width"
    echo "    [-px <x position>]                  x position for this text entry only"
    echo "    [-py <y position>]                  y position for this text entry only"
    echo "    [-pg <gravity>]                     position for this text entry only"
    echo "    [-ox <x position>]                  offset x position for this text entry only"
    echo "    [-oy <y position>]                  offset y position for this text entry only"
    echo "    [-sw <width>]                       stroke width in pixels"
    echo "    [-sc <color>]                       stroke color"
    echo "    [-sf <percentage>]                  stroke fade percentage, default is 1"
    echo "    [-sh <percentage>]                  shadow percentage"
    echo "    [-shc <color>]                      shadow color"
    echo "    [-sho <pixels>]                     shadow offset in pixels, default is 3"
    echo "  --author                            Define author text"
    echo "    -a <name>                            author name"
    echo "    -d <description>                     description text"
    echo "  --add-info                          Add Exif information"
    echo "  "
    echo "Font Family:"
    echo "  font-default                    Roboto"
    echo "  font-default-light              Roboto-Light"
    echo "  font-default-medium             Roboto-Medium"
    echo "  font-default-bold               Roboto-Bold"
    echo "  font-default-black              Roboto-Black"
    echo "  font-default-thin               Roboto-Thin"
    echo "  font-default-condensed          Roboto-Condensed"
    echo "  font-default-condensed-light    Roboto-Condensed-Light"
    echo "  font-default-condensed-bold     Roboto-Condensed-Bold"
    echo "  font-sans                       Open-Sans-Regular"
    echo "  font-sans-light                 Open-Sans-Light"
    echo "  font-sans-semibold              Open-Sans-SemiBold"
    echo "  font-sans-bold                  Open-Sans-Bold"
    echo "  font-sans-extrabold             Open-Sans-ExtraBold"
    echo "  font-sans-condensed-light       Open-Sans-Condensed-Light"
    echo "  font-sans-condensed-bold        Open-Sans-Condensed-Bold"
    echo "  font-sans-1                     Archivo-Narrow-Regular"
    echo "  font-sans-1-medium              Archivo-Narrow-Medium"
    echo "  font-sans-1-semibold            Archivo-Narrow-Semibold"
    echo "  font-sans-1-bold                Archivo-Narrow-Bold"
    echo "  font-sans-2                     Poppins-Regular"
    echo "  font-sans-2-thin                Poppins-Thin"
    echo "  font-sans-2-light               Poppins-Light"
    echo "  font-sans-2-extralight          Poppins-ExtraLight"
    echo "  font-sans-2-medium              Poppins-Medium"
    echo "  font-sans-2-semibold            Poppins-SemiBold"
    echo "  font-sans-2-bold                Poppins-Bold"
    echo "  font-sans-2-extrabold           Poppins-ExtraBold"
    echo "  font-sans-2-black               Poppins-Black"
    echo "  font-sans-3                     Share-Regular"
    echo "  font-sans-3-bold                Share-Bold"
    echo "  font-serif                      Merriweather-Regular"
    echo "  font-serif-light                Merriweather-Light"
    echo "  font-serif-bold                 Merriweather-Bold"
    echo "  font-serif-black                Merriweather-Black"
    echo "  font-serif-1                    Cormorant-Garamond-Regular"
    echo "  font-serif-1-light              Cormorant-Garamond-Light"
    echo "  font-serif-1-medium             Cormorant-Garamond-Medium"
    echo "  font-serif-1-semibold           Cormorant-Garamond-Semibold"
    echo "  font-serif-1-bold               Cormorant-Garamond-Bold"
    echo "  font-serif-2                    GTSectraFine-Regular"
    echo "  font-serif-2-medium             GTSectraFine-Medium"
    echo "  font-serif-2-bold               GTSectraFine-Bold"
    echo "  font-serif-2-black              GTSectraFine-Black"
    echo "  font-serif-3                    Calluna-Regular"
    echo "  font-serif-3-bold               Calluna-Bold"
    echo "  font-mono                       RM-Courier-Regular"
    echo "  font-mono-vt323                 VT323-Regular"
    echo "  font-mono-fixedsys              Fixedsys-Excelsior"
    echo "  font-mono-ocr                   OCR-A-Extended"
    echo "  font-typewriter                 F25Executive"
    echo "  font-typewriter-thin            ELEGANT-TYPEWRITER"
    echo "  font-typewriter-1               Underwood-Champion"
    echo "  font-typewriter-2               Sears-Tower"
    echo "  font-typewriter-3               Rough_Typewriter"
    echo "  font-comic                      DigitalStrip"
    echo "  font-comic-1                    SmackAttack-BB"
    echo "  font-comic-2                    Year-supply-of-fairy-cakes"
    echo "  font-comic-3                    Komika-Title---Axis"
    echo "  font-comic-4                    BadaBoom-BB"
    echo "  font-comic-5                    Bangers"
    echo "  font-comic-6                    Yikes!"
    echo "  font-comic-7                    Mouse-Memoirs"
    echo "  font-comic-8                    GROBOLD"
    echo "  font-comic-9                    Helsinki"
    echo "  font-display                    Coda-ExtraBold"
    echo "  font-display-1                  Muli-Black"
    echo "  font-display-2                  Chonburi"
    echo "  font-display-3                  Bambi-Bold"
    echo "  font-dirty                      Dirty-Headline"
    echo "  font-dirty-1                    DCC-Ash"
    echo "  font-dirty-2                    DCC-SharpDistressBlack"
    echo "  font-dirty-3                    Dark-Underground"
    echo "  font-dirty-4                    Iron-&-Brine"
    echo "  font-dirty-5                    A-Love-of-Thunder"
    echo "  font-brush                      LemonTuesday"
    echo "  font-brush-1                    Edo-SZ"
    echo "  font-brush-2                    ProtestPaint-BB"
    echo "  font-brush-2-italic             ProtestPaint-BB-Italic"
    echo "  font-brush-3                    SketchaLot"
    echo "  font-horror                     YouMurdererBB"
    echo "  font-horror-1                   FaceYourFears"
    echo "  font-horror-2                   Something-Strange"
    echo "  font-old                        OldNewspaperTypes"
    echo "  font-old-1                      1543HumaneJenson-Normal"
    echo "  font-old-1-bold                 1543HumaneJenson-Bold"
    echo "  font-acme                       Acme"
    echo "  font-averia                     Averia-Libre-Regular"
    echo "  font-averia-bold                Averia-Libre-Bold"
    echo "  font-scratch                    Scratch"
    echo "  font-something                  Something-in-the-air"
    echo "  font-<font name>                use \`convert -list font\` to check font names"
}



function echo_debug {
    if [ $# -eq 0 ]; then
        echo "Debug: Required echo debug parameter missing."
        return 1
    fi
    if [ $debug -eq 1 ]; then
        echo "Debug: $1"
    fi
    return 0
}



# Echo the error message parameter
function echo_err {
    echo "-----"
    echo "Error: $1"
    echo "-----"
}



# Return the width of the specified canvas
function get_canvas_width {
    declare -r WIDTH_DEFAULT=588
    declare -r WIDTH_BIG=734            # prev 735 (588 / 4) + 588
    declare -r WIDTH_BIGGER=819
    declare -r WIDTH_LARGE=1176         # prev 817
    declare -r WIDTH_HUGE=1532          # (1176-819)+1176-1
    declare -r WIDTH_SQUARE=680
    declare -r WIDTH_SQUARE_BIG=800
    declare -r WIDTH_SQUARE_LARGE=1040
    declare -r WIDTH_TALL=540
    declare -r WIDTH_TALLER=720
    declare -r WIDTH_TOWER=900

    [[ $# -eq 0 ]] \
        && { echo_err "get_canvas_width parameter not found."; return 1; }
    case "$1" in
        $CANVAS_DEFAULT)        width_temp=$WIDTH_DEFAULT ;;
        $CANVAS_BIG)            width_temp=$WIDTH_BIG ;;
        $CANVAS_BIGGER)         width_temp=$WIDTH_BIGGER ;;
        $CANVAS_LARGE)          width_temp=$WIDTH_LARGE ;;
        $CANVAS_HUGE)           width_temp=$WIDTH_HUGE ;;
        $CANVAS_SQUARE)         width_temp=$WIDTH_SQUARE ;;
        $CANVAS_SQUARE_BIG)     width_temp=$WIDTH_SQUARE_BIG ;;
        $CANVAS_SQUARE_LARGE)   width_temp=$WIDTH_SQUARE_LARGE ;;
        $CANVAS_TALL)           width_temp=$WIDTH_TALL ;;
        $CANVAS_TALLER)         width_temp=$WIDTH_TALLER ;;
        $CANVAS_TOWER)          width_temp=$WIDTH_TOWER ;;
        *)                      width_temp=0 ;;
    esac
    return 0
}



# Return the height of the specified canvas
function get_canvas_height {
    declare -r HEIGHT_DEFAULT=330
    declare -r HEIGHT_BIG=412
    declare -r HEIGHT_BIGGER=460
    declare -r HEIGHT_LARGE=660
    declare -r HEIGHT_HUGE=860
    declare -r HEIGHT_SQUARE=680
    declare -r HEIGHT_SQUARE_BIG=800
    declare -r HEIGHT_SQUARE_LARGE=1040
    declare -r HEIGHT_TALL=720
    declare -r HEIGHT_TALLER=960
    declare -r HEIGHT_TOWER=1200

    [[ $# -eq 0 ]] \
        && { echo_err "get_canvas_height parameter not found."; return 1; }
    case "$1" in
        $CANVAS_DEFAULT)        height_temp=$HEIGHT_DEFAULT ;;
        $CANVAS_BIG)            height_temp=$HEIGHT_BIG ;;
        $CANVAS_BIGGER)         height_temp=$HEIGHT_BIGGER ;;
        $CANVAS_LARGE)          height_temp=$HEIGHT_LARGE ;;
        $CANVAS_HUGE)           height_temp=$HEIGHT_HUGE ;;
        $CANVAS_SQUARE)         height_temp=$HEIGHT_SQUARE ;;
        $CANVAS_SQUARE_BIG)     height_temp=$HEIGHT_SQUARE_BIG ;;
        $CANVAS_SQUARE_LARGE)   height_temp=$HEIGHT_SQUARE_LARGE ;;
        $CANVAS_TALL)           height_temp=$HEIGHT_TALL ;;
        $CANVAS_TALLER)         height_temp=$HEIGHT_TALLER ;;
        $CANVAS_TOWER)          height_temp=$HEIGHT_TOWER ;;
        *)                      height_temp=0 ;;
    esac
    return 0
}



function get_font_family {
    [[ $# -eq 0 ]] \
        && { echo_err "get_font parameter not found."; return 1; }
    local font="$1"
    [[ ! "${font:0:5}" == "font-" ]] \
        && { echo_err "Font does not start with 'font-'"; return 1; } \
        || font="${font:5}"

    case "$font" in
        default)                    font_temp="Roboto" ;;
        default-light)              font_temp="Roboto-Light" ;;
        default-medium)             font_temp="Roboto-Medium" ;;
        default-bold)               font_temp="Roboto-Bold" ;;
        default-black)              font_temp="Roboto-Black" ;;
        default-thin)               font_temp="Roboto-Thin" ;;
        default-condensed)          font_temp="Roboto-Condensed" ;;
        default-condensed-light)    font_temp="Roboto-Condensed-Light" ;;
        default-condensed-bold)     font_temp="Roboto-Condensed-Bold" ;;
        sans)                       font_temp="Open-Sans-Regular" ;;
        sans-light)                 font_temp="Open-Sans-Light" ;;
        sans-semibold)              font_temp="Open-Sans-SemiBold" ;;
        sans-bold)                  font_temp="Open-Sans-Bold" ;;
        sans-extrabold)             font_temp="Open-Sans-ExtraBold" ;;
        sans-condensed-light)       font_temp="Open-Sans-Condensed-Light" ;;
        sans-condensed-bold)        font_temp="Open-Sans-Condensed-Bold" ;;
        sans-1)                     font_temp="Archivo-Narrow-Regular" ;;
        sans-1-medium)              font_temp="Archivo-Narrow-Medium" ;;
        sans-1-semibold)            font_temp="Archivo-Narrow-Semibold" ;;
        sans-1-bold)                font_temp="Archivo-Narrow-Bold" ;;
        sans-2)                     font_temp="Poppins-Regular" ;;
        sans-2-thin)                font_temp="Poppins-Thin" ;;
        sans-2-light)               font_temp="Poppins-Light" ;;
        sans-2-extralight)          font_temp="Poppins-ExtraLight" ;;
        sans-2-medium)              font_temp="Poppins-Medium" ;;
        sans-2-semibold)            font_temp="Poppins-SemiBold" ;;
        sans-2-bold)                font_temp="Poppins-Bold" ;;
        sans-2-extrabold)           font_temp="Poppins-ExtraBold" ;;
        sans-2-black)               font_temp="Poppins-Black" ;;
        sans-3)                     font_temp="Share-Regular" ;;
        sans-3-bold)                font_temp="Share-Bold" ;;
        serif)                      font_temp="Merriweather-Regular" ;;
        serif-light)                font_temp="Merriweather-Light" ;;
        serif-bold)                 font_temp="Merriweather-Bold" ;;
        serif-black)                font_temp="Merriweather-Black" ;;
        serif-1)                    font_temp="Cormorant-Garamond-Regular" ;;
        serif-1-light)              font_temp="Cormorant-Garamond-Light" ;;
        serif-1-medium)             font_temp="Cormorant-Garamond-Medium" ;;
        serif-1-semibold)           font_temp="Cormorant-Garamond-Semibold" ;;
        serif-1-bold)               font_temp="Cormorant-Garamond-Bold" ;;
        serif-2)                    font_temp="GTSectraFine-Regular" ;;
        serif-2-medium)             font_temp="GTSectraFine-Medium" ;;
        serif-2-bold)               font_temp="GTSectraFine-Bold" ;;
        serif-2-black)              font_temp="GTSectraFine-Black" ;;
        serif-3)                    font_temp="Calluna-Regular" ;;
        serif-3-bold)               font_temp="Calluna-Bold" ;;
        mono)                       font_temp="RM-Courier-Regular" ;;
        mono-vt323)                 font_temp="VT323-Regular" ;;
        mono-fixedsys)              font_temp="Fixedsys-Excelsior-3.01" ;;
        mono-ocr)                   font_temp="OCR-A-Extended" ;;
        typewriter)                 font_temp="F25Executive" ;;
        typewriter-thin)            font_temp="ELEGANT-TYPEWRITER" ;;
        typewriter-1)               font_temp="Underwood-Champion" ;;
        typewriter-2)               font_temp="Sears-Tower" ;;
        typewriter-3)               font_temp="Rough_Typewriter" ;;
        comic)                      font_temp="DigitalStrip" ;;
        comic-1)                    font_temp="SmackAttack-BB" ;;
        comic-2)                    font_temp="Year-supply-of-fairy-cakes" ;;
        comic-3)                    font_temp="Komika-Title---Axis" ;;
        comic-4)                    font_temp="BadaBoom-BB" ;;
        comic-5)                    font_temp="Bangers" ;;
        comic-6)                    font_temp="Yikes!" ;;
        comic-7)                    font_temp="Mouse-Memoirs" ;;
        comic-8)                    font_temp="GROBOLD" ;;
        comic-9)                    font_temp="Helsinki" ;;
        display)                    font_temp="Coda-ExtraBold" ;;
        display-1)                  font_temp="Muli-Black" ;;
        display-2)                  font_temp="Chonburi" ;;
        display-3)                  font_temp="Bambi-Bold" ;;
        dirty)                      font_temp="Dirty-Headline" ;;
        dirty-1)                    font_temp="DCC-Ash" ;;
        dirty-2)                    font_temp="DCC-SharpDistressBlack" ;;
        dirty-3)                    font_temp="Dark-Underground" ;;
        dirty-4)                    font_temp="Iron-&-Brine" ;;
        dirty-5)                    font_temp="A-Love-of-Thunder" ;;
        brush)                      font_temp="LemonTuesday" ;;
        brush-1)                    font_temp="Edo-SZ" ;;
        brush-2)                    font_temp="ProtestPaint-BB" ;;
        brush-2-italic)             font_temp="ProtestPaint-BB-Italic" ;;
        brush-3)                    font_temp="SketchaLot" ;;
        horror)                     font_temp="YouMurdererBB" ;;
        horror-1)                   font_temp="FaceYourFears" ;;
        horror-2)                   font_temp="Something-Strange" ;;
        old)                        font_temp="OldNewspaperTypes" ;;
        old-1)                      font_temp="1543HumaneJenson-Normal" ;;
        old-1-bold)                 font_temp="1543HumaneJenson-Bold" ;;
        acme)                       font_temp="Acme" ;;
        averia)                     font_temp="Averia-Libre-Regular" ;;
        averia-bold)                font_temp="Averia-Libre-Bold" ;;
        scratch)                    font_temp="Scratch" ;;
        something)                  font_temp="Something-in-the-air" ;;
        *)                          font_temp="$font"
    esac
    return 0
}



# Create rectangle
#
# Arguments:
#   size
#   color
#   opaqueness, 100=opaque, 0=transparent
#   output image
function create_rectangle {
    local arg_size=""
    local arg_color=""
    local arg_opaqueness=100
    local arg_output=""

    [[ "$1" == "-s" ]]  && { arg_size="$2"; shift 2; }
    [[ "$1" == "-c" ]]  && { arg_color="$2"; shift 2; }
    [[ "$1" == "-p" ]]  && { arg_opaqueness="$2"; shift 2; }
    [[ "$1" == "-o" ]]  && { arg_output="$2"; shift 2; }

    convert                                 \
        -size $arg_size                     \
        xc:$arg_color                       \
        -alpha set                          \
        -channel A                          \
        -evaluate set ${arg_opaqueness}%    \
        $arg_output
}



# Create a gradient image
#
# Arguments:
#   width
#   height
#   dimension
#   gravity
#     rotation
#     color string
#   color1
#   color2
#   color3
#   output file
function create_gradient {
    local arg_width=0
    local arg_height=0
    local arg_gravity=""
    local arg_rotation=0
    local arg_color_string=""
    local arg_color_1=""
    local arg_color_2=""
    local arg_color_3=""
    local arg_output=""

    local dimension=""

    [[ "$1" == "-d" ]]  && { dimension="$2"; shift 2; }
    [[ "$1" == "-dw" ]] && { arg_width=$2; shift 2; }
    [[ "$1" == "-dh" ]] && { arg_height=$2; shift 2; }
    [[ "$1" == "-g" ]]  && { arg_gravity=$2; shift 2; }
    unset arg_rotation
    [[ "$1" == "-r" ]] && { arg_rotation=$2; shift 2; }
    unset arg_color_string
    [[ "$1" == "-cs" ]] && { arg_color_string="$2"; shift 2; }
    [[ "$1" == "-c1" ]] && { arg_color_1="$2"; shift 2; }
    [[ "$1" == "-c2" ]] && { arg_color_2="$2"; shift 2; }
    [[ "$1" == "-o" ]]  && { arg_output="$2"; shift 2; }

    if [[ ! "$arg_gravity" == @("north"|"south"|"east"|"west"|"northwest"|"northeast"|"southwest"|"southeast"|"northsouth"|"eastwest"|"custom") ]]; then
        echo "Error: Unknown gravity ($arg_gravity)."
    fi
    if [[ "$arg_gravity" == "custom" ]]; then
        if [[ -z ${arg_rotation+x} ]]; then
            echo "Error: Missing argument (rotation)."
        fi
        if [[ -z ${arg_color_string+x} ]]; then
            echo "Error: Missing argument (color string)."
        fi
    fi

    echo_debug "Create Gradient:"
    echo_debug "  Dimension: ${dimension}"
    echo_debug "  Width: ${arg_width}"
    echo_debug "  Height: ${arg_height}"
    echo_debug "  Gravity: ${arg_gravity}"
    echo_debug "  Rotation: ${arg_rotation}"
    echo_debug "  Color string: ${arg_color_string}"
    echo_debug "  Color: $arg_color_1"
    echo_debug "  Color: $arg_color_2"
    echo_debug "  Output file: $arg_output"

    if [[ "$arg_gravity" == @("north"|"south"|"east"|"west"|"northwest"|"northeast"|"southwest"|"southeast"|"northsouth"|"eastwest") ]]; then
        if [ "$arg_gravity" == "north" ]; then
            arg_rotation=180
        elif [ "$arg_gravity" == "south" ]; then
            arg_rotation=0
        elif [ "$arg_gravity" == "east" ]; then
            arg_rotation=270
        elif [ "$arg_gravity" == "west" ]; then
            arg_rotation=90
        elif [ "$arg_gravity" == "northwest" ]; then
            arg_rotation=135
        elif [ "$arg_gravity" == "northeast" ]; then
            arg_rotation=225
        elif [ "$arg_gravity" == "southwest" ]; then
            arg_rotation=45
        elif [ "$arg_gravity" == "southeast" ]; then
            arg_rotation=315
        elif [ "$arg_gravity" == "northsouth" ]; then
            arg_rotation=0
        elif [ "$arg_gravity" == "eastwest" ]; then
            arg_rotation=90
        else
            arg_rotation=0
        fi

        arg_color_string="$arg_color_1 $arg_color_2"
        if [[ "$arg_gravity" == @("northsouth"|"eastwest") ]]; then
            arg_color_string="$arg_color_1 $arg_color_2 50 $arg_color_1"
        fi
    fi

    ./multigradient             \
        -w $arg_width           \
        -h $arg_height          \
        -s "$arg_color_string"  \
        -t linear               \
        -d $arg_rotation        \
        $arg_output
}



# Apply mask to image
#
# Arguments:
#
#   image file
#   mask file
#   output file
function apply_mask {
    local arg_image=""
    local arg_mask=""
    local arg_output=""

    [[ "$1" == "-i" ]]  && { arg_image="$2"; shift 2; }
    [[ "$1" == "-m" ]] && { arg_mask=$2; shift 2; }
    [[ "$1" == "-o" ]] && { arg_output=$2; shift 2; }

    echo_debug "Apply mask:"
    echo_debug "  Input: ${arg_image}"
    echo_debug "  Mask: ${arg_mask}"
    echo_debug "  Output: ${arg_output}"

    convert                             \
        $arg_image                      \
        -write MPR:orig                 \
        -alpha extract                  \
        $arg_mask                       \
        -compose multiply               \
        -composite MPR:orig             \
        +swap                           \
        -compose copyopacity            \
        -composite $arg_output
}



# Blur image
#
# Arguments:
#   input file
#   output file
function simple_blur {
    local arg_input_file="$1"
    local arg_output_file="$2"
    convert                         \
        $arg_input_file             \
        -filter Gaussian            \
        -resize 50%                 \
        -define filter:sigma=2.5    \
        -resize 200%                \
        $arg_output_file
}



# Blur image
#
# Arguments:
#   input file
#   output file
function blur {
    local arg_input_file="$1"
    local arg_output_file="$2"
    local arg_radius=$3
    local arg_sigma=$4
    convert                                 \
        $arg_input_file                     \
        -channel A                          \
        -blur ${arg_radius}x${arg_sigma}    \
        -channel RGB                        \
        -blur ${arg_radius}x${arg_sigma}    \
        $arg_output_file
}



# Make a rounded corner image
#
# Arguments:
#   image file
#   round corner pixel count
#   output image file
function round_corner {
    local arg_image="$1"
    local arg_corner="$2"
    local arg_output="$3"
    convert                         \
        $arg_image                  \
        \( +clone -alpha extract    \
            -draw "fill black polygon 0,0 0,$arg_corner $arg_corner,0 fill white circle $arg_corner,$arg_corner $arg_corner,0" \
            \( +clone -flip \) -compose Multiply -composite \
            \( +clone -flop \) -compose Multiply -composite \
        \)                                                  \
        -alpha off                                          \
        -compose CopyOpacity                                \
        -composite  "$arg_output"
}



# ============================================================================



program_name="$0"

if [ $# -eq 0 ]; then
    show_usage
    exit
fi

if [ "$1" == "--help" ]; then
    show_usage
    exit
fi

# Collect all arguments so it can be passed to Exif later
args=("$@")                             # store arguments in a special array
ELEMENTS=${#args[@]}                    # get number of elements
commandline_arguments=""
for (( i=0;i<$ELEMENTS;i++)); do
    commandline_arguments="$commandline_arguments ${args[${i}]}"
done

if [ "$1" == "--debug" ]; then
    echo "Mode: Debug"
    debug=1
    shift 1
fi

canvas_color="black"
canvas_color_2=""
canvas_color_3=""
unset canvas_gravity
unset canvas_gradient_rotation
unset canvas_gradient_color_string
if [ "$1" == "--canvas" ]; then
    shift 1
    if [[ ! "$1" == @("default"|"big"|"bigger"|"large"|"huge"|"square"|"square-big"|"square-large"|"tall"|"taller"|"tower") ]]; then
        echo_err "Unknown canvas size constant."
        exit 1
    fi
    case "$1" in
        default)       canvas="$CANVAS_DEFAULT" ;;
        big)           canvas="$CANVAS_BIG" ;;
        bigger)        canvas="$CANVAS_BIGGER" ;;
        large)         canvas="$CANVAS_LARGE" ;;
        huge)          canvas="$CANVAS_HUGE" ;;
        square)        canvas="$CANVAS_SQUARE" ;;
        square-big)    canvas="$CANVAS_SQUARE_BIG" ;;
        square-large)  canvas="$CANVAS_SQUARE_LARGE" ;;
        tall)          canvas="$CANVAS_TALL" ;;
        taller)        canvas="$CANVAS_TALLER" ;;
        tower)         canvas="$CANVAS_TOWER" ;;
    esac
    shift 1
    [[ "$1" == "-c" ]] && { canvas_color="$2"; shift 2; }
    [[ "$1" == "-c2" ]] && { canvas_color_2="$2"; shift 2; }
    [[ "$1" == "-g" ]] && { canvas_gravity="$2"; shift 2; }
    [[ "$1" == "-r" ]] && { canvas_gradient_rotation="$2"; shift 2; }
    [[ "$1" == "-cs" ]] && { canvas_gradient_color_string="$2"; shift 2; }

    if [[ -n ${canvas_gradient_color_string+x} ]]; then
        if [[ ! "$canvas_gravity" == @("north"|"south"|"east"|"west"|"northwest"|"northeast"|"southwest"|"southeast"|"northsouth"|"eastwest"|"custom") ]]; then
            echo_err "Unknown gravity ($canvas_gravity)."
            exit 1
        fi
        if [[ "$canvas_gravity" == "custom" ]]; then
            if [[ -z ${canvas_gradient_rotation+x} ]]; then
                echo_err "Missing argument (rotation)."
                exit 1
            fi
            if [[ -z ${canvas_gradient_color_string+x} ]]; then
                echo_err "Missing argument (color string)."
                exit 1
            fi
        else
            canvas_gradient_rotation=0
            canvas_gradient_color_string=""
            if [[ -z "$canvas_color_2" ]]; then
                echo_err "Canvas second gradient color not specified."
                exit 1
            fi
        fi
    else
        # These variables need to be set so we do not have issues
        # when passed to the gradient function
        canvas_gradient_rotation=0
        canvas_gradient_color_string=""
    fi
else
    canvas="$CANVAS_DEFAULT"
fi # --canvas

get_canvas_width "$canvas"
get_canvas_height "$canvas"

canvas_width="$width_temp"
canvas_height="$height_temp"

echo_debug "Canvas"
echo_debug "  Size: $canvas"
echo_debug "  Color: $canvas_color"
echo_debug "  Color: $canvas_color_2"
echo_debug "  Gravity: $canvas_gravity"
echo_debug "  Gradient rotation: $canvas_gradient_rotation"
echo_debug "  Gradient color string: $canvas_gradient_color_string"
echo_debug "  Width: $canvas_width"
echo_debug "  Height: $canvas_height"
echo_debug "  Dimension: ${canvas_width}x${canvas_height}"

if [ -n "$canvas_gravity" ]; then
    create_gradient                         \
        -dw $canvas_width                   \
        -dh $canvas_height                  \
        -g  $canvas_gravity                 \
        -r  $canvas_gradient_rotation       \
        -cs "$canvas_gradient_color_string" \
        -c1 $canvas_color                   \
        -c2 $canvas_color_2                 \
        -o $OUTPUT_FILE
else
    convert                                     \
        -size ${canvas_width}x${canvas_height}  \
        xc:"$canvas_color"                      \
        $OUTPUT_FILE
fi

if [ $debug -eq 1 ]; then
    # Make a copy of the canvas image for debugging purposes
    cp -f $OUTPUT_FILE int_canvas.png
fi

while [ $# -gt 0 ] && \
      [[ "$1" == @("--image"|"--rectangle"|"--bottombar"|"--hbar"|"--logo"|"--text"|"--author") ]]; do

while [ "$1" == "--image" ]; do
    shift 1
    if [[ ! -f "$1" ]]; then
        echo_err "Cannot find image file '$1'"
        exit 1
    fi
    image_file="$1"
    shift 1
    image_gravity="northwest" && \
        [[ "$1" == "-g" ]] && { image_gravity="$2"; shift 2; }
    image_offset="+0+0" && \
        [[ "$1" == "-o" ]] && { image_offset="$2"; shift 2; }

    echo_debug "Image:"
    echo_debug "  File: $image_file"
    echo_debug "  Dimension (w/ adj.): $image_dimension"
    echo_debug "  Gravity: $image_gravity"
    echo_debug "  Offset: $image_offset"

    cp -f "$image_file" int_image.png

    while [[ "$1" == @("-blur"|"-border"|"-color"|"-corner"|"-cut"|"-flip"|"-gradient"|"-rotate"|"-size"|"-tint"|"-transparent"|"-vignette") ]]; do
        if [ "$1" == "-blur" ]; then
            shift 1
            if [ "$1" == "-simple" ]; then
                shift 1
                echo_debug "  Blur: simple"
                simple_blur         \
                    int_image.png   \
                    int_image.png
            else
                blur_radius=0 && \
                    [[ "$1" == "-r" ]] && { blur_radius=$2; shift 2; }
                blur_sigma=4 && \
                    [[ "$1" == "-s" ]] && { blur_sigma=$2; shift 2; }

                echo_debug "  Blur:"
                echo_debug "    Radius: $blur_radius"
                echo_debug "    Sigma: $blur_sigma"

                blur                \
                    int_image.png   \
                    int_image.png   \
                    $blur_radius    \
                    $blur_sigma
            fi
        elif [ "$1" == "-border" ]; then
            image_border_color="$2"
            shift 2
            image_border_width=3
            [[ "$1" == "-w" ]] && { image_border_width=$2; shift 2; }
            image_border_radius=0
            [[ "$1" == "-r" ]] && { image_border_radius=$2; shift 2; }

            echo_debug "  Border:"
            echo_debug "    Color: $image_border_color"
            echo_debug "    Width: $image_border_width"
            echo_debug "    Radius: $image_border_radius"

            if [ $image_border_radius -eq 0 ]; then
                convert                                     \
                    int_image.png                           \
                    -shave 1x1                              \
                    -bordercolor "$image_border_color"      \
                    -border $image_border_width             \
                    int_image.png
            else

                image_border_width=`convert int_image.png -ping -format '%w' info:`
                image_border_height=`convert int_image.png -ping -format '%h' info:`

                image_border_width=$((image_border_width + image_border_radius))
                image_border_height=$((image_border_height + image_border_radius))

                convert                                                 \
                    -size ${image_border_width}x${image_border_height}  \
                    xc:none -fill $image_border_color                   \
                    -draw "roundrectangle 0,0 ${image_border_width},${image_border_height} $image_border_radius,$image_border_radius" \
                    int_rr.png
                convert                 \
                    int_rr.png          \
                    int_image.png       \
                    -gravity center     \
                    -composite          \
                    int_image.png
            fi
        elif [ "$1" == "-color" ]; then
            shift 1
            while [[ "-f -n -ng" == *"$1"* ]]; do
                color_from="" && \
                    [[ "$1" == "-f" ]] && { color_from=$2; shift 2; }
                color_to="" && \
                    [[ "$1" == "-t" ]] && { color_to=$2; shift 2; }
                color_to_transparent=0 && \
                    [[ "$1" == "-x" ]] && { color_to_transparent=1; shift 1; }
                color_negate=0 && \
                    [[ "$1" == "-n" ]] && { color_negate=1; shift 1; }
                color_negate_grayscale=0 && \
                    [[ "$1" == "-ng" ]] && { color_negate_grayscale=1; shift 1; }

                echo_debug "  Color:"
                echo_debug "    From: $color_from"
                echo_debug "    To: $color_to"
                echo_debug "    Transparent: $color_to_transparent"
                echo_debug "    Negate: $color_negate"
                echo_debug "    Negate (grayscale): $color_negate_grayscale"

                if [ $color_to_transparent -gt 0 ]; then
                    convert                         \
                        int_image.png               \
                        -transparent $color_from    \
                        int_image.png
                elif [ $color_negate -gt 0 ]; then
                    convert                         \
                        int_image.png               \
                        -negate                     \
                        int_image.png
                elif [ $color_negate_grayscale -gt 0 ]; then
                    convert                         \
                        int_image.png               \
                        +negate                     \
                        int_image.png
                else
                    convert                         \
                        int_image.png               \
                        -fill $color_to             \
                        -opaque $color_from         \
                        int_image.png
                fi
            done
        elif [ "$1" == "-corner" ]; then
            shift 1
            corner_radius=15 && \
                [[ "$1" == "-r" ]] && { corner_radius=$2; shift 2; }
            echo_debug "  Round corner: $corner_radius"
            round_corner        \
                int_image.png   \
                $corner_radius  \
                int_image.png
        elif [ "$1" == "-cut" ]; then
            shift 1
            if [ "$1" == "-circle" ]; then
                shift 1
                cut_radius=100 && \
                    [[ "$1" == "-r" ]] && { cut_radius=$2; shift 2; }
                cut_x=0 && \
                    [[ "$1" == "-px" ]] && { cut_x=$2; shift 2; }
                cut_y=0 && \
                    [[ "$1" == "-py" ]] && { cut_y=$2; shift 2; }
                cut_border=10 && \
                    [[ "$1" == "-bw" ]] && { cut_border=$2; shift 2; }
                cut_border_color=white && \
                    [[ "$1" == "-bc" ]] && { cut_border_color="$2"; shift 2; }

                echo_debug "  Cut (circle):"
                echo_debug "    Radius: $cut_radius"
                echo_debug "    Position: $cut_x, $cut_y"
                echo_debug "    Border: $cut_border"
                echo_debug "    Color: $cut_border_color"

                convert int_image.png                               \
                    \( +clone                                       \
                        -threshold -1                               \
                        -negate                                     \
                        -fill white                                 \
                        -draw "ellipse $cut_x,$cut_y $cut_radius,$cut_radius 0,360" \)    \
                    -alpha off                                      \
                    -compose copy_opacity                           \
                    -composite                                      \
                    png:-                                           \
                | convert                                           \
                    -                                               \
                    -trim                                           \
                    +repage                                         \
                    int_image.png

                x0=$((cut_radius + cut_border))
                y0=$((cut_radius + cut_border))
                x1=$(((cut_radius * 2) + (cut_border * 2)))
                y1=$((cut_radius))
                cut_diameter=$(((cut_radius * 2) + (cut_border * 2) + 1))

                convert                                     \
                    -size ${cut_diameter}x${cut_diameter}   \
                    xc:none                                 \
                    -fill $cut_border_color                 \
                    -draw "circle $x0,$y0, $x1,$y0"         \
                    png:-                                   \
                | convert                                   \
                    -                                       \
                    int_image.png                           \
                    -gravity center                         \
                    -composite                              \
                    int_image.png
            elif [ "$1" == "-side" ]; then
                shift 1
                while [[ "$1" == @("north"|"south"|"east"|"west") ]]; do
                    cut_gravity=$1
                    cut_pixels=$2
                    shift 2

                    if [ $cut_pixels -gt 0 ]; then
                        echo_debug "  Cut (side):"
                        echo_debug "    Gravity: $cut_gravity"
                        echo_debug "    Pixels: $cut_pixels"

                        chop_argument=""
                        if [[ "$cut_gravity" == @("east"|"west") ]]; then
                            chop_argument="${cut_pixels}x0"
                        elif [[ "$cut_gravity" == @("north"|"south") ]]; then
                            chop_argument="0x${cut_pixels}"
                        fi

                        convert                     \
                            int_image.png           \
                            -gravity $cut_gravity   \
                            -chop $chop_argument    \
                            int_image.png

                        cut_image_width=`convert int_image.png -ping -format '%w' info:`
                        cut_image_height=`convert int_image.png -ping -format '%h' info:`

                        echo_debug "    New width: $cut_image_width"
                        echo_debug "    New height: $cut_image_height"
                    fi
                done
            fi
        elif [ "$1" == "-flip" ]; then
            shift 1
            echo_debug "  Flip: true"
            convert                                 \
                int_image.png                       \
                -flop                               \
                int_image.png
        elif [ "$1" == "-gradient" ]; then
            image_gradient_gravity="$2"
            shift 2
            image_gradient_color_1="black"
            image_gradient_color_2="white"
            [[ "$1" == "-c1" ]] && { image_gradient_color_1="$2"; shift 2; }
            [[ "$1" == "-c2" ]] && { image_gradient_color_2="$2"; shift 2; }

            image_gradient_rotation=0
            unset image_gradient_color_string
            [[ "$1" == "-r" ]] && { image_gradient_rotation=$2; shift 2; }
            [[ "$1" == "-cs" ]] && { image_gradient_color_string="$2"; shift 2; }

            if [[ ! "$image_gradient_gravity" == @("north"|"south"|"east"|"west"|"northwest"|"northeast"|"southwest"|"southeast"|"northsouth"|"eastwest"|"custom") ]]; then
                echo_err "Unknown gravity ($image_gradient_gravity)."
                exit 1
            fi
            if [[ "$image_gradient_gravity" == "custom" ]]; then
                if [[ -z ${image_gradient_color_string+x} ]]; then
                    echo_err "Missing argument (color string)."
                    exit 1
                fi
            else
                image_gradient_color_string=""
            fi
            image_width=`convert int_image.png -ping -format '%w' info:`
            image_height=`convert int_image.png -ping -format '%h' info:`

            echo_debug "  Gradient"
            echo_debug "    Width: $image_width"
            echo_debug "    Height: $image_height"
            echo_debug "    Gravity: $image_gradient_gravity"
            echo_debug "    Color: $image_gradient_color_1"
            echo_debug "    Color: $image_gradient_color_2"
            echo_debug "    Rotation: $image_gradient_rotation"
            echo_debug "    Color string: $image_gradient_color_string"

            create_gradient                         \
                -dw $image_width                    \
                -dh $image_height                   \
                -g  $image_gradient_gravity         \
                -r  $image_gradient_rotation        \
                -cs "$image_gradient_color_string"  \
                -c1 $image_gradient_color_1         \
                -c2 $image_gradient_color_2         \
                -o  int_gradient.png
            apply_mask                      \
                -i int_image.png            \
                -m int_gradient.png         \
                -o int_image.png
        elif [ "$1" == "-rotate" ]; then
            shift 1
            unset rotate_angle
            [[ "$1" == "-a" ]] && { rotate_angle=$2; shift 2; }
            if [ -z ${rotate_angle+x} ]; then
                echo_err "Missing -rotate argument (angle)."
                exit 1
            fi
            echo_debug "  Rotate: $rotate_angle"
            mogrify                         \
                -background 'rgba(0,0,0,0)' \
                -rotate $rotate_angle       \
                int_image.png
        elif [ "$1" == "-size" ]; then
            shift 1
            image_dimension="${canvas_width}x${canvas_height}"
            [[ "$1" == "-s" ]] && { image_dimension="$2"; shift 2; }
            # Size/dimension adjustment is appended
            [[ "$1" == "-a" ]] \
                && { image_dimension="$image_dimension$2"; shift 2; } \
                || image_dimension="${image_dimension}>"

            echo_debug "  Size: $image_dimension"
            convert                         \
                -background none            \
                int_image.png               \
                -resize "$image_dimension"  \
                int_image.png
        elif [ "$1" == "-tint" ]; then
            shift 1
            tint_use_rgb=0
            tint_red=0.0
            tint_green=0.0
            tint_blue=0.0
            tint_brightness=0
            tint_contrast=0
            tint_mode="a"
            tint_color="black"
            tint_amount=10
            [[ "$1" == "-c" ]] && { tint_color="$2"; shift 2; }
            [[ "$1" == "-a" ]] && { tint_amount="$2"; shift 2; }
            if [[ "$1" == "-rgb" ]]; then
                shift 1
                tint_use_rgb=1
                if [[ "$1" == "-default" ]]; then
                    tint_red=29.9
                    tint_green=58.7
                    tint_blue=11.4
                    shift 1
                else
                    tint_red="$1";
                    tint_green="$2";
                    tint_blue="$3";
                    shift 3
                fi
            elif [[ "$1" == "-bc" ]]; then
                shift 1
                tint_brightness="$1"
                tint_contrast="$2"
                shift 2
                [[ "$1" == "-m" ]] && { tint_mode="$2"; shift 2; }
            fi

            echo_debug "  Tint:"
            echo_debug "    Color: $tint_color"
            echo_debug "    Amount: $tint_amount"
            echo_debug "    Red: $tint_red"
            echo_debug "    Green: $tint_green"
            echo_debug "    Blue: $tint_blue"
            echo_debug "    Brightness: $tint_brightness"
            echo_debug "    Contrast: $tint_contrast"
            echo_debug "    Mode: $tint_mode"

            if [ $tint_use_rgb -eq 1 ]; then
                ./graytoning            \
                    -r $tint_red        \
                    -g $tint_green      \
                    -b $tint_blue       \
                    -t $tint_color      \
                    -a $tint_amount     \
                    int_image.png       \
                    int_image.png
            else
                ./graytoning            \
                    -o $tint_brightness \
                    -c $tint_contrast   \
                    -t $tint_color      \
                    -m $tint_mode       \
                    -a $tint_amount     \
                    int_image.png       \
                    int_image.png
            fi
        elif [ "$1" == "-transparent" ]; then
            shift 1
            unset transparent_color
            [[ "$1" == "-c" ]] && { transparent_color="$2"; shift 2; }
            transparent_fuzz=0
            [[ "$1" == "-f" ]] && { transparent_fuzz=$2; shift 2; }
            mogrify                                 \
                -fuzz ${transparent_fuzz}%          \
                -transparent $transparent_color     \
                int_image.png
        elif [ "$1" == "-vignette" ]; then
            shift 1
            vignette_background="black" && \
                [[ "$1" == "-c" ]] && { vignette_background=$2; shift 2; }
            vignette_sigma=10 && \
                [[ "$1" == "-s" ]] && { vignette_sigma=$2; shift 2; }
            vignette_size="+10+10%" && \
                [[ "$1" == "-d" ]] && { vignette_size=$2; shift 2; }

            echo_debug "  Vignette:"
            echo_debug "    Background: $vignette_background"
            echo_debug "    Sigma: $vignette_sigma"
            echo_debug "    Size: $vignette_size"

            convert                                             \
                int_image.png                                   \
                -background $vignette_background                \
                -vignette 0x${vignette_sigma}${vignette_size}   \
                int_image.png
        else
            break;
        fi
    done # while

    convert                         \
        $OUTPUT_FILE                \
        int_image.png               \
        -gravity "$image_gravity"   \
        -geometry "$image_offset"   \
        -composite                  \
        $OUTPUT_FILE
done # --image

while [ "$1" == "--rectangle" ]; do
    shift 1
    rect_width="${canvas_width}"
    rect_height="${canvas_height}"
    rect_color="black"
    rect_opaqueness=100
    rect_gravity="northwest"
    rect_position="+0+0"

    rect_color_2=""
    unset rect_gradient_gravity
    unset rect_gradient_rotation
    unset rect_gradient_color_string
    rect_round_corner_radius=0
    destination_file="$OUTPUT_FILE"

    [[ "$1" == "-w" ]] && { rect_width="$2"; shift 2; }
    [[ "$1" == "-h" ]] && { rect_height="$2"; shift 2; }
    [[ "$1" == "-c" ]] && { rect_color="$2"; shift 2; }
    [[ "$1" == "-p" ]] && { rect_opaqueness="$2"; shift 2; }
    [[ "$1" == "-g" ]] && { rect_gravity="$2"; shift 2; }
    [[ "$1" == "-p" ]] && { rect_position="$2"; shift 2; }
    [[ "$1" == "-c2" ]] && { rect_color_2="$2"; shift 2; }
    [[ "$1" == "-gg" ]] && { rect_gradient_gravity="$2"; shift 2; }
    [[ "$1" == "-gr" ]] && { rect_gradient_rotation=$2; shift 2; }
    [[ "$1" == "-gcs" ]] && { rect_gradient_color_string=$2; shift 2; }
    [[ "$1" == "-r" ]] && { rect_round_corner_radius="$2"; shift 2; }
    [[ "$1" == "-o" ]] && { destination_file="$2"; shift 2; }

    if [[ -n ${rect_gradient_color_string+x} ]]; then
        if [[ ! "$rect_gradient_gravity" == @("north"|"south"|"east"|"west"|"northwest"|"northeast"|"southwest"|"southeast"|"northsouth"|"eastwest"|"custom") ]]; then
            echo_err "Unknown gravity ($rect_gradient_gravity)."
            exit 1
        fi
        if [[ "$rect_gradient_gravity" == "custom" ]]; then
            if [[ -z ${rect_gradient_rotation+x} ]]; then
                echo_err "Missing argument (rotation)."
                exit 1
            fi
            if [[ -z ${rect_gradient_color_string+x} ]]; then
                echo_err "Missing argument (color string)."
                exit 1
            fi
        else
            rect_gradient_rotation=0
            rect_gradient_color_string=""
            if [[ -z ${rect_color_2} ]]; then
                echo_err "Second gradient color not specified."
                exit 1
            fi
        fi
    fi

    echo_debug "Rectangle:"
    echo_debug "  Dimension: ${rect_width}x${rect_height}"
    echo_debug "  Color: $rect_color"
    echo_debug "  Opaqueness: $rect_opaqueness"
    echo_debug "  Gravity: $rect_gravity"
    echo_debug "  Position: $rect_position"
    echo_debug "  Color: $rect_color_2"
    echo_debug "  Gradient gravity: $rect_gradient_gravity"
    echo_debug "  Gradient rotation: $rect_gradient_rotation"
    echo_debug "  Gradient color string: $rect_gradient_color_string"
    echo_debug "  Rounded corner radius: $rect_round_corner_radius"
    echo_debug "  Output file: $destination_file"

    if [ -n "$rect_color_2" ]; then
        create_gradient                         \
            -dw $rect_width                     \
            -dh $rect_height                    \
            -g  $rect_gradient_gravity          \
            -r  $rect_gradient_rotation         \
            -cs "$rect_gradient_color_string"   \
            -c1 $rect_color                     \
            -c2 $rect_color_2                   \
            -o  int_rect.png
    else
        create_rectangle                        \
            -s "${rect_width}x${rect_height}"   \
            -c $rect_color                      \
            -p $rect_opaqueness                 \
            -o int_rect.png

        if [ $rect_round_corner_radius -gt 0 ]; then
            round_corner                        \
                int_rect.png                    \
                $rect_round_corner_radius       \
                int_rect.png
        fi
    fi

    composite                       \
        int_rect.png                \
        $OUTPUT_FILE                \
        -alpha set                  \
        -gravity $rect_gravity      \
        -geometry $rect_position    \
        $destination_file

    if [ $debug -eq 0 ]; then
        rm -f int_rect.png
    fi
done # --rectangle

while [ "$1" == "--hbar" ]; do
    shift 1
    hbar_height=50
    hbar_color="black"
    hbar_opaqueness=50
    hbar_gravity="northwest"
    hbar_position="+0+0"
    hbar_color_2=""
    unset hbar_gradient_gravity
    unset hbar_gradient_rotation
    unset hbar_gradient_color_string

    [[ "$1" == "-h" ]] && { hbar_height=$2; shift 2; }
    [[ "$1" == "-c" ]] && { hbar_color="$2"; shift 2; }
    [[ "$1" == "-p" ]] && { hbar_opaqueness=$2; shift 2; }
    [[ "$1" == "-g" ]] && { hbar_gravity="$2"; shift 2; }
    [[ "$1" == "-y" ]] && { hbar_position=+0+"$2"; shift 2; }
    [[ "$1" == "-c2" ]] && { hbar_color_2="$2"; shift 2; }
    [[ "$1" == "-gg" ]] && { hbar_gradient_gravity="$2"; shift 2; }
    [[ "$1" == "-gr" ]] && { hbar_gradient_rotation=$2; shift 2; }
    [[ "$1" == "-gcs" ]] && { hbar_gradient_color_string=$2; shift 2; }

    if [[ -n ${hbar_gradient_color_string+x} ]]; then
        if [[ ! "$hbar_gradient_gravity" == @("north"|"south"|"east"|"west"|"northwest"|"northeast"|"southwest"|"southeast"|"northsouth"|"eastwest"|"custom") ]]; then
            echo_err "Unknown gravity ($hbar_gradient_gravity)."
            exit 1
        fi
        if [[ "$hbar_gradient_gravity" == "custom" ]]; then
            if [[ -z ${hbar_gradient_rotation+x} ]]; then
                echo_err "Missing argument (rotation)."
                exit 1
            fi
            if [[ -z ${hbar_gradient_color_string+x} ]]; then
                echo_err "Missing argument (color string)."
                exit 1
            fi
        else
            hbar_gradient_rotation=0
            hbar_gradient_color_string=""
            if [[ -z ${hbar_color_2} ]]; then
                echo_err "Second gradient color not specified."
                exit 1
            fi
        fi
    fi

    echo_debug "Horizontal Bar:"
    echo_debug "  Height: $hbar_height"
    echo_debug "  Color: $hbar_color"
    echo_debug "  Opaqueness: $hbar_opaqueness"
    echo_debug "  Gravity: $hbar_gravity"
    echo_debug "  Y Position: $hbar_position"
    echo_debug "  Color: $hbar_color_2"
    echo_debug "  Gradient gravity: $hbar_gradient_gravity"
    echo_debug "  Gradient rotation: $hbar_gradient_rotation"
    echo_debug "  Gradient color string: $hbar_gradient_color_string"

    if [ -n "$hbar_color_2" ]; then
        create_gradient                         \
            -dw $canvas_width                   \
            -dh $hbar_height                    \
            -g  $hbar_gradient_gravity          \
            -r  $hbar_gradient_rotation         \
            -cs "$hbar_gradient_color_string"   \
            -c1 $hbar_color                     \
            -c2 $hbar_color_2                   \
            -o  int_hbar.png
    else
        create_rectangle                        \
            -s "${canvas_width}x${hbar_height}" \
            -c $hbar_color                      \
            -p $hbar_opaqueness                 \
            -o int_hbar.png
    fi

    composite                           \
        int_hbar.png                    \
        $OUTPUT_FILE                    \
        -alpha set                      \
        -gravity $hbar_gravity          \
        -geometry $hbar_position        \
        $OUTPUT_FILE

    if [ $debug -eq 0 ]; then
        rm -f int_hbar.png
    fi
done # --hbar

if [ "$1" == "--bottombar" ]; then
    shift 1
    bb_height=50
    bb_color="black"
    bb_opaqueness=100
    bb_color_2=""
    bb_gradient_gravity=""
    unset bb_gradient_rotation
    unset bb_gradient_color_string

    [[ "$1" == "-h" ]] && { bb_height=$2; shift 2; }
    [[ "$1" == "-c" ]] && { bb_color="$2"; shift 2; }
    [[ "$1" == "-p" ]] && { bb_opaqueness=$2; shift 2; }
    [[ "$1" == "-c2" ]] && { bb_color_2="$2"; shift 2; }
    [[ "$1" == "-gg" ]] && { bb_gradient_gravity=$2; shift 2; }
    [[ "$1" == "-gr" ]] && { bb_gradient_rotation=$2; shift 2; }
    [[ "$1" == "-gcs" ]] && { bb_gradient_color_string=$2; shift 2; }

    if [[ -n ${bb_gradient_color_string+x} ]]; then
        if [[ ! "$bb_gradient_gravity" == @("north"|"south"|"east"|"west"|"northwest"|"northeast"|"southwest"|"southeast"|"northsouth"|"eastwest"|"custom") ]]; then
            echo_err "Unknown gravity ($bb_gradient_gravity)."
            exit 1
        fi
        if [[ "$bb_gradient_gravity" == "custom" ]]; then
            if [[ -z ${bb_gradient_rotation+x} ]]; then
                echo_err "Missing argument (rotation)."
                exit 1
            fi
            if [[ -z ${bb_gradient_color_string+x} ]]; then
                echo_err "Missing argument (color string)."
                exit 1
            fi
        else
            bb_gradient_rotation=0
            bb_gradient_color_string=""
            if [[ -z ${bb_color_2} ]]; then
                echo_err "Second gradient color not specified."
                exit 1
            fi
        fi
    fi

    echo_debug "Bottom Bar:"
    echo_debug "  Height: $bb_height"
    echo_debug "  Color: $bb_color"
    echo_debug "  Opaqueness: $bb_opaqueness"
    echo_debug "  Color: $bb_color_2"
    echo_debug "  Gradient gravity: $bb_gradient_gravity"
    echo_debug "  Gradient rotation: $bb_gradient_rotation"
    echo_debug "  Gradient color string: $bb_gradient_color_string"

    if [ -n "$bb_color_2" ]; then
        create_gradient                         \
            -dw $canvas_width                   \
            -dh $bb_height                      \
            -g  $bb_gradient_gravity            \
            -r  $bb_gradient_rotation           \
            -cs "$bb_gradient_color_string"     \
            -c1 $bb_color                       \
            -c2 $bb_color_2                     \
            -o  int_bb.png
    else
        create_rectangle                        \
            -s "${canvas_width}x${bb_height}"   \
            -c $bb_color                        \
            -p $bb_opaqueness                   \
            -o int_bb.png
    fi

    composite                       \
        int_bb.png                  \
        $OUTPUT_FILE                \
        -alpha set                  \
        -gravity south              \
        -geometry +0+0              \
        $OUTPUT_FILE
fi # --bottombar

if [ "$1" == "--logo" ]; then
    shift 1
    logo_color="black" && \
        [[ "$1" == "-c" ]] && { logo_color="$2"; shift 2; }
    logo_dimension="30x30" && \
        [[ "$1" == "-s" ]] && { logo_dimension="$2"; shift 2; }
    logo_offset_x=11 && \
        [[ "$1" == "-ox" ]] && { logo_offset_x=$2; shift 2; }
    logo_offset_y=9 && \
        [[ "$1" == "-oy" ]] && { logo_offset_y=$2; shift 2; }
    logo_gravity="southeast" && \
        [[ "$1" == "-g" ]] && { logo_gravity="$2"; shift 2; }
    logo_label="" && \
        [[ "$1" == "-l" ]] && { logo_label="$2"; shift 2; }

    logo_offset=+${logo_offset_x}+${logo_offset_y}

    echo_debug "Logo:"
    echo_debug "  Color: $logo_color"
    echo_debug "  Label: $logo_label"

    image_logo="logo/logo_fist2_white.png"
    convert                                         \
        "$image_logo"                               \
        -fill "$logo_color"                         \
        -colorize 100%                              \
        png:-                                       \
    | convert                                       \
        $OUTPUT_FILE                                \
        -                                           \
        -gravity $logo_gravity                      \
        -geometry ${logo_dimension}${logo_offset}   \
        -composite                                  \
        $OUTPUT_FILE

    if [ -n "$logo_label" ]; then
        label_offset_x=$((logo_offset_x + 37))
        label_offset_y=$((logo_offset_y + 6))
        convert                                             \
            -background none                                \
            -size 150x18                                    \
            -font "Oswald-Regular"                          \
            -pointsize 13                                   \
            -gravity east                                   \
            -fill "$logo_color"                             \
            caption:"$logo_label"                           \
            png:-                                           \
        | convert                                           \
            $OUTPUT_FILE                                    \
            -                                               \
            -gravity $logo_gravity                          \
            -geometry +${label_offset_x}+${label_offset_y}  \
            -composite                                      \
            $OUTPUT_FILE
    fi
fi # --logo

guide_show=0
guide_color=black

text_width_all="$canvas_width"
text_position_x_all=0
text_position_y_all=0
next_y_pos=0

text_font="$FONT_DEFAULT"
text_size="15"
text_color="black"
text_background_color="none"
text_gravity="northwest"
text_interline_spacing=0
text_width="$text_width_all"
compute_next=0
text_stroke_width=0
text_stroke_color="black"
text_stroke_fade=1
text_shadow_percent=0
text_shadow_color="black"
text_shadow_offset=3

pos_x=0
pos_y=0

if [ $debug -gt 0 ]; then
    text_count=0
fi

while [ "$1" == "--text" ]; do
    shift 1
    text_string=""
    [[ "$1" == "-W" ]] && { text_width_all="$2"; shift 2; }
    [[ "$1" == "-Wo" ]] && { text_width_all=$((text_width_all - ${2})); shift 2; }
    if [ "$1" == "-Px" ]; then
        text_position_x_all="$2"
        pos_x="$2"
        shift 2
    fi
    if [ "$1" == "-Py" ]; then
        text_position_y_all="$2"
        pos_y="$2"
        shift 2
    fi
    if [[ "$1" == "-guide" ]]; then
        guide_color="$2"
        shift 2
        guide_show=1
    fi

    if [ $guide_show -eq 1 ]; then
        create_rectangle                            \
            -s "${text_width_all}x${canvas_height}" \
            -c $guide_color                         \
            -p 50                                   \
            -o int_guide.png
        composite                                                   \
            int_guide.png                                           \
            $OUTPUT_FILE                                            \
            -alpha set                                              \
            -gravity northwest                                      \
            -geometry "+$text_position_x_all+$text_position_y_all"  \
            $OUTPUT_FILE
        rm -f int_guide.png
    fi

    text_width="$text_width_all"
    while [ $# -gt 0 ] && [[ "-t -f -s -c -bc -i -g -w -px -py -pg -ox -oy -sw -sc -sf -sh -shc -sho" == *"$1"* ]]; do
        [[ "$1" == "-t" ]] && { text_string="$2"; shift 2; }
        if [ "$1" == "-f" ]; then
            get_font_family "$2"
            text_font="$font_temp"
            shift 2
        fi
        [[ "$1" == "-s" ]] && { text_size="$2"; shift 2; }
        [[ "$1" == "-c" ]] && { text_color="$2"; shift 2; }
        [[ "$1" == "-bc" ]] && { text_background_color="$2"; shift 2; }
        [[ "$1" == "-i" ]] && { text_interline_spacing="$2"; shift 2; }
        [[ "$1" == "-g" ]] && { text_gravity="$2"; shift 2; }
        if [ "$1" == "-w" ]; then
            text_width="$2"
            shift 2
        fi
        # Always reset absolute position to defaults
        text_position_x=0 && \
            [[ "$1" == "-px" ]] && { text_position_x="$2"; shift 2; }
        text_position_y=0 && \
            [[ "$1" == "-py" ]] && { text_position_y="$2"; shift 2; }
        text_position_gravity="northwest" && \
            [[ "$1" == "-pg" ]] && { text_position_gravity="$2"; shift 2; }
        if [ "$1" == "-ox" ]; then
            pos_x=$((text_position_x_all + $2))
            shift 2
        fi
        if [ "$1" == "-oy" ]; then
            pos_y=$((pos_y + $2))
            shift 2
        fi

        [[ "$1" == "-sw" ]] && { text_stroke_width=$2; shift 2; }
        [[ "$1" == "-sc" ]] && { text_stroke_color="$2"; shift 2; }
        [[ "$1" == "-sf" ]] && { text_stroke_fade=$2; shift 2; }
        [[ "$1" == "-sh" ]] && { text_shadow_percent=$2; shift 2; }
        [[ "$1" == "-shc" ]] && { text_shadow_color="$2"; shift 2; }
        [[ "$1" == "-sho" ]] && { text_shadow_offset="$2"; shift 2; }

        # Always compute the next y position
        # except when absolute x,y position is specified
        compute_next=1
    done

    unset text_transparent_color
    if [ "$1" == "-transparent" ]; then
        shift 1
        [[ "$1" == "-c" ]] && { text_transparent_color="$2"; shift 2; }
        text_transparent_fuzz=0
        [[ "$1" == "-f" ]] && { text_transparent_fuzz=$2; shift 2; }
        if [ -z ${text_transparent_color+x} ]; then
            echo_err "Missing -transparent argument (color)."
            exit 1
        fi
    fi

    unset text_rotate_angle
    if [ "$1" == "-rotate" ]; then
        shift 1
        [[ "$1" == "-a" ]] && { text_rotate_angle=$2; shift 2; }
        if [ -z ${text_rotate_angle+x} ]; then
            echo_err "Missing -rotate argument (angle)."
            exit 1
        fi
    fi

    echo_debug "Text:"
    echo_debug "  Width (all): $text_width_all"
    echo_debug "  Position X (all): $text_position_x_all"
    echo_debug "  Position Y (all): $text_position_y_all"
    echo_debug "  Text: $text_string"
    echo_debug "  Font: $text_font"
    echo_debug "  Size: $text_size"
    echo_debug "  Color: $text_color"
    echo_debug "  Background color: $text_background_color"
    echo_debug "  Gravity: $text_gravity"
    echo_debug "  Inter-line spacing: $text_interline_spacing"
    echo_debug "  Width: $text_width"
    echo_debug "  Position: $text_position_x x $text_position_y"
    echo_debug "  Gravity: $text_position_gravity"
    echo_debug "  Stroke width: $text_stroke_width"
    echo_debug "  Stroke color: $text_stroke_color"
    echo_debug "  Stroke fade: $text_stroke_fade"
    echo_debug "  Shadow: $text_shadow_percent"
    echo_debug "  Shadow color: $text_shadow_color"
    echo_debug "  Shadow offset: $text_shadow_offset"
    echo_debug "  Rotate: $text_rotate_angle"
    echo_debug "  Transparent: $text_transparent_color"
    echo_debug "  Fuzz: $text_transparent_fuzz"

    if [[ -n "$text_string" ]]; then
        if [[ $text_stroke_width -gt 0 && $text_shadow_percent -eq 0 ]]; then
            convert                                                 \
                -background $text_background_color                  \
                -size ${text_width}x                                \
                -font $text_font                                    \
                -pointsize $text_size                               \
                -gravity $text_gravity                              \
                -interline-spacing $text_interline_spacing          \
                -fill $text_color                                   \
                -bordercolor $text_background_color                 \
                -border $text_stroke_width                          \
                caption:"$text_string"                              \
                \( +clone                                           \
                    -background $text_stroke_color                  \
                    -shadow 100x${text_stroke_width}+0+0            \
                    -channel A                                      \
                    -level 0%,${text_stroke_fade}%                  \
                    +channel \)                                     \
                +swap                                               \
                +repage                                             \
                -gravity center                                     \
                -composite                                          \
                int_text.png
        fi

        if [[ $text_stroke_width -eq 0 && $text_shadow_percent -gt 0 ]]; then
            convert                                                     \
                -background $text_background_color                      \
                -size ${text_width}x                                    \
                -font "$text_font"                                      \
                -pointsize "$text_size"                                 \
                -gravity "$text_gravity"                                \
                -interline-spacing "$text_interline_spacing"            \
                -fill "$text_color"                                     \
                -bordercolor $text_background_color                     \
                -border $text_stroke_width                              \
                caption:"$text_string"                                  \
                \( +clone                                               \
                    -background "$text_shadow_color"                    \
                    -shadow ${text_shadow_percent}x2+2+2                \
                     -channel A                                         \
                     -level 0,50%                                       \
                     +channel \)                                        \
                -geometry -${text_shadow_offset}-${text_shadow_offset}  \
                +swap                                                   \
                +repage                                                 \
                -gravity center                                         \
                -composite                                              \
                int_text.png
        fi

        if [[ $text_stroke_width -gt 0 && $text_shadow_percent -gt 0 ]]; then
            echo "--------------------------------------------------"
            echo "Error: Text stroke with shadow is not implemented."
            echo "--------------------------------------------------"
        fi

        if [[ $text_stroke_width -eq 0 && $text_shadow_percent -eq 0 ]]; then
            convert                                                 \
                -background $text_background_color                  \
                -size ${text_width}x                                \
                -font "$text_font"                                  \
                -pointsize "$text_size"                             \
                -gravity "$text_gravity"                            \
                -interline-spacing "$text_interline_spacing"        \
                -fill "$text_color"                                 \
                caption:"$text_string"                              \
                int_text.png
        fi

        if [[ -n ${text_rotate_angle+x} ]]; then
            mogrify                         \
                -background 'rgba(0,0,0,0)' \
                -rotate $text_rotate_angle  \
                int_text.png
        fi

        if [[ -n ${text_transparent_color+x} ]]; then
            mogrify                                     \
                -median 2                               \
                -fuzz ${text_transparent_fuzz}%         \
                -transparent $text_transparent_color    \
                int_text.png
        fi

        if [ $debug -gt 0 ]; then
            text_count=$((text_count + 1))
            cp -f int_text.png "int_text_${text_count}.png"
        fi

        if [[ $text_position_x -gt 0 || $text_position_y -gt 0 ]]; then
            convert                                                 \
                int_text.png                                        \
                -trim                                               \
                int_text.png
            convert                                                 \
                $OUTPUT_FILE                                        \
                int_text.png                                        \
                -gravity $text_position_gravity                     \
                -geometry +${text_position_x}+${text_position_y}    \
                -composite                                          \
                $OUTPUT_FILE
            compute_next=0
        else
            convert                                 \
                $OUTPUT_FILE                        \
                int_text.png                        \
                -geometry +${pos_x}+${pos_y}        \
                -composite                          \
                $OUTPUT_FILE
        fi

        # Compute next y position
        if [[ $compute_next -eq 1 ]]; then
            temp_height=`convert int_text.png -ping -format "%h" info:`
            pos_y=$((pos_y + temp_height))
        fi
    fi # if -n $text_string
done # --text

if [ "$1" == "--author" ]; then
    shift 1
    author_name="" && [[ "$1" == "-a" ]] && { author_name="$2"; shift 2; }
    description="" && [[ "$1" == "-d" ]] && { description="$2"; shift 2; }
    author_color=black && [[ "$1" == "-c" ]] && { author_color="$2"; shift 2; }

    echo_debug "Author"
    echo_debug "  Name: $author_name"
    echo_debug "  Description: $description"
    echo_debug "  Color: $author_color"

    convert                                 \
        -background none                    \
        -size "$canvas_width"x              \
        -font "Roboto-Condensed-Bold"       \
        -pointsize  15                      \
        -gravity west                       \
        -fill "$author_color"               \
        caption:"$author_name"              \
        png:-                               \
    | convert                               \
        $OUTPUT_FILE                        \
        -                                   \
        -gravity southwest                  \
        -geometry +12+24                    \
        -composite                          \
        $OUTPUT_FILE

    convert                                 \
        -background none                    \
        -size "$canvas_width"x              \
        -font "Roboto-Condensed"            \
        -pointsize 14                       \
        -gravity west                       \
        -fill "$author_color"               \
        caption:"$description"              \
        png:-                               \
    | convert                               \
        $OUTPUT_FILE                        \
        -                                   \
        -gravity southwest                  \
        -geometry +12+7                     \
        -composite                          \
        $OUTPUT_FILE
fi # --author

done

if [ "$1" == "--output" ]; then
    cp -f $OUTPUT_FILE "$2"
fi

if [ "$1" == "--add-info" ]; then
    shift 1
    if hash exiftool 2>/dev/null; then
        exiftool -q -XMP-dc:Creator="Duterte Legionnaire" $OUTPUT_FILE
        exiftool -q -xmp-dc:description="Test description" $OUTPUT_FILE
        exiftool -q -xmp-dc:source="Arguments:$commandline_arguments" $OUTPUT_FILE

        rm -f "${OUTPUT_FILE}_original"

        echo "--------"
        echo "ExifTool"
        echo "--------"
        exiftool "$OUTPUT_FILE"
    else
        echo "Missing: ExifTool"
    fi
fi

echo "Done."

exit 0
