&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME Win-Client
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Win-Client 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

BLOCK-LEVEL ON ERROR UNDO, THROW.
     
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.*.
using OpenEdge.Net.URI.

USING OpenEdge.Core.Memptr FROM PROPATH.
 USING Progress.Json.ObjectModel.*.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
USING OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder FROM PROPATH.
using Progress.Lang.*.
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE STREAM sJson.    
def temp-table ttCli
    field name       as char
    field username   as char
    field password   as char
    field email      as char
    field phone      as char
    field experience as char
    field education  as char
    .   
/* Local Variable Definition ---                                        */
def    var      oClient        as IHttpClient   no-undo.
def    var      oUri           as URI           no-undo.
def    var      oReq           as IHttpRequest  no-undo.
def    var      oResp          as IHttpResponse no-undo.
def    var      oCreds         as Credentials   no-undo.
      
def    var      oJsonRespObj   as JsonObject    no-undo.        
def    var      oJsonRespArray as JsonArray     no-undo.
def    var      oJsonObj       as JsonObject    no-undo.
def    var      oJsonArray     as JsonArray     no-undo.

DEFINE VARIABLE token          AS CHARACTER     NO-UNDO.
DEFINE VARIABLE expira_em      AS INT64         NO-UNDO.  
DEFINE VARIABLE mensagem       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE codigo         AS CHARACTER     NO-UNDO.
DEFINE VARIABLE detalhes       AS CHARACTER     NO-UNDO.
      
DEFINE VARIABLE i              AS INTEGER       NO-UNDO.
DEFINE VARIABLE op-CRUD        AS integer       NO-UNDO.
DEFINE VARIABLE formatado      AS CHARACTER     NO-UNDO initial "@Email.com".
DEFINE VARIABLE log            AS LOGICAL       NO-UNDO initial false.

DEFINE VARIABLE metodo         AS CHARACTER     NO-UNDO initial "HTTP".
DEFINE VARIABLE host           AS CHARACTER     NO-UNDO initial "localhost".
DEFINE VARIABLE porta          AS CHARACTER     NO-UNDO initial "8080".
DEFINE VARIABLE role           AS CHARACTER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frm-home

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-2 f-Unome 
&Scoped-define List-4 f-exp 
&Scoped-define List-6 f-Unome f-nome f-senha f-email f-telefone f-Form ~
f-exp 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Apagar Win-Client 
FUNCTION Fc-Apagar RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Atualizar Win-Client 
FUNCTION Fc-Atualizar RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Cadastrar Win-Client 
FUNCTION Fc-Cadastrar RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Conectar Win-Client 
FUNCTION Fc-Conectar RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Inicia Win-Client 
FUNCTION Fc-Inicia RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Ler Win-Client 
FUNCTION Fc-Ler RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Login Win-Client 
FUNCTION Fc-Login RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Logout Win-Client 
FUNCTION Fc-Logout RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Token Win-Client 
FUNCTION Fc-Token RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Trata Win-Client 
FUNCTION Fc-Trata RETURNS LOGICAL
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE Win-Client AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Navegation 
       MENU-ITEM m_Home         LABEL "&Home"         
       MENU-ITEM m_User         LABEL "&User"         
       MENU-ITEM m_Login        LABEL "&Login"        
       RULE
       MENU-ITEM m_Logout       LABEL "&Logout"       .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_Navegation   LABEL "&Navegation"   
       MENU-ITEM m_Conectar     LABEL "&Conectar"     .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-con 
     LABEL "Conectar" 
     SIZE 15 BY 1.14
     FGCOLOR 9 FONT 3.

DEFINE VARIABLE f-host AS CHARACTER FORMAT "x(20)":U INITIAL "HOST" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 TOOLTIP "host"
     FGCOLOR 9 FONT 3 NO-UNDO.

DEFINE VARIABLE f-port AS CHARACTER FORMAT "x(10)":U INITIAL "PORT" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     FGCOLOR 9 FONT 3 NO-UNDO.

DEFINE VARIABLE f-role AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "User", 1,
"Company", 2
     SIZE 26 BY 1.19 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 10.

DEFINE BUTTON bt-L 
     LABEL "Login" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bt-VC 
     LABEL "Cadastrar" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE f-senhaL AS CHARACTER FORMAT "X(256)":U INITIAL "Senha" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-UnomeL AS CHARACTER FORMAT "X(30)":U INITIAL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 7.38.

DEFINE VARIABLE fi-host AS CHARACTER FORMAT "X(15)":U 
     LABEL "host" 
      VIEW-AS TEXT 
     SIZE 30.2 BY .62
     FGCOLOR 10  NO-UNDO.

DEFINE VARIABLE fi-port AS CHARACTER FORMAT "X(20)":U 
     LABEL "port" 
      VIEW-AS TEXT 
     SIZE 20 BY .62
     FGCOLOR 10  NO-UNDO.

DEFINE VARIABLE fi-role AS CHARACTER FORMAT "X(20)":U 
     LABEL "role" 
      VIEW-AS TEXT 
     SIZE 20 BY .62
     FGCOLOR 10  NO-UNDO.

DEFINE BUTTON bt-C 
     LABEL "bt-C" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-D 
     LABEL "bt-D" 
     SIZE 8 BY 1.91 TOOLTIP "Elimina Registro".

DEFINE BUTTON bt-R 
     LABEL "bt-R" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-U 
     LABEL "bt-U" 
     SIZE 8 BY 1.91.

DEFINE VARIABLE f-email AS CHARACTER FORMAT "X(30)":U 
     LABEL "E-mail" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-exp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Experiencia" 
     VIEW-AS FILL-IN 
     SIZE 59.8 BY 2.14
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Form AS CHARACTER FORMAT "X(256)":U 
     LABEL "Formacao" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .95
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-nome AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-senha AS CHARACTER FORMAT "X(256)":U 
     LABEL "Senha" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-telefone AS CHARACTER FORMAT "+55(x(2)) 9 x(4)-x(4)":U 
     LABEL "Telefone" 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Unome AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nome de Usuario" 
     VIEW-AS FILL-IN 
     SIZE 53.4 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 4.29.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 4.05.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 2.86.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 2.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frm-rodape
     fi-host AT ROW 1.71 COL 9.8 COLON-ALIGNED WIDGET-ID 2
     fi-port AT ROW 2.81 COL 9.8 COLON-ALIGNED WIDGET-ID 4
     fi-role AT ROW 3.86 COL 9.8 COLON-ALIGNED WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 18.14
         SIZE 101.6 BY 3.86
         FONT 3 WIDGET-ID 700.

DEFINE FRAME frm-home
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 101.6 BY 17.14
         FONT 3 WIDGET-ID 400.

DEFINE FRAME frm-L
     f-UnomeL AT ROW 6 COL 31.8 NO-LABEL WIDGET-ID 10
     f-senhaL AT ROW 7.43 COL 29.8 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     bt-L AT ROW 9.1 COL 31.8 WIDGET-ID 20
     bt-VC AT ROW 9.1 COL 55.8 WIDGET-ID 22
     RECT-10 AT ROW 4.57 COL 25 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 101 BY 16
         FONT 3 WIDGET-ID 500.

DEFINE FRAME frm-C
     f-host AT ROW 7.43 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     f-port AT ROW 8.86 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     f-role AT ROW 10.29 COL 38 NO-LABEL WIDGET-ID 12
     bt-con AT ROW 12.19 COL 43.6 WIDGET-ID 8
     RECT-8 AT ROW 5.29 COL 21 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 101 BY 15.95
         FONT 3 WIDGET-ID 600.

DEFINE FRAME frm-U
     bt-C AT ROW 1.24 COL 60.4 WIDGET-ID 32
     bt-R AT ROW 1.24 COL 69 WIDGET-ID 30
     bt-U AT ROW 1.24 COL 77.6 WIDGET-ID 2
     bt-D AT ROW 1.24 COL 86.2 WIDGET-ID 28
     f-Unome AT ROW 5.38 COL 31 COLON-ALIGNED WIDGET-ID 6
     f-nome AT ROW 6.48 COL 31 COLON-ALIGNED WIDGET-ID 4
     f-senha AT ROW 7.52 COL 31 COLON-ALIGNED WIDGET-ID 8
     f-email AT ROW 9.43 COL 31 COLON-ALIGNED WIDGET-ID 10
     f-telefone AT ROW 10.62 COL 31 COLON-ALIGNED WIDGET-ID 12
     f-Form AT ROW 12.38 COL 31 COLON-ALIGNED WIDGET-ID 14
     f-exp AT ROW 13.57 COL 31 COLON-ALIGNED WIDGET-ID 16
     RECT-4 AT ROW 4.81 COL 4 WIDGET-ID 34
     RECT-5 AT ROW 11.95 COL 4 WIDGET-ID 36
     RECT-6 AT ROW 9.1 COL 4 WIDGET-ID 38
     RECT-7 AT ROW 1 COL 1.2 WIDGET-ID 40
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 102 BY 17.1
         FONT 3 WIDGET-ID 300.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW Win-Client ASSIGN
         HIDDEN             = YES
         TITLE              = "Client"
         HEIGHT             = 21.1
         WIDTH              = 101.8
         MAX-HEIGHT         = 22.91
         MAX-WIDTH          = 190.6
         VIRTUAL-HEIGHT     = 22.91
         VIRTUAL-WIDTH      = 190.6
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 3
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Win-Client
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME frm-C:FRAME = FRAME frm-home:HANDLE
       FRAME frm-L:FRAME = FRAME frm-home:HANDLE.

/* SETTINGS FOR FRAME frm-C
                                                                        */
/* SETTINGS FOR FRAME frm-home
   FRAME-NAME                                                           */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME frm-C:MOVE-BEFORE-TAB-ITEM (FRAME frm-L:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME frm-L
                                                                        */
/* SETTINGS FOR FILL-IN f-UnomeL IN FRAME frm-L
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME frm-rodape
                                                                        */
ASSIGN 
       fi-host:READ-ONLY IN FRAME frm-rodape        = TRUE.

ASSIGN 
       fi-port:READ-ONLY IN FRAME frm-rodape        = TRUE.

ASSIGN 
       fi-role:READ-ONLY IN FRAME frm-rodape        = TRUE.

/* SETTINGS FOR FRAME frm-U
                                                                        */
/* SETTINGS FOR FILL-IN f-email IN FRAME frm-U
   6                                                                    */
/* SETTINGS FOR FILL-IN f-exp IN FRAME frm-U
   4 6                                                                  */
/* SETTINGS FOR FILL-IN f-Form IN FRAME frm-U
   6                                                                    */
/* SETTINGS FOR FILL-IN f-nome IN FRAME frm-U
   6                                                                    */
/* SETTINGS FOR FILL-IN f-senha IN FRAME frm-U
   6                                                                    */
/* SETTINGS FOR FILL-IN f-telefone IN FRAME frm-U
   6                                                                    */
/* SETTINGS FOR FILL-IN f-Unome IN FRAME frm-U
   2 6                                                                  */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Win-Client)
THEN Win-Client:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Win-Client
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Win-Client Win-Client
ON END-ERROR OF Win-Client /* Client */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE 
    DO:
        /* This case occurs when the user presses the "Esc" key.
           In a persistently run window, just ignore this.  If we did not, the
           application would exit. */
        IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Win-Client Win-Client
