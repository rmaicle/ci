#!/usr/bin/env bash

# Create image driver script

declare -r PROGRAM_NAME="${0##*/}"
# Define directory of 3rd party scripts;
# usually the same directory as this script.
declare -r PROGRAM_DIR="/mnt/work/imagemagick/ci"
declare -r FRED_DIR="/mnt/work/imagemagick/ci/fred"

declare LARGE_IMAGE_SUPPORT="-monitor -limit memory 2GiB -limit map 4GiB"

declare debug=0
declare debug_flag=""

declare -i -r CANVAS_CUSTOM=0
declare -i -r CANVAS_DEFAULT=1
declare -i -r CANVAS_BIG=2
declare -i -r CANVAS_BIGGER=3
declare -i -r CANVAS_LARGE=4
declare -i -r CANVAS_HUGE=5
declare -i -r CANVAS_SQUARE=6
declare -i -r CANVAS_SQUARE_BIG=7
declare -i -r CANVAS_SQUARE_BIGGER=8
declare -i -r CANVAS_SQUARE_LARGE=9
declare -i -r CANVAS_SQUARE_HUGE=10
declare -i -r CANVAS_TALL=11
declare -i -r CANVAS_TALLER=12
declare -i -r CANVAS_TOWER=13
declare -i -r CANVAS_WIDE=14
declare -i -r CANVAS_A_FOUR=15

declare -a -r CANVAS_SIZE_STRINGS=(
    "custom"
    "default"
    "big"
    "bigger"
    "large"
    "huge"
    "square"
    "square-big"
    "square-bigger"
    "square-large"
    "square-huge"
    "tall"
    "taller"
    "tower"
    "wide"
    "wide-big"
    "wide-bigger"
    "a-four"
)

# https://www.calculator.net/ratio-calculator.html
#
# Given:
# 16:9 resolutions: 1024×576, 1152×648, 1280×720, 1600×900, 1920×1080, 2560×1440, 3840×2160
# 8:9 resolutions: 512×576, 576×648, 640×720, 800×900, 960×1080, 1280×1440, 1920×2160
#
# Random initial numbers:
# 21:9 res: 864x370, 1080x463, 1296x555, 1512x648, 1728x740
# 24:9 res: 690x254, 863x318, 1035x381, 1208x445, 1380x508
# 54:13 res: 864x208, 1080x260, 1350x325, 1620x390
# 9:1 res: 648x72, 810x90, 972x108, 1134x126, 1296x144
# 6:1 res: 1284x214
#
# Old:
#     Width formula starts at 580.
#     Let 580 be n and the next number is x. Find out the next number.
#       x = (n / 4) + n
#       725 = (580 / 4) + 580
#
#      Note on tall, etc sizes:
#        Sizes are computed based on iphone 4 dimensions
#         640/960 = 0.666
#
#     Height formula starts at 580.
#     Use US calling card size ratio.
#       3.5" x 2"
#       ratio: w / h = 1.75
#         w / 1.75 = h
#         3.5 / 1.75 = 2
#     Let 580 be the width. Find out the height.
#       w / 1.75 = h
#       580 / 1.75 = 331.428571429
# card: 580x331, 725x414, 906x518, 1133x647, 1416x809
# square: 580x580, 725x725, 906x906, 1133x1133, 1416x1416
# vertical: 640x960, 720x1080, 800x1200
# wide: 574x148, 1910x434
# a-four: 794x1122



declare -A CANVAS_WIDTH
declare -A CANVAS_HEIGHT

CANVAS_WIDTH[default]=580
CANVAS_WIDTH[big]=725
CANVAS_WIDTH[bigger]=906
CANVAS_WIDTH[large]=1133
CANVAS_WIDTH[huge]=1416
CANVAS_WIDTH[square]=580
CANVAS_WIDTH[square-big]=725
CANVAS_WIDTH[square-bigger]=906
CANVAS_WIDTH[square-large]=1133
CANVAS_WIDTH[square-huge]=1416
CANVAS_WIDTH[tall]=640
CANVAS_WIDTH[taller]=720
CANVAS_WIDTH[tower]=800
# Wide sizes just found on twitter
CANVAS_WIDTH[wide]=864
CANVAS_WIDTH[wide-big]=1080
CANVAS_WIDTH[wide-bigger]=1350
# A4 is 8.27x1169 at 96 dpi
CANVAS_WIDTH[a-four]=794

CANVAS_HEIGHT[default]=331
CANVAS_HEIGHT[big]=414
CANVAS_HEIGHT[bigger]=518
CANVAS_HEIGHT[large]=647
CANVAS_HEIGHT[huge]=809
CANVAS_HEIGHT[square]=580
CANVAS_HEIGHT[square-big]=725
CANVAS_HEIGHT[square-bigger]=906
CANVAS_HEIGHT[square-large]=1133
CANVAS_HEIGHT[square-huge]=1416
CANVAS_HEIGHT[tall]=960
CANVAS_HEIGHT[taller]=1080
CANVAS_HEIGHT[tower]=1200
# Wide sizes just found in twitter
CANVAS_HEIGHT[wide]=208
CANVAS_HEIGHT[wide-big]=260
CANVAS_HEIGHT[wide-bigger]=325
# A4 is 8.27x1169 at 96 dpi
CANVAS_HEIGHT[a-four]=1122

declare -r OP_QUERY="--query"
declare -r OP_CANVAS="--canvas"
declare -r OP_IMAGE="--image"
declare -r OP_TEXT="--text"
declare -r OP_RECTANGLE="--rectangle"
declare -r OP_QUAD="--quad"
declare -r OP_ELLIPSE="--ellipse"
declare -r OP_GRID="--grid"
declare -r OP_SPLAT="--splat"
declare -r OP_LOGO="--logo"
declare -r OP_TRIM="--trim"
declare -r OP_CUSTOM="--custom"
declare -r OP_ADD_EXIF="--add-exif"
declare -r OP_STRIP_EXIF="--strip-exif"

declare -a -r MAJOR_OPERATIONS=(
    "${OP_QUERY}"
    "${OP_CANVAS}"
    "${OP_IMAGE}"
    "${OP_TEXT}"
    "${OP_RECTANGLE}"
    "${OP_QUAD}"
    "${OP_ELLIPSE}"
    "${OP_GRID}"
    "${OP_SPLAT}"
    "${OP_LOGO}"
    "${OP_TRIM}"
    "${OP_CUSTOM}"
    "${OP_ADD_EXIF}"
    "${OP_STRIP_EXIF}"
)

declare -r IMAGE_OP_ADJUST="-adjust"
declare -r IMAGE_OP_BLUR="-blur"
declare -r IMAGE_OP_BORDER="-border"
declare -r IMAGE_OP_CHOP="-chop"
declare -r IMAGE_OP_COLORIZE="-colorize"
declare -r IMAGE_OP_CONTRAST="-contrast"
declare -r IMAGE_OP_CONTRAST_SIGMOIDAL="-contrast-sig"
declare -r IMAGE_OP_CONVERT="-convert"
declare -r IMAGE_OP_CORNER="-corner"
declare -r IMAGE_OP_CROP="-crop"
declare -r IMAGE_OP_ELLIPSE_SELECT="-ellipse"
declare -r IMAGE_OP_FLIP="-flip"
declare -r IMAGE_OP_FLOP="-flop"
declare -r IMAGE_OP_GRADIENT="-gradient"
declare -r IMAGE_OP_GRAYSCALE="-grayscale"
declare -r IMAGE_OP_GRAYSCALE_SIGMOIDAL="-grayscale-sig"
declare -r IMAGE_OP_GRID="-grid"
declare -r IMAGE_OP_MODULATE="-modulate"
declare -r IMAGE_OP_RECOLOR="-recolor"
declare -r IMAGE_OP_RESIZE="-resize"
declare -r IMAGE_OP_RESIZE_DIM="-resize-dim"
declare -r IMAGE_OP_RESIZE_LAB="-resize-lab"
declare -r IMAGE_OP_ROTATE="-rotate"
declare -r IMAGE_OP_SHADE="-shade"
declare -r IMAGE_OP_SHADOW="-shadow"
declare -r IMAGE_OP_SHADOW_ADVANCE="-shadow-advance"
declare -r IMAGE_OP_SLICE="-slice"
declare -r IMAGE_OP_TINT="-tint"
declare -r IMAGE_OP_TRANSPARENT="-transparent"
declare -r IMAGE_OP_TRANSPOSE="-transpose"
declare -r IMAGE_OP_TRANSVERSE="-transverse"
declare -r IMAGE_OP_VIGNETTE="-vignette"

declare -r IMAGE_OP_MERGE="-merge"
declare -r IMAGE_OP_NOMERGE="-nomerge"

declare -a -r IMAGE_OPERATIONS=(
    "${IMAGE_OP_BLUR}"
    "${IMAGE_OP_BORDER}"
    "${IMAGE_OP_ADJUST}"
    "${IMAGE_OP_RECOLOR}"
    "${IMAGE_OP_COLORIZE}"
    "${IMAGE_OP_CONTRAST}"
    "${IMAGE_OP_CONTRAST_SIGMOIDAL}"
    "${IMAGE_OP_CONVERT}"
    "${IMAGE_OP_CORNER}"
    "${IMAGE_OP_CHOP}"
    "${IMAGE_OP_CROP}"
    "${IMAGE_OP_SLICE}"
    "${IMAGE_OP_ELLIPSE_SELECT}"
    "${IMAGE_OP_FLIP}"
    "${IMAGE_OP_FLOP}"
    "${IMAGE_OP_GRADIENT}"
    "${IMAGE_OP_GRAYSCALE}"
    "${IMAGE_OP_GRAYSCALE_SIGMOIDAL}"
    "${IMAGE_OP_GRID}"
    "${IMAGE_OP_MODULATE}"
    "${IMAGE_OP_MERGE}"
    "${IMAGE_OP_NOMERGE}"
    "${IMAGE_OP_RESIZE}"
    "${IMAGE_OP_RESIZE_DIM}"
    "${IMAGE_OP_RESIZE_LAB}"
    "${IMAGE_OP_ROTATE}"
    "${IMAGE_OP_SHADE}"
    "${IMAGE_OP_SHADOW}"
    "${IMAGE_OP_SHADOW_ADVANCE}"
    "${IMAGE_OP_TINT}"
    "${IMAGE_OP_TRANSPARENT}"
    "${IMAGE_OP_TRANSPOSE}"
    "${IMAGE_OP_TRANSVERSE}"
    "${IMAGE_OP_VIGNETTE}"
)

declare -A LOGO_WIDTH
LOGO_WIDTH[custom]=30
LOGO_WIDTH[default]=15
LOGO_WIDTH[big]=20
LOGO_WIDTH[bigger]=30
LOGO_WIDTH[large]=35
LOGO_WIDTH[huge]=40
LOGO_WIDTH[square]=15
LOGO_WIDTH[square-big]=20
LOGO_WIDTH[square-bigger]=30
LOGO_WIDTH[square-large]=35
LOGO_WIDTH[square-huge]=40
LOGO_WIDTH[tall]=30
LOGO_WIDTH[taller]=35
LOGO_WIDTH[tower]=40
LOGO_WIDTH[wide]=30
LOGO_WIDTH[wide-big]=30
LOGO_WIDTH[wide-bigger]=30
LOGO_WIDTH[a-four]=30



declare -r DEFAULT_DPI=96
declare -r DEFAULT_DEPTH=8
declare -r TEXT_FILE="int_text.png"
declare -r RECTANGLE_FILE="int_rectangle.png"
declare -r QUAD_FILE="int_quad.png"
declare -r ELLIPSE_FILE="int_ellipse.png"
declare -r LOGO_FILE="int_logo.png"

declare -r WORK_FILE="int_work.png"
declare -r OUTPUT_FILE="out_0.png"



