/*****************************************************************************
    System Name : TVoutColor_NTSC
    File Name   : CG_NTSC_20130603.h
    Content     : 
    Version     : 0.0
    CPU board   : Arduino UNO/Duemilanove
    Compiler    : Arduino 1.0.4
    History     : 2013/10/04
*****************************************************************************/
/*----------------------------------------------------------------------------
;  Copyright (C) 2013 Masami Watanabe
;
;  This program is free software; you can redistribute it and/or modify it
;  under the terms of the GNU General Public License as published by the Free
;  Software Foundation; either version 3 of the License, or (at your option)
;  any later version.
;
;  This program is distributed in the hope that it will be useful, but
;  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
;  for more details.
;
;  You should have received a copy of the GNU General Public License along
;  with this program. If not, see <http://www.gnu.org/licenses/>.
;---------------------------------------------------------------------------*/
/*  
http://en.wikipedia.org/wiki/Character_generator

[5x7 font]          'A'
0x00    00000000
0x7C    01111100    *****
0x12    00010010      *  *
0x11    00010001      *   *
0x12    00010010      *  * 
0x7C    01111100    *****

[type A1]
0x98    10011000    *  **
0x5C    01011100     * ***
0xB6    10110110    * ** **
0x5F    01011111     * *****
0x5F    01011111     * *****
0xB6    10110110    * ** **
0x5C    01011100     * ***
0x98    10011000    *  **

[type A2]
0x58    01011000     * **
0xBC    10111100    * ****
0x16    00010110       * **
0x3F    01111111     *******
0x3F    01111111     *******
0x16    00010110       * **
0xBC    10111100    * *****
0x58    01011000     * **


[type B1]
0x1E    00011110    1      ****
0x98    10011000    2   *  **
0x7D    01111011    3    **** **
0x36    00110110    4     ** **
0x3C    00111100    5     ****
0x3C    00111100    6     ****
0x3C    00111100    7     ****
0x36    00110110    8     ** **
0x7D    01111011    9    **** **
0x98    10011000    10  *  **
0x1E    00011110    11     ****

[type B2]
0x70    01110000    1
0x18    00011000    2
0x7D    01111011    3
0xB6    10110110    4
0xBC    10111100    5
0x3C    01111100    6
0xBC    10111100    7
0xB6    10110110    8
0x7D    01111011    9
0x18    00011000    10
0x70    01110000    11


[type C1]
0x9C    10011100    1
0x9E    10011110    2
0x5E    01011110    3
0x76    01110110    4
0x37    00110111    5
0x5F    01011111    6
0x5F    01011111    7
0x37    01110111    8
0x76    01110110    9
0x5E    01011110    10
0x9E    10011110    11
0x9C    10011100    12

[type C2]
0x1C    00011100    1
0x5E    01011110    2
0xFE    11111110    3
0xB6    10110110    4
0x37    01110111    5
0x5F    01011111    6
0x5F    01011111    7
0x37    01110111    8
0xB6    10110110    9
0xFE    11111110    10
0x5E    01011110    11
0x1C    00011100    12


[silo]
0xF8    11111000    1
0xFC    11111100    2
0xFE    11111110    3
0x7F    01111111    4
0x3F    01111111    5
0x3F    01111111    6
0x3F    01111111    7
0x3F    01111111    8
0x7F    01111111    9
0xFE    11111110    10
0xFC    11111100    11
0xF8    11111000    12


[turret]
0xE0    11100000    1
0xF0    11110000    2
0xF0    11110000    3
0xF8    11111000    4
0xF8    11111000    5
0xFC    11111100    6
0xF8    11111000    7
0xF8    11111000    8
0xF0    11110000    9
0xF0    11110000    10
0xE0    11100000    11


*/
0xFF,       /*     */
0xFF,       
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,



0x10,       /*  01H Type A1-R   */
0x18,
0x1C,
0x16,
0x1E,
0x08,
0x14,
0x0A,