ON WINDOW-CLOSE OF Win-Client /* Client */
DO:
        /* This event will close the window and terminate the procedure.  */
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-U
&Scoped-define SELF-NAME bt-C
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-C Win-Client
ON CHOOSE OF bt-C IN FRAME frm-U /* bt-C */
DO:
        assign 
            op-CRUD = 3.
        Fc-Cadastrar().
     
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-C
&Scoped-define SELF-NAME bt-con
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-con Win-Client
ON CHOOSE OF bt-con IN FRAME frm-C /* Conectar */
DO:
        Fc-Conectar().
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-U
&Scoped-define SELF-NAME bt-D
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-D Win-Client
ON CHOOSE OF bt-D IN FRAME frm-U /* bt-D */
DO:
        assign 
            op-CRUD = 4.
        Fc-Apagar(). 
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-L
&Scoped-define SELF-NAME bt-L
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-L Win-Client
ON CHOOSE OF bt-L IN FRAME frm-L /* Login */
DO:
        assign 
            op-CRUD = 5. 
        Fc-Login().  
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-U
&Scoped-define SELF-NAME bt-R
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-R Win-Client
ON CHOOSE OF bt-R IN FRAME frm-U /* bt-R */
DO:
        assign 
            op-CRUD = 2.
        Fc-Ler().
       
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-U
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-U Win-Client
ON CHOOSE OF bt-U IN FRAME frm-U /* bt-U */
DO:
        assign 
            op-CRUD = 3.
        Fc-Cadastrar().
     
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-L
&Scoped-define SELF-NAME bt-VC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-VC Win-Client
ON CHOOSE OF bt-VC IN FRAME frm-L /* Cadastrar */
DO:
        assign 
            op-CRUD = 1. 
        Fc-Cadastrar().
        frame frm-u:hidden = false.
        frame frm-L:hidden = true.
        frame frm-C:hidden = true.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Conectar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Conectar Win-Client
ON CHOOSE OF MENU-ITEM m_Conectar /* Conectar */
DO:
        frame frm-C:hidden = false.
        frame frm-home:hidden = false.
   
   
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Login
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Login Win-Client
ON CHOOSE OF MENU-ITEM m_Login /* Login */
DO:
        frame frm-L:hidden = false.
        frame frm-u:hidden = true.
        frame frm-C:hidden = true.
        frame frm-home:hidden = false.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Logout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Logout Win-Client
ON CHOOSE OF MENU-ITEM m_Logout /* Logout */
DO:
        assign 
            op-CRUD = 6.
        Fc-Logout().
        Fc-Inicia() .
  
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_User
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_User Win-Client
ON CHOOSE OF MENU-ITEM m_User /* User */
DO:
        frame frm-u:hidden = false.    
        frame frm-home:hidden = true.
        frame frm-L:hidden = true.
   
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-home
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Win-Client 


/* ***************************  Main Block  *************************** */
run c\center.p({&WINDOW-NAME}).
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
    RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    Fc-Inicia() .
    display host @ fi-host
        porta @ fi-port 
        with frame frm-rodape.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Win-Client  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Win-Client)
  THEN DELETE WIDGET Win-Client.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Win-Client  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY f-host f-port f-role 
      WITH FRAME frm-C IN WINDOW Win-Client.
  ENABLE RECT-8 f-host f-port f-role bt-con 
      WITH FRAME frm-C IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-C}
  VIEW FRAME frm-home IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-home}
  DISPLAY f-UnomeL f-senhaL 
      WITH FRAME frm-L IN WINDOW Win-Client.
  ENABLE RECT-10 f-UnomeL f-senhaL bt-L bt-VC 
      WITH FRAME frm-L IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-L}
  DISPLAY f-Unome f-nome f-senha f-email f-telefone f-Form f-exp 
      WITH FRAME frm-U IN WINDOW Win-Client.
  ENABLE RECT-4 RECT-5 RECT-6 RECT-7 bt-C bt-R bt-U bt-D f-Unome f-nome f-senha 
         f-email f-telefone f-Form f-exp 
      WITH FRAME frm-U IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-U}
  DISPLAY fi-host fi-port fi-role 
      WITH FRAME frm-rodape IN WINDOW Win-Client.
  ENABLE fi-host fi-port fi-role 
      WITH FRAME frm-rodape IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-rodape}
  VIEW Win-Client.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraregistro Win-Client 