function show_usage {
    echo "$PROGRAM_NAME - Create an image."
    echo ""
    echo "Usage: $PROGRAM_NAME [options] [image operations]"
    echo ""
    echo "Options:"
    echo "  --help                       Show usage"
    echo "  --debug                      Debug mode"
    echo ""
    echo "  --query                      Query information"
    echo "    [canvas-width size]          Echo width in pixels of given canvas size, see below"
    echo "    [canvas-height size]         Echo height in pixels of given canvas size, see below"
    echo "    [logo-width size]            Echo logo width in pixels of given canvas size, see below"
    echo "    [logo-x size]                Echo half of logo width in pixels of given canvas size, see below"
    echo ""
    echo "  --canvas size                Define pre-defined canvas 'size'"
    echo "                                 default          ${CANVAS_WIDTH[default]}x${CANVAS_HEIGHT[default]}"
    echo "                                 big              ${CANVAS_WIDTH[big]}x${CANVAS_HEIGHT[big]}"
    echo "                                 bigger           ${CANVAS_WIDTH[bigger]}x${CANVAS_HEIGHT[bigger]}"
    echo "                                 large            ${CANVAS_WIDTH[large]}x${CANVAS_HEIGHT[large]}"
    echo "                                 huge             ${CANVAS_WIDTH[huge]}x${CANVAS_HEIGHT[huge]}"
    echo "                                 square           ${CANVAS_WIDTH[square]}x${CANVAS_HEIGHT[square]}"
    echo "                                 square-big       ${CANVAS_WIDTH[square-big]}x${CANVAS_HEIGHT[square-big]}"
    echo "                                 square-bigger    ${CANVAS_WIDTH[square-bigger]}x${CANVAS_HEIGHT[square-bigger]}"
    echo "                                 square-large     ${CANVAS_WIDTH[square-large]}x${CANVAS_HEIGHT[square-large]}"
    echo "                                 square-huge      ${CANVAS_WIDTH[square-huge]}x${CANVAS_HEIGHT[square-huge]}"
    echo "                                 tall             ${CANVAS_WIDTH[tall]}x${CANVAS_HEIGHT[tall]}"
    echo "                                 taller           ${CANVAS_WIDTH[taller]}x${CANVAS_HEIGHT[taller]}"
    echo "                                 tower            ${CANVAS_WIDTH[tower]}x${CANVAS_HEIGHT[tower]}"
    echo "                                 wide             ${CANVAS_WIDTH[wide]}x${CANVAS_HEIGHT[wide]}"
    echo "                                 extra-wide       ${CANVAS_WIDTH[extra-wide]}x${CANVAS_HEIGHT[extra-wide]}"
    echo "                                 a-four           ${CANVAS_WIDTH[a-four]}x${CANVAS_HEIGHT[a-four]}"
    echo "                                 custom           requires -w and -h to be specified"
    echo "    [-d dpi]                     Density in dots per inch, default is ${DEFAULT_DPI} DPI;"
    echo "                                   possible values: 300, 600"
    echo "    [-b bits]                    Number of bits per pixel; default is ${DEFAULT_DEPTH}"
    echo "    [-w width]                   Canvas width in pixels"
    echo "    [-h height]                  Canvas height in pixels"
    echo "    [-i file]                    Set canvas dimensions equal to some image file"
    echo "                                   overrides -w and -h options"
    echo "    [-c color]                   Canvas fill color; default is white"
    echo "    [-o file]                    Write output to file"
    echo ""
    echo "  --image input                Use image"
    echo "                                 Input could be a file or one of these values:"
    echo "                                   canvas"
    echo "                                   rectangle"
    echo "                                   quad"
    echo "                                   ellipse"
    echo "                                   text"
    echo ""
    echo "  --text                       Create text"
    echo "    text                         Text"
    echo "    [-quote]                     Enclose text between quotation marks"
    echo "    [-w width]                   Text area width; default is canvas width"
    echo "    [-h height]                  Text area height; default is 0"
    echo "    [-ow pixels]                 Offset width in pixels added to width; default is 0"
    echo "    [-oh pixels]                 Offset height in pixels added to height; default is 0,"
    echo "    [-f font]                    Font"
    echo "    [-s pointsize]               Font size; default is 15"
    echo "    [-c color]                   Text color; default is black"
    echo "    [-b color]                   Background color; default is none"
    echo "    [-g gravity]                 Gravity; default is northwest"
    echo "    [-k kerning]                 Inter-character spacing; default is 0"
    echo "    [-t tracking]                Inter-word spacing; default is 0"
    echo "    [-l leading]                 Inter-line spacing; default is 0"
    echo "    [-sw width]                  Stroke width in pixels, visually acceptable values >= 3;"
    echo "                                   default is 0"
    echo "    [-sc color]                  Stroke color; default is none"
    echo "    [-so geoposition]            Stroke offset to center filled areas; default is +1+1"
    echo "    [-notrim]                    Do not trim text area; default is trim"
    echo "    [-o file]                    Write output to file; default is ${TEXT_FILE}"
    echo ""
    echo "  --rectangle                  Draw rectangle"
    echo "    [-w width]                   Width in pixels; default is canvas width"
    echo "    [-h height]                  Height in pixels; default is canvas height"
    echo "    [-r radius]                  x,y corner radius in pixels; default is 0,0"
    echo "    [-c color]                   Fill color; default is black"
    echo "    [-sw width]                  Stroke width in pixels; default is 0"
    echo "    [-sc color]                  Stroke color; default is none"
    echo "    [-o file]                    Write output to file; default is ${RECTANGLE_FILE}"
    echo ""
    echo "  --quad                       Draw a quadrilateral polygon"
    echo "    [-ul position]               Upper left x,y position; default is 0,0"
    echo "    [-ll position]               Lower left x,y position; default is 0,canvas-height"
    echo "    [-ur position]               Upper right x,y position; default is canvas-width,0"
    echo "    [-lr position]               Lower right x,y position; default is canvas-width,canvas-height"
    echo "    [-c color]                   Fill color; default is black"
    echo "    [-sw width]                  Stroke width in pixels; default is 0"
    echo "    [-sc color]                  Stroke color; default is none"
    echo "    [-o file]                    Write output to file; default is ${QUAD_FILE}"
    echo ""
    echo "  --ellipse                    Draw an ellipse"
    echo "    [-w width]                   Width in pixels; default is half width"
    echo "    [-h height]                  Height in pixels; default is half height"
    echo "    [-r radius]                  Circle radius in pixels; default is half height"
    echo "    [-c color]                   Fill color; default is black"
    echo "    [-sc width]                  Stroke width in pixels; default is 0"
    echo "    [-sc color]                  Stroke color; default is none"
    echo "    [-o file]                    Write output to file; default is ${ELLIPSE_FILE}"
    echo ""
    echo "  --grid pixels color          Draw grid with pixels width/height using color"
    echo ""
    echo "  --splat                      Draw blood splats"
    echo "    text                         Text"
    echo "    [-s pointsize]               Font size; default is 500"
    echo "    [-c color]                   Text color; default is black"
    echo "    [-b color]                   Background color; default is none"
    echo ""
    echo "  --logo input                 Draw logo image"
    echo "    [-w width]                   Width in pixels, height is automatically scaled;"
    echo "                                   default is canvas size dependent"
    echo "    [-p x y]                     Offset x and y positions relative to gravity"
    echo "    [-x xposition]               X position relative to gravity; default is 1/3 image width"
    echo "    [-y yposition]               Y position relative to gravity; default is 1/3 image width + 1"
    echo "    [-g gravity]                 Gravity; default is southeast"
    echo "    [-c color]                   Fill color; default is black"
    echo ""
    echo "  --trim                       Trim image"
    echo "    [-w width]                   Width in pixels"
    echo "    [-h height]                  Height in pixels"
    echo ""
    echo "  --custom                     Pass a custom command without the output destination"
    echo "                                 specification. The following is an example of such"
    echo "                                 command assigned to a variable which is passed to"
    echo "                                 this script."
    echo "                                   rectangle=\"convert -size 100x60 xc:none"
    echo "                                              -fill white -stroke black"
    echo "                                              -draw \\\"rectangle 5,10 15,50\\\"\""
    echo "                                 The variable 'rectangle' is passed like:"
    echo "                                   --custom \"\${rectangle}\" -merge -p 100 100 "
    echo "  --add-exif                   Add Exif information"
    echo "                                 query Exif information like: exiftool <file>"
    echo ""
    echo "  Image operations:"
    echo ""
    echo "  --convert                    Convert RGB colorspace to sRGB"
    echo ""
    echo "  -resize                      Resize image"
    echo "    [-lab]                       Use LAB colorspace"
    echo "    [-w]                         Width in pixels; default is canvas width"
    echo "    [-h]                         Height in pixels; default is canvas height"
    echo "    [-ow]                        Offset width in pixels added to width; default is 0"
    echo "    [-oh]                        Offset height in pixels added to height; default is 0"
    echo "    [-s]                         Scale (fill | shrink | enlarge) base on dimension;"
    echo "                                   default is fill"
    echo "  -resize-dim                  Resize image dimension"
    echo "    [-w]                         Width in pixels; default is canvas width"
    echo "    [-h]                         Height in pixels; default is canvas height"
    echo "    [-ow]                        Image offset width in pixels; argument is"
    echo "                                 added/subtracted to the image width"
    echo "    [-oh]                        Image offset height in pixels; argument is"
    echo "                                 added/subtracted to the image height"
    echo "    [-cow]                       Canvas offset width in pixels; argument is"
    echo "                                 added/subtracted to the canvas width"
    echo "    [-coh]                       Canvas offset height in pixels; argument is"
    echo "                                 added/subtracted to the canvas height"
    echo "  -flip                        Reflect the image vertically"
    echo "  -flop                        Reflect the image horizontally"
    echo "  -transpose                   Reflect the image along the top-left to bottom-right diagonal"
    echo "  -transverse                  Reflect the image along the bottom-left to top-right diagonal"
    echo "  -rotate angle                Rotate image,"
    echo "                                 positive value rotates clockwise,"
    echo "                                 negative value rotates counter-clockwise"
    echo "  -chop                        Chop off side from an image"
    echo "    [north pixels]               North x pixels"
    echo "    [south pixels]               South x pixels"
    echo "    [east pixels]                East x pixels"
    echo "    [west pixels]                West x pixels"
    echo "  -crop                        Cut rectangular area from an image"
    echo "    [-p point]                   Starting at point relative to gravity; default is 0x0"
    echo "    [-w pixels]                  Width in pixels; 0 means canvas width; default is 100"
    echo "    [-h pixels]                  Height in pixels; 0 means canvas height; default is 100"
    echo "    [-g gravity]                 Gravity; default is northwest"
    echo "  -slice                       Cut off sides from a quadrilateral area"
    echo "    [-nw xposition]              Northwest x position"
    echo "    [-sw xposition]              Southwest x position"
    echo "    [-ne xposition]              Northeast x position"
    echo "    [-se xposition]              Southeast x position"
    echo "  -ellipse                     Select an elliptical area"
    echo "    x,y                          Comma-separated x and y coodinates"
    echo "    xradius,yradius              Comma-separated x and y radius in pixels"
    echo "  -corner                      Rounded corner"
    echo "    [-r radius]                  Corner radius in pixels; default is 6"
    echo "  -border                      Draw border"
    echo "    [-c color]                   Color; default is none"
    echo "    [-w pixels]                  Width in pixels (preferrably even number); default is 4"
    echo "    [-r pixels]                  Radius in pixels for rounded corner"
    echo "  -vignette                    Vignette"
    echo "    [-i radius]                  Inner radius, default is 0"
    echo "    [-o radius]                  Inner radius, default is 150"
    echo "    [-f radius]                  Feathering amount for inner radius; float>=0; default is 0"
    echo "    [-c color]                   Color, default is black"
    echo "    [-a amount]                  Vignette amount, default is 100"
    echo "  -blur                        Blur image"
    echo "    [-gaussian                   Use gaussian algorithm"
    echo "      -s sigma]                    Sigma, default is 2.5"
    echo "    [-r radius                   Radius, default is 0"
    echo "    -s sigma]                    Sigma, default is 4"
    echo "  -contrast                    Linear constrast/decontrast"
    echo "    [-b percentage]              Black percentage; default is 0%"
    echo "    [-w percentage]              White percentage; default is 0%"
    echo "    [-g gamma]                   Gamma adjustment, 10.0 bright; default is 1.0"
    echo "    [-r]                         Reverse or decontrast image"
    echo "  -contrast-sig                Sigmoidal (non-linear) constrast/decontrast"
    echo "    [-f factor]                  Contrast factor, 10 (very high), 0.5 (very low); default is 5"
    echo "    [-t percentage]              Threshold percentage; default is 50%"
    echo "    [-r]                         Reverse or decontrast image"
    echo "  -grayscale                   Mix color channels into grayscale using weighted combination"
    echo "    [-r red]                     Red mix percentage; default is 29.9"
    echo "    [-g green]                   Green mix percentage; default is 58.7"
    echo "    [-b blue]                    Blue mix percentage; default is 11.4"
    echo "    [-f form]                    Form of channel combination; default is add"
    echo "                                   add | rms (root mean squared) | colorspace"
    echo "    [-cs colorspace]             Where to get intensity channel from; default is hsl (HSL)"
    echo "                                   rec709luma (gray) | rec601luma (HCL) | ohta | sgray |"
    echo "                                   lab | hsl | bch | hsb"
    echo "    [-br percentage]             Percent brightness, -100<=float<=100; default=0"
    echo "    [-c percentage]              Percent contrast, -100<=float<=100; default=0"
    echo "  -grayscale-sig               Sigmoidal (non-linear) grayscale"
    echo "    [-f factor]                  Contrast factor, 0<=float<=10; default is 10"
    echo "    [-t percentage]              Threshold percentage; default is 40%"
    echo "  -tint                        Tint"
    echo "    [-c color]                   Mid-point color; default is GoldenRod"
    echo "                                   Possible sepia tone colors: GoldenRod, Gold, Khaki, Wheat"
    echo "    [-h color]                   Highlight color for \"3-color duotone\""
    echo "    [-a amount]                  Tint amount, 0<=tint<=200; default is 100"
    echo "    [-m mode]                  Mode of tinting; default is midtones"
    echo "                                 Modes: all | midtones | highlights | shadows"
    echo "  -modulate                    Modulate brightness, saturation and hue"
    echo "    [-h percentage]              Hue percentage, 0<=value<=200; default is 100"
    echo "    [-s percentage]              Saturation percentage, 0<=value<=200; default is 100"
    echo "    [-b percentage]              Brightness percentage, 0<=value<=200; default is 100"
    echo "  -adjust                      Level adjustment for contrast and color enhancement"
    echo "    -b color                     Color values <= color becomes black"
    echo "    [-w color]                   Color values >= color becomes white; default none"
    echo "    [-t channel]                 Include transparency channel; default is RGB only"
    echo "  -recolor                     Recolor using look-up table; image must be in grayscale"
    echo "    color                        Dark color"
    echo "    color                        Light color"
    echo "    [-t n]                       The size of the look-up table; default is 10"
    echo "  -colorize                    Change color"
    echo "    [-r                          Replace color with another"
    echo "      color                        Color to replace"
    echo "      color                        Replacement color"
    echo "      [-f value]                   Fuzz value on each side of the color to replace for "
    echo "                                     the range of hues; 0<=float<=180 degrees;"
    echo "                                     default=40 degrees"
    echo "      [-g value]                   Gain on color conversion; integers>=0; default=100"
    echo "      [-t value]                   Threshold value in percent for forcing low saturation"
    echo "                                     colors to zero saturation, i.e. converts near gray"
    echo "                                     (white through black) to pure gray; float>=0; default=0"
    echo "      [-b brightness]              Percent change in replacement color brightness; integer>=-100;"
    echo "                                     default=0 (no change)"
    echo "      [-s saturation]]             Percent change in replacement color saturation;"
    echo "                                     -100<=integer<=100; default=0 (no change)"
    echo "    [-x[r] color r g b]          Replace color with RGB color and optional transparency,"
    echo "                                   or the reverse, replace non-matching color to RGB color"
    echo "                                   and optional transparency"
    echo "                                   RGB color default is black; transparency default is 50%"
    echo "      [-f percentage]            Fuzz percentage, 0<=value<=100; default is 100"
    echo "      [-q percentage]            Opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-t[r] color]                Replace color with transparency, or the reverse, replace"
    echo "                                   non-matching color with transparency"
    echo "      [-f percentage]            Fuzz percentage, 0<=value<=100; default is 10"
    echo "    [-c]                         Convert grayscale image to RGBA"
    echo "  -gradient                    Create gradient color"
    echo "    [-width]                     Width in pixels; default is canvas width"
    echo "    [-height]                    Height in pixels; default is canvas height"
    echo "    [-m]                         Use as mask to transparent to opaque gradient,"
    echo "                                   black is transparent, white is opaque."
    echo "    [-c \"color\"]                 Space-separated pairs of color and percent location;"
    echo "                                   default=\"black white\""
    echo "                                   Ex. \"none blue\" and \"blue none\" will output blue to none"
    echo "                                   Ex. \"red yellow 33 blue 66 red\""
    echo "    [-t type]                    Gradient type: [linear | circle | ellipse],"
    echo "                                   linear draws as specified by the direction, see option -d,"
    echo "                                   circle and ellipse draws from the 'center',"
    echo "                                   default is linear"
    echo "    [-d direction]               Direction of gradient; angle or sides or corners;"
    echo "                                   Linear default is to-bottom;"
    echo "                                   Circle or ellipse default is closest-side"
    echo "    [-p x,y]                     X and y coordinates for ellipse or circle;"
    echo "                                   pair of comma separated floats>=0;"
    echo "                                   default is (width-2)/2,(height-1)/2"
    echo "    [-q percentage]              Opaqueness, default is 100, 100=opaque, 0=transparent"
    echo "    [-r x,y]                     X and y radii for ellipse or circle;"
    echo "                                   pair of comma separated floats>=0;"
    echo "                                   default is determined by distance from center"
    echo "                                   to closest-side"
    echo "    [-zeroangle direction]       Direction where angle=0 for type=linear;"
    echo "                                   or to-top | to-right; default is to-top"
    echo "  -shadow                      Add shadow (simple)"
    echo "    [-c color]                   Shadow color; default is black"
    echo "    [-r radius]                  Shadow radius; default is 80"
    echo "    [-s sigma]                   Shadow sigma; default is 3; 0=hard shadow"
    echo "    [-p x y]                     x and y offset position; default is +5 +5;"
    echo "    [-x position]                x offset position; default is +5; + is east"
    echo "    [-y position]]               y offset position; default is +5; + is south"
    echo "  -shadow-advance              Add shadow (advance)"
    echo "    [-t type]                    Type may be inner or outer; default is outer"
    echo "    [-c color]                   Shadow color; default is black"
    echo "    [-r radius]                  Shadow radius; default is 80"
    echo "    [-s sigma]                   Shadow sigma; default is 3; 0=hard shadow"
    echo "    [-d direction]               Shadow direction, -360<=integer<=360 clockwise from the"
    echo "                                   positive x axis; default=135"
    echo "  -grid pixels color           Draw grid with pixels width/height using color"
    echo "  -nomerge                     Do not merge, make working file the output file"
    echo "    [-o file]                    Output file name"
    echo "  -merge                       Merge working image to output image"
    echo "    [-g gravity]                 Where image position gravitates to; default is northwest"
    echo "    [-p x y]                     Offset x and y positions relative to gravity;"
    echo "                                   default is 0 0"
    echo "    [-x position]                Offset x position relative to gravity; default is 0"
    echo "    [-y position]                Offset y position relative to gravity; default is 0"
    echo "    [-ox pixels]                 Offset the x position, added to x position; default is 0"
    echo "    [-oy pixels]                 Offset the y position, added to y position; default is 0"
    echo "    [-px]                        Use previously computed x position"
    echo "    [-py]                        Use previously computed y position"
    echo "    [-nx]                        Use next computed x position"
    echo "    [-ny]                        Use next computed y position"
    echo "    [-q percentage]              Opaqueness, default is 100, 100=opaque, 0=transparent"
    echo ""
    echo "  Gravity: north | south | east | west | northeast | northwest | southeast | southwest"
    echo "  Direction: angle | side | corner"
    echo "    Either an angle in degrees measured clockwise starting from 'zeroangle' from -360 to 360"
    echo "    Side (linear): to-top | to-right | to-bottom | to-left"
    echo "    Corner (linear): to-topright | to-bottomright | to-bottomleft | to-topleft"
    echo "    Side (circle or ellipse): closest-side | furthest-side"
    echo "    Corner (linear): closest-corner | furthest-corner"
    echo "  Position: <+|->xposition<+|->yposition; +0+0, +10-20"
    echo "  Dimension: widthxheight; 100x200"
    echo "  Scale: fill | shrink | enlarge"
    echo "  Side: north | south | east | west"
}