0x01,       /*  02H Type A2-L   */
0x03,
0x07,
0x0D,
0x0F,
0x05,
0x09,
0x04,

0x10,       /*  03H Type A2-R   */
0x18,
0x1C,
0x16,
0x1E,
0x14,
0x12,
0x04,

0x02,       /*  04H Type B1-L   */
0x0B,
0x09,
0x0E,
0x0F,
0x03,
0x02,
0x04,

0x01,       /*  05H Type B1-M   */
0x03,
0x1E,
0x1D,
0x1F,
0x1F,
0x01,
0x00,

0x00,       /*  06H Type B1-R   */
0x08,
0x08,
0x18,
0x18,
0x00,
0x00,
0x10,

0x02,       /*  07H Type B2-L */
0x03,
0x01,
0x06,
0x0F,
0x0D,
0x0A,
0x01,

0x01,       /*  08H Type B2-M */
0x03,
0x1E,
0x1D,
0x1F,
0x1F,
0x09,
0x16,

0x00,       /*  09H Type B2-R */
0x00,
0x00,
0x00,
0x10,
0x10,
0x10,
0x00,

0x00,       /*  0AH Type C1-L */
0x07,
0x0F,
0x0E,
0x0F,
0x01,
0x03,
0x0C,

0x00,       /*  0BH Z-0 */
0x01,
0x03,
0x07,
0x0F,
0x1F,
0x00,
0x00,

0x00,       /*  0CH Z-1 */
0x0A,
0x15,
0x11,
0x0A,
0x04,
0x00,
0x00,

0x00,       /*  0DH Type C2-R */
0x0A,
0x1F,
0x1F,
0x0E,
0x04,
0x00,
0x00,

0x00,       /*  0EH Type C2-M */
0x0A,
0x1F,
0x1F,
0x0E,
0x04,
0x00,
0x00,

0x00,       /*  0FH '' */
0x0A,
0x1F,
0x1F,
0x0E,
0x0E,
0x04,
0x00,

0x1F,       /*  10H 'ァ ' */
0x01,
0x0A,
0x0C,
0x08,
0x08,
0x10,
0x00,

0x08,       /*  11H 'ミ' */
0x04,
0x0A,
0x04,
0x0A,
0x04,
0x02,
0x00,

      /*  12H ' ' */
0x03,       
0x09,
0x1F,
0x0A,
0x08,
0x08,
0x0E,
0x02,


0x03,       /*  13H ' ' */
0x01,
0x1F,
0x01,
0x02,
0x04,
0x08,
0x10,

0x0E,       /*  14H ' ' */
0x00,
0x1F,
0x01,
0x02,
0x04,
0x08,
0x10,

0x05,       /*  15H ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x06,       /*  16H ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x07,       /*  17H ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x08,       /*  18H ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x09,       /*  19H ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x0A,       /*  1AH ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x0B,       /*  1BH ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x0C,       /*  1CH ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x0D,       /*  1DH ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x0E,       /*  1EH ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x0F,       /*  1FH ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x00,       /*  20H ' ' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x04,       /*  21H '!' */
0x04,
0x04,
0x04,
0x00,
0x00,
0x04,
0x00,

0x0C,       /*  22H     */
0x0C,
0x0C,
0x00,
0x00,
0x00,
0x00,
0x00,

0x0A,       /*  23H '#' */
0x0A,
0x1F,
0x0A,
0x1F,
0x0A,
0x0A,
0x00,

0x04,       /*  24H '$' */
0x0F,
0x14,
0x0E,
0x05,
0x1E,
0x04,
0x00,

0x18,       /*  25H '%' */
0x19,
0x02,
0x04,
0x08,
0x13,
0x03,
0x00,

0x0C,       /*  26H '&' */
0x12,
0x14,
0x08,
0x15,
0x12,
0x0D,
0x00,

0x04,       /*  27H     */
0x04,
0x04,
0x00,
0x00,
0x00,
0x00,
0x00,

0x02,       /*  28H '(' */
0x04,
0x08,
0x08,
0x08,
0x04,
0x02,
0x00,

0x08,       /*  29H ')' */
0x04,
0x02,
0x02,
0x02,
0x04,
0x08,
0x00,

0x00,       /*  2AH '*  */
0x00,
0x15,
0x0E,
0x1F,
0x0E,
0x15,
0x00,

0x00,       /*  2BH '+' */
0x00,
0x04,
0x04,
0x1F,
0x04,
0x04,
0x00,

0x00,       /*  2CH ',' */
0x00,
0x00,
0x00,
0x08,
0x08,
0x10,
0x00,

0x00,       /*  2DH '-' */
0x00,
0x00,
0x1F,
0x00,
0x00,
0x00,
0x00,

0x00,       /*  2EH '.' */
0x00,
0x00,
0x00,
0x04,
0x04,
0x00,
0x00,

0x00,       /*  2FH '/' */
0x01,
0x02,
0x04,
0x08,
0x10,
0x00,
0x00,

0x0E,       /*  30H '0' */
0x11,
0x13,
0x15,
0x19,
0x11,
0x0E,
0x00,

0x04,       /*  31H '1' */
0x0C,
0x04,
0x04,
0x04,
0x04,
0x0E,
0x00,

0x0E,       /*  32H '2' */
0x11,
0x01,
0x02,
0x04,
0x08,
0x1F,
0x00,

0x1F,       /*  33H '3' */
0x02,
0x04,
0x02,
0x01,
0x11,
0x0E,
0x00,

0x02,       /*  34H '4' */
0x06,
0x0A,
0x12,
0x1F,
0x02,
0x02,
0x00,

0x1F,       /*  35H '5' */
0x10,
0x1E,
0x01,
0x01,
0x11,
0x1E,
0x00,

0x06,       /*  36H '6' */
0x08,
0x10,
0x1E,
0x11,
0x11,
0x0E,
0x00,

0x1F,       /*  37H '7' */
0x01,
0x01,
0x02,
0x04,
0x04,
0x04,
0x00,

0x0E,       /*  38H '8' */
0x11,
0x11,
0x0E,
0x11,
0x11,
0x0E,
0x00,

0x0E,       /*  39H '9' */
0x11,
0x11,
0x0F,
0x01,
0x02,
0x0E,
0x00,

0x00,       /*  3AH ':' */
0x04,
0x04,
0x00,
0x04,
0x04,
0x00,
0x00,

0x00,       /*  3BH ';' */
0x04,
0x04,
0x00,
0x04,
0x04,
0x08,
0x00,

0x02,       /*  3CH '<' */
0x04,
0x08,
0x10,
0x08,
0x04,
0x02,
0x00,

0x00,       /*  3DH '=' */
0x00,
0x1F,
0x00,
0x1F,
0x00,
0x00,
0x00,

0x08,       /*  3EH '>' */
0x04,
0x02,
0x01,
0x02,
0x04,
0x08,
0x00,

0x0E,       /*  3FH '?' */
0x11,
0x01,
0x02,
0x04,
0x00,
0x04,
0x00,

0x0E,       /*  40H '@' */
0x11,
0x01,
0x0D,
0x15,
0x15,
0x0E,
0x00,

0x04,       /*  41H 'A' */
0x0A,
0x11,
0x11,
0x1F,
0x11,
0x11,
0x00,

0x1E,       /*  42H 'B' */
0x11,
0x11,
0x1E,
0x11,
0x11,
0x1E,
0x00,

0x0E,       /*  43H 'C' */
0x11,
0x10,
0x10,
0x10,
0x11,
0x0E,
0x00,

0x1C,       /*  44H 'D' */
0x12,
0x11,
0x11,
0x11,
0x12,
0x1C,
0x00,

