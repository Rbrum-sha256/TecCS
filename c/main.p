
/*------------------------------------------------------------------------
    File        : main.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Roberty
    Created     : Mon Nov 03 09:39:21 BRT 2025
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */
DEFINE VARIABLE token AS CHARACTER NO-UNDO.
DEFINE VARIABLE id AS INTEGER NO-UNDO.

/* ***************************  Main Block  *************************** */
run c\Login.w(output token).
run c\Token.p(input token, output id).
run c\RestC.w(input token, input id).