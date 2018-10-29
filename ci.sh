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
declare -i -r CANVAS_SQUARE_BIGGER=8
declare -i -r CANVAS_SQUARE_LARGE=9
declare -i -r CANVAS_TALL=10
declare -i -r CANVAS_TALLER=11
declare -i -r CANVAS_TOWER=12

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

    get_canvas_width "$CANVAS_SQUARE_BIGGER"
    get_canvas_height "$CANVAS_SQUARE_BIGGER"
    local -r dimension_square_bigger="${width_temp}x${height_temp}"

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
    echo "                                          default       ${dimension_default}"
    echo "                                          big           ${dimension_big}"
    echo "                                          bigger        ${dimension_bigger}"
    echo "                                          large         ${dimension_large}"
    echo "                                          huge          ${dimension_huge}"
    echo "                                          square        ${dimension_square}"
    echo "                                          square-big    ${dimension_square_big}"
    echo "                                          square-bigger ${dimension_square_bigger}"
    echo "                                          square-large  ${dimension_square_large}"
    echo "                                          tall          ${dimension_tall_large}"
    echo "                                          taller        ${dimension_taller_large}"
    echo "                                          tower         ${dimension_tower_large}"
    echo "    [-c <color>]                        canvas color"
    echo "    [-gc <color> <color>]               first and second gradient color"
    echo "    [-cs <color string>]                color string (ex. \"red yellow 33 blue 66 red\")"
    echo "    [-gr <rotation>]                    rotation (0-360), 0=south, default is 0"
    echo "                                          or to-top, to-right, to-bottom, to-left, to-topright,"
    echo "                                          to-bottomright, to-bottomleft or to-topleft"
    echo "  --image                             Define image properties"
    echo "    <filename>                          image file"
    echo "    [-g <gravity>]                      where the image position gravitates to"
    echo "    [-op <position>]                     offset position relative to gravity"
    echo "    [-q <percentage>]                   opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-blur                              blur image"
    echo "      <-simple> |                         simple blurring"
    echo "      [-r <radius>]                       radius, default is 0"
    echo "      <-s <sigma>>]                       sigma, default is 4"
    echo "    [-border                            draw border"
    echo "        <color>                           color"
    echo "        <[-w <pixels>] |                   width in pixels, default is 3"
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
    echo "      [-poly                              right/left diagonal"
    echo "        <-nw <x position>>                   northwest x position"
    echo "        <-sw <x position>>]                  southwest x position"
    echo "        <-ne <x position>>                   northeast x position"
    echo "        <-se <x position>>]                  southeast x position"
    echo "    [-flip]                             flip image horizontally"
    echo "    [-gradient                          transparent gradient"
    #echo "      [-d <dimension>]                    width and height in pixels, defaults to canvas width and height"
    echo "      [-w <width>]                        width in pixels, defaults to canvas width"
    echo "      [-h <height>]                       height in pixels, defaults to canvas height"
    echo "      <-c <color> |                       first and second gradient color, [color to none]"
    echo "       -cs <color string>>                color string (ex. \"red yellow 33 blue 66 red\")"
    echo "      [-r <rotation>]                     rotation (0-360), 0=south, default is 0"
    echo "                                            or to-top, to-right, to-bottom, to-left, to-topright,"
    echo "                                            to-bottomright, to-bottomleft or to-topleft"
    echo "      [-q <percentage> |                  opaqueness, default is 50, 100=opaque, 0=transparent"
    echo "       -m]]                               use as mask, white is opaque, black is transparent"
    echo "    [-mask]                             make the image as a mask"
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
    echo "  --gradient                          Gradient color"
    echo "    [-g <gravity>]                      gravity, default is northwest"
    echo "    [-p <position>]                     position relative to gravity, defaults to +0+0"
    echo "    [-horizontal <height>]              full width with specified height"
    echo "    [-bottom <height>]                  full width with specified height, gravity is south"
    echo "    [-w <width>]                        width in pixels, defaults to canvas width"
    echo "    [-h <height>]                       height in pixels, defaults to canvas height"
    echo "    [-bc <color>]                       background color, default is black"
    echo "    <-c <color> <color> |               first and second gradient color, [color to none]"
    echo "     -cs <color string>>                color string (ex. \"red yellow 33 blue 66 red\")"
    echo "     [-r <rotation>]                    rotation (0-360), 0=south, default is 0"
    echo "                                          or to-top, to-right, to-bottom, to-left, to-topright,"
    echo "                                          to-bottomright, to-bottomleft or to-topleft"
    echo "     [-q <percentage> |                 opaqueness, default is 50, 100=opaque, 0=transparent"
    echo "      -m]                               use as mask, white is opaque, black is transparent"
    echo "  --rectangle                         Define rectangular area"
    echo "    [-g <gravity>]                      gravity, default is northwest"
    echo "    [-p <position>]                     position relative to gravity, defaults to +0+0"
    echo "    [-r <pixels>]                       rounded corner diameter, default is 0"
    echo "    [-horizontal <height>]              full width with specified height"
    echo "    [-bottom <height>]                  full width with specified height, gravity is south"
    echo "    [-w <width>]                        width in pixels, defaults to canvas width"
    echo "    [-h <height>]                       height in pixels, defaults to canvas height"
    echo "    [-c <color>]                        fill color or first gradient color"
    echo "    [-q <percentage>]                   opaqueness, default is 100, 100=opaque, 0=transparent"