# Echo the message if debug only
function echo_debug {
    if [ $# -eq 0 ]; then
        echo "Debug: Required echo debug parameter missing."
        return 1
    fi
    if [ $debug -eq 1 ]; then
        echo "Debug: ${1}"
    fi
    return 0
}



# Echo the error message parameter
function echo_err {
    echo "-----"
    echo "Error: ${1}"
    echo "-----"
}



# Watch values
function watch {
    local label="${1}"
    shift
    local others=""
    if [ $# -gt 0 ]; then
        others=": ${@}"
    fi
    echo "-----"
    echo "${label}${others}"
}



# Returns the font name in the 'font_temp' variable.
function get_font {
    [[ $# -eq 0 ]] \
        && { echo_err "get_font parameter not found."; return 1; }

    case "${1}" in
        sans-regular)                       font_temp="Fira-Sans-Regular" ;;
        sans-thin)                          font_temp="Fira-Sans-Thin" ;;
        sans-extralight)                    font_temp="Fira-Sans-ExtraLight" ;;
        sans-light)                         font_temp="Fira-Sans-Light" ;;
        sans-medium)                        font_temp="Fira-Sans-Medium" ;;
        sans-semibold)                      font_temp="Fira-Sans-Semibold" ;;
        sans-bold)                          font_temp="Fira-Sans-Bold" ;;
        sans-extrabold)                     font_temp="Fira-Sans-ExtraBold" ;;
        sans-heavy)                         font_temp="Fira-Sans-Heavy" ;;
        sans-ultra)                         font_temp="Fira-Sans-Ultra" ;;

        sans-condensed-regular)             font_temp="Fira-Sans-Condensed-Regular" ;;
        sans-condensed-thin)                font_temp="Fira-Sans-Condensed-Thin" ;;
        sans-condensed-extralight)          font_temp="Fira-Sans-Condensed-ExtraLight" ;;
        sans-condensed-light)               font_temp="Fira-Sans-Condensed-Light" ;;
        sans-condensed-medium)              font_temp="Fira-Sans-Condensed-Medium" ;;
        sans-condensed-semibold)            font_temp="Fira-Sans-Condensed-Semibold" ;;
        sans-condensed-bold)                font_temp="Fira-Sans-Condensed-Bold" ;;
        sans-condensed-extrabold)           font_temp="Fira-Sans-Condensed-ExtraBold" ;;
        sans-condensed-heavy)               font_temp="Fira-Sans-Condensed-Heavy" ;;

        sans-compressed-regular)            font_temp="Fira-Sans-Compressed-Regular" ;;
        sans-compressed-thin)               font_temp="Fira-Sans-Compressed-Thin" ;;
        sans-compressed-extralight)         font_temp="Fira-Sans-Compressed-ExtraLight" ;;
        sans-compressed-light)              font_temp="Fira-Sans-Compressed-Light" ;;
        sans-compressed-medium)             font_temp="Fira-Sans-Compressed-Medium" ;;
        sans-compressed-semibold)           font_temp="Fira-Sans-Compressed-Semibold" ;;
        sans-compressed-bold)               font_temp="Fira-Sans-Compressed-Bold" ;;
        sans-compressed-extrabold)          font_temp="Fira-Sans-Compressed-ExtraBold" ;;
        sans-compressed-heavy)              font_temp="Fira-Sans-Compressed-Heavy" ;;

        # Public Sans vs Robert Sans:
        #   Thicker letters, a bit wider, with less inter-line spacing.

        sans-1-regular)                     font_temp="Public-Sans-Regular" ;;
        sans-1-thin)                        font_temp="Public-Sans-Thin" ;;
        sans-1-extralight)                  font_temp="Public-Sans-ExtraLight" ;;
        sans-1-light)                       font_temp="Public-Sans-Light" ;;
        sans-1-medium)                      font_temp="Public-Sans-Medium" ;;
        sans-1-semibold)                    font_temp="Public-Sans-SemiBold" ;;
        sans-1-bold)                        font_temp="Public-Sans-Bold" ;;
        sans-1-extrabold)                   font_temp="Public-Sans-ExtraBold" ;;
        sans-1-black)                       font_temp="Public-Sans-Black" ;;

        sans-1-italic)                      font_temp="Public-Sans-Italic" ;;
        sans-1-thin-italic)                 font_temp="Public-Sans-Thin-Italic" ;;
        sans-1-extralight-italic)           font_temp="Public-Sans-ExtraLight-Italic" ;;
        sans-1-light-italic)                font_temp="Public-Sans-Light-Italic" ;;
        sans-1-medium-italic)               font_temp="Public-Sans-Medium-Italic" ;;
        sans-1-semibold-italic)             font_temp="Public-Sans-SemiBold-Italic" ;;
        sans-1-bold-italic)                 font_temp="Public-Sans-Bold-Italic" ;;
        sans-1-extrabold-italic)            font_temp="Public-Sans-ExtraBold-Italic" ;;
        sans-1-black-italic)                font_temp="Public-Sans-Black-Italic" ;;

        # Almost similar to Fira Sans but with thinner weights, a little
        # little bit more horizontal space, and more inter-line spacing

        sans-2-regular)                     font_temp="IBM-Plex-Sans" ;;
        sans-2-thin)                        font_temp="IBM-Plex-Sans-Thin" ;;
        sans-2-extralight)                  font_temp="IBM-Plex-Sans-ExtraLight" ;;
        sans-2-light)                       font_temp="IBM-Plex-Sans-Light" ;;
        sans-2-medium)                      font_temp="IBM-Plex-Sans-Medium" ;;
        sans-2-semibold)                    font_temp="IBM-Plex-Sans-SemiBold" ;;
        sans-2-bold)                        font_temp="IBM-Plex-Sans-Bold" ;;

        sans-2-condensed-regular)           font_temp="IBM-Plex-Sans-Condensed" ;;
        sans-2-condensed-thin)              font_temp="IBM-Plex-Sans-Condensed-Thin" ;;
        sans-2-condensed-extralight)        font_temp="IBM-Plex-Sans-Condensed-ExtraLight" ;;
        sans-2-condensed-light)             font_temp="IBM-Plex-Sans-Condensed-Light" ;;
        sans-2-condensed-medium)            font_temp="IBM-Plex-Sans-Condensed-Medium" ;;
        sans-2-condensed-semibold)          font_temp="IBM-Plex-Sans-Condensed-SemiBold" ;;
        sans-2-condensed-bold)              font_temp="IBM-Plex-Sans-Condensed-Bold" ;;

        # Barlow is smaller, thinner, narrower than Encode Sans; no tail on lowercase L.
        # Barlow is shorter, thinner, narrower than Fira Sans, appears geometric (square).

        sans-3-regular)                     font_temp="Barlow-Regular" ;;
        sans-3-thin)                        font_temp="Barlow-Thin" ;;
        sans-3-extralight)                  font_temp="Barlow-ExtraLight" ;;
        sans-3-light)                       font_temp="Barlow-Light" ;;
        sans-3-medium)                      font_temp="Barlow-Medium" ;;
        sans-3-semibold)                    font_temp="Barlow-Semibold" ;;
        sans-3-bold)                        font_temp="Barlow-Bold" ;;
        sans-3-extrabold)                   font_temp="Barlow-ExtraBold" ;;
        sans-3-black)                       font_temp="Barlow-Black" ;;

        sans-3-semicondensed-regular)       font_temp="Barlow-Semi-Condensed-Regular" ;;
        sans-3-semicondensed-thin)          font_temp="Barlow-Semi-Condensed-Thin" ;;
        sans-3-semicondensed-extralight)    font_temp="Barlow-Semi-Condensed-ExtraLight" ;;
        sans-3-semicondensed-light)         font_temp="Barlow-Semi-Condensed-Light" ;;
        sans-3-semicondensed-medium)        font_temp="Barlow-Semi-Condensed-Medium" ;;
        sans-3-semicondensed-semibold)      font_temp="Barlow-Semi-Condensed-Semibold" ;;
        sans-3-semicondensed-bold)          font_temp="Barlow-Semi-Condensed-Bold" ;;
        sans-3-semicondensed-extrabold)     font_temp="Barlow-Semi-Condensed-ExtraBold" ;;
        sans-3-semicondensed-black)         font_temp="Barlow-Semi-Condensed-Black" ;;

        sans-3-condensed-regular)           font_temp="Barlow-Condensed-Regular" ;;
        sans-3-condensed-thin)              font_temp="Barlow-Condensed-Thin" ;;
        sans-3-condensed-extralight)        font_temp="Barlow-Condensed-ExtraLight" ;;
        sans-3-condensed-light)             font_temp="Barlow-Condensed-Light" ;;
        sans-3-condensed-medium)            font_temp="Barlow-Condensed-Medium" ;;
        sans-3-condensed-semibold)          font_temp="Barlow-Condensed-Semibold" ;;
        sans-3-condensed-bold)              font_temp="Barlow-Condensed-Bold" ;;
        sans-3-condensed-extrabold)         font_temp="Barlow-Condensed-ExtraBold" ;;
        sans-3-condensed-black)             font_temp="Barlow-Condensed-Black" ;;

        sans-4-regular)                     font_temp="Alte-Haas-Grotesk" ;;
        sans-4-bold)                        font_temp="Alte-Haas-Grotesk-Bold" ;;

        # Transpass seems to have a bit much of horizontal spacing

        sans-x)                             font_temp="Transpass-Regular" ;;
        sans-x-thin)                        font_temp="Transpass-Thin" ;;
        sans-x-extralight)                  font_temp="Transpass-ExtraLight" ;;
        sans-x-light)                       font_temp="Transpass-Light" ;;
        sans-x-medium)                      font_temp="Transpass-Medium" ;;
        sans-x-semibold)                    font_temp="Transpass-SemiBold" ;;
        sans-x-bold)                        font_temp="Transpass-Bold" ;;
        sans-x-extrabold)                   font_temp="Transpass-ExtraBold" ;;
        sans-x-black)                       font_temp="Transpass-Black" ;;

        serif)                              font_temp="Spectral-Regular" ;;
        serif-extralight)                   font_temp="Spectral-ExtraLight" ;;
        serif-light)                        font_temp="Spectral-Light" ;;
        serif-medium)                       font_temp="Spectral-Medium" ;;
        serif-semibold)                     font_temp="Spectral-SemiBold" ;;
        serif-bold)                         font_temp="Spectral-Bold" ;;
        serif-extrabold)                    font_temp="Spectral-ExtraBold" ;;

        serif-italic)                       font_temp="Spectral-Italic" ;;
        serif-extralight-italic)            font_temp="Spectral-ExtraLightItalic" ;;
        serif-light-italic)                 font_temp="Spectral-LightItalic" ;;
        serif-medium-italic)                font_temp="Spectral-MediumItalic" ;;
        serif-semibold-italic)              font_temp="Spectral-SemiBoldItalic" ;;
        serif-bold-italic)                  font_temp="Spectral-BoldItalic" ;;
        serif-extrabold-italic)             font_temp="Spectral-ExtraBoldItalic" ;;

        serif-1)                            font_temp="IBM-Plex-Serif" ;;
        serif-1-thin)                       font_temp="IBM-Plex-Serif-Thin" ;;
        serif-1-extralight)                 font_temp="IBM-Plex-Serif-ExtraLight" ;;
        serif-1-light)                      font_temp="IBM-Plex-Serif-Light" ;;
        serif-1-medium)                     font_temp="IBM-Plex-Serif-Medium" ;;
        serif-1-semibold)                   font_temp="IBM-Plex-Serif-SemiBold" ;;
        serif-1-bold)                       font_temp="IBM-Plex-Serif-Bold" ;;
        serif-1-italic)                     font_temp="IBM-Plex-Serif-Italic" ;;
        serif-1-thin-italic)                font_temp="IBM-Plex-Serif-ThinItalic" ;;
        serif-1-extralight-italic)          font_temp="IBM-Plex-Serif-ExtraLightItalic" ;;
        serif-1-light-italic)               font_temp="IBM-Plex-Serif-LightItalic" ;;
        serif-1-medium-italic)              font_temp="IBM-Plex-Serif-MediumItalic" ;;
        serif-1-semibold-italic)            font_temp="IBM-Plex-Serif-SemiBoldItalic" ;;
        serif-1-bold-italic)                font_temp="IBM-Plex-Serif-BoldItalic" ;;

        serif-2)                            font_temp="Cormorant-Regular" ;;
        serif-2-light)                      font_temp="Cormorant-Light" ;;
        serif-2-medium)                     font_temp="Cormorant-Medium" ;;
        serif-2-semibold)                   font_temp="Cormorant-Semibold" ;;
        serif-2-bold)                       font_temp="Cormorant-Bold" ;;
        serif-2-italic)                     font_temp="Cormorant-Italic" ;;
        serif-2-light-italic)               font_temp="Cormorant-Light-Italic" ;;
        serif-2-medium-italic)              font_temp="Cormorant-Medium-Italic" ;;
        serif-2-semibold-italic)            font_temp="Cormorant-SemiBold-Italic" ;;
        serif-2-bold-italic)                font_temp="Cormorant-Bold-Italic" ;;

        serif-3)                            font_temp="GTSectraFine-Regular" ;;
        serif-3-medium)                     font_temp="GTSectraFine-Medium" ;;
        serif-3-bold)                       font_temp="GTSectraFine-Bold" ;;
        serif-3-black)                      font_temp="GTSectraFine-Black" ;;
        serif-3-italic)                     font_temp="GTSectraFine-RegularItalic" ;;
        serif-3-medium-italic)              font_temp="GTSectraFine-MediumItalic" ;;
        serif-3-bold-italic)                font_temp="GTSectraFineBold-Italic" ;;
        serif-3-black-italic)               font_temp="GTSectraFine-BlackItalic" ;;

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
        comic-5)                            font_temp="Bangers-Regular" ;;
        comic-6)                            font_temp="Yikes!" ;;
        comic-7)                            font_temp="Mouse-Memoirs" ;;
        comic-8)                            font_temp="GROBOLD" ;;
        comic-9)                            font_temp="Helsinki" ;;

        display-1)                          font_temp="Oswald-Regular" ;;                   # Narrower, a bit thicker
        display-1-extralight)               font_temp="Oswald-ExtraLight" ;;
        display-1-light)                    font_temp="Oswald-Light" ;;
        display-1-medium)                   font_temp="Oswald-Medium" ;;
        display-1-semibold)                 font_temp="Oswald-Semibold" ;;
        display-1-bold)                     font_temp="Oswald-Bold" ;;

        display-2)                          font_temp="Coda-ExtraBold" ;;
        display-3)                          font_temp="Muli-Black" ;;
        display-4)                          font_temp="Chonburi" ;;
        display-5)                          font_temp="Anton-Regular" ;;                    # thin

        dirty)                              font_temp="Fake-News" ;;                        # Thick CAPS
        dirty-0)                            font_temp="Dark-Underground" ;;
        dirty-1)                            font_temp="BadSuabiaSwing-Regular" ;;           # Narrow, erratic
        dirty-2)                            font_temp="Depressionist-3-Revisited" ;;        # Less Narrow no symbols, all caps
        dirty-3)                            font_temp="Very-Damaged-Bold" ;;
        dirty-4)                            font_temp="Impacted2.0-Regular" ;;              # Thick, all caps
        dirty-5)                            font_temp="Dirty-Headline" ;;
        dirty-6)                            font_temp="HighVoltage-Rough" ;;
        dirty-7)                            font_temp="Iron-&-Brine" ;;
        dirty-8)                            font_temp="A-Love-of-Thunder" ;;                # Thick, all caps

        brush)                              font_temp="Edo-SZ" ;;
        brush-1)                            font_temp="ProtestPaint-BB" ;;
        brush-1-italic)                     font_temp="ProtestPaint-BB-Italic" ;;

        horror)                             font_temp="YouMurdererBB" ;;
        horror-1)                           font_temp="FaceYourFears" ;;
        horror-2)                           font_temp="Something-Strange" ;;
        horror-3)                           font_temp="Gallow-Tree-Free" ;;

        splat)                              font_temp="WC-Rhesus-B-Bta" ;;

        old)                                font_temp="OldNewspaperTypes" ;;
        #old-1)                              font_temp="1543HumaneJenson-Normal" ;;
        #old-1-bold)                         font_temp="1543HumaneJenson-Bold" ;;
        ash)                                font_temp="/usr/share/fonts/OTF/dcc_sharp_distress_black_by_dccanim.otf" ;;
        acme)                               font_temp="Acme" ;;
        averia)                             font_temp="Averia-Libre-Regular" ;;
        averia-bold)                        font_temp="Averia-Libre-Bold" ;;
        calluna)                            font_temp="Calluna-Regular" ;;
        scratch)                            font_temp="Scratch" ;;                      # xxx
        something)                          font_temp="Something-in-the-air" ;;
        *)                                  font_temp="${1}"
    esac
    return 0
}



if [[ $# -eq 0 || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

if [ "${1}" == "--debug" ]; then
    echo "Mode: Debug"
    debug=1
    debug_flag=--debug
    shift
fi



# Collect all arguments so it can be passed to Exif later
args=("$@")                             # store arguments in a special array
ELEMENTS=${#args[@]}                    # get number of elements
commandline_arguments=""
for (( i=0;i<$ELEMENTS;i++)); do
    commandline_arguments+="${args[${i}]} "
done

# Make sure there is no work file.
# The existence of the work file will be checked by some operations
# and will be dependent on how the operation will proceed.
rm -f "${WORK_FILE}"
if [[ -f "${arg_source_image_file}" ]]; then
    echo_err "Work file should not exist: '${WORK_FILE}'"
    exit 1
fi

arg_canvas_size="default"
arg_canvas_density=${DEFAULT_DPI}
arg_canvas_depth=${DEFAULT_DEPTH}
arg_canvas_width=0
arg_canvas_height=0
arg_canvas_color="white"
arg_canvas_output="${OUTPUT_FILE}"

#is_text_operation=0
compute_next_y=0
declare -i skip_merge_operation=0
text_prev_x=0
text_prev_y=0
text_next_x=0
text_next_y=0

text_widths=()
text_heights=()

while [ $# -gt 0 ] && [[ "${MAJOR_OPERATIONS[@]}" =~ "${1}" ]]; do
    echo_debug "Operation: ${1}"

    if [[ "${1}" == "${OP_QUERY}" ]]; then

        shift

        arg_logo_width=${LOGO_WIDTH[${arg_canvas_size}]}
        arg_logo_x=$((arg_logo_width / 2))
        arg_logo_y=$((arg_logo_width / 2 + 1))

        while [ $# -gt 0 ]; do
            case "${1}" in
                canvas-width)   arg_canvas_size=${2}
                                echo "${CANVAS_WIDTH[${arg_canvas_size}]}"
                                shift 2 ;;
                canvas-height)  arg_canvas_size=${2}
                                echo "${CANVAS_HEIGHT[${arg_canvas_size}]}"
                                shift 2 ;;
                logo-width)     arg_canvas_size=${2}
                                echo "${LOGO_WIDTH[${arg_canvas_size}]}"
                                shift 2 ;;
                logo-x)         arg_canvas_size=${2}
                                arg_logo_width=${LOGO_WIDTH[${arg_canvas_size}]}
                                arg_logo_x=$((arg_logo_width / 2))
                                echo "${arg_logo_x}"
                                shift 2 ;;
                logo-y)         arg_canvas_size=${2}
                                arg_logo_width=${LOGO_WIDTH[${arg_canvas_size}]}
                                arg_logo_y=$((arg_logo_width / 2 + 1))
                                echo "${arg_logo_y}"
                                shift 2 ;;
                *)              echo_err "Unknown query argument: ${1}."
                                exit 1
                                ;;
            esac
        done

    elif [[ "${1}" == "${OP_CANVAS}" ]]; then

        arg_canvas_image_file=""
        arg_canvas_size="${2}"
        shift 2
        if [[ ! "${CANVAS_SIZE_STRINGS[@]}" =~ "${arg_canvas_size}" ]]; then
            if [[ ! "${arg_canvas_size}" == "custom" ]]; then
                echo_err "Unknown canvas size: ${arg_canvas_size}"
                exit 1
            fi
        fi

        while [ $# -gt 0 ]; do
            case "${1}" in
                -d)     arg_canvas_density=${2}; shift 2 ;;
                -b)     arg_canvas_depth=${2}; shift 2 ;;
                -w)     arg_canvas_width=${2}; shift 2 ;;
                -h)     arg_canvas_height=${2}; shift 2 ;;
                -i)     arg_canvas_image_file="${2}"; shift 2 ;;
                -c)     arg_canvas_color=${2}; shift 2 ;;
                -o)     arg_canvas_output="${2}"; shift 2 ;;
                *)      break ;;
            esac
        done

        if [ -n "${arg_canvas_image_file}" ]; then
            if [[ ! -f "${arg_canvas_image_file}" ]]; then
                echo "Cannot find image file: '${arg_canvas_image_file}'"
                echo "Aborting."
                exit 1
            fi
            arg_canvas_size="custom"
            arg_canvas_width=`convert "${arg_canvas_image_file}" -ping -format '%w' info:`
            arg_canvas_height=`convert "${arg_canvas_image_file}" -ping -format '%h' info:`
        else
            if [[ ! "${arg_canvas_size}" == "custom" ]]; then
                arg_canvas_width=${CANVAS_WIDTH[${arg_canvas_size}]}
                arg_canvas_height=${CANVAS_HEIGHT[${arg_canvas_size}]}
            fi
        fi

        if [[ ${arg_canvas_width} -lt 1500 || ${arg_canvas_height} -lt 1500 ]]; then
            LARGE_IMAGE_SUPPORT=""
        fi

        echo_debug "Canvas:"
        echo_debug "  DPI: ${arg_canvas_density}"
        echo_debug "  Bits: ${arg_canvas_depth}"
        echo_debug "  Size: ${arg_canvas_size}"
        echo_debug "  Dimension: ${arg_canvas_width}x${arg_canvas_height}"
        echo_debug "  Background: ${arg_canvas_color}"

#        convert                                                 \
#            -size ${arg_canvas_width}x${arg_canvas_height}      \
#            xc:"${arg_canvas_color}"                            \
#            png:-                                               \
#        | convert                                               \
#            -units PixelsPerInch                                \
#            -                                                   \
#            -colorspace sRGB                                    \
#            -type truecoloralpha                                \
#            -density ${arg_canvas_width}x${arg_canvas_height}   \
#            -depth ${arg_canvas_depth}                          \
#            ${arg_canvas_output}

        convert                                                 \
            -size ${arg_canvas_width}x${arg_canvas_height}      \
            xc:"${arg_canvas_color}"                            \
            -units PixelsPerInch                                \
            -colorspace sRGB                                    \
            -type truecoloralpha                                \
            -density ${arg_canvas_width}x${arg_canvas_height}   \
            -depth ${arg_canvas_depth}                          \
            ${arg_canvas_output}

#        if [ -n "${arg_canvas_image_file}" ]; then
#            convert                         \
#                "${arg_canvas_output}"      \
#                "${arg_canvas_image_file}"  \
#                -colorspace sRGB            \
#                -gravity northwest          \
#                -composite                  \
#                "${arg_canvas_output}"
#        fi

        # Make the output file our working output file.
        # The original file can or may be used for some other operation(s).
        if [[ ! "${arg_canvas_output}" == "${OUTPUT_FILE}" ]]; then
            cp -f "${arg_canvas_output}" "${OUTPUT_FILE}"
        fi

    elif [[ "${1}" == "${OP_IMAGE}" ]]; then

        # This is moved here because recoloring the canvas only yields
        # the previous output file image.
        #   --image canvas -recolor ${theme_color_1} ${theme_color_2} -merge
        # Use this workaround until the issue has been worked out.
