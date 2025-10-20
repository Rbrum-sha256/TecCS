/*center.p:  */
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure
/*--------------------------------------------------------------------------
File : center.p
Purpose : center a window dynamically depending on certain attributes
Syntax :
Description :
Author(s) : Robert J. Mirro
Created :
Notes : The windows property sheet should have 'Hidden' checked.
If hidden is set to false, the window will be initially
displayed where you saved it (if you checked the 'Explicit
Postition' box), then it will move to the new coordinates.
If the window is NOT initially hidden, the user will
see the window repostioning itself.

This .p will not let the user resize the window at run-time,
but the window will retain the 3D border. This .p will also
control the size of the window when the 'Max' button is
choosen. The window will not be allowed to be maximized
larger than its current size.

Input Params: Center.p accepts the window handle as an input parameter.

EX.- run f:/generico/center.p(input {&window-name}:handle).

------------------------------------------------------------------------*/
/* This .W file was created with the Progress UIB. */
/*----------------------------------------------------------------------*/
/* *************************** Definitions ************************** */
def input param win_handle as handle no-undo.
def var win_x as int no-undo.
def var win_y as int no-undo.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK
/* ******************** Preprocessor Definitions ******************** */
&Scoped-define PROCEDURE-TYPE Procedure


/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */
&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
Type: Procedure
Allow:
Frames: 0
Add Fields to: Neither
Other Settings: CODE-ONLY
*/
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS
/* ************************* Create Window ************************** */
&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
CREATE WINDOW Procedure ASSIGN
HEIGHT = 2.23
WIDTH = 30.29.
*/
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure

/* *************************** Main Block *************************** */
/* insure that the window starts hidden */
if win_handle:hidden = false then do:
bell.
message "This window's 'Hidden' attribute is 'False'." skip
"Please select 'Hidden = True' on this windows" skip
"property sheet."
view-as alert-box warning buttons ok.
end.
else
assign
win_handle:resize = true no-error.

/* calculate window's true width and height */
assign
/* window not resizable */
win_x = win_handle:width-pixels + 2 when NOT win_handle:resize
win_y = win_handle:height-pixels + 21 when NOT win_handle:resize

/* window resizable */
win_x = win_handle:width-pixels + 8 when win_handle:resize
win_y = win_handle:height-pixels + 27 when win_handle:resize

/* other attributes */
win_y = win_y + 19 when win_handle:menu-bar <> ?
win_y = win_y + 25 when win_handle:status-area.

/*
I have not included a calculation for a 'message area'
simply because I have never used this feature in the
past
*/

assign
/* center window */
win_handle:x = (session:width-pixels - win_x) / 2
win_handle:y = (session:height-pixels - win_y) / 2
/* control size of window */
win_handle:max-width-pixels = win_handle:width-pixels
win_handle:min-width-pixels = win_handle:width-pixels
win_handle:max-height-pixels = win_handle:height-pixels
win_handle:min-height-pixels = win_handle:height-pixels.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