#    echo "    [-gradient                          gradient color"
#    echo "      [-gc <color> <color>]               first and second gradient color"
#    echo "      [-cs <color string>]                color string (ex. \"red yellow 33 blue 66 red\")"
#    echo "      [-gr <rotation>]]                   rotation (0-360), 0=south, default is 0"
#    echo "                                            or to-top, to-right, to-bottom, to-left, to-topright,"
#    echo "                                            to-bottomright, to-bottomleft or to-topleft"
    echo "    [-o <filename>]                     output image filename"
    echo "  --poly                              Define four-sided polygon"
    echo "    [-c <color>]                        fill color"
    echo "    [-q <perentage>]                    opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-nw <x position>]                  northwest x position"
    echo "    [-sw <x position>]                  southwest x position"
    echo "    [-ne <x position>]                  northeast x position"
    echo "    [-se <x position>]                  southeast x position"
    echo "  --circle                              Define a circle"
    echo "    [-x <position>]                       x position"
    echo "    [-y <position>]                       y position"
    echo "    [-r <pixels>]                         radius in pixels"
    echo "    [-d <pixels>]                         diameter in pixels"
    echo "    [-c <color>]                          fill color"
    echo "    [-q <perentage>]                      opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-sw <pixels>]                        stroke width in pixels"
    echo "    [-sc <color>]                         stroke color"
    echo "  --logo                              Define logo properties"
    echo "    [-f <file>]                         image file to use"
    echo "    [-c <color>]                        color"
    echo "    [-s <size>]                         size in pixels, default is 30x30"
    echo "    [-ox <x position>]                  x position, defaults to 11"
    echo "    [-oy <y position>]                  y position, defaults to 9"
    echo "    [-g <gravity>]                      gravity, defaults to southeast"
    echo "    [-l <text>]                         optional label before logo"
    echo "  --text                              Define text properties"
    echo "    [-W <width>]                        Global text area width"
    echo "    [-Wo <width>]                       Offset, value is subtracted from W"
    echo "    [-Ho <height>]                      Offset, value is subtracted from H"
    echo "    [-Px <x position>]                  Global x position"
    echo "    [-Py <y position>]                  Global y position"
    echo "    [-t <text>]                         text"
    echo "    [-f <font>]                         font"
    echo "    [-s <point size>]                   font size"
    echo "    [-c <color>]                        text color"
    echo "    [-bc <color>]                       background color"
    echo "    [-g <gravity>]                      gravity"
    echo "    [-k <kerning>]                      inter-character spacing"
    echo "    [-iw <inter-word spacing>]          inter-word spacing"
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
    echo "    [-shc <color>]                      shadow color, default is black"
    echo "    [-sho <pixels>]                     shadow offset in pixels, default is 3"
    echo "    [-rotate <angle>]                   rotate text by the specified angle"
    echo "  --author                            Define author text"
    echo "    -a <name>                            author name"
    echo "    -d <description>                     description text"
    echo "  --add-info                          Add Exif information"
    echo "                                        query Exif information like:"
    echo "                                          exiftool <file>"
    echo "  "
    echo "Font Family:"
    echo "  font-default                            Roboto"
    echo "  font-default-light                      Roboto-Light"
    echo "  font-default-medium                     Roboto-Medium"
    echo "  font-default-bold                       Roboto-Bold"
    echo "  font-default-black                      Roboto-Black"
    echo "  font-default-thin                       Roboto-Thin"
    echo "  font-default-condensed                  Roboto-Condensed"
    echo "  font-default-condensed-light            Roboto-Condensed-Light"
    echo "  font-default-condensed-bold             Roboto-Condensed-Bold"
    echo "  font-sans                               Open-Sans-Regular"
    echo "  font-sans-light                         Open-Sans-Light"
    echo "  font-sans-semibold                      Open-Sans-SemiBold"
    echo "  font-sans-bold                          Open-Sans-Bold"
    echo "  font-sans-extrabold                     Open-Sans-ExtraBold"
    echo "  font-sans-condensed-light               Open-Sans-Condensed-Light"
    echo "  font-sans-condensed-bold                Open-Sans-Condensed-Bold"
    echo "  font-sans-1                             Encode-Sans-Regular"
    echo "  font-sans-1-thin                        Encode-Sans-Thin"
    echo "  font-sans-1-light                       Encode-Sans-Light"
    echo "  font-sans-1-extralight                  Encode-Sans-ExtraLight"
    echo "  font-sans-1-medium                      Encode-Sans-Medium"
    echo "  font-sans-1-semibold                    Encode-Sans-Semibold"
    echo "  font-sans-1-bold                        Encode-Sans-Bold"
    echo "  font-sans-1-extabold                    Encode-Sans-ExtraBold"
    echo "  font-sans-1-black                       Encode-Sans-Black"
    echo "  font-sans-1-condensed                   Encode-Sans-Condensed-Regular"
    echo "  font-sans-1-condensed-thin              Encode-Sans-Condensed-Thin"
    echo "  font-sans-1-condensed-light             Encode-Sans-Condensed-Light"
    echo "  font-sans-1-condensed-extralight        Encode-Sans-Condensed-ExtraLight"
    echo "  font-sans-1-condensed-medium            Encode-Sans-Condensed-Medium"
    echo "  font-sans-1-condensed-semibold          Encode-Sans-Condensed-Semibold"
    echo "  font-sans-1-condensed-bold              Encode-Sans-Condensed-Bold"
    echo "  font-sans-1-condensed-extabold          Encode-Sans-Condensed-ExtraBold"
    echo "  font-sans-1-condensed-black             Encode-Sans-Condensed-Black"
    echo "  font-sans-1-semicondensed               Encode-Sans-SemiCondensed-Regular"
    echo "  font-sans-1-semicondensed-thin          Encode-Sans-SemiCondensed-Thin"
    echo "  font-sans-1-semicondensed-light         Encode-Sans-SemiCondensed-Light"
    echo "  font-sans-1-semicondensed-extralight    Encode-Sans-SemiCondensed-ExtraLight"
    echo "  font-sans-1-semicondensed-medium        Encode-Sans-SemiCondensed-Medium"
    echo "  font-sans-1-semicondensed-semibold      Encode-Sans-SemiCondensed-Semibold"
    echo "  font-sans-1-semicondensed-bold          Encode-Sans-SemiCondensed-Bold"
    echo "  font-sans-1-semicondensed-extabold      Encode-Sans-SemiCondensed-ExtraBold"
    echo "  font-sans-1-semicondensed-black         Encode-Sans-SemiCondensed-Black"
    echo "  font-sans-1-expanded                    Encode-Sans-Expanded-Regular"
    echo "  font-sans-1-expanded-thin               Encode-Sans-Expanded-Thin"
    echo "  font-sans-1-expanded-light              Encode-Sans-Expanded-Light"
    echo "  font-sans-1-expanded-extralight         Encode-Sans-Expanded-ExtraLight"
    echo "  font-sans-1-expanded-medium             Encode-Sans-Expanded-Medium"
    echo "  font-sans-1-expanded-semibold           Encode-Sans-Expanded-Semibold"
    echo "  font-sans-1-expanded-bold               Encode-Sans-Expanded-Bold"
    echo "  font-sans-1-expanded-extabold           Encode-Sans-Expanded-ExtraBold"
    echo "  font-sans-1-expanded-black              Encode-Sans-Expanded-Black"
    echo "  font-sans-1-semiexpanded                Encode-Sans-SemiExpanded-Regular"
    echo "  font-sans-1-semiexpanded-thin           Encode-Sans-SemiExpanded-Thin"
    echo "  font-sans-1-semiexpanded-light          Encode-Sans-SemiExpanded-Light"
    echo "  font-sans-1-semiexpanded-extralight     Encode-Sans-SemiExpanded-ExtraLight"
    echo "  font-sans-1-semiexpanded-medium         Encode-Sans-SemiExpanded-Medium"
    echo "  font-sans-1-semiexpanded-semibold       Encode-Sans-SemiExpanded-Semibold"
    echo "  font-sans-1-semiexpanded-bold           Encode-Sans-SemiExpanded-Bold"
    echo "  font-sans-1-semiexpanded-extabold       Encode-Sans-SemiExpanded-ExtraBold"
    echo "  font-sans-1-semiexpanded-black          Encode-Sans-SemiExpanded-Black"
    echo "  font-sans-2                             Poppins-Regular"
    echo "  font-sans-2-thin                        Poppins-Thin"
    echo "  font-sans-2-light                       Poppins-Light"
    echo "  font-sans-2-extralight                  Poppins-ExtraLight"
    echo "  font-sans-2-medium                      Poppins-Medium"
    echo "  font-sans-2-semibold                    Poppins-SemiBold"
    echo "  font-sans-2-bold                        Poppins-Bold"
    echo "  font-sans-2-extrabold                   Poppins-ExtraBold"
    echo "  font-sans-2-black                       Poppins-Black"
    echo "  font-sans-3                             Share-Regular"
    echo "  font-sans-3-bold                        Share-Bold"
    echo "  font-serif                              Merriweather-Regular"
    echo "  font-serif-light                        Merriweather-Light"
    echo "  font-serif-bold                         Merriweather-Bold"
    echo "  font-serif-black                        Merriweather-Black"
    echo "  font-serif-1                            Cormorant-Regular"
    echo "  font-serif-1-light                      Cormorant-Light"
    echo "  font-serif-1-medium                     Cormorant-Medium"
    echo "  font-serif-1-semibold                   Cormorant-Semibold"
    echo "  font-serif-1-bold                       Cormorant-Bold"
    echo "  font-serif-2                            GTSectraFine-Regular"
    echo "  font-serif-2-medium                     GTSectraFine-Medium"
    echo "  font-serif-2-bold                       GTSectraFine-Bold"
    echo "  font-serif-2-black                      GTSectraFine-Black"
    echo "  font-serif-3                            Calluna-Regular"
    echo "  font-serif-3-bold                       Calluna-Bold"
    echo "  font-mono                               RM-Courier-Regular"
    echo "  font-mono-vt323                         VT323-Regular"
    echo "  font-mono-fixedsys                      Fixedsys-Excelsior"
    echo "  font-mono-ocr                           OCR-A-Extended"
    echo "  font-typewriter                         F25Executive"
    echo "  font-typewriter-thin                    ELEGANT-TYPEWRITER"
    echo "  font-typewriter-1                       Underwood-Champion"
    echo "  font-typewriter-2                       Sears-Tower"
    echo "  font-typewriter-3                       Rough_Typewriter"
    echo "  font-comic                              DigitalStrip"
    echo "  font-comic-1                            SmackAttack-BB"
    echo "  font-comic-2                            Year-supply-of-fairy-cakes"
    echo "  font-comic-3                            Komika-Title---Axis"
    echo "  font-comic-4                            BadaBoom-BB"
    echo "  font-comic-5                            Bangers"
    echo "  font-comic-6                            Yikes!"
    echo "  font-comic-7                            Mouse-Memoirs"
    echo "  font-comic-8                            GROBOLD"
    echo "  font-comic-9                            Helsinki"
    echo "  font-display                            Coda-ExtraBold"
    echo "  font-display-1                          Muli-Black"
    echo "  font-display-2                          Chonburi"
    echo "  font-dirty                              Dirty-Headline"
    echo "  font-dirty-1                            DCC-Ash"
    echo "  font-dirty-2                            DCC-SharpDistressBlack"
    echo "  font-dirty-3                            Dark-Underground"
    echo "  font-dirty-4                            Boycott"
    echo "  font-dirty-5                            Iron-&-Brine"
    echo "  font-dirty-6                            A-Love-of-Thunder"
    echo "  font-brush                              Edo-SZ"
    echo "  font-brush-1                            Yenoh-Brush"
    echo "  font-brush-2                            ProtestPaint-BB"
    echo "  font-brush-2-italic                     ProtestPaint-BB-Italic"
    echo "  font-horror                             YouMurdererBB"
    echo "  font-horror-1                           FaceYourFears"
    echo "  font-horror-2                           Something-Strange"
    echo "  font-horror-3                           Gallow-Tree-Free (Italic)"
    echo "  font-old                                OldNewspaperTypes"
    echo "  font-old-1                              1543HumaneJenson-Normal"
    echo "  font-old-1-bold                         1543HumaneJenson-Bold"
    echo "  font-acme                               Acme"
    echo "  font-averia                             Averia-Libre-Regular"
    echo "  font-averia-bold                        Averia-Libre-Bold"
    echo "  font-scratch                            Scratch"
    echo "  font-something                          Something-in-the-air"
    echo "  font-<font name>                        use \`convert -list font\` to check font names"
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
    declare -r WIDTH_SQUARE=588
    declare -r WIDTH_SQUARE_BIG=734
    declare -r WIDTH_SQUARE_BIGGER=819
    declare -r WIDTH_SQUARE_LARGE=1176
    declare -r WIDTH_TALL=640           # iphone 4: 640/960 = 0.666
    declare -r WIDTH_TALLER=720
    declare -r WIDTH_TOWER=800

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
        $CANVAS_SQUARE_BIGGER)  width_temp=$WIDTH_SQUARE_BIGGER ;;
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
    declare -r HEIGHT_SQUARE=588
    declare -r HEIGHT_SQUARE_BIG=734
    declare -r HEIGHT_SQUARE_BIGGER=819
    declare -r HEIGHT_SQUARE_LARGE=1176
    declare -r HEIGHT_TALL=960
    declare -r HEIGHT_TALLER=1080
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
        $CANVAS_SQUARE_BIGGER)  height_temp=$HEIGHT_SQUARE_BIGGER ;;
        $CANVAS_SQUARE_LARGE)   height_temp=$HEIGHT_SQUARE_LARGE ;;
        $CANVAS_TALL)           height_temp=$HEIGHT_TALL ;;
        $CANVAS_TALLER)         height_temp=$HEIGHT_TALLER ;;
        $CANVAS_TOWER)          height_temp=$HEIGHT_TOWER ;;
        *)                      height_temp=0 ;;
    esac
    return 0
}