PROCEDURE mostraregistro :
/*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    Fc-Trata().
    apply "entry" to {&List-4} in frame frm-u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mudadeoperacao Win-Client 
PROCEDURE mudadeoperacao :
/*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/  
    case op-CRUD:
        when 1 then 
            do.
                assign
                    
                    bt-R:sensitive in frame frm-u = yes
                    bt-U:sensitive in frame frm-u = yes
                    bt-D:sensitive in frame frm-u = no.

                /* limpara a tela */
                clear frame frm-u.
  
                /* posiciona o cursor no primeiro campo da chave */
                apply "entry" to {&List-2} in frame frm-u.

            end.
        when 3 or 
        when 4 then 
            do.
                assign
                   
                    bt-R:sensitive in frame frm-u = no
                    bt-U:sensitive in frame frm-u = yes
                    bt-D:sensitive in frame frm-u = yes.

                /* desabilita os campos da chave */ 
                   
                /* posiciona o cursor no primeiro campo alteravel */
                apply "entry" to {&List-4} in frame frm-u.

            end.
  
    end case.  
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Apagar Win-Client 
FUNCTION Fc-Apagar RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    Fc-Token().
    ASSIGN 
        oClient = ClientBuilder:Build():Client
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)).
    oUri:Path = "/users/".

    oReq = RequestBuilder:Delete(oUri)
              :AddHeader("Authorization", "Bearer " + token)
              :AcceptJson()
              :Request.

    oResp = oClient:Execute(oReq).

    IF oResp:StatusCode = 200 THEN 
        DO:
            assign 
                    mensagem = oJsonRespObj:GetCharacter("message")    
                . 
        END.
    IF oResp:StatusCode eq 401 THEN 
        do:
           
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 403 THEN 
        do:
          
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 404 THEN 
        do:
          
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
    ELSE 
    DO:
        MESSAGE "Erro ao excluir cliente. Status:" oResp:StatusCode VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Atualizar Win-Client 
FUNCTION Fc-Atualizar RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    empty temp-table ttcli.
    Fc-Token().
    assign 
        oClient = ClientBuilder:Build():Client       
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)). /* URI("metodo", "dominio", "porta") */
    oUri:Path = "/users/".  
        
    /* Cria objeto Json e popula ele */
    oJsonObj = NEW JsonObject().
    oJsonObj:Add("name", input frame frm-u f-nome).
    oJsonObj:Add("password", input frame frm-u f-Senha).
    oJsonObj:Add("email", input frame frm-u f-email + formatado).
    oJsonObj:Add("phone", input frame frm-u f-telefone).
    oJsonObj:Add("experience", input frame frm-u f-exp).
    oJsonObj:Add("education", input frame frm-u f-Form).

    /* Faz a requisicao utilizando POST */
    oReq  = RequestBuilder:Patch(oUri, oJsonObj)
            :AddHeader("Authorization", "Bearer " + token)
            :AcceptJson()
            :Request.
    oResp = oClient:Execute(oReq).

    /* valida o tipo de retorno, se for Json processa normalmente */
    if type-of(oResp:Entity, JsonObject) then 
    do:
        oJsonRespObj = cast(oResp:Entity, JsonObject).
        oJsonArray = oJsonRespArray.  
        
        IF oResp:StatusCode eq 200 THEN 
        do:
           create ttcli.
            assign 
            ttcli.name       = oJsonRespObj:getCharacter("name")    
            ttcli.email      = oJsonRespObj:getCharacter("email")
            ttcli.password   = oJsonRespObj:getCharacter("password")
            ttcli.phone      = oJsonRespObj:getCharacter("phone")
            ttcli.experience = oJsonRespObj:getCharacter("experience")
            ttcli.education  = oJsonRespObj:getCharacter("education").  
            . 
        end. 
        IF oResp:StatusCode eq 401 THEN 
        do:
           
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 403 THEN 
        do:
          
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 404 THEN 
        do:
          
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 422 THEN 
        do:
           /* Mostra o total de registros retornados */
            assign 
                mensagem = oJsonRespObj:GetCharacter("message") 
                codigo   = oJsonRespObj:GetCharacter("code") 
                detalhes = oJsonRespObj:GetCharacter("detail")  
            . 
        end.                      
    end.
    CATCH e AS Progress.Lang.Error:
        MESSAGE "Erro: " e:GetMessage(1) VIEW-AS ALERT-BOX.
    END CATCH.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Cadastrar Win-Client 
FUNCTION Fc-Cadastrar RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    assign 
        oClient = ClientBuilder:Build():Client   
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)). /* URI("metodo", "dominio", "porta") */
    oUri:Path = "/users".  
        
    /* Cria objeto Json e popula ele */
    oJsonObj = NEW JsonObject().
    oJsonObj:Add("name", input frame frm-u f-nome).
    oJsonObj:Add("username", input frame frm-u f-Unome).
    oJsonObj:Add("password", input frame frm-u f-Senha).
    oJsonObj:Add("email", input frame frm-u f-email + formatado).
    oJsonObj:Add("phone", input frame frm-u f-telefone).
    oJsonObj:Add("experience", input frame frm-u f-exp).
    oJsonObj:Add("education", input frame frm-u f-Form).

  
    /* Faz a requisicao utilizando POST */
    oReq  = RequestBuilder:Post(oUri, oJsonObj)
            :AcceptJson()
            :Request.
    oResp = oClient:Execute(oReq).
    
    if type-of(oResp:Entity, JsonObject) then 
    do:
        oJsonRespObj = cast(oResp:Entity, JsonObject).
        oJsonArray = oJsonRespArray.  
        
        IF oResp:StatusCode eq 201 THEN 
        do:
           /* Mostra o total de registros retornados */
            assign 
                mensagem = oJsonRespObj:GetCharacter("message") 
                codigo   = oJsonRespObj:GetCharacter("code") 
                detalhes = oJsonRespObj:GetCharacter("detail")  
            . 
        end. 
        IF oResp:StatusCode eq 409 THEN 
        do:
           /* Mostra o total de registros retornados */
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 422 THEN 
        do:
           /* Mostra o total de registros retornados */
            assign 
                mensagem = oJsonRespObj:GetCharacter("message") 
                codigo   = oJsonRespObj:GetCharacter("code") 
                detalhes = oJsonRespObj:GetCharacter("detail")  
            . 
        end.
        ELSE DO :
                 MESSAGE "outra coisa"
                 VIEW-AS ALERT-BOX. 
        END.                   
    end. 
    CATCH e AS Progress.Lang.Error:
        MESSAGE "Erro: " e:GetMessage(1) VIEW-AS ALERT-BOX.
    END CATCH.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Conectar Win-Client 
FUNCTION Fc-Conectar RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    assign 
        porta = input frame frm-C f-port
        host  = input frame frm-C f-host 
        role  = input frame frm-C f-role.
           
    frame frm-c:hidden = true.
    
    display host @ fi-host
        porta @ fi-port 
        role @ fi-role
        with frame frm-rodape.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Inicia Win-Client 
FUNCTION Fc-Inicia RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    frame frm-c:hidden = true.
    frame frm-u:hidden = true.
    frame frm-l:hidden = true.
    //frame frm-trab:hidden = true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Ler Win-Client 
FUNCTION Fc-Ler RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    Fc-Token().
    ASSIGN 
        oClient = ClientBuilder:Build():Client
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)).
    oUri:Path = "/users/".

    oReq = RequestBuilder:get(oUri)
              :AddHeader("Authorization", "Bearer " + token)
              :AcceptJson()
              :Request.

    oResp = oClient:Execute(oReq).

    if type-of(oResp:Entity, JsonObject) then 
    do:
        oJsonRespObj = cast(oResp:Entity, JsonObject).
        oJsonArray = oJsonRespArray.  
        
        IF oResp:StatusCode eq 200 THEN 
        do:
            CREATE ttcli.
            assign 
                ttcli.name       = oJsonRespObj:GetCharacter("name")
                ttcli.username   = oJsonRespObj:GetCharacter("username")
                ttcli.email      = oJsonRespObj:GetCharacter("email")
                ttcli.password   = oJsonRespObj:GetCharacter("password")
                ttcli.phone      = oJsonRespObj:GetCharacter("phone")
                ttcli.experience = oJsonRespObj:GetCharacter("experience")
                ttcli.education  = oJsonRespObj:GetCharacter("education")
                .              
        end.
        IF oResp:StatusCode eq 401 THEN 
        do:
           
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 403 THEN 
        do:
          
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
        IF oResp:StatusCode eq 404 THEN 
        do:
          
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
            . 
        end.
    end.
    ELSE 
    DO:
        MESSAGE "Falha ao ler cliente. Status:" oResp:StatusCode VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.
    disp mensagem. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Login Win-Client 