0x1F,       /*  45H 'E' */
0x10,
0x10,
0x1E,
0x10,
0x10,
0x1F,
0x00,

0x1F,       /*  46H 'F' */
0x10,
0x10,
0x1E,
0x10,
0x10,
0x10,
0x00,

0x0E,       /*  47H 'G' */
0x11,
0x10,
0x17,
0x11,
0x11,
0x0E,
0x00,

0x11,       /*  48H 'H' */
0x11,
0x11,
0x1F,
0x11,
0x11,
0x11,
0x00,

0x0E,       /*  49H 'I' */
0x04,
0x04,
0x04,
0x04,
0x04,
0x0E,
0x00,

0x07,       /*  4AH 'J' */
0x02,
0x02,
0x02,
0x02,
0x12,
0x0C,
0x00,

0x11,       /*  4BH 'k' */
0x12,
0x14,
0x18,
0x14,
0x12,
0x11,
0x00,

0x10,       /*  4CH 'L' */
0x10,
0x10,
0x10,
0x10,
0x10,
0x1F,
0x00,

0x11,       /*  4DH 'M' */
0x1B,
0x15,
0x15,
0x11,
0x11,
0x11,
0x00,

0x11,       /*  4EH 'N' */
0x11,
0x19,
0x15,
0x13,
0x11,
0x11,
0x00,

0x0E,       /*  4FH 'O' */
0x11,
0x11,
0x11,
0x11,
0x11,
0x0E,
0x00,

0x1E,       /*  50H 'P' */
0x11,
0x11,
0x1E,
0x10,
0x10,
0x10,
0x00,

0x0E,       /*  51H 'Q' */
0x11,
0x11,
0x11,
0x15,
0x12,
0x0D,
0x00,

0x1E,       /*  52H 'R' */
0x11,
0x11,
0x1E,
0x14,
0x12,
0x11,
0x00,

0x0F,       /*  53H 'S' */
0x10,
0x10,
0x0E,
0x01,
0x01,
0x1F,
0x00,

0x1F,       /*  54H 'T' */
0x04,
0x04,
0x04,
0x04,
0x04,
0x04,
0x00,

0x11,       /*  55H 'U' */
0x11,
0x11,
0x11,
0x11,
0x11,
0x0E,
0x00,

0x11,       /*  56H 'V' */
0x11,
0x11,
0x0A,
0x0A,
0x0A,
0x04,
0x00,

0x11,       /*  57H 'W' */
0x11,
0x11,
0x15,
0x15,
0x15,
0x0A,
0x00,

0x11,       /*  58H 'X' */
0x11,
0x0A,
0x04,
0x0A,
0x11,
0x11,
0x00,

0x11,       /*  59H 'Y' */
0x11,
0x11,
0x0A,
0x04,
0x04,
0x04,
0x00,

0x1F,       /*  5AH 'Z' */
0x01,
0x02,
0x04,
0x08,
0x10,
0x1F,
0x00,

0x1E,       /*  5BH '[' */
0x10,
0x10,
0x10,
0x10,
0x10,
0x1E,
0x00,

0x00,       /*  5CH '   */
0x10,
0x08,
0x04,
0x02,
0x01,
0x00,
0x00,

0x1E,       /*  5DH ']' */
0x02,
0x02,
0x02,
0x02,
0x02,
0x1E,
0x00,

0x04,       /*  5EH '^' */
0x0A,
0x11,
0x00,
0x00,
0x00,
0x00,
0x00,

0x00,       /*  5FH '_' */
0x00,
0x00,
0x00,
0x00,
0x00,
0x1F,
0x00,

0x08,       /*  60H '   */
0x04,
0x02,
0x00,
0x00,
0x00,
0x00,
0x00,

0x00,       /*  61H 'a' */
0x0E,
0x01,
0x0F,
0x11,
0x0F,
0x00,
0x00,

0x10,       /*  62H 'b' */
0x10,
0x1E,
0x11,
0x11,
0x1E,
0x00,
0x00,