# Return the corresponding logo width or height of the specified canvas
function get_logo_dimension {
    declare -r WH_DEFAULT=15
    declare -r WH_BIG=20
    declare -r WH_BIGGER=25
    declare -r WH_LARGE=30
    declare -r WH_HUGE=35
    declare -r WH_SQUARE=15
    declare -r WH_SQUARE_BIG=20
    declare -r WH_SQUARE_BIGGER=25
    declare -r WH_SQUARE_LARGE=30
    declare -r WH_TALL=30
    declare -r WH_TALLER=35
    declare -r WH_TOWER=40

    [[ $# -eq 0 ]] \
        && { echo_err "get_logo_dimension parameter not found."; return 1; }
    case "$1" in
        $CANVAS_DEFAULT)        dim_temp=$WH_DEFAULT ;;
        $CANVAS_BIG)            dim_temp=$WH_BIG ;;
        $CANVAS_BIGGER)         dim_temp=$WH_BIGGER ;;
        $CANVAS_LARGE)          dim_temp=$WH_LARGE ;;
        $CANVAS_HUGE)           dim_temp=$WH_HUGE ;;
        $CANVAS_SQUARE)         dim_temp=$WH_SQUARE ;;
        $CANVAS_SQUARE_BIG)     dim_temp=$WH_SQUARE_BIG ;;
        $CANVAS_SQUARE_BIGGER)  dim_temp=$WH_SQUARE_BIGGER ;;
        $CANVAS_SQUARE_LARGE)   dim_temp=$WH_SQUARE_LARGE ;;
        $CANVAS_TALL)           dim_temp=$WH_TALL ;;
        $CANVAS_TALLER)         dim_temp=$WH_TALLER ;;
        $CANVAS_TOWER)          dim_temp=$WH_TOWER ;;
        *)                      dim_temp=0 ;;
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
        default)                            font_temp="Roboto" ;;
        default-light)                      font_temp="Roboto-Light" ;;
        default-medium)                     font_temp="Roboto-Medium" ;;
        default-bold)                       font_temp="Roboto-Bold" ;;
        default-black)                      font_temp="Roboto-Black" ;;
        default-thin)                       font_temp="Roboto-Thin" ;;
        default-condensed)                  font_temp="Roboto-Condensed" ;;
        default-condensed-light)            font_temp="Roboto-Condensed-Light" ;;
        default-condensed-bold)             font_temp="Roboto-Condensed-Bold" ;;
        sans)                               font_temp="Open-Sans-Regular" ;;
        sans-light)                         font_temp="Open-Sans-Light" ;;
        sans-semibold)                      font_temp="Open-Sans-SemiBold" ;;
        sans-bold)                          font_temp="Open-Sans-Bold" ;;
        sans-extrabold)                     font_temp="Open-Sans-ExtraBold" ;;
        sans-condensed-light)               font_temp="Open-Sans-Condensed-Light" ;;
        sans-condensed-bold)                font_temp="Open-Sans-Condensed-Bold" ;;
        sans-1)                             font_temp="Encode-Sans-Regular" ;;
        sans-1-thin)                        font_temp="Encode-Sans-Thin" ;;
        sans-1-light)                       font_temp="Encode-Sans-Light" ;;
        sans-1-extralight)                  font_temp="Encode-Sans-ExtraLight" ;;
        sans-1-medium)                      font_temp="Encode-Sans-Medium" ;;
        sans-1-semibold)                    font_temp="Encode-Sans-Semibold" ;;
        sans-1-bold)                        font_temp="Encode-Sans-Bold" ;;
        sans-1-extrabold)                   font_temp="Encode-Sans-ExtraBold" ;;
        sans-1-black)                       font_temp="Encode-Sans-Black" ;;
        sans-1-condensed)                   font_temp="Encode-Sans-Condensed-Regular" ;;
        sans-1-condensed-thin)              font_temp="Encode-Sans-Condensed-Thin" ;;
        sans-1-condensed-light)             font_temp="Encode-Sans-Condensed-Light" ;;
        sans-1-condensed-extralight)        font_temp="Encode-Sans-Condensed-ExtraLight" ;;
        sans-1-condensed-medium)            font_temp="Encode-Sans-Condensed-Medium" ;;
        sans-1-condensed-semibold)          font_temp="Encode-Sans-Condensed-Semibold" ;;
        sans-1-condensed-bold)              font_temp="Encode-Sans-Condensed-Bold" ;;
        sans-1-condensed-extrabold)         font_temp="Encode-Sans-Condensed-ExtraBold" ;;
        sans-1-condensed-black)             font_temp="Encode-Sans-Condensed-Black" ;;
        sans-1-semicondensed)               font_temp="Encode-Sans-SemiCondensed-Regular" ;;
        sans-1-semicondensed-thin)          font_temp="Encode-Sans-SemiCondensed-Thin" ;;
        sans-1-semicondensed-light)         font_temp="Encode-Sans-SemiCondensed-Light" ;;
        sans-1-semicondensed-extralight)    font_temp="Encode-Sans-SemiCondensed-ExtraLight" ;;
        sans-1-semicondensed-medium)        font_temp="Encode-Sans-SemiCondensed-Medium" ;;
        sans-1-semicondensed-semibold)      font_temp="Encode-Sans-SemiCondensed-Semibold" ;;
        sans-1-semicondensed-bold)          font_temp="Encode-Sans-SemiCondensed-Bold" ;;
        sans-1-semicondensed-extrabold)     font_temp="Encode-Sans-SemiCondensed-ExtraBold" ;;
        sans-1-semicondensed-black)         font_temp="Encode-Sans-SemiCondensed-Black" ;;
        sans-1-expanded)                    font_temp="Encode-Sans-Expanded-Regular" ;;
        sans-1-expanded-thin)               font_temp="Encode-Sans-Expanded-Thin" ;;
        sans-1-expanded-light)              font_temp="Encode-Sans-Expanded-Light" ;;
        sans-1-expanded-extralight)         font_temp="Encode-Sans-Expanded-ExtraLight" ;;
        sans-1-expanded-medium)             font_temp="Encode-Sans-Expanded-Medium" ;;
        sans-1-expanded-semibold)           font_temp="Encode-Sans-Expanded-Semibold" ;;
        sans-1-expanded-bold)               font_temp="Encode-Sans-Expanded-Bold" ;;
        sans-1-expanded-extrabold)          font_temp="Encode-Sans-Expanded-ExtraBold" ;;
        sans-1-expanded-black)              font_temp="Encode-Sans-Expanded-Black" ;;
        sans-1-semiexpanded)                font_temp="Encode-Sans-SemiExpanded-Regular" ;;
        sans-1-semiexpanded-thin)           font_temp="Encode-Sans-SemiExpanded-Thin" ;;
        sans-1-semiexpanded-light)          font_temp="Encode-Sans-SemiExpanded-Light" ;;
        sans-1-semiexpanded-extralight)     font_temp="Encode-Sans-SemiExpanded-ExtraLight" ;;
        sans-1-semiexpanded-medium)         font_temp="Encode-Sans-SemiExpanded-Medium" ;;
        sans-1-semiexpanded-semibold)       font_temp="Encode-Sans-SemiExpanded-Semibold" ;;
        sans-1-semiexpanded-bold)           font_temp="Encode-Sans-SemiExpanded-Bold" ;;
        sans-1-semiexpanded-extrabold)      font_temp="Encode-Sans-SemiExpanded-ExtraBold" ;;
        sans-1-semiexpanded-black)          font_temp="Encode-Sans-SemiExpanded-Black" ;;
        sans-2)                             font_temp="Poppins-Regular" ;;
        sans-2-thin)                        font_temp="Poppins-Thin" ;;
        sans-2-light)                       font_temp="Poppins-Light" ;;
        sans-2-extralight)                  font_temp="Poppins-ExtraLight" ;;
        sans-2-medium)                      font_temp="Poppins-Medium" ;;
        sans-2-semibold)                    font_temp="Poppins-SemiBold" ;;
        sans-2-bold)                        font_temp="Poppins-Bold" ;;
        sans-2-extrabold)                   font_temp="Poppins-ExtraBold" ;;
        sans-2-black)                       font_temp="Poppins-Black" ;;
        sans-3)                             font_temp="Share-Regular" ;;
        sans-3-bold)                        font_temp="Share-Bold" ;;
        serif)                              font_temp="Merriweather-Regular" ;;
        serif-light)                        font_temp="Merriweather-Light" ;;
        serif-bold)                         font_temp="Merriweather-Bold" ;;
        serif-black)                        font_temp="Merriweather-Black" ;;
        serif-1)                            font_temp="Cormorant-Regular" ;;
        serif-1-light)                      font_temp="Cormorant-Light" ;;
        serif-1-medium)                     font_temp="Cormorant-Medium" ;;
        serif-1-semibold)                   font_temp="Cormorant-Semibold" ;;
        serif-1-bold)                       font_temp="Cormorant-Bold" ;;
        serif-2)                            font_temp="GTSectraFine-Regular" ;;
        serif-2-medium)                     font_temp="GTSectraFine-Medium" ;;
        serif-2-bold)                       font_temp="GTSectraFine-Bold" ;;
        serif-2-black)                      font_temp="GTSectraFine-Black" ;;
        serif-3)                            font_temp="Calluna-Regular" ;;
        serif-3-bold)                       font_temp="Calluna-Bold" ;;
        mono)                               font_temp="RM-Courier-Regular" ;;
        mono-vt323)                         font_temp="VT323-Regular" ;;
        mono-fixedsys)                      font_temp="Fixedsys-Excelsior-3.01" ;;
        mono-ocr)                           font_temp="OCR-A-Extended" ;;
        typewriter)                         font_temp="F25Executive" ;;
        typewriter-thin)                    font_temp="ELEGANT-TYPEWRITER" ;;
        typewriter-1)                       font_temp="Underwood-Champion" ;;
        typewriter-2)                       font_temp="Sears-Tower" ;;
        typewriter-3)                       font_temp="Rough_Typewriter" ;;
        comic)                              font_temp="DigitalStrip" ;;
        comic-1)                            font_temp="SmackAttack-BB" ;;
        comic-2)                            font_temp="Year-supply-of-fairy-cakes" ;;
        comic-3)                            font_temp="Komika-Title---Axis" ;;
        comic-4)                            font_temp="BadaBoom-BB" ;;
        comic-5)                            font_temp="Bangers" ;;
        comic-6)                            font_temp="Yikes!" ;;
        comic-7)                            font_temp="Mouse-Memoirs" ;;
        comic-8)                            font_temp="GROBOLD" ;;
        comic-9)                            font_temp="Helsinki" ;;
        display)                            font_temp="Coda-ExtraBold" ;;
        display-1)                          font_temp="Muli-Black" ;;
        display-2)                          font_temp="Chonburi" ;;
        dirty)                              font_temp="Dirty-Headline" ;;
        dirty-1)                            font_temp="DCC-Ash" ;;
        dirty-2)                            font_temp="DCC-SharpDistressBlack" ;;
        dirty-3)                            font_temp="Dark-Underground" ;;
        dirty-4)                            font_temp="Boycott" ;;
        dirty-5)                            font_temp="Iron-&-Brine" ;;
        dirty-6)                            font_temp="A-Love-of-Thunder" ;;
        brush)                              font_temp="Edo-SZ" ;;
        brush-1)                            font_temp="Yenoh-Brush" ;;
        brush-2)                            font_temp="ProtestPaint-BB" ;;
        brush-2-italic)                     font_temp="ProtestPaint-BB-Italic" ;;
        horror)                             font_temp="YouMurdererBB" ;;
        horror-1)                           font_temp="FaceYourFears" ;;
        horror-2)                           font_temp="Something-Strange" ;;
        horror-3)                           font_temp="Gallow-Tree-Free" ;;
        old)                                font_temp="OldNewspaperTypes" ;;
        old-1)                              font_temp="1543HumaneJenson-Normal" ;;
        old-1-bold)                         font_temp="1543HumaneJenson-Bold" ;;
        acme)                               font_temp="Acme" ;;
        averia)                             font_temp="Averia-Libre-Regular" ;;
        averia-bold)                        font_temp="Averia-Libre-Bold" ;;
        scratch)                            font_temp="Scratch" ;;
        something)                          font_temp="Something-in-the-air" ;;
        *)                                  font_temp="$font"
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
    [[ "$1" == "-q" ]]  && { arg_opaqueness=$2; shift 2; }
    [[ "$1" == "-o" ]]  && { arg_output="$2"; shift 2; }

    echo_debug "Create Rectangle:"
    echo_debug "  Size: ${arg_size}"
    echo_debug "  Color: ${arg_color}"
    echo_debug "  Opaqueness: ${arg_opaqueness}"
    echo_debug "  Output: ${arg_output}"

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
#   dimension
#   width
#   height
#   rotation
#   color1
#   color2
#   color string
#   output file
function create_gradient {
    local arg_width=0
    local arg_height=0
    local arg_rotation=0
    local arg_color_1=""
    local arg_color_2=""
    local arg_color_string=""
    local arg_output=""

    local dimension=""

    [[ "$1" == "-d" ]]  && { dimension="$2"; shift 2; }
    [[ "$1" == "-dw" ]] && { arg_width=$2; shift 2; }
    [[ "$1" == "-dh" ]] && { arg_height=$2; shift 2; }
    unset arg_rotation
    [[ "$1" == "-r" ]] && { arg_rotation=$2; shift 2; }
    unset arg_color_1
    unset arg_color_2
    [[ "$1" == "-c1" ]] && { arg_color_1="$2"; shift 2; }
    [[ "$1" == "-c2" ]] && { arg_color_2="$2"; shift 2; }
    arg_color_string=""
    [[ "$1" == "-cs" ]] && { arg_color_string="$2"; shift 2; }
    [[ "$1" == "-o" ]]  && { arg_output="$2"; shift 2; }

    if [[ -z ${arg_color_string} ]]; then
        arg_color_string="$arg_color_1 $arg_color_2"
        if [[ "$arg_rotation" == @("northsouth"|"eastwest") ]]; then
            if [ "$arg_rotation" == "northsouth" ]; then
                arg_rotation=0
            elif [ "$arg_rotation" == "eastwest" ]; then
                arg_rotation=90
            fi
            arg_color_string="$arg_color_1 $arg_color_2 50 $arg_color_1"
        fi
    fi

    echo_debug "Create Gradient:"
    echo_debug "  Dimension: ${dimension}"
    echo_debug "  Width: ${arg_width}"
    echo_debug "  Height: ${arg_height}"
    echo_debug "  Rotation: ${arg_rotation}"
    echo_debug "  Color: $arg_color_1 $arg_color_2"
    echo_debug "  Color string: ${arg_color_string}"
    echo_debug "  Output file: $arg_output"

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

    [[ "$1" == "-i" ]] && { arg_image="$2"; shift 2; }
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



# Resize the specified image
#
# Arguments:
#   -i image file
#   -o output image file
#   -s size
#   -a adjustment
function resize_image {
    local arg_input_file=""
    local arg_output_file=""
    local arg_size
    local arg_adjustment=">"

    [[ "$1" == "-i" ]] && { arg_input_file="$2"; shift 2; }
    [[ "$1" == "-o" ]] && { arg_output_file="$2"; shift 2; }
    [[ "$1" == "-s" ]] && { arg_size="$2"; shift 2; }

    if [[ "$1" == "-a"  && -n "$2" ]]; then
        arg_adjustment="$2"
        shift 2
    fi

    # Size/dimension adjustment is appended
    local image_dimension="${arg_size}${arg_adjustment}"

    echo_debug "Resize image:"
    echo_debug "  Size: $arg_size"
    echo_debug "  Adjustment: $arg_adjustment"
    echo_debug "  Dimension: $image_dimension"

    convert                         \
        -background none            \
        $arg_input_file             \
        -resize "$image_dimension"  \
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
            \( +clone -flip \) -compose multiply -composite \
            \( +clone -flop \) -compose multiply -composite \
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
canvas_gradient_color_1=""
canvas_gradient_color_2=""
canvas_gradient_color_string=""
canvas_gradient_rotation=0

if [ "$1" == "--canvas" ]; then
    shift 1
    if [[ ! "$1" == @("default"|"big"|"bigger"|"large"|"huge"|"square"|"square-big"|"square-bigger"|"square-large"|"tall"|"taller"|"tower") ]]; then
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
        square-bigger) canvas="$CANVAS_SQUARE_BIGGER" ;;
        square-large)  canvas="$CANVAS_SQUARE_LARGE" ;;
        tall)          canvas="$CANVAS_TALL" ;;
        taller)        canvas="$CANVAS_TALLER" ;;
        tower)         canvas="$CANVAS_TOWER" ;;
    esac
    shift 1
    [[ "$1" == "-c" ]] && { canvas_color="$2"; shift 2; }
    [[ "$1" == "-gc" ]] && { canvas_gradient_color_1="$2"; canvas_gradient_color_2="$3"; shift 3; }
    [[ "$1" == "-cs" ]] && { canvas_gradient_color_string="$2"; shift 2; }
    [[ "$1" == "-gr" ]] && { canvas_gradient_rotation=$2; shift 2; }
