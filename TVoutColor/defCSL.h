/*****************************************************************************
    System Name : TVoutColor_NTSC
    File Name   : defCSL.h
    Content     : 
    Version     : 0.0
    CPU board   : Arduino UNO/Duemilanove
    Compiler    : Arduino 1.0.4
    History     : 2013/10/04
*****************************************************************************/
/*----------------------------------------------------------------------------
;  Copyleft @Nabe_RMC
;---------------------------------------------------------------------------*/
#ifdef      CSL_INCLUDE
#define     CSL_EXT 
#else
#define     CSL_EXT extern
#endif

/*==========================================================================*/
/*  Includes                                                                */
/*==========================================================================*/
#ifndef     COMMON_H
#include    "nabe_common.h"
#endif

/*==========================================================================*/
/*  DEFINE                                                                  */
/*==========================================================================*/
#define COL_WHI     0
#define COL_GRN     1
#define COL_BLU     2
#define COL_MAG     3
#define COL_CYN     4
#define COL_YEL     5
#define COL_RED     6
#define COL_BLK     7





/*==========================================================================*/
/*                                                                          */
/*==========================================================================*/
class CCSL
{
public:
    CCSL();                 /* constructor for intializing                  */
    void Ini();
    void SetVram();
    void clear_screen();
    UB   set_cursor( UB, UB );
    UB   set_line_color( UB, UB, UB );
    UB   put_char( UB, UB, UB );
    UB   put_char( UB );
    void print(const char *);
    
private:
    UB cursor_x, cursor_y;
    int numRows;
    int numCols;
};