0x00,       /*  63H 'c' */
0x0F,
0x10,
0x10,
0x10,
0x0F,
0x00,
0x00,

0x01,       /*  64H 'd' */
0x01,
0x0F,
0x11,
0x11,
0x0F,
0x00,
0x00,

0x00,       /*  65H 'e' */
0x0E,
0x11,
0x1F,
0x10,
0x0F,
0x00,
0x00,

0x06,       /*  66H 'f' */
0x09,
0x08,
0x1E,
0x08,
0x08,
0x00,
0x00,

0x00,       /*  67H 'g' */
0x0F,
0x11,
0x11,
0x0F,
0x01,
0x0E,
0x00,

0x10,       /*  68H 'h' */
0x10,
0x1E,
0x11,
0x11,
0x11,
0x00,
0x00,

0x04,       /*  69H 'i' */
0x00,
0x0C,
0x04,
0x04,
0x0E,
0x00,
0x00,

0x02,       /*  6AH 'j' */
0x06,
0x02,
0x02,
0x12,
0x0C,
0x00,
0x00,

0x10,       /*  6BH 'k' */
0x11,
0x12,
0x1C,
0x12,
0x11,
0x00,
0x00,

0x0C,       /*  6CH 'l' */
0x04,
0x04,
0x04,
0x04,
0x0E,
0x00,
0x00,

0x00,       /*  6DH 'm' */
0x0E,
0x15,
0x15,
0x15,
0x15,
0x00,
0x00,

0x00,       /*  6EH 'n' */
0x16,
0x19,
0x11,
0x11,
0x11,
0x00,
0x00,

0x00,       /*  6FH 'o' */
0x00,
0x0E,
0x11,
0x11,
0x11,
0x0E,
0x00,

0x00,       /* 70H  'p' */
0x1E,
0x11,
0x11,
0x1E,
0x10,
0x10,
0x00,

0x00,       /*  71H 'q' */
0x0F,
0x11,
0x11,
0x0F,
0x01,
0x01,
0x00,

0x00,       /*  72H 'r' */
0x16,
0x19,
0x10,
0x10,
0x10,
0x00,
0x00,

0x00,       /*  73H 's' */
0x0F,
0x10,
0x0E,
0x01,
0x1E,
0x00,
0x00,

0x08,       /*  74H 't' */
0x08,
0x1F,
0x08,
0x09,
0x06,
0x00,
0x00,

0x00,       /*  75H 'u' */
0x11,
0x11,
0x11,
0x11,
0x0F,
0x00,
0x00,

0x00,       /*  76H 'v' */
0x11,
0x11,
0x11,
0x0A,
0x04,
0x00,
0x00,

0x00,       /*  77H 'w' */
0x11,
0x11,
0x15,
0x15,
0x0A,
0x00,
0x00,

0x00,       /*  78H 'x' */
0x11,
0x0A,
0x04,
0x0A,
0x11,
0x00,
0x00,

0x00,       /*  79H 'y' */
0x11,
0x11,
0x0A,
0x04,
0x04,
0x08,
0x00,

0x00,       /*  7AH 'z' */
0x1F,
0x02,
0x04,
0x08,
0x1F,
0x00,
0x00,

0x06,       /*  7BH '<' */
0x08,
0x08,
0x10,
0x08,
0x08,
0x06,
0x00,

0x04,       /*  7CH ':' */
0x04,
0x04,
0x00,
0x04,
0x04,
0x04,
0x00,

0x0C,       /*  7DH '>' */
0x02,
0x02,
0x01,
0x02,
0x02,
0x0C,
0x00,

0x0D,       /*  7EH '~' */
0x16,
0x00,
0x00,
0x00,
0x00,
0x00,
0x00,

0x1F,       /*  7FH ' ' */
0x1F,
0x1F,
0x1F,
0x1F,
0x1F,
0x1F,
0x00,