else
    canvas="$CANVAS_DEFAULT"
fi # --canvas

get_canvas_width "$canvas"
get_canvas_height "$canvas"

canvas_width="$width_temp"
canvas_height="$height_temp"

echo_debug "Canvas"
echo_debug "  Size: $canvas"
echo_debug "  Dimension: ${canvas_width}x${canvas_height}"
echo_debug "  Width: $canvas_width"
echo_debug "  Height: $canvas_height"
echo_debug "  Color: $canvas_color"
echo_debug "  Gradient color: $canvas_gradient_color_1 $canvas_gradient_color_2"
echo_debug "  Gradient color string: $canvas_gradient_color_string"
echo_debug "  Gradient rotation: $canvas_gradient_rotation"

if [[ -n "$canvas_gradient_color_1" || -n "$canvas_gradient_color_string" ]]; then
    create_gradient                         \
        -dw $canvas_width                   \
        -dh $canvas_height                  \
        -r  $canvas_gradient_rotation       \
        -c1 $canvas_gradient_color_1        \
        -c2 $canvas_gradient_color_2        \
        -cs "$canvas_gradient_color_string" \
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
      [[ "$1" == @("--image"|"--gradient"|"--rectangle"|"--poly"|"--circle"|"--logo"|"--text"|"--author") ]]; do