FUNCTION Fc-Login RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    assign 
        oClient = ClientBuilder:Build():Client       
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)). /* URI("metodo", "dominio", "porta") */
        oUri:Path = "/login".  
        
    /* Cria objeto Json e popula ele */
    oJsonObj = NEW JsonObject().
    oJsonObj:Add("username", input frame frm-L f-UnomeL).
    oJsonObj:Add("password", input frame frm-L f-SenhaL).
 
  
    /* Faz a requisicao utilizando POST */
    oReq  = RequestBuilder:Post(oUri, oJsonObj)
            :AcceptJson()
            :Request.     
             
    oResp = oClient:Execute(oReq).
    
    
    /* valida o tipo de retorno*/
    if type-of(oResp:Entity, JsonObject) then 
    do:
        oJsonRespObj = cast(oResp:Entity, JsonObject).
        oJsonArray = oJsonRespArray.  
        
        IF oResp:StatusCode eq 200 THEN 
        do: 
           assign
            Token     = oJsonRespObj:GetCharacter("token")
            expira_em = oJsonRespObj:GetInt64("expires_in")
            log = true.
        end.
        ELSE DO :
           assign   
            mensagem  = oJsonRespObj:GetCharacter("message")
           .       
        END. 
        
    end.
    disp mensagem. 
    
    CATCH e AS Progress.Lang.Error:
        MESSAGE "Erro: " e:GetMessage(1) VIEW-AS ALERT-BOX.
    END CATCH.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Logout Win-Client 
FUNCTION Fc-Logout RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/      
    Fc-Token().
    ASSIGN 
        oClient   = ClientBuilder:Build():Client
        oUri      = URI:Parse(metodo + "://" + host + ":" + STRING(porta)) /* URI("metodo", "dominio", "porta") */
        oUri:Path = "/logout".

    oReq = RequestBuilder:Post(oUri)
              :AddHeader("Authorization", "Bearer " + token)
              :AcceptJson()
              :Request.

    oResp = oClient:Execute(oReq).

    IF oResp:StatusCode = 200 THEN 
    DO:
        MESSAGE "Logout efetuado." VIEW-AS ALERT-BOX INFO.
        ASSIGN 
            token = "".
        RETURN TRUE.
    END.
    ELSE 
    DO:
        MESSAGE "Falha no logout. C�digo: " oResp:StatusCode VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Token Win-Client 
FUNCTION Fc-Token RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE payload   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iSep1     AS INTEGER NO-UNDO.
    DEFINE VARIABLE iSep2     AS INTEGER NO-UNDO.
    DEFINE VARIABLE cPayload  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE mDecoded  AS MEMPTR NO-UNDO.
    DEFINE VARIABLE lcDecoded AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE id AS CHARACTER NO-UNDO.
   
    
    iSep1 = INDEX(token, ".").
    iSep2 = INDEX(token, ".", iSep1 + 1).
    cPayload = SUBSTRING(token, iSep1 + 1, iSep2 - iSep1 - 1).
    
    /* base64url -> base64 */
    cPayload = REPLACE(REPLACE(cPayload, "-", "+"), "_", "/").
    DO WHILE (LENGTH(cPayload) MOD 4) <> 0:
        cPayload = cPayload + "=".
    END.
    
    /* decodifica */
    mDecoded = BASE64-DECODE(cPayload).
    COPY-LOB FROM mDecoded TO lcDecoded.
    id = lcDecoded.
    MESSAGE id
    VIEW-AS ALERT-BOX.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Trata Win-Client 
FUNCTION Fc-Trata RETURNS LOGICAL
    ():
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    /** Abaixo regras de negocio e tratamentos necessarios **/
    for each ttcli no-lock:
        disp ttcli.name @ {&List-6}
            with frame frm-u.    
    end.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