#        if [ "${2}" == "-recolor" ]; then
#            arg_recolor_lut_from="${3}"
#            arg_recolor_lut_to="${4}"
#            shift 4
#            arg_recolor_lut_size=10
#            while [ $# -gt 0 ]; do
#                case "${1}" in
#                    -t)     arg_recolor_lut_size=${2}; shift 2 ;;
#                    *)      break ;;
#                esac
#            done
#            convert                                                     \
#                -size 1x${arg_recolor_lut_size}                         \
#                gradient:${arg_recolor_lut_from}-${arg_recolor_lut_to}  \
#                gradient_lut.png
#            convert                 \
#                ${OUTPUT_FILE}      \
#                gradient_lut.png    \
#                -clut               \
#                ${OUTPUT_FILE}
#            rm -f gradient_lut.png
#            continue
#        fi

        compute_next_y=1
        case "${2}" in
            canvas)     arg_source_image_file="${OUTPUT_FILE}"
                        compute_next_y=0 ;;
            text)       arg_source_image_file="${TEXT_FILE}" ;;
            rectangle)  arg_source_image_file="${RECTANGLE_FILE}" ;;
            quad)       arg_source_image_file="${QUAD_FILE}" ;;
            ellipse)    arg_source_image_file="${ELLIPSE_FILE}" ;;
            *)          arg_source_image_file="${2}" ;;
        esac
        shift 2
        if [[ ! -f "${arg_source_image_file}" ]]; then
            echo "Cannot find image file: '${arg_source_image_file}'"
            echo "Aborting."
            exit 1
            # echo "Skipping..."
            # skip_merge_operation=1
        fi

        echo_debug "Image: ${arg_source_image_file}"
        # Make a copy of the image file in our directory
        cp -f "${arg_source_image_file}" "${WORK_FILE}"
        # to sRGB
        #convert "${WORK_FILE}" -colorspace RGB -depth ${arg_canvas_depth} "${WORK_FILE}"

    elif [[ "${1}" == "${OP_TEXT}" ]]; then

        arg_text_string="${2}"
        shift 2
        arg_text_quote=0
        arg_text_width=${arg_canvas_width}
        arg_text_height=0
        arg_text_offset_width=0
        arg_text_offset_height=0
        arg_text_font="default"
        arg_text_size=""
        arg_text_color="black"
        arg_text_background_color="none"
        arg_text_gravity="northwest"
        arg_text_kerning=0
        arg_text_tracking=0
        arg_text_leading=0
        arg_text_stroke_width=0
        arg_text_stroke_color="none"
        arg_text_stroke_offset="+0+0"
        arg_text_trim=1
        arg_text_output="${TEXT_FILE}"

        while [ $# -gt 0 ]; do
            case "${1}" in
                -quote)     arg_text_quote=1; shift ;;
                -w)         arg_text_width=${2}; shift 2 ;;
                -h)         arg_text_height=${2}; shift 2 ;;
                -ow)        arg_text_offset_width=${2}; shift 2 ;;
                -oh)        arg_text_offset_height=${2}; shift 2 ;;
                -f)         arg_text_font="${2}"; shift 2 ;;
                -s)         arg_text_size=${2}; shift 2 ;;
                -c)         arg_text_color="${2}"; shift 2 ;;
                -b)         arg_text_background_color="${2}"; shift 2 ;;
                -g)         arg_text_gravity=${2}; shift 2 ;;
                -k)         arg_text_kerning=${2}; shift 2 ;;
                -t)         arg_text_tracking=${2}; shift 2 ;;
                -l)         arg_text_leading=${2}; shift 2 ;;
                -sw)        arg_text_stroke_width=${2}; shift 2 ;;
                -sc)        arg_text_stroke_color="${2}"; shift 2 ;;
                -so)        arg_text_stroke_offset="${2}"; shift 2 ;;
                -notrim)    arg_text_trim=0; shift ;;
                -o)         arg_text_output="${2}"; shift 2 ;;
                *)          break ;;
            esac
        done

        if [[ -z "${arg_text_string}" ]]; then
            skip_merge_operation=1
        elif [[ -n "${arg_text_string}" ]]; then
            compute_next_y=1

            get_font "${arg_text_font}"
            arg_text_font="$font_temp"

            echo_debug "Text:"
            echo_debug "  Text: ${arg_text_string}"
            echo_debug "  Width: ${arg_text_width}"
            echo_debug "  Height: ${arg_text_height}"
            echo_debug "  Offset width: ${arg_text_offset_width}"
            echo_debug "  Offset height: ${arg_text_offset_height}"
            echo_debug "  Font: ${arg_text_font}"
            echo_debug "  Size: ${arg_text_size}"
            echo_debug "  Color: ${arg_text_color}"
            echo_debug "  Gradient Color: ${arg_text_color_gradient_1} ${arg_text_color_gradient_2}"
            echo_debug "  Background color: ${arg_text_background_color}"
            echo_debug "  Gravity: ${arg_text_gravity}"
            echo_debug "  Kerning: ${arg_text_kerning}"
            echo_debug "  Tracking: ${arg_text_tracking}"
            echo_debug "  Leading: ${arg_text_leading}"
            echo_debug "  Stroke width: ${arg_text_stroke_width}"
            echo_debug "  Stroke color: ${arg_text_stroke_color}"
            echo_debug "  Trim: ${arg_text_trim}"
            echo_debug "  Output: ${arg_text_output}"

            size_width=$((arg_text_width + arg_text_offset_width + (arg_text_stroke_width * 2)))
            size_height=$((arg_text_height + arg_text_offset_height))

            if [ ${size_width} -eq 0 ]; then
                echo_err "Text width cannot be zero."
                exit 1
            fi

            size_dimension=""
            if [ ${arg_text_height} -eq 0 ]; then
                size_dimension="${size_width}x${arg_canvas_height}"
            else
                size_dimension="${size_width}x${size_height}"
            fi

            if [ ${arg_text_quote} -eq 1 ]; then
                arg_text_string="“${arg_text_string}”"
            fi

            # If font size is not given, let the font size be computed
            # with regards to how big the dimensions are.
            param_pointsize=""
            if [ -n "${arg_text_size}" ]; then
                param_pointsize="-pointsize ${arg_text_size}"
            fi


            convert                                             \
                -background "${arg_text_background_color}"      \
                -size ${size_dimension}                         \
                -font "${arg_text_font}"                        \
                ${param_pointsize}                              \
                -gravity "${arg_text_gravity}"                  \
                -kerning ${arg_text_kerning}                    \
                -interword-spacing ${arg_text_tracking}         \
                -interline-spacing ${arg_text_leading}          \
                -fill ${arg_text_color}                         \
                -stroke "${arg_text_stroke_color}"              \
                -strokewidth ${arg_text_stroke_width}           \
                caption:"${arg_text_string}"                    \
                "${arg_text_output}"

            if [ ${arg_text_stroke_width} -gt 2 ]; then
                convert                                         \
                    -background "${arg_text_background_color}"  \
                    -size ${size_dimension}                     \
                    -font "${arg_text_font}"                    \
                    ${param_pointsize}                          \
                    -gravity "${arg_text_gravity}"              \
                    -kerning ${arg_text_kerning}                \
                    -interword-spacing ${arg_text_tracking}     \
                    -interline-spacing ${arg_text_leading}      \
                    -fill "${arg_text_color}"                   \
                    caption:"${arg_text_string}"                \
                    png:-                                       \
                | composite                                     \
                    -gravity center                             \
                    -geometry ${arg_text_stroke_offset}         \
                    -                                           \
                    "${arg_text_output}"                        \
                    "${arg_text_output}"
            fi

            if [ ${arg_text_trim} -eq 1 ]; then
                mogrify -trim "${arg_text_output}"
            fi

            size_width=`identify -format "%w" "${arg_text_output}"`
            size_height=`identify -format "%h" "${arg_text_output}"`

            echo_debug "  Text Width: ${size_width}"
            echo_debug "  Text Height: ${size_height}"

            text_widths+=(${size_width})
            text_heights+=(${size_height})

            echo_debug "  Text Width: ${#text_widths[*]}"
            echo_debug "  Text Height: ${#text_heights[*]}"
            echo_debug "  Text Width: ${text_widths[-1]}"
            echo_debug "  Text Height: ${text_heights[-1]}"

            # Make a copy of the image file in our directory
            cp -f "${arg_text_output}" "./${WORK_FILE}"
        fi # if string is not empty

    elif [[ "${1}" == "${OP_RECTANGLE}" ]]; then

        shift
        if [ ${arg_canvas_width} -eq 0 ] && [ ${arg_canvas_height} -eq 0 ]; then
            echo_err "No canvas dimension specified."
            exit 1
        fi

        compute_next_y=1
        arg_rectangle_width=${arg_canvas_width}
        arg_rectangle_height=${arg_canvas_height}
        arg_rectangle_corner_radius=0
        arg_rectangle_color="black"
        arg_rectangle_stroke_width=0
        arg_rectangle_stroke_color="none"
        arg_rectangle_output="${RECTANGLE_FILE}"

        while [ $# -gt 0 ]; do
            case "${1}" in
                -w)         if [[ "${2}" == "prev_text_width" ]]; then
                                arg_rectangle_width=${text_widths[-1]}
                            else
                                arg_rectangle_width=${2}
                            fi
                            shift 2
                            ;;
                -h)         if [[ "${2}" == "prev_text_height" ]]; then
                                arg_rectangle_height=${text_heights[-1]}
                            else
                                arg_rectangle_height=${2}
                            fi
                            shift 2
                            ;;
                -r)         arg_rectangle_corner_radius=${2}; shift 2 ;;
                -c)         arg_rectangle_color="${2}"; shift 2 ;;
                -sw)        arg_rectangle_stroke_width=${2}; shift 2 ;;
                -sc)        arg_rectangle_stroke_color="${2}"; shift 2 ;;
                -o)         arg_rectangle_output="${2}"; shift 2 ;;
                *)          break ;;
            esac
        done

        echo_debug "Rectangle:"
        echo_debug "  Width: ${arg_rectangle_width}"
        echo_debug "  Height: ${arg_rectangle_height}"
        echo_debug "  Corner radius: ${arg_rectangle_corner_radius}"
        echo_debug "  Color: ${arg_rectangle_color}"
        echo_debug "  Stroke width: ${arg_rectangle_stroke_width}"
        echo_debug "  Stroke color: ${arg_rectangle_stroke_color}"

        size_width=$((arg_rectangle_width + arg_rectangle_stroke_width))
        size_height=$((arg_rectangle_height + arg_rectangle_stroke_width))
        arg_draw="rectangle 0,0 ${arg_rectangle_width},${arg_rectangle_height}"

        if [ ${size_height} -gt 0 ]; then
            convert                                                     \
                -size ${size_width}x${size_height}                      \
                xc:none -fill "${arg_rectangle_color}"                  \
                -stroke "${arg_rectangle_stroke_color}"                 \
                -strokewidth ${arg_rectangle_stroke_width}              \
                -draw "${arg_draw}"                                     \
                "${arg_rectangle_output}"

            if [ ${arg_rectangle_corner_radius} -gt 0 ]; then
                draw_fill_black="fill black polygon 0,0 0,${arg_rectangle_corner_radius} ${arg_rectangle_corner_radius},0"
                draw_fill_white="fill white circle ${arg_rectangle_corner_radius},${arg_rectangle_corner_radius} ${arg_rectangle_corner_radius},0"
                convert                                                 \
                    "${arg_rectangle_output}"                           \
                    \( +clone -alpha extract                            \
                        -draw "${draw_fill_black} ${draw_fill_white}"   \
                        \( +clone -flip \) -compose multiply -composite \
                        \( +clone -flop \) -compose multiply -composite \
                    \)                                                  \
                    -alpha off                                          \
                    -compose copyopacity                                \
                    -composite  "${arg_rectangle_output}"
            fi

            # Make the output file our current work file.
            # The original file can or may be used for some other operation(s).
            cp -f "${arg_rectangle_output}" "${WORK_FILE}"
        fi

    elif [[ "${1}" == "${OP_QUAD}" ]]; then

        if [ ${arg_canvas_width} -eq 0 ] && [ ${arg_canvas_height} -eq 0 ]; then
            echo_err "No canvas dimension specified."
            exit 1
        fi
        shift
        arg_quad_ul=0
        arg_quad_ll=0
        arg_quad_ur=${arg_canvas_width}
        arg_quad_lr=${arg_canvas_width}
        arg_quad_color="black"
        arg_quad_stroke_width=0
        arg_quad_stroke_color="none"
        arg_quad_output="${QUAD_FILE}"

        while [ $# -gt 0 ]; do
            case "${1}" in
                -ul)        arg_quad_ul="${2}"; shift 2 ;;
                -ll)        arg_quad_ll="${2}"; shift 2 ;;
                -ur)        arg_quad_ur="${2}"; shift 2 ;;
                -lr)        arg_quad_lr="${2}"; shift 2 ;;
                -c)         arg_quad_color="${2}"; shift 2 ;;
                -sw)        arg_quad_stroke_width=${2}; shift 2 ;;
                -sc)        arg_quad_stroke_color="${2}"; shift 2 ;;
                -o)         arg_rectangle_output="${2}"; shift 2 ;;
                *)          break ;;
            esac
        done

        echo_debug "Quadrilateral:"
        echo_debug "  Upper left: ${arg_quad_ul}"
        echo_debug "  Lower left: ${arg_quad_ll}"
        echo_debug "  Upper right: ${arg_quad_ur}"
        echo_debug "  Lower right: ${arg_quad_lr}"
        echo_debug "  Color: ${arg_quad_color}"
        echo_debug "  Stroke width: ${arg_quad_stroke_width}"
        echo_debug "  Stroke color: ${arg_quad_stroke_color}"

        arg_draw="polygon ${arg_quad_ul} ${arg_quad_ll} ${arg_quad_lr} ${arg_quad_ur}"

        if [ ${arg_quad_stroke_width} -eq 0 ]; then
            convert                                             \
                -size ${arg_canvas_width}x${arg_canvas_height}  \
                xc:none -fill "${arg_quad_color}"               \
                -draw "${arg_draw}"                             \
                "${arg_quad_output}"
        else
            convert                                             \
                -size ${arg_canvas_width}x${arg_canvas_height}  \
                xc:none -fill "${arg_quad_color}"               \
                -stroke "${arg_quad_stroke_color}"              \
                -strokewidth ${arg_quad_stroke_width}           \
                -draw "${arg_draw}"                             \
                "${arg_quad_output}"
        fi

        convert -trim "${arg_quad_output}"

        # Make the output file our current work file.
        # The original file can or may be used for some other operation(s).
        cp -f "${arg_quad_output}" "${WORK_FILE}"

    elif [[ "${1}" == "${OP_ELLIPSE}" ]]; then

        shift
        arg_ellipse_width=${arg_canvas_width}
        arg_ellipse_height=${arg_canvas_height}
        arg_ellipse_radius=0
        arg_ellipse_fill_color="none"
        arg_ellipse_background_color="none"
        arg_ellipse_stroke_width=0
        arg_ellipse_stroke_color="none"
        arg_ellipse_output="${ELLIPSE_FILE}"

        while [ $# -gt 0 ]; do
            case "${1}" in
                -w)         arg_ellipse_width=${2}; shift 2 ;;
                -h)         arg_ellipse_height=${2}; shift 2 ;;
                -r)         arg_ellipse_radius=${2}; shift 2 ;;
                -c)         arg_ellipse_fill_color="${2}"
                            arg_ellipse_stroke_color="${2}"
                            shift 2
                            ;;
                -bc)        arg_ellipse_background_color="${2}"; shift 2 ;;
                -sw)        arg_ellipse_stroke_width=${2}; shift 2 ;;
                -sc)        arg_ellipse_stroke_color="${2}"; shift 2 ;;
                -o)         arg_ellipse_output="${2}"; shift 2 ;;
                *)          break ;;
            esac
        done

        # Get the horizontal and vertical radius
        half_width=$(( (arg_ellipse_width / 2) - (arg_ellipse_width % 2) ))
        half_height=$(( (arg_ellipse_height / 2) - (arg_ellipse_height % 2) ))
        if [ ${arg_ellipse_radius} -gt 0 ]; then
            half_width=${arg_ellipse_radius}
            half_height=${arg_ellipse_radius}
        fi

        # Add width and height because of the stroke
        size_width=$(( (half_width * 2) + (arg_ellipse_stroke_width * 2) + 1))
        size_height=$(( (half_height * 2) + (arg_ellipse_stroke_width * 2) + 1))
        # Get the center point
        x_pos=$((size_width / 2))
        y_pos=$((size_height / 2))

        echo_debug "Ellipse:"
        echo_debug "  Center: ${x_pos} ${y_pos}"
        echo_debug "  Width: ${arg_ellipse_width}"
        echo_debug "  Height: ${arg_ellipse_height}"
        echo_debug "  Radius: ${arg_ellipse_radius}"
        echo_debug "  Fill color: ${arg_ellipse_fill_color}"
        echo_debug "  Background color: ${arg_ellipse_background_color}"
        echo_debug "  Stroke width: ${arg_ellipse_stroke_width}"
        echo_debug "  Stroke color: ${arg_ellipse_stroke_color}"

        arg_draw="ellipse ${x_pos},${y_pos} ${half_width},${half_height} 0,360"
        convert                                                 \
            -size ${size_width}x${size_height}                  \
            xc:none                \
            -fill "${arg_ellipse_fill_color}"                   \
            -stroke "${arg_ellipse_stroke_color}"               \
            -strokewidth ${arg_ellipse_stroke_width}            \
            -draw "${arg_draw}"                                 \
            "${arg_ellipse_output}"

        # Make the output file our current work file.
        # The original file can or may be used for some other operation(s).
        cp -f "${arg_ellipse_output}" "${WORK_FILE}"

    elif [[ "${1}" == "${OP_GRID}" ]]; then

        arg_grid_pixels=${2}
        arg_grid_color="${3}"
        shift 3
        echo_debug "Image operation: grid ${arg_grid_pixels} ${arg_grid_color}"
        ${FRED_DIR}/grid            \
            -s ${arg_grid_pixels}   \
            -c "${arg_grid_color}"  \
            "${OUTPUT_FILE}"        \
            "${OUTPUT_FILE}"

    elif [[ "${1}" == "${OP_SPLAT}" ]]; then

        arg_splat_text="${2}"
        shift 2
        arg_splat_size="500"
        arg_splat_color="black"
        arg_splat_background_color="none"
        arg_splat_gravity=center
        arg_splat_xpos=0
        arg_splat_ypos=0
        arg_splat_trim=1
        arg_splat_output="int_splat.png"

        while [ $# -gt 0 ]; do
            case "${1}" in
                -s)         arg_splat_size=${2}; shift 2 ;;
                -c)         arg_splat_color="${2}"; shift 2 ;;
                -b)         arg_splat_background_color="${2}"; shift 2 ;;
                -g)         arg_splat_gravity="${2}"; shift 2 ;;
                -x)         arg_splat_xpos=${2}; shift 2 ;;
                -y)         arg_splat_ypos=${2}; shift 2 ;;
                *)          break ;;
            esac
        done

        get_font "splat"
        arg_splat_font="$font_temp"

        echo_debug "Splat:"
        echo_debug "  Text: ${arg_splat_text}"
        echo_debug "  Font: ${arg_splat_font}"
        echo_debug "  Font Size: ${arg_splat_size}"
        echo_debug "  Color: ${arg_splat_color}"
        echo_debug "  Background Color: ${arg_splat_background_color}"
        echo_debug "  Gravity: ${arg_splat_gravity}"
        echo_debug "  X Position: ${arg_splat_xpos}"
        echo_debug "  Y Position: ${arg_splat_ypos}"

        convert                                                 \
            -size ${arg_canvas_width}x${arg_canvas_height}      \
            xc:${arg_splat_background_color}                    \
            -units PixelsPerInch                                \
            -colorspace sRGB                                    \
            -type truecoloralpha                                \
            -density ${arg_canvas_width}x${arg_canvas_height}   \
            -depth ${arg_canvas_depth}                          \
            "${WORK_FILE}"

        # This is the background to be used to fill the
        # left out areas when the subject is moved to
        # the specified coordinates
        cp -f "${WORK_FILE}" int_splat_bg.png

        if [ ${#arg_splat_text} -gt 0 ]; then
            for (( i=0; i<${#arg_splat_text}; i++ )); do
                # TODO: Change the white color to something else
                #       like the complementary color of the
                #       background.
                convert                                             \
                    -background ${arg_splat_background_color}       \
                    -size ${arg_canvas_width}x${arg_canvas_height}  \
                    -font "${arg_splat_font}"                       \
                    -pointsize ${arg_splat_size}                    \
                    -gravity center                                 \
                    -fill white                                     \
                    caption:"${arg_splat_text:$i:1}"                \
                    "${arg_splat_output}"

                # Merge the contents
                composite                   \
                    -compose lighten        \
                    -gravity center         \
                    "${arg_splat_output}"   \
                    "${WORK_FILE}"          \
                    -alpha set              \
                    "${WORK_FILE}"

                cp -f "${WORK_FILE}" int_splat_${i}.png
            done
        fi

        # Move the subject of the image to specified coordinates
        convert                                             \
            "int_splat_bg.png"                              \
            "${WORK_FILE}"                                  \
            -colorspace sRGB                                \
            -compose dissolve                               \
            -define compose:args=100                        \
            -gravity ${arg_splat_gravity}                   \
            -geometry +${arg_splat_xpos}+${arg_splat_ypos}  \
            -composite                                      \
            "${WORK_FILE}"
        if [[ "${arg_splat_color}" == "transparent" || "${arg_splat_color}" == "none" ]]; then
            # Change the white color to transparent
            # https://www.imagemagick.org/Usage/compose/#changemask
            convert "${WORK_FILE}" int_splat_bg.png \
                -compose ChangeMask \
                -composite \
                -channel A -negate \
                "${WORK_FILE}"
        fi

    elif [[ "${1}" == "${OP_LOGO}" ]]; then

        if [ ${arg_canvas_width} -eq 0 ] && [ ${arg_canvas_height} -eq 0 ]; then
            echo_err "No canvas dimension specified."
            exit 1
        fi

        arg_logo_image="${2}"
        shift 2
        if [[ ! -f "${arg_logo_image}" ]]; then
            echo_err "Cannot find logo file: '${arg_logo_image}'"
            exit 1
        fi
        arg_logo_width=${LOGO_WIDTH[${arg_canvas_size}]}
        arg_logo_x=$((arg_logo_width / 2))
        arg_logo_y=$((arg_logo_width / 2))
        arg_logo_gravity=southeast
        arg_logo_color="black"
        arg_logo_output="${LOGO_FILE}"

        while [ $# -gt 0 ]; do
            case "${1}" in
                -w)         arg_logo_width=${2}; shift 2 ;;
                -p)         arg_logo_x=${2}; arg_logo_y=${3}; shift 3 ;;
                -x)         arg_logo_x=${2}; shift 2 ;;
                -y)         arg_logo_y=${2}; shift 2 ;;
                -g)         arg_logo_gravity=${2}; shift 2 ;;
                -c)         arg_logo_color="${2}"; shift 2 ;;
                *)          break ;;
            esac
        done

        echo_debug "Logo:"
        echo_debug "  Image: ${arg_logo_image}"
        echo_debug "  Width: ${arg_logo_width}"
        echo_debug "  Position: +${arg_logo_x}+${arg_logo_y}"
        echo_debug "  Gravity: ${arg_logo_gravity}"
        echo_debug "  Color: ${arg_logo_color}"

        convert                                                         \
            "${arg_logo_image}"                                         \
            -colorspace LAB                                             \
            -resize ${arg_logo_width}x${arg_logo_width}                 \
            -colorspace sRGB                                            \
            png:-                                                       \
        | convert                                                       \
            -                                                           \
            -fill "${arg_logo_color}"                                   \
            -colorize 100%                                              \
            png:-                                                       \
        | convert                                                       \
            "${OUTPUT_FILE}"                                            \
            -                                                           \
            -gravity ${arg_logo_gravity}                                \
            -geometry ${arg_logo_width}x+${arg_logo_x}+${arg_logo_y}    \
            -composite                                                  \
            "${OUTPUT_FILE}"

    elif [[ "${1}" == "${OP_TRIM}" ]]; then

        shift
        while [ $# -gt 0 ] && [[ "${1}" == @("north"|"south"|"east"|"west") ]]; do
            arg_trim_gravity=${1}
            arg_trim_pixels=${2}
            shift 2
            echo_debug "Trim:"
            echo_debug "  Gravity: ${arg_trim_gravity}"
            echo_debug "  Pixels: ${arg_trim_pixels}"
            [ ${arg_trim_pixels} -eq 0 ] && continue;
            arg_trim=""
            if [[ "${arg_trim_gravity}" == @("east"|"west") ]]; then
                arg_trim="0x0+${arg_trim_pixels}+0"
            elif [[ "${arg_trim_gravity}" == @("north"|"south") ]]; then
                arg_trim="0x0+0+${arg_trim_pixels}"
            fi
            convert                             \
                "${OUTPUT_FILE}"                \
                -gravity ${arg_trim_gravity}    \
                -crop ${arg_trim}               \
                +repage                         \
                "${OUTPUT_FILE}"
        done

#        convert                                 \
#            "${OUTPUT_FILE}"                    \
#            -gravity northwest                  \
#            -crop ${arg_trim_position}+${arg_trim_width}+${arg_trim_height} \
#            +repage \
#            "${OUTPUT_FILE}"
#
#        convert                                 \
#            "${OUTPUT_FILE}"                    \
#            -gravity southeast                  \
#            -crop ${arg_trim_position}+${arg_trim_width}+${arg_trim_height} \
#            +repage \
#            "${OUTPUT_FILE}"

    elif [[ "${1}" == "${OP_CUSTOM}" ]]; then

        shift
        op="${1}"
        echo_debug "Custom:"
        echo_debug "  ${op}"
        eval "${1} ${WORK_FILE}"
        shift

    elif [ "${1}" == "--add-exif" ]; then

        shift
        arg_exif_artist=""
        arg_exif_author="Duterte Legionnaire"
        arg_exif_description=""
        arg_exif_copyright="CC BY-NC-SA 4.0"
        arg_exif_copyright=""
        arg_exif_source="${commandline_arguments}"
        arg_exif_create_date=`date --iso-8601=ns`
        if hash exiftool 2>/dev/null; then
            exiftool                                            \
                -q                                              \
                -overwrite_original                             \
                -XMP-dc:creator="${arg_exif_author}"            \
                -XMP-dc:description="${arg_exif_description}"   \
                -XMP-dc:source="${arg_exif_source}"             \
                "${OUTPUT_FILE}"

            arg_exif_show=0
            [[ "${1}" == "-s" ]] && { arg_exif_show=1; shift; }

            if [ ${arg_exif_show} -eq 1 ]; then
                exiftool_output=`exiftool "${OUTPUT_FILE}"`
                echo "--------"
                echo "ExifTool:"
                echo "${exiftool_output}"
            fi
        else
            echo "Missing ExifTool"
        fi

    elif [ "${1}" == "--strip-exif" ]; then

        shift
        mogrify -strip "${WORK_FILE}"

    fi # major operations



    # --------------------------------------------------------------------------



    if [[ ! "${MAJOR_OPERATIONS[@]}" =~ "${1}" ]]; then
        if [[ ! "${IMAGE_OPERATIONS[@]}" =~ "${1}" ]]; then
            echo_err "Unknown operation or option: ${1}"
            exit 1
        fi
    fi

    while [ $# -gt 0 ] && [[ "${IMAGE_OPERATIONS[@]}" =~ "${1}" ]]; do

        if [[ "${1}" == "${IMAGE_OP_CONVERT}" ]]; then

            shift
            convert "${WORK_FILE}" -colorspace RGB -colorspace sRGB "${WORK_FILE}"

        elif [[ "${1}" == "${IMAGE_OP_RESIZE}" ]]; then
            shift
            if [ ${arg_canvas_width} -eq 0 ] && [ ${arg_canvas_height} -eq 0 ]; then
                echo_err "No canvas dimension specified."
                exit 1
            fi
            arg_resize_colorspace_lab=0
            arg_resize_width=${arg_canvas_width}
            arg_resize_height=${arg_canvas_height}
            arg_resize_offset_width=0
            arg_resize_offset_height=0
            arg_resize_scale="fill"
            with_width=0
            with_height=0
            size_width=0
            size_height=0
            size_dimension=""

            while [ $# -gt 0 ]; do
                case "${1}" in
                    -lab)   arg_resize_colorspace_lab=1; shift 1 ;;
                    -w)     arg_resize_width=${2}
                            with_width=1
                            shift 2 ;;
                    -h)     arg_resize_height=${2}
                            with_height=1
                            shift 2 ;;
                    -ow)    arg_resize_offset_width=${2}
                            with_width=1
                            shift 2 ;;
                    -oh)    arg_resize_offset_height=${2}
                            with_height=1
                            shift 2 ;;
                    -s)     arg_resize_scale="${2}"; shift 2 ;;
                    *)      break ;;
                esac
            done

            size_width=$((arg_resize_width + arg_resize_offset_width))
            size_height=$((arg_resize_height + arg_resize_offset_height))

            size_dimension="${size_width}x${size_height}"
            if [ ${with_width} -eq 1 ] && [ ${with_height} -eq 0 ]; then
                #size_dimension="${size_width}x${arg_resize_height}"
                size_dimension="${size_width}x"
            elif [ ${with_width} -eq 0 ] && [ ${with_height} -eq 1 ]; then
                #size_dimension="${arg_resize_width}x${size_height}"
                size_dimension="x${size_height}"
            fi

            # Append Size/dimension adjustment
            case "${arg_resize_scale}" in
                fill)       size_dimension+="^" ;;
                shrink)     size_dimension+=">" ;;
                enlarge)    size_dimension+="<" ;;
            esac
            echo_debug "Image operation: Resize"
            echo_debug " Colorspace: ${arg_resize_colorspace_lab}"
            echo_debug " Width: ${arg_resize_width}"
            echo_debug " Height: ${arg_resize_height}"
            echo_debug " Width (computed): ${size_width}"
            echo_debug " Height (computed): ${size_height}"
            echo_debug " Dimension: ${size_dimension}"
            if [ ${arg_resize_colorspace_lab} -eq 0 ]; then
                convert                                                 \
                    ${LARGE_IMAGE_SUPPORT}                              \
                    "${WORK_FILE}"                                      \
                    -colorspace RGB                                     \
                    -resize ${size_dimension}                           \
                    -gravity center                                     \
                    `#-extent ${arg_resize_width}x${arg_resize_height}`    \
                    -colorspace sRGB                                    \
                    "${WORK_FILE}"
            else
                convert                                                 \
                    ${LARGE_IMAGE_SUPPORT}                              \
                    "${WORK_FILE}"                                      \
                    -colorspace LAB                                     \
                    -resize ${size_dimension}                           \
                    -gravity center                                     \
                    `#-extent ${arg_resize_width}x${arg_resize_height}`    \
                    -colorspace sRGB                                    \
                    "${WORK_FILE}"
            fi
        elif [[ "${1}" == "${IMAGE_OP_RESIZE_DIM}" ]]; then
            shift
            if [ ${arg_canvas_width} -eq 0 ] && [ ${arg_canvas_height} -eq 0 ]; then
                echo_err "No canvas dimension specified."
                exit 1
            fi

            with_width=0
            with_height=0
            size_width=0
            size_height=0
            arg_resize_offset_width=0
            arg_resize_offset_height=0
            arg_resize_canvas_offset_width=0
            arg_resize_canvas_offset_height=0
            size_dimension=""

            while [ $# -gt 0 ]; do
                case "${1}" in
                    -w)     arg_resize_width=${2}
                            [ ${arg_resize_width} -gt 0 ] && with_width=1
                            shift 2 ;;
                    -h)     arg_resize_height=${2}
                            [ ${arg_resize_height} -gt 0 ] && with_height=1
                            shift 2 ;;
                    -ow)    arg_resize_offset_width=${2}; shift 2 ;;
                    -oh)    arg_resize_offset_height=${2}; shift 2 ;;
                    -cow)   arg_resize_canvas_offset_width=${2}; shift 2 ;;
                    -coh)   arg_resize_canvas_offset_height=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done

            if [ ${with_width} -gt 0 ]; then
                size_dimension="${arg_resize_width}"
            elif [ ${with_height} -gt 0 ]; then
                size_dimension+="x${arg_resize_height}"
            else
                if [ ${arg_resize_offset_width} -ne 0 ]; then
                    size_width=$((arg_resize_width + arg_resize_offset_width))
                    size_dimension="${size_width}"
                elif [ ${arg_resize_offset_height} -ne 0 ]; then
                    size_height=$((arg_resize_height + arg_resize_offset_height))
                    size_dimension+="x${size_height}"
                else
                    if [ ${arg_resize_canvas_offset_width} -ne 0 ]; then
                        size_width=$((arg_canvas_width + arg_resize_canvas_offset_width))
                        size_dimension="${size_width}"
                    elif [ ${arg_resize_canvas_offset_height} -ne 0 ]; then
                        size_height=$((arg_canvas_height + arg_resize_canvas_offset_height))
                        size_dimension="x${size_height}"
                    else
                        arg_resize_width=`convert "${WORK_FILE}" -ping -format '%w' info:`
                        arg_resize_height=`convert "${WORK_FILE}" -ping -format '%h' info:`
                        size_dimension="${arg_resize_width}x${arg_resize_height}"
                    fi
                fi
            fi

            echo_debug "Image operation: Resize Dimension"
            echo_debug "  Dimension: ${size_dimension}"
            convert                                 \
                "${WORK_FILE}"                      \
                `#-gravity center`                  \
                `#-background none`                 \
                -adaptive-resize ${size_dimension}  \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_FLIP}" ]]; then
            shift
            echo_debug "Image operation: Flip"
            mogrify -flip "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_FLOP}" ]]; then
            shift
            echo_debug "Image operation: Flop"
            mogrify -flop "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_TRANSPOSE}" ]]; then
            shift
            echo_debug "Image operation: Transpose"
            mogrify -transpose "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_TRANSVERSE}" ]]; then
            shift
            echo_debug "Image operation: Transverse"
            mogrify -transverse "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_ROTATE}" ]]; then
            arg_rotate_angle="${2}"
            shift 2
            echo_debug "Image operation: Rotate"
            echo_debug "  Angle: ${arg_rotate_angle}"
            mogrify                             \
                -background 'rgba(0,0,0,0)'     \
                -rotate ${arg_rotate_angle}     \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_CHOP}" ]]; then
            shift
            while [ $# -gt 0 ] && [[ "${1}" == @("north"|"south"|"east"|"west") ]]; do
                arg_chop_gravity=${1}
                arg_chop_pixels=${2}
                shift 2
                echo_debug "Image operation: Chop"
                echo_debug "  Gravity: ${arg_chop_gravity}"
                echo_debug "  Pixels: ${arg_chop_pixels}"
                if [ ${arg_chop_pixels} -gt 0 ]; then
                    arg_chop=""
                    if [[ "${arg_chop_gravity}" == @("east"|"west") ]]; then
                        arg_chop="${arg_chop_pixels}x0"
                    elif [[ "${arg_chop_gravity}" == @("north"|"south") ]]; then
                        arg_chop="0x${arg_chop_pixels}"
                    fi
                    convert                             \
                        "${WORK_FILE}"                  \
                        -gravity ${arg_chop_gravity}    \
                        -chop ${arg_chop}               \
                        "${WORK_FILE}"
                fi
            done
        elif [[ "${1}" == "${IMAGE_OP_CROP}" ]]; then
                "${WORK_FILE}"
            shift
            arg_crop_position="0x0"
            arg_crop_gravity=northwest
            arg_crop_width=100
            arg_crop_height=100
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -p)     arg_crop_position="${2}"; shift 2 ;;
                    -g)     arg_crop_gravity="${2}"; shift 2 ;;
                    -w)     arg_crop_width=${2}; shift 2 ;;
                    -h)     arg_crop_height=${2}; shift 2 ;;
                    -o)     arg_crop_output="${2}"; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: Crop"
            echo_debug "  Position: ${arg_crop_position}"
            echo_debug "  Gravity: ${arg_crop_gravity}"
            echo_debug "  Width: ${arg_crop_width}"
            echo_debug "  Height: ${arg_crop_height}"
            echo_debug "  Output: ${arg_crop_output}"
            convert                                 \
                "${WORK_FILE}"                      \
                -gravity ${arg_crop_gravity}        \
                -crop ${arg_crop_position}+${arg_crop_width}+${arg_crop_height} \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_SLICE}" ]]; then
            shift
            image_width=`convert "${WORK_FILE}" -ping -format '%w' info:`
            image_height=`convert "${WORK_FILE}" -ping -format '%h' info:`
            arg_slice_northwest_x=0
            arg_slice_southwest_x=0
            arg_slice_northeast_x=${image_width}
            arg_slice_southeast_x=${image_width}
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -nw)    arg_slice_northwest_x=${2}; shift 2 ;;
                    -sw)    arg_slice_southwest_x=${2}; shift 2 ;;
                    -ne)    arg_slice_northeast_x=${2}; shift 2 ;;
                    -se)    arg_slice_southeast_x=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: Slice"
            echo_debug "  Dimension: ${image_width}x${image_height}"
            echo_debug "  Upper left: ${arg_slice_northwest_x}"
            echo_debug "  Lower left: ${arg_slice_southwest_x}"
            echo_debug "  Upper right: ${arg_slice_northeast_x}"
            echo_debug "  Lower right: ${arg_slice_southeast_x}"
            cut_gravity=west
            cut_width=0

            if [[ ${arg_slice_northwest_x} -gt 0 || ${arg_slice_southwest_x} -gt 0 ]]; then
                cut_gravity=west
                if [ ${arg_slice_northwest_x} -le ${arg_slice_southwest_x} ]; then
                    diff_width=${arg_slice_northwest_x}
                    cut_width=$((arg_slice_northwest_x - 1))
                    arg_slice_northwest_x=0
                    arg_slice_southwest_x=$((arg_slice_southwest_x - diff_width))
                    arg_slice_northeast_x=$((arg_slice_northeast_x - diff_width))
                    arg_slice_southeast_x=$((arg_slice_southeast_x - diff_width))
                else
                    diff_width=${arg_slice_southwest_x}
                    cut_width="$((arg_slice_southwest_x - 1))"
                    arg_slice_northwest_x=$((arg_slice_northwest_x - diff_width))
                    arg_slice_southwest_x=0
                    arg_slice_northeast_x=$((arg_slice_northeast_x - diff_width))
                    arg_slice_southeast_x=$((arg_slice_southeast_x - diff_width))
                fi
                convert                             \
                    "${WORK_FILE}"                  \
                    -gravity ${cut_gravity}         \
                    -chop ${cut_width}x0            \
                    "${WORK_FILE}"
            fi
            image_width=`convert "${WORK_FILE}" -ping -format '%w' info:`
            if [[ ${arg_slice_northeast_x} -lt ${image_width} || ${arg_slice_southeast_x} -lt ${image_width} ]]; then
                cut_gravity=east
                if [[ ${arg_slice_northeast_x} -ge ${arg_slice_southeast_x} ]]; then
                    cut_width=$((image_width - arg_slice_northeast_x + 1))
                    # There is a blank 1 pixel at the left of the image so do not add 1
                    #cut_width=$((image_width - arg_cut_northeast_x))
                else
                    cut_width=$((image_width - arg_slice_southeast_x + 1))
                    # There is a blank 1 pixel at the left of the image so do not add 1
                    #cut_width=$((image_width - arg_cut_southeast_x))
                fi
                convert                             \
                    "${WORK_FILE}"                  \
                    -gravity ${cut_gravity}         \
                    -chop ${cut_width}x0            \
                    "${WORK_FILE}"
            fi

            if [[ ${arg_slice_southwest_x} -gt 0 || ${arg_slice_northwest_x} -gt 0 ]]; then
                ul="0,0"
                ll="0,${image_height}"
                lr="${arg_slice_southwest_x},${image_height}"
                ur="${arg_slice_northwest_x},0"
                convert                                     \
                    -size ${image_width}x${image_height}    \
                    xc:white                                \
                    -fill black                             \
                    -draw "polygon ${ul} ${ll} ${lr} ${ur}" \
                    int_cut_diagonal_left.png
                convert                                     \
                    "${WORK_FILE}"                          \
                    -write MPR:orig                         \
                    -alpha extract                          \
                    int_cut_diagonal_left.png               \
                    -compose multiply                       \
                    -composite MPR:orig                     \
                    +swap                                   \
                    -compose copyopacity                    \
                    -composite                              \
                    "${WORK_FILE}"
            fi

            if [[ ${arg_slice_southeast_x} -gt 0 || ${arg_slice_northeast_x} -gt 0 ]]; then
                ul="${arg_slice_northeast_x},0"
                ll="${arg_slice_southeast_x},${image_height}"
                lr="${image_width},${image_height}"
                ur="${image_width},0"
                convert                                     \
                    -size ${image_width}x${image_height}    \
                    xc:white                                \
                    -fill black                             \
                    -draw "polygon ${ul} ${ll} ${lr} ${ur}" \
                    int_cut_diagonal_right.png
                convert                                     \
                    "${WORK_FILE}"                          \
                    -write MPR:orig                         \
                    -alpha extract                          \
                    int_cut_diagonal_right.png              \
                    -compose multiply                       \
                    -composite MPR:orig                     \
                    +swap                                   \
                    -compose copyopacity                    \
                    -composite                              \
                    "${WORK_FILE}"
            fi

            rm -f "int_cut_diagonal_left.png"
            rm -f "int_cut_diagonal_right.png"
        elif [[ "${1}" == "${IMAGE_OP_SELECT_ELLIPSE}" ]]; then
            arg_cut_xy="${2}"
            arg_cut_xyradius="${3}"
            shift 3
            echo_debug "Image operation: Select Ellipse"
            echo_debug "  Position: ${arg_cut_xy}"
            echo_debug "  Radius: ${arg_cut_xyradius}"

            arg_draw="ellipse ${arg_cut_xy} ${arg_cut_xyradius} 0,360"
            convert                             \
                "${WORK_FILE}"                  \
                \( +clone                       \
                    -threshold -1               \
                    -negate                     \
                    -fill white                 \
                    -draw "${arg_draw}" \)      \
                -alpha off                      \
                -compose copy_opacity           \
                -composite                      \
                png:-                           \
            | convert                           \
                -                               \
                -trim                           \
                +repage                         \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_CORNER}" ]]; then
            shift
            arg_corner_radius=6
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -r)     arg_corner_radius=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: Rounded Corner"
            echo_debug "  Corner radius: ${arg_corner_radius}"
            draw_fill_black="fill black polygon 0,0 0,${arg_corner_radius} ${arg_corner_radius},0"
            draw_fill_white="fill white circle ${arg_corner_radius},${arg_corner_radius} ${arg_corner_radius},0"
            convert                                                 \
                "${WORK_FILE}"                                      \
                \( +clone -alpha extract                            \
                    -draw "${draw_fill_black} ${draw_fill_white}"   \
                    \( +clone -flip \) -compose multiply -composite \
                    \( +clone -flop \) -compose multiply -composite \
                \)                                                  \
                -alpha off                                          \
                -compose copyopacity                                \
                -composite  "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_BORDER}" ]]; then
            shift
            arg_border_background_color="none"
            arg_border_color="none"
            arg_border_width=4
            arg_border_corner_radius=0
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -b)     arg_border_background_color="${2}"; shift 2 ;;
                    -c)     arg_border_color="${2}"; shift 2 ;;
                    -w)     arg_border_width=${2}; shift 2 ;;
                    -r)     arg_border_corner_radius=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: Border"
            echo_debug "  Color: ${arg_border_color}"
            echo_debug "  Width: ${arg_border_width}"
            echo_debug "  Corner radius: ${arg_border_corner_radius}"
            if [ ${arg_border_corner_radius} -eq 0 ]; then
                mogrify                                     \
                    -shave 1x1                              \
                    -bordercolor "${arg_border_color}"      \
                    -border ${arg_border_width}             \
                    "${WORK_FILE}"
            else
                arg_original_width=`convert "${WORK_FILE}" -ping -format '%w' info:`
                arg_original_height=`convert "${WORK_FILE}" -ping -format '%h' info:`

                arg_width=$(( arg_original_width + arg_border_width ))
                arg_height=$(( arg_original_height + arg_border_width ))

                # Adjustment to make the rectangle corners match the image corners
                arg_corner_radius=$(( arg_border_corner_radius + 1 ))

                # Draw a filled rounded rectangle, bigger than the image
                draw_fill_black="fill black polygon 0,0 0,${arg_corner_radius} ${arg_corner_radius},0"
                draw_fill_white="fill white circle ${arg_corner_radius},${arg_corner_radius} ${arg_corner_radius},0"
                convert                                                 \
                    -size ${arg_width}x${arg_height}                    \
                    xc:${arg_border_color}                              \
                    -colorspace sRGB                                    \
                    -type truecoloralpha                                \
                    \( +clone -alpha extract                            \
                        -draw "${draw_fill_black} ${draw_fill_white}"   \
                        \( +clone -flip \) -compose multiply -composite \
                        \( +clone -flop \) -compose multiply -composite \
                    \)                                                  \
                    -alpha off                                          \
                    -compose copyopacity                                \
                    -composite                                          \
                    int_rr.png

                # Round the corners of the image
                draw_fill_black="fill black polygon 0,0 0,${arg_border_corner_radius} ${arg_border_corner_radius},0"
                draw_fill_white="fill white circle ${arg_border_corner_radius},${arg_border_corner_radius} ${arg_border_corner_radius},0"
                convert                                                 \
                    "${WORK_FILE}"                                      \
                    \( +clone -alpha extract                            \
                        -draw "${draw_fill_black} ${draw_fill_white}"   \
                        \( +clone -flip \) -compose multiply -composite \
                        \( +clone -flop \) -compose multiply -composite \
                    \)                                                  \
                    -alpha off                                          \
                    -compose copyopacity                                \
                    -composite                                          \
                    "${WORK_FILE}"
                cp "${WORK_FILE}" int_image_rounded.png

                # Overlay the image on the rectangle image
                # NOTE: Image becomes monochrome, using -colorspace and -type
                #       seem to fix it. Verify.
                convert                     \
                    int_rr.png              \
                    "${WORK_FILE}"          \
                    -colorspace sRGB        \
                    -type truecoloralpha    \
                    -gravity center         \
                    -composite              \
                    "${WORK_FILE}"

                rm -f int_rr.png
            fi
        elif [[ "${1}" == "${IMAGE_OP_VIGNETTE}" ]]; then
            shift
            arg_vignette_inner=0
            arg_vignette_outer=150
            arg_vignette_feather=0
            arg_vignette_color="black"
            arg_vignette_amount=100
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -i)     arg_vignette_inner=${2}; shift 2 ;;
                    -o)     arg_vignette_outer=${2}; shift 2 ;;
                    -f)     arg_vignette_feather=${2}; shift 2 ;;
                    -c)     arg_vignette_color="${2}"; shift 2 ;;
                    -a)     arg_vignette_amount=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: vignette"
            echo_debug "  Inner: ${arg_vignette_inner}"
            echo_debug "  Outer: ${arg_vignette_outer}"
            echo_debug "  Feather: ${arg_vignette_feather}"
            echo_debug "  Color: ${arg_vignette_color}"
            echo_debug "  Amount: ${arg_vignette_amount}"

            ${FRED_DIR}/vignette            \
                -i ${arg_vignette_inner}    \
                -o ${arg_vignette_outer}    \
                -f ${arg_vignette_feather}  \
                -c ${arg_vignette_color}    \
                -a ${arg_vignette_amount}   \
                "${WORK_FILE}"              \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_BLUR}" ]]; then
            shift
            if [ "${1}" == "-gaussian" ]; then
                shift
                arg_blur_sigma=2.5
                [[ "${1}" == "-s" ]] && { arg_blur_sigma="${2}"; shift 2; }
                echo_debug "Image operation: blur gaussian"
                echo_debug "  Sigma: ${arg_blur_sigma}"
                mogrify                         \
                    -filter Gaussian            \
                    -resize 50%                 \
                    -define filter:sigma=${arg_blur_sigma}    \
                    -resize 200%                \
                    "${WORK_FILE}"
            else
                arg_blur_radius=0
                arg_blur_sigma=4
                [[ "${1}" == "-r" ]] && { arg_blur_radius=${2}; shift 2; }
                [[ "${1}" == "-s" ]] && { arg_blur_sigma=${2}; shift 2; }
                echo_debug "Image operation: blur"
                echo_debug "  Radius: ${arg_blur_radius}"
                echo_debug "  Sigma: ${arg_blur_sigma}"
                arg_border_width=$((arg_blur_sigma * 2))
                mogrify                                         \
                    -bordercolor none                           \
                    -border ${arg_border_width}                 \
                    "${WORK_FILE}"
                mogrify                                         \
                    -channel A                                  \
                    -blur ${arg_blur_radius}x${arg_blur_sigma}  \
                    -channel RGB                                \
                    -blur ${arg_blur_radius}x${arg_blur_sigma}  \
                    "${WORK_FILE}"
            fi
        elif [ "${1}" == "${IMAGE_OP_CONTRAST}" ]; then
            shift
            arg_contrast_black="0"
            arg_contrast_white="0"
            arg_contrast_gamma="1.0"
            with_gamma=0
            arg_contrast_reverse=0
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -b)     arg_contrast_black="${2}"; shift 2 ;;
                    -w)     arg_contrast_white="${2}"; shift 2 ;;
                    -g)     arg_contrast_gamma="${2}"
                            with_gamma=1
                            shift 2 ;;
                    -r)     arg_contrast_reverse=1; shift 1 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: contrast"
            echo_debug "  Black: ${arg_contrast_black}"
            echo_debug "  White: ${arg_contrast_white}"
            echo_debug "  Gamma: ${arg_contrast_gamma}"
            arg_gamma=""
            if [ ${with_gamma} -eq 0 ]; then
                arg_gamma=",${arg_contrast_gamma}"
            fi
            if [ ${arg_contrast_reverse} -eq 0 ]; then
                convert                                                                 \
                    "${WORK_FILE}"                                                      \
                    -level ${arg_contrast_black}%,${arg_contrast_white}%${arg_gamma}    \
                    "${WORK_FILE}"
            else
                convert                                                                 \
                    "${WORK_FILE}"                                                      \
                    +level ${arg_contrast_black}%,${arg_contrast_white}%${arg_gamma}    \
                    "${WORK_FILE}"
            fi
        elif [[ "${1}" == "${IMAGE_OP_CONTRAST_SIGMOIDAL}" ]]; then
            shift
            arg_contrast_factor=5
            arg_contrast_threshold="50"
            arg_contrast_reverse=0
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -f)     arg_contrast_factor=${2}; shift 2 ;;
                    -t)     arg_contrast_threshold="${2}"; shift 2 ;;
                    -r)     arg_contrast_reverse=1; shift 1 ;;
                    *)      break ;;
                esac
            done
            if [ ${arg_contrast_reverse} -eq 0 ]; then
                convert                     \
                    "${WORK_FILE}"          \
                    -sigmoidal-contrast ${arg_contrast_factor},${arg_contrast_threshold}% \
                    "${WORK_FILE}"
            else
                convert                     \
                    "${WORK_FILE}"          \
                    +sigmoidal-contrast ${arg_contrast_factor},${arg_contrast_threshold}% \
                    "${WORK_FILE}"
            fi
        elif [ "${1}" == "${IMAGE_OP_GRAYSCALE}" ]; then
            shift
            arg_grayscale_red=29.9
            arg_grayscale_green=58.7
            arg_grayscale_blue=11.4
            arg_grayscale_form="add"
            arg_grayscale_colorspace="gray"
            arg_grayscale_colorspace="rec709luma"
            arg_grayscale_brightness=10
            arg_grayscale_contrast=10
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -r)     arg_grayscale_red="${2}"; shift 2 ;;
                    -g)     arg_grayscale_green="${2}"; shift 2 ;;
                    -b)     arg_grayscale_blue="${2}"; shift 2 ;;
                    -f)     arg_grayscale_form=${2}; shift 2 ;;
                    -cs)    arg_grayscale_colorspace=${2}; shift 2 ;;
                    -br)    arg_grayscale_brightness=${2}; shift 2 ;;
                    -c)     arg_grayscale_contrast=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: grayscale"
            echo_debug "  RGB: ${arg_grayscale_red} ${arg_grayscale_green} ${arg_grayscale_blue}"
            echo_debug "  Form: ${arg_grayscale_form}"
            echo_debug "  Colorspace: ${arg_grayscale_colorspace}"
            echo_debug "  Brightness/Contrast: ${arg_grayscale_brightness} ${arg_grayscale_contrast}"
            ${FRED_DIR}/color2gray                  \
                -r "${arg_grayscale_red}"           \
                -g "${arg_grayscale_green}"         \
                -b "${arg_grayscale_blue}"          \
                -f ${arg_grayscale_form}            \
                -c ${arg_grayscale_colorspace}      \
                -B ${arg_grayscale_brightness}      \
                -C ${arg_grayscale_contrast}        \
                "${WORK_FILE}"                      \
                "${WORK_FILE}"
        elif [ "${1}" == "${IMAGE_OP_GRAYSCALE_SIGMOIDAL}" ]; then
            shift
            arg_tone_factor=10
            arg_tone_threshold="40%"
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -f)     arg_tone_factor=${2}; shift 2 ;;
                    -t)     arg_tone_threshold=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            mogrify                     \
                -colorspace gray        \
                -sigmoidal-contrast ${arg_tone_factor},${arg_tone_threshold} \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_TINT}" ]]; then
            shift
            arg_tint_midpoint="goldenrod"
            arg_tint_highlight=""
            arg_tint_amount=100
            arg_tint_mode="midtones"
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -c)     arg_tint_midpoint="${2}"; shift 2 ;;
                    -h)     arg_tint_highlight="${2}"; shift 2 ;;
                    -a)     arg_tint_amount=${2}; shift 2 ;;
                    -m)     arg_tint_mode=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            if [[ -z "${arg_tint_midpoint}" ]]; then
                echo_err "Missing mid-point color."
                exit 1
            fi
            if [[ -z "${arg_tint_highlight}" ]]; then
                echo_debug "Image operation: tint"
                echo_debug "  Color: ${arg_tint_midpoint}"
                echo_debug "  Amount: ${arg_tint_amount}"
                echo_debug "  Mode: ${arg_tint_mode}"
                if [[ "${arg_tint_mode}" == "shadows" ]]; then
                    convert \
                        "${WORK_FILE}"                                      \
                        \( -clone 0                                         \
                            +level-colors "${arg_tint_midpoint},white" \)   \
                        -compose blend                                      \
                        -define compose:args=${arg_tint_amount}             \
                        -composite                                          \
                        "${WORK_FILE}"
                elif [[ "${arg_tint_mode}" == "highlights" ]]; then
                    convert                                                 \
                        "${WORK_FILE}"                                      \
                        \( -clone 0                                         \
                            +level-colors "black,${arg_tint_midpoint}" \)   \
                        -compose over                                       \
                        -compose blend                                      \
                        -define compose:args=${arg_tint_amount}             \
                        -composite                                          \
                        "${WORK_FILE}"
                elif [[ "${arg_tint_mode}" == "all" ]]; then
                    convert                                     \
                        "${WORK_FILE}"                          \
                        -fill "${arg_tint_midpoint}"            \
                        -colorize ${arg_tint_amount}            \
                        "${WORK_FILE}"
                elif [[ "${arg_tint_mode}" == "midtones" ]]; then
                    convert                                     \
                        "${WORK_FILE}"                          \
                        -fill "${arg_tint_midpoint}"            \
                        -tint ${arg_tint_amount}                \
                        "${WORK_FILE}"
                fi
            else
                echo_debug "Image operation: tint"
                echo_debug "  Color: ${arg_tint_midpoint}"
                echo_debug "  Highlight: ${arg_tint_highlight}"
                # Use 3-color duotone
                # Catrom is also known as Bicubic
                convert                             \
                    -size 1x1                       \
                    xc:Black                        \
                    xc:"${arg_tint_midpoint}"       \
                    xc:"${arg_tint_highlight}"      \
                    +append                         \
                    duotone_clut.gif
                convert                             \
                    "${WORK_FILE}"                  \
                    duotone_clut.gif                \
                    -interpolate catrom             \
                    -clut                           \
                    "${WORK_FILE}"
                rm -f duotone_clut.gif
            fi

            # ==================================================================
            # Add colorization (see fred's script)
            # Colorization converts image to grayscale and tints it.
            # ==================================================================

        elif [ "${1}" == "${IMAGE_OP_MODULATE}" ]; then
            shift
            arg_modulate_hue="100"
            arg_modulate_saturation="100"
            arg_modulate_brightness="100"
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -h)     arg_modulate_hue=${2}; shift 2 ;;
                    -s)     arg_modulate_saturation=${2}; shift 2 ;;
                    -b)     arg_modulate_brightness=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: modulate ${arg_modulate_brightness},${arg_modulate_saturation},${arg_modulate_hue}"
            echo_debug "Image operation: modulate"
            echo_debug "  Brightness: ${arg_modulate_brightness}"
            echo_debug "  Saturation: ${arg_modulate_saturation}"
            echo_debug "  Hue: ${arg_modulate_hue}"
            convert                     \
                "${WORK_FILE}"          \
                -modulate ${arg_modulate_brightness},${arg_modulate_saturation},${arg_modulate_hue} \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_ADJUST}" ]]; then
            arg_adjust_black=""
            arg_adjust_white=""
            arg_adjust_channel=""
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -b)     arg_adjust_black="${2}"; shift 2 ;;
                    -w)     arg_adjust_white="${2}"; shift 2 ;;
                    -t)     arg_adjust_channel=" -channel ALL "; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: level adjustment"
            echo_debug "  Black: ${arg_adjust_black}"
            echo_debug "  White: ${arg_adjust_white}"
            if [ -z "${arg_adjust_channel}" ]; then
                echo_debug "  Transparency: exclude"
            else
                echo_debug "  Transparency: include"
            fi
            arg_colors=""
            if [ -z "${arg_adjust_black}" ]; then
                echo_err "Missing argument for parameter -b"
            else
                arg_colors="${arg_adjust_black},"
            fi
            if [ -z "${arg_adjust_white}" ]; then
                arg_colors+="${arg_adjust_white}"
            fi
            mogrify                             \
                ${arg_colorize_channel}         \
                -level-colors ${arg_colors}     \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_RECOLOR}" ]]; then
            arg_recolor_lut_from="${2}"
            arg_recolor_lut_to="${3}"
            shift 3
            arg_recolor_lut_size=10
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -t)     arg_recolor_lut_size=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            echo_debug "Image operation: recolor (using LUT)"
            echo_debug "  Black: ${arg_recolor_lut_from}"
            echo_debug "  White: ${arg_recolor_lut_to}"
            echo_debug "  LUT size: ${arg_recolor_lut_size}"
            convert                                                     \
                -size 10x${arg_recolor_lut_size}                        \
                gradient:${arg_recolor_lut_from}-${arg_recolor_lut_to}  \
                gradient_lut.png
            convert ${WORK_FILE} gradient_lut.png -clut ${WORK_FILE}
            #rm -f gradient_lut.png
        elif [[ "${1}" == "${IMAGE_OP_COLORIZE}" ]]; then
            shift
            if [[ "${1}" == "-r" ]]; then
                arg_colorize_color_from="${2}"
                arg_colorize_color_to="${3}"
                shift 3
                arg_colorize_fuzz=40
                arg_colorize_gain=100
                arg_colorize_threshold=0
                arg_colorize_brightness=0
                arg_colorize_saturation=0
                while [ $# -gt 0 ]; do
                    case "${1}" in
                        -f)     arg_colorize_fuzz=${2}; shift 2 ;;
                        -g)     arg_colorize_gain=${2}; shift 2 ;;
                        -t)     arg_colorize_threshold=${2}; shift 2 ;;
                        -b)     arg_colorize_brightness=${2}; shift 2 ;;
                        -s)     arg_colorize_saturation=${2}; shift 2 ;;
                        *)      break ;;
                    esac
                done
                echo_debug "Image operation: colorize (replace color advance)"
                echo_debug "  From Color: ${arg_colorize_color_from}"
                echo_debug "  To Color: ${arg_colorize_color_to}"
                echo_debug "  Fuzz: ${arg_colorize_fuzz}"
                echo_debug "  Gain: ${arg_colorize_gain}"
                echo_debug "  Threshold: ${arg_colorize_threshold}"
                echo_debug "  Brightness: ${arg_colorize_brightness}"
                echo_debug "  Saturation: ${arg_colorize_saturation}"
                ${FRED_DIR}/replacecolor                \
                    -i "${arg_colorize_color_from}"     \
                    -o "${arg_colorize_color_to}"       \
                    -f ${arg_colorize_fuzz}             \
                    -g ${arg_colorize_gain}             \
                    -t ${arg_colorize_threshold}        \
                    -b ${arg_colorize_brightness}       \
                    -s ${arg_colorize_saturation}       \
                    "${WORK_FILE}"                      \
                    "${WORK_FILE}"
            elif [[ "${1}" == "-x" || "${1}" == "-xr" ]]; then
                arg_colorize_option="${1}"
                shift
                if [ $# -lt 4 ]; then
                    echo_err "Missing arguments in colorize -t option."
                fi
                arg_colorize_color_from="${1}"
                arg_colorize_color_red=${2}
                arg_colorize_color_green=${3}
                arg_colorize_color_blue=${4}
                shift 4
                #arg_colorize_color_destination="${2}"
                #shift 2
                arg_colorize_fuzz=100
                arg_colorize_transparency=100
                [[ "${1}" == "-f" ]] && { arg_colorize_fuzz=${2}; shift 2; }
                [[ "${1}" == "-q" ]] && { arg_colorize_transparency=${2}; shift 2; }
                transparency=$((arg_colorize_transparency / 100))
                echo_debug "Image operation: colorize (replace color)"
                echo_debug "  From color: ${arg_colorize_color_from}"
                echo_debug "  To RGB color: ${arg_colorize_color_red},${arg_colorize_color_green},${arg_colorize_color_blue}"
                echo_debug "  Fuzz: ${arg_colorize_fuzz}"
                echo_debug "  Transparency: ${transparency}"
                if [[ "${arg_colorize_option}" == "-x" ]]; then
                    convert                                     \
                        "${WORK_FILE}"                          \
                        -fuzz ${arg_colorize_fuzz}%             \
                        -alpha on                               \
                        -fill "rgba(${arg_colorize_color_red},${arg_colorize_color_green},${arg_colorize_color_blue})" \
                        -opaque "${arg_colorize_color_from}"    \
                        "${WORK_FILE}"
                elif [[ "${arg_colorize_option}" == "-xr" ]]; then
                    convert                                     \
                        "${WORK_FILE}"                          \
                        -fuzz ${arg_colorize_fuzz}%             \
                        -alpha on                               \
                        -fill "rgba(${arg_colorize_color_red},${arg_colorize_color_green},${arg_colorize_color_blue},${transparency})" \
                        +opaque "${arg_colorize_color_from}"    \
                        "${WORK_FILE}"
                fi
            elif [[ "${1}" == "-t" || "${1}" == "-tr" ]]; then
                arg_colorize_option="${1}"
                arg_colorize_color_from="${2}"
                shift 2
                arg_colorize_fuzz=10
                [[ "${1}" == "-f" ]] && { arg_colorize_fuzz=${2}; shift 2; }
                echo_debug "Image operation: colorize (make color transparent)"
                echo_debug "  From color: ${arg_colorize_color_from}"
                echo_debug "  Fuzz: ${arg_colorize_fuzz}"
                if [[ "${arg_colorize_option}" == "-t" ]]; then
                    convert                                         \
                        "${WORK_FILE}"                              \
                        -fuzz ${arg_colorize_fuzz}%                 \
                        -transparent "${arg_colorize_color_from}"   \
                        "${WORK_FILE}"
                elif [[ "${arg_colorize_option}" == "-tr" ]]; then
                    convert                                         \
                        "${WORK_FILE}"                              \
                        -fuzz ${arg_colorize_fuzz}%                 \
                        +transparent "${arg_colorize_color_from}"   \
                        "${WORK_FILE}"
                fi
            elif [[ "${1}" == "-c" ]]; then
                shift
                echo_debug "Image operation: colorize (grayscale to RGB)"
                # https://stackoverflow.com/questions/34874771/
                convert "${WORK_FILE}" -define png:color-type=2 "${WORK_FILE}"
                # Why does the 'rgba' argument cause an error?
                # convert "${WORK_FILE}" -define png:color-type=rgba "${WORK_FILE}"
            elif [[ "${1}" == "-n" ]]; then
                shift
                echo_debug "Image operation: colorize (-negate - replace with complementary colors)"
                mogrify -negate "${WORK_FILE}"
            elif [[ "${1}" == "-g" ]]; then
                shift
                echo_debug "Image operation: colorize (+negate - replace grayscale with complementary colors)"
                mogrify +negate "${WORK_FILE}"
            fi
        elif [[ "${1}" == "${IMAGE_OP_GRADIENT}" ]]; then
            shift
            image_width=`convert "${WORK_FILE}" -ping -format '%w' info:`
            image_height=`convert "${WORK_FILE}" -ping -format '%h' info:`

            arg_gradient_width=${image_width}
            arg_gradient_height=${image_height}
            arg_gradient_mask=0
            arg_gradient_color="black white"
            arg_gradient_type="linear"
            arg_gradient_dir="to-bottom"
            arg_gradient_center=""
            arg_gradient_radii=""
            arg_gradient_zeroangle=to-top
            arg_gradient_output="int_gradient_0.png"
            arg_gradient_opaqueness=100

            while [ $# -gt 0 ]; do
                case "${1}" in
                    -m)             arg_gradient_mask=1; shift ;;
                    -width)         arg_gradient_width=${2}; shift 2 ;;
                    -height)        arg_gradient_height=${2}; shift 2 ;;
                    -c)             arg_gradient_color="${2}"; shift 2 ;;
                    -t)             arg_gradient_type=${2}; shift 2 ;;
                    -d)             arg_gradient_dir=${2}; shift 2 ;;
                    -p)             arg_gradient_center="${2}"; shift 2 ;;
                    -q)             arg_gradient_opaqueness="${2}"; shift 2 ;;
                    -r)             arg_gradient_radii="${2}"; shift 2 ;;
                    -zeroangle)     arg_gradient_zeroangle=${2}; shift 2 ;;
                    -output)        arg_gradient_output="${2}"; shift 2 ;;
                    *)              break ;;
                esac
            done

            echo_debug "Image operation: gradient"
            echo_debug "  Width: ${arg_gradient_width}"
            echo_debug "  Height: ${arg_gradient_height}"
            echo_debug "  Mask: ${arg_gradient_mask}"
            echo_debug "  Color Stops: ${arg_gradient_color}"
            echo_debug "  Type: ${arg_gradient_type}"
            echo_debug "  Direction: ${arg_gradient_dir}"
            echo_debug "  Center: ${arg_gradient_center}"
            echo_debug "  Radii: ${arg_gradient_radii}"
            echo_debug "  Output file: ${arg_gradient_output}"
            echo_debug "  Opaqueness: ${arg_gradient_opaqueness}"

            arg_center_params=""
            arg_radii_params=""
            if [ "${arg_gradient_type}" == "linear" ]; then
                # Disregard use of -z option until effect is known and tested
                ${FRED_DIR}/multigradient               \
                        -w ${arg_gradient_width}        \
                        -h ${arg_gradient_height}       \
                        -s "${arg_gradient_color}"      \
                        -t ${arg_gradient_type}         \
                        -d ${arg_gradient_dir}          \
                        `#-z ${arg_gradient_zeroangle}` \
                        "${arg_gradient_output}"
            elif [ ! "${arg_gradient_type}" == "linear" ]; then
                if [ -n "${arg_gradient_center}" ]; then
                    arg_center_params="-c ${arg_gradient_center}"
                fi
                if [ -n "${arg_gradient_radii}" ]; then
                    arg_radii_params="-r ${arg_gradient_radii}"
                fi
                ${FRED_DIR}/multigradient               \
                        -w ${arg_gradient_width}        \
                        -h ${arg_gradient_height}       \
                        -s "${arg_gradient_color}"      \
                        -t ${arg_gradient_type}         \
                        -d closest-side                 \
                        ${arg_center_params}            \
                        ${arg_radii_params}             \
                        "${arg_gradient_output}"
            fi
            if [ ${arg_gradient_mask} -eq 1 ]; then
                convert                             \
                    ${LARGE_IMAGE_SUPPORT}          \
                    "${WORK_FILE}"                  \
                    -write MPR:orig                 \
                    -alpha extract                  \
                    "${arg_gradient_output}"        \
                    -compose multiply               \
                    -composite MPR:orig             \
                    +swap                           \
                    -compose copyopacity            \
                    -composite                      \
                    "${WORK_FILE}"
            else
                # Code below is replaced to try and remove a gradient
                # at the bottom of the image after combining the images

                #convert                                                 \
                #    ${LARGE_IMAGE_SUPPORT}                              \
                #    "${WORK_FILE}"                                      \
                #    "${arg_gradient_output}"                            \
                #    -size ${arg_gradient_width}x${arg_gradient_height}  \
                #    gradient: -composite                                \
                #    "${WORK_FILE}"

                convert                                                 \
                    ${LARGE_IMAGE_SUPPORT}                              \
                    "${WORK_FILE}"                                      \
                    "${arg_gradient_output}"                            \
                    -size ${arg_gradient_width}x${arg_gradient_height}  \
                    -compose dissolve                                   \
                    -define compose:args=${arg_gradient_opaqueness}     \
                    -composite                                          \
                    "${WORK_FILE}"
            fi
            if [ ${debug} -eq 0 ]; then
                rm -f "${arg_gradient_output}"
            fi
        elif [[ "${1}" == "${IMAGE_OP_SHADE}" ]]; then
            shift
            arg_shade_direction=0
            arg_shade_elevation=45
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -d)     arg_shade_direction=${2}; shift 2 ;;
                    -e)     arg_shade_elevation=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            convert                                                     \
                "${WORK_FILE}"                                          \
                -shade ${arg_shade_direction}x${arg_shade_elevation}    \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_SHADOW}" ]]; then
            shift
            arg_shadow_color="black"
            arg_shadow_radius=80
            arg_shadow_sigma=3
            arg_shadow_xoffset=+5
            arg_shadow_yoffset=+5
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -c)     arg_shadow_color=${2}; shift 2 ;;
                    -r)     arg_shadow_radius=${2}; shift 2 ;;
                    -s)     arg_shadow_sigma=${2}; shift 2 ;;
                    -p)     arg_shadow_xoffset="${2}"
                            arg_shadow_yoffset="${3}"
                            shift 3 ;;
                    -x)     arg_shadow_xoffset="${2}"; shift 2 ;;
                    -y)     arg_shadow_yoffset="${2}"; shift 2 ;;
                    *)      break ;;
                esac
            done
#            ${PROGRAM_DIR}/ci_shadow            \
#                "${debug_flag}"                 \
#                --c "${arg_shadow_color}"       \
#                --r ${arg_shadow_radius}        \
#                --s ${arg_shadow_sigma}         \
#                --x ${arg_shadow_xoffset}       \
#                --y ${arg_shadow_yoffset}       \
#                --input "${WORK_FILE}"          \
#                --output "${WORK_FILE}"
            arg_shadow="${arg_shadow_radius}x${arg_shadow_sigma}${arg_shadow_xoffset}${arg_shadow_yoffset}"
            convert                                     \
                "${WORK_FILE}"                          \
                \( -clone 0                             \
                    -background "${arg_shadow_color}"   \
                    -shadow "${arg_shadow}" \)          \
                -reverse                                \
                -background none                        \
                -layers merge +repage                   \
                "${WORK_FILE}"

        elif [[ "${1}" == "${IMAGE_OP_SHADOW_ADVANCE}" ]]; then
            shift
            arg_shadow_type=outer
            arg_shadow_color="black"
            arg_shadow_radius=80
            arg_shadow_sigma=3
            arg_shadow_direction=135
            while [ $# -gt 0 ]; do
                case "${1}" in
                    -t)     arg_shadow_type="${2}"; shift 2 ;;
                    -c)     arg_shadow_color="${2}"; shift 2 ;;
                    -r)     arg_shadow_radius=${2}; shift 2 ;;
                    -s)     arg_shadow_sigma=${2}; shift 2 ;;
                    -d)     arg_shadow_direction=${2}; shift 2 ;;
                    *)      break ;;
                esac
            done
            ${FRED_DIR}/shadows                 \
                -t ${arg_shadow_type}           \
                -c ${arg_shadow_color}          \
                -r ${arg_shadow_radius}         \
                -s ${arg_shadow_sigma}          \
                -d ${arg_shadow_direction}      \
                -b white                        \
                "${WORK_FILE}"                  \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_GRID}" ]]; then
            arg_grid_pixels=${2}
            arg_grid_color="${3}"
            shift 3
            echo_debug "Image operation: grid ${arg_grid_pixels} ${arg_grid_color}"
            ${FRED_DIR}/grid            \
                -s ${arg_grid_pixels}   \
                -c "${arg_grid_color}"  \
                "${WORK_FILE}"          \
                "${WORK_FILE}"
        elif [[ "${1}" == "${IMAGE_OP_NOMERGE}" ]]; then
            shift
            arg_nomerge_output="${OUTPUT_FILE}"
            [[ "${1}" == "-o" ]] && { arg_nomerge_output="${2}"; shift 2; }
            echo_debug "Image operation: no merge (output only)"
            echo_debug "  Output: ${arg_nomerge_output}"
            cp -f "${WORK_FILE}" "${arg_nomerge_output}"
        elif [[ "${1}" == "${IMAGE_OP_MERGE}" ]]; then
            shift
            arg_merge_gravity="northwest"
            arg_merge_xpos=0
            arg_merge_ypos=0
            # The x and y offsets move the working image by some pixel.
            # This becomes necessary when the previously drawn text image
            # have a shadow so as not to overwrite its lower part.
            arg_merge_xoffset=0
            arg_merge_yoffset=0
            arg_merge_opaqueness=100
            arg_merge_center_vertically=0
            arg_merge_center_vertically_height=0

            while [ $# -gt 0 ]; do
                case "${1}" in
                    -g)         arg_merge_gravity=${2}; shift 2 ;;
                    -p)         arg_merge_xpos=${2}
                                arg_merge_ypos=${3}
                                shift 3 ;;
                    -x)         arg_merge_xpos=${2}; shift 2 ;;
                    -y)         arg_merge_ypos=${2}; shift 2 ;;
                    -ox)        if [[ "${2}" == "prev_text_width" ]]; then
                                    arg_merge_xoffset=${text_widths[-1]}
                                else
                                    arg_merge_xoffset=${2}
                                fi
                                shift 2
                                ;;
                    -oy)        if [[ "${2}" == "prev_text_height" ]]; then
                                    arg_merge_yoffset=${text_heights[-1]}
                                else
                                    arg_merge_yoffset=${2}
                                fi
                                shift 2
                                ;;
                    -px)        arg_merge_xpos=${text_prev_x}; shift ;;
                    -py)        arg_merge_ypos=${text_prev_y}; shift ;;


                    -nx)        arg_merge_xpos=${text_next_x}; shift ;;
                    -ny)        arg_merge_ypos=${text_next_y}; shift ;;
                    -q)         arg_merge_opaqueness="${2}"; shift 2 ;;
                    -o)         arg_merge_output="${2}"; shift 2 ;;
                    -vh)        arg_merge_center_vertically_height=${2}
                                arg_merge_center_vertically=1
                                shift 2 ;;
                    *)          break ;;
                esac
            done

            if [ ${skip_merge_operation} -eq 1 ]; then
                skip_merge_operation=0
                continue
            fi

            if [ ${arg_merge_xoffset} -ne 0 ]; then
                arg_merge_xpos=$((arg_merge_xpos + arg_merge_xoffset))
            fi
            if [ ${arg_merge_yoffset} -ne 0 ]; then
                arg_merge_ypos=$((arg_merge_ypos + arg_merge_yoffset))
            fi

            if [ ${arg_merge_center_vertically} -eq 1 ]; then
                image_height=`convert "${WORK_FILE}" -ping -format '%h' info:`
                arg_merge_ypos=$((arg_merge_ypos + (${arg_merge_center_vertically_height} / 2) - (${image_height} / 2) ))
            fi

            echo_debug "Merging work file to canvas:"
            echo_debug "  Gravity: ${arg_merge_gravity}"
            echo_debug "  Position: ${arg_merge_xpos} ${arg_merge_ypos}"
            echo_debug "  X offset: ${arg_merge_xoffset}"
            echo_debug "  Y offset: ${arg_merge_yoffset}"
            echo_debug "  Opaqueness: ${arg_merge_opaqueness}"

        convert                                                 \
            "${OUTPUT_FILE}"                                    \
            "${WORK_FILE}"                                      \
            -colorspace sRGB                                    \
            -compose dissolve                                   \
            -define compose:args=${arg_merge_opaqueness}        \
            -gravity ${arg_merge_gravity}                       \
            -geometry "+${arg_merge_xpos}+${arg_merge_ypos}"    \
            -composite                                          \
            "${OUTPUT_FILE}"

            if [ -n "${arg_merge_output}" ]; then
                cp -f "${OUTPUT_FILE}" "${arg_merge_output}"
                arg_merge_output=""
            fi

            # Compute the next text x and y positions will be
            # only if a text image was last drawn
            if [ ${compute_next_y} -eq 1 ]; then

                compute_next_y=0

                text_prev_x=${arg_merge_xpos}
                text_prev_y=${arg_merge_ypos}

                # Compute where the next x position will be.
                # The next x position is computed to be at the right
                # of the current text area.
                image_width=`convert "${WORK_FILE}" -ping -format '%w' info:`
                text_next_x=$((arg_merge_xpos + image_width))

                # Compute where the next y position will be.
                # The next y position is computed to be at the bottom
                # of the current text area.
                image_height=`convert "${WORK_FILE}" -ping -format '%h' info:`
                text_next_y=$((arg_merge_ypos + image_height))

                echo_debug "  Prev position: ${text_prev_x},${text_prev_y}"
                echo_debug "  Next position: ${text_next_x},${text_next_y}"
            fi

        fi # Image operations

    done # Image operations

    if [[ ! "${MAJOR_OPERATIONS[@]}" =~ "${1}" ]]; then
        if [[ ! "${IMAGE_OPERATIONS[@]}" =~ "${1}" ]]; then
            echo_err "Unknown operation or option: ${1}"
            exit 1
        fi
    fi

done # operations


# More
# http://www.imagemagick.org/discourse-server/viewtopic.php?t=34152
# http://www.imagemagick.org/discourse-server/viewtopic.php?t=31042