while [ "$1" == "--image" ]; do
    shift 1
    if [[ ! -f "$1" ]]; then
        echo_err "Cannot find image file '$1'"
        exit 1
    fi
    image_file="$1"
    shift 1
    image_gravity="northwest"
    [[ "$1" == "-g" ]] && { image_gravity="$2"; shift 2; }
    image_offset_position="+0+0"
    [[ "$1" == "-op" ]] && { image_offset_position="$2"; shift 2; }
    image_opaqueness=100
    [[ "$1" == "-q" ]] && { image_opaqueness="$2"; shift 2; }
    image_output_file=""
    [[ "$1" == "-o" ]] && { image_output_file="$2"; shift 2; }

    echo_debug "Image:"
    echo_debug "  File: $image_file"
    echo_debug "  Dimension (w/ adj.): $image_dimension"
    echo_debug "  Gravity: $image_gravity"
    echo_debug "  Offset: $image_offset_position"
    echo_debug "  Output file: $image_output_file"

    # Make a copy of the image file into our directory
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

                        if [ $debug -eq 1 ]; then
                            image_width=`convert int_image.png -ping -format '%w' info:`
                            image_height=`convert int_image.png -ping -format '%h' info:`

                            echo_debug "    New width: $image_width"
                            echo_debug "    New height: $image_height"
                        fi
                    fi
                done
            elif [ "$1" == "-poly" ]; then
                shift 1

                image_width=`convert int_image.png -ping -format '%w' info:`
                image_height=`convert int_image.png -ping -format '%h' info:`

                cut_northwest_x=0
                cut_southwest_x=0
                cut_northeast_x=$image_width
                cut_southeast_x=$image_width
                [[ "$1" == "-nw" ]] && { cut_northwest_x=$2; shift 2; }
                [[ "$1" == "-sw" ]] && { cut_southwest_x=$2; shift 2; }
                [[ "$1" == "-ne" ]] && { cut_northeast_x=$2; shift 2; }
                [[ "$1" == "-se" ]] && { cut_southeast_x=$2; shift 2; }

                echo_debug "  Cut (left diagonal):"
                echo_debug "    Dimension: ${image_width}x${image_height}"
                echo_debug "    NorthWest X: $cut_northwest_x"
                echo_debug "    SouthWest X: $cut_southwest_x"
                echo_debug "    NorthEast X: $cut_northeast_x"
                echo_debug "    SouthEast X: $cut_southeast_x"

                # polygon starts at the top left
                convert                                     \
                    -size ${image_width}x${image_height}    \
                    xc:black                                \
                    -fill white                             \
                    -draw "polygon $cut_northwest_x,0 $cut_southwest_x,$image_height $cut_southeast_x,$image_height $cut_northeast_x,0" \
                    png:-                                   \
                | convert                                   \
                    int_image.png                           \
                    -                                       \
                    -alpha off                              \
                    -compose copyopacity                    \
                    -composite int_image.png
            fi
        elif [ "$1" == "-flip" ]; then
            shift 1
            echo_debug "  Flip: true"
            convert                                 \
                int_image.png                       \
                -flop                               \
                int_image.png
        elif [ "$1" == "-gradient" ]; then
            shift 1
            image_gradient_width=`convert int_image.png -ping -format '%w' info:`
            image_gradient_height=`convert int_image.png -ping -format '%h' info:`
            [[ "$1" == "-w" ]] && { image_gradient_width=$2; shift 2; }
            [[ "$1" == "-h" ]] && { image_gradient_height=$2; shift 2; }
            image_gradient_color_1="black"
            image_gradient_color_2="white"
            [[ "$1" == "-c" ]] && \
                { image_gradient_color_1="$2"; image_gradient_color_2="$3"; shift 3; }
            image_gradient_color_string=""
            [[ "$1" == "-cs" ]] && { image_gradient_color_string="$2"; shift 2; }
            image_gradient_rotation=0
            [[ "$1" == "-r" ]] && { image_gradient_rotation=$2; shift 2; }
            image_gradient_opaqueness=50
            [[ "$1" == "-q" ]] && { image_gradient_opaqueness=$2; shift 2; }
            image_gradient_mask=0
            [[ "$1" == "-m" ]] && { image_gradient_mask=1; shift 1; }

            echo_debug "  Gradient"
            echo_debug "    Width: $image_gradient_width"
            echo_debug "    Height: $image_gradient_height"
            echo_debug "    2 Color: $image_gradient_color_1 $image_gradient_color_2"
            echo_debug "    Color string: $image_gradient_color_string"
            echo_debug "    Rotation: $image_gradient_rotation"
            echo_debug "    Opaqueness: $image_gradient_opaqueness"
            echo_debug "    Mask: $image_gradient_mask"

            create_gradient                         \
                -dw $image_gradient_width           \
                -dh $image_gradient_height          \
                -r  $image_gradient_rotation        \
                -c1 $image_gradient_color_1         \
                -c2 $image_gradient_color_2         \
                -cs "$image_gradient_color_string"  \
                -o  int_gradient.png

            if [ $image_gradient_mask -eq 1 ]; then
                apply_mask                      \
                    -i int_image.png            \
                    -m int_gradient.png         \
                    -o int_image.png
            else
                composite                                       \
                    -dissolve ${image_gradient_opaqueness}x100  \
                    int_gradient.png                            \
                    int_image.png                               \
                    -alpha set                                  \
                    `#-gravity north`                           \
                    `#-geometry +0+0`                           \
                    int_image.png
            fi
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
            image_resize_dimension="${canvas_width}x${canvas_height}"
            [[ "$1" == "-s" ]] && { image_resize_dimension="$2"; shift 2; }
            image_resize_dimension_offset=0
            [[ "$1" == "-o" ]] && { image_resize_dimension_offset=$2; shift 2; }
            image_resize_adjustment=""
            [[ "$1" == "-a" ]] && { image_resize_adjustment="$2"; shift 2; }

            if [ $image_resize_dimension_offset -ne 0 ]; then
                image_resize_width=$((canvas_width + image_resize_dimension_offset))
                image_resize_height=$((canvas_height + image_resize_dimension_offset))
                image_resize_dimension="${image_resize_width}x${image_resize_height}"
            fi

            resize_image                    \
                -i int_image.png            \
                -o int_image.png            \
                -s $image_resize_dimension  \
                -a $image_resize_adjustment
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

    if [ -z "$image_output_file" ]; then
        image_output_file="$OUTPUT_FILE"
    fi

    composite                               \
        -dissolve ${image_opaqueness}x100   \
        int_image.png                       \
        $OUTPUT_FILE                        \
        -alpha set                          \
        -gravity $image_gravity             \
        -geometry $image_offset_position    \
        $image_output_file

done # --image

if [ "$1" == "--tint" ]; then
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

    echo_debug "Tint:"
    echo_debug "  Color: $tint_color"
    echo_debug "  Amount: $tint_amount"
    echo_debug "  Red: $tint_red"
    echo_debug "  Green: $tint_green"
    echo_debug "  Blue: $tint_blue"
    echo_debug "  Brightness: $tint_brightness"
    echo_debug "  Contrast: $tint_contrast"
    echo_debug "  Mode: $tint_mode"

    if [ $tint_use_rgb -eq 1 ]; then
        ./graytoning            \
            -r $tint_red        \
            -g $tint_green      \
            -b $tint_blue       \
            -t $tint_color      \
            -a $tint_amount     \
            $OUTPUT_FILE        \
            $OUTPUT_FILE
    else
        ./graytoning            \
            -o $tint_brightness \
            -c $tint_contrast   \
            -t $tint_color      \
            -m $tint_mode       \
            -a $tint_amount     \
            $OUTPUT_FILE        \
            $OUTPUT_FILE
    fi
fi # --tint

if [ "$1" == "--gradient" ]; then
    shift 1
    image_gradient_gravity="northwest"
    image_gradient_position="+0+0"

    image_gradient_width=$canvas_width
    image_gradient_height=$canvas_height

    [[ "$1" == "-g" ]] && { image_gradient_gravity="$2"; shift 2; }
    [[ "$1" == "-p" ]] && { image_gradient_position="$2"; shift 2; }

    if [[ "$1" == @("-horizontal"|"-bottom") ]]; then
        if [ "$1" == "-bottom" ]; then
            image_gradient_gravity="south"
        fi
        image_gradient_height=$2
        shift 2
    fi

    [[ "$1" == "-w" ]] && { image_gradient_width=$2; shift 2; }
    [[ "$1" == "-h" ]] && { image_gradient_height=$2; shift 2; }

    echo_debug "Gradient:"
    echo_debug "  Gravity: $image_gradient_gravity"
    echo_debug "  Position: $image_gradient_position"
    echo_debug "  Width: $image_gradient_width"
    echo_debug "  Height: $image_gradient_height"

    image_gradient_background_color="black"
    [[ "$1" == "-bc" ]] && { image_gradient_background_color="$2"; shift 2; }
    image_gradient_color_1="black"
    image_gradient_color_2="white"
    [[ "$1" == "-c" ]] && { image_gradient_color_1="$2"; image_gradient_color_2="$3"; shift 3; }
    unset image_gradient_color_string
    [[ "$1" == "-cs" ]] && { image_gradient_color_string="$2"; shift 2; }
    image_gradient_rotation=0
     [[ "$1" == "-r" ]] && { image_gradient_rotation=$2; shift 2; }
    image_gradient_opaqueness=50
    [[ "$1" == "-q" ]] && { image_gradient_opaqueness=$2; shift 2; }
    image_gradient_mask=0
    [[ "$1" == "-m" ]] && { image_gradient_mask=1; shift 1; }

    echo_debug "  Background color: $image_gradient_background_color"
    echo_debug "  2 Color: $image_gradient_color_1 $image_gradient_color_2"
    echo_debug "  Color string: $image_gradient_color_string"
    echo_debug "  Rotation: $image_gradient_rotation"
    echo_debug "  Opaqueness: $image_gradient_opaqueness"
    echo_debug "  Mask: $image_gradient_mask"

    create_gradient                         \
        -dw $image_gradient_width           \
        -dh $image_gradient_height          \
        -r  $image_gradient_rotation        \
        -c1 $image_gradient_color_1         \
        -c2 $image_gradient_color_2         \
        -cs "$image_gradient_color_string"  \
        -o  int_gradient.png

    if [ $image_gradient_mask -eq 1 ]; then
        apply_mask                                  \
            -i $OUTPUT_FILE                         \
            -m int_gradient.png                     \
            -o int_mask.png

        convert                                                     \
            -size ${image_gradient_width}x${image_gradient_height}  \
            xc:$image_gradient_background_color                     \
            png:-                                                   \
        | composite                                                 \
            int_mask.png                                            \
            -                                                       \
            -alpha set                                              \
            -gravity $image_gradient_gravity                        \
            -geometry $image_gradient_position                      \
            $OUTPUT_FILE

        if [ $debug -eq 0 ]; then
            rm -f int_mask.png
        fi
    else
        composite                                       \
            -dissolve ${image_gradient_opaqueness}x100  \
            int_gradient.png                            \
            $OUTPUT_FILE                                \
            -alpha set                                  \
            -gravity $image_gradient_gravity            \
            -geometry $image_gradient_position          \
            $OUTPUT_FILE
    fi

    if [ $debug -eq 0 ]; then
        rm -f int_gradient.png
    fi
fi # --gradient

while [ "$1" == "--rectangle" ]; do
    shift 1
    rect_gravity="northwest"
    rect_position="+0+0"

    rect_width=$canvas_width
    rect_height=$canvas_height
    rect_color="black"
    rect_opaqueness=100
    rect_round_corner_pixels=0

    rect_destination_file="$OUTPUT_FILE"

    [[ "$1" == "-g" ]] && { rect_gravity="$2"; shift 2; }
    [[ "$1" == "-p" ]] && { rect_position="$2"; shift 2; }
    [[ "$1" == "-r" ]] && { rect_round_corner_pixels=$2; shift 2; }

    echo_debug "Rectangle:"
    echo_debug "  Gravity: $rect_gravity"
    echo_debug "  Position: $rect_position"
    echo_debug "  Corner: $rect_round_corner_pixels"

    if [[ "$1" == @("-horizontal"|"-bottom") ]]; then
        rect_height=0
        rect_opaqueness=1000
        if [ "$1" == "-bottom" ]; then
            rect_gravity="south"
        fi
        rect_height=$2
        shift 2
    fi

    while [[ "$1" == @("-w"|"-h"|"-c"|"-q"|"-r") ]]; do
        [[ "$1" == "-w" ]] && { rect_width=$2; shift 2; }
        [[ "$1" == "-h" ]] && { rect_height=$2; shift 2; }
        [[ "$1" == "-c" ]] && { rect_color="$2"; shift 2; }
        [[ "$1" == "-q" ]] && { rect_opaqueness=$2; shift 2; }
    done

    echo_debug "  Width: $rect_width"
    echo_debug "  Height: $rect_height"
    echo_debug "  Color: $rect_color"
    echo_debug "  Opaqueness: $rect_opaqueness"

    if [ -n "$rect_color" ]; then
        create_rectangle                        \
            -s "${rect_width}x${rect_height}"   \
            -c $rect_color                      \
            -q $rect_opaqueness                 \
            -o int_rect.png
    else
        echo_err "No rectangle color specified."
    fi

    if [ $rect_round_corner_pixels -gt 0 ]; then
        round_corner                        \
            int_rect.png                    \
            $rect_round_corner_pixels       \
            int_rect.png
    fi

    [[ "$1" == "-o" ]] && { rect_destination_file="$2"; shift 2; }

    echo_debug "  Output file: $rect_destination_file"

    composite                               \
        -dissolve ${rect_opaqueness}x100    \
        int_rect.png                        \
        $OUTPUT_FILE                        \
        -alpha set                          \
        -gravity $rect_gravity              \
        -geometry $rect_position            \
        $rect_destination_file

    if [ $debug -eq 0 ]; then
        rm -f int_rect.png
    fi
done # --rectangle

while [ "$1" == "--poly" ]; do
    shift 1
    poly_northwest_x=0
    poly_southwest_x=0
    poly_northeast_x=$canvas_width
    poly_southeast_x=$canvas_width

    while [[ "$1" == @("-c"|"-q"|"-nw"|"-sw"|"ne"|"se") ]]; do
        [[ "$1" == "-c" ]] && { poly_color="$2"; shift 2; }
        [[ "$1" == "-q" ]] && { poly_opaqueness=$2; shift 2; }
        [[ "$1" == "-nw" ]] && { poly_northwest_x=$2; shift 2; }
        [[ "$1" == "-sw" ]] && { poly_southwest_x=$2; shift 2; }
        [[ "$1" == "-ne" ]] && { poly_northeast_x=$2; shift 2; }
        [[ "$1" == "-se" ]] && { poly_southeast_x=$2; shift 2; }
    done

    echo_debug "  Polygon (4-sides):"
    echo_debug "    Dimension: ${canvas_width}x${canvas_height}"
    echo_debug "    Color: $poly_color"
    echo_debug "    Opaqueness: $poly_opaqueness"
    echo_debug "    NorthWest X: $poly_northwest_x"
    echo_debug "    SouthWest X: $poly_southwest_x"
    echo_debug "    NorthEast X: $poly_northeast_x"
    echo_debug "    SouthEast X: $poly_southeast_x"

    convert                                     \
        -size ${canvas_width}x${canvas_height}  \
        xc:none                                 \
        -alpha set                              \
        -channel A                              \
        -fill $poly_color                       \
        -draw "polygon $poly_northwest_x,0 $poly_southwest_x,$canvas_height $poly_southeast_x,$canvas_height $poly_northeast_x,0" \
        png:-                                   \
    | composite                                 \
        -dissolve ${poly_opaqueness}x100        \
        -                                       \
        $OUTPUT_FILE                            \
        $OUTPUT_FILE
done # --poly

while [ "$1" == "--circle" ]; do
    shift 1
    circle_x=0
    circle_y=0
    circle_radius=0
    circle_diameter=0
    circle_color="black"
    circle_stroke_width=0
    circle_stroke_color="none"
    circle_opaqueness=50

    while [[ "$1" == @("-x"|"-y"|"-r"|"-d"|"-c"|"-q"|"-sw"|"-sc") ]]; do
        [[ "$1" == "-x" ]] && { circle_x=$2; shift 2; }
        [[ "$1" == "-y" ]] && { circle_y=$2; shift 2; }
        [[ "$1" == "-r" ]] && { circle_radius=$2; shift 2; }
        [[ "$1" == "-d" ]] && { circle_diameter=$2; shift 2; }
        [[ "$1" == "-c" ]] && { circle_color="$2"; shift 2; }
        [[ "$1" == "-q" ]] && { circle_opaqueness=$2; shift 2; }
        [[ "$1" == "-sw" ]] && { circle_stroke_width=$2; shift 2; }
        [[ "$1" == "-sc" ]] && { circle_stroke_color="$2"; shift 2; }
    done

    if [ $circle_diameter -gt 0 ]; then
        circle_radius=$((circle_diameter / 2))
    fi

    circle_image_width=$((circle_radius + circle_radius + 5))
    center=$((circle_radius + 2))
    dest_y=$((circle_y - circle_radius))

    echo_debug "  Circle:"
    echo_debug "    Position: ${circle_x},${circle_y}"
    echo_debug "    Radius: $circle_radius"
    echo_debug "    Diameter: $circle_diameter"
    echo_debug "    Color: $circle_color"
    echo_debug "    Stroke width: $circle_stroke_width"
    echo_debug "    Stroke color: $circle_stroke_color"
    echo_debug "    Opaqueness: $circle_opaqueness"

    convert                                                 \
        -size ${circle_image_width}x${circle_image_width}   \
        xc:none                                             \
        `#-alpha set`                                       \
        `#-channel A`                                       \
        -stroke $circle_stroke_color                        \
        -fill $circle_color                                 \
        -strokewidth $circle_stroke_width                   \
        -draw "ellipse $center,$center $circle_radius,$circle_radius 0,360" \
        png:-                                               \
    | composite                                             \
        -dissolve ${circle_opaqueness}x100                  \
        -                                                   \
        $OUTPUT_FILE                                        \
        -gravity northwest                                  \
        -geometry +${circle_x}+${dest_y}                    \
        $OUTPUT_FILE
done # --circle

if [ "$1" == "--logo" ]; then
    shift 1
    image_logo="logo/logo_fist_2018.png" && \
        [[ "$1" == "-f" ]] && { image_logo="$2"; shift 2; }
    if [[ ! -f "$image_logo" ]]; then
        echo_err "Cannot find logo file '$image_logo'"
        exit 1
    fi

    logo_color="black" && \
        [[ "$1" == "-c" ]] && { logo_color="$2"; shift 2; }
    get_logo_dimension $canvas
    logo_dimension="${dim_temp}x${dim_temp}"
    logo_offset_x=$dim_temp
    logo_offset_y=$dim_temp
    [[ "$1" == "-s" ]] && { logo_dimension="$2"; shift 2; }
    [[ "$1" == "-ox" ]] && { logo_offset_x=$2; shift 2; }
    [[ "$1" == "-oy" ]] && { logo_offset_y=$2; shift 2; }
    logo_gravity="southeast" && \
        [[ "$1" == "-g" ]] && { logo_gravity="$2"; shift 2; }
    logo_label="" && \
        [[ "$1" == "-l" ]] && { logo_label="$2"; shift 2; }

    logo_offset=+${logo_offset_x}+${logo_offset_y}

    echo_debug "Logo:"
    echo_debug "  File: $image_logo"
    echo_debug "  Size: $logo_dimension"
    echo_debug "  Color: $logo_color"
    echo_debug "  Label: $logo_label"

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

text_width_all=$canvas_width
text_height_all=$canvas_height
text_position_x_all=0
text_position_y_all=0
next_y_pos=0

text_font="$FONT_DEFAULT"
text_size="15"
text_color="black"
text_background_color="none"
text_gravity="northwest"
text_kerning=0
text_interword_spacing=0
text_interline_spacing=0
text_width=$text_width_all
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
    [[ "$1" == "-W" ]] && { text_width_all=$2; shift 2; }
    [[ "$1" == "-Wo" ]] && { text_width_all=$(($canvas_width - ${2})); shift 2; }
    if [ "$1" == "-Ho" ]; then
        text_position_y_all=$((text_height_all - ${2}))
        pos_y=$text_position_y_all
        shift 2
    fi
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
    guide_show=0
    if [[ "$1" == "-guide" ]]; then
        guide_color="$2"
        shift 2
        guide_show=1
    fi

    if [ $guide_show -eq 1 ]; then
        create_rectangle                            \
            -s "${text_width_all}x${canvas_height}" \
            -c $guide_color                         \
            -q 50                                   \
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

    text_width=$text_width_all
    while [ $# -gt 0 ] && [[ "-t -f -s -c -bc -k -iw -i -g -w -px -py -pg -ox -oy -sw -sc -sf -sh -shc -sho" == *"$1"* ]]; do
        [[ "$1" == "-t" ]] && { text_string="$2"; shift 2; }
        if [ "$1" == "-f" ]; then
            get_font_family "$2"
            text_font="$font_temp"
            shift 2
        fi
        [[ "$1" == "-s" ]] && { text_size="$2"; shift 2; }
        [[ "$1" == "-c" ]] && { text_color="$2"; shift 2; }
        [[ "$1" == "-bc" ]] && { text_background_color="$2"; shift 2; }
        [[ "$1" == "-k" ]] && { text_kerning=$2; shift 2; }
        [[ "$1" == "-iw" ]] && { text_interword_spacing=$2; shift 2; }
        [[ "$1" == "-i" ]] && { text_interline_spacing="$2"; shift 2; }
        [[ "$1" == "-g" ]] && { text_gravity="$2"; shift 2; }
        [[ "$1" == "-w" ]] && { text_width=$2; shift 2; }

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
        text_rotate_angle=$2
        shift 2
        if [ -z ${text_rotate_angle+x} ]; then
            echo_err "Missing -rotate argument (angle)."
            exit 1
        fi
    fi

    if [[ -n "$text_string" ]]; then
        echo_debug "Text:"
        echo_debug "  Width (all): $text_width_all"
        echo_debug "  Position X (all): $text_position_x_all"
        echo_debug "  Position Y (all): $text_position_y_all"
        echo_debug "  Text: $text_string"
        echo_debug "  Font: $text_font"
        echo_debug "  Size: $text_size"
        echo_debug "  Color: $text_color"
        echo_debug "  Background color: $text_background_color"
        echo_debug "  Kerning: $text_kerning"
        echo_debug "  Inter-word spacing: $text_interword_spacing"
        echo_debug "  Inter-line spacing: $text_interline_spacing"
        echo_debug "  Gravity: $text_gravity"
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
    fi

    if [[ -n "$text_string" ]]; then
        if [[ $text_stroke_width -gt 0 && $text_shadow_percent -eq 0 ]]; then
            convert                                                 \
                -background $text_background_color                  \
                -size ${text_width}x                                \
                -font $text_font                                    \
                -pointsize $text_size                               \
                -gravity $text_gravity                              \
                -kerning $text_kerning                              \
                -interword-spacing $text_interword_spacing          \
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
                -kerning $text_kerning                                  \
                -interword-spacing $text_interword_spacing              \
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
                -kerning $text_kerning                              \
                -interword-spacing $text_interword_spacing          \
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
