&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
using Progress.Json.ObjectModel.ObjectModelParser.
USING OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder FROM PROPATH.
using Progress.Lang.*.
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE STREAM sJson. 
def temp-table ttjob
    field id       as int
    field titel    as char
    field area     as char
    field dsc      as char
    field state    as char
    field city     as char
    field salary   as decimal
    field companie as char
    .    
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
DEFINE VARIABLE user_id        AS character     NO-UNDO.  
    
DEFINE VARIABLE i              AS INTEGER       NO-UNDO.
DEFINE VARIABLE op-CRUD        AS integer       NO-UNDO.
DEFINE VARIABLE formatado      AS CHARACTER     NO-UNDO initial "@Email.com".
DEFINE VARIABLE log            AS LOGICAL       NO-UNDO initial false.

DEFINE VARIABLE metodo         AS CHARACTER     NO-UNDO initial "HTTP".
DEFINE VARIABLE host           AS CHARACTER     NO-UNDO initial "localhost".
DEFINE VARIABLE porta          AS CHARACTER     NO-UNDO initial "8080".
DEFINE VARIABLE rle            AS CHARACTER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frm-home
&Scoped-define BROWSE-NAME brw-vagas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttjob

/* Definitions for BROWSE brw-vagas                                     */
&Scoped-define FIELDS-IN-QUERY-brw-vagas ttjob   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-vagas   
&Scoped-define SELF-NAME brw-vagas
&Scoped-define QUERY-STRING-brw-vagas FOR EACH ttjob
&Scoped-define OPEN-QUERY-brw-vagas OPEN QUERY {&SELF-NAME} FOR EACH ttjob.
&Scoped-define TABLES-IN-QUERY-brw-vagas ttjob
&Scoped-define FIRST-TABLE-IN-QUERY-brw-vagas ttjob


/* Definitions for FRAME frm-V                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frm-V ~
    ~{&OPEN-QUERY-brw-vagas}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Aplicar Win-Client 
FUNCTION Fc-Aplicar RETURNS LOGICAL
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
DEFINE SUB-MENU m_Home 
       MENU-ITEM m_Login        LABEL "&Login"        
       MENU-ITEM m_Logout       LABEL "&Logout"       
       RULE
       MENU-ITEM m_Conectar     LABEL "&Conectar"     .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_Home         LABEL "&Home"         
       MENU-ITEM m_User         LABEL "&User"         
       MENU-ITEM m_job          LABEL "&Job"          .


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

DEFINE VARIABLE f-role AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "User", "1",
"Company", "2"
     SIZE 26 BY 1.19 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 10.

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

DEFINE BUTTON bt-sub 
     LABEL "" 
     SIZE 10 BY .71.

DEFINE VARIABLE f-sub AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1.1 NO-UNDO.

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
     SIZE 16.2 BY .62
     FGCOLOR 10  NO-UNDO.

DEFINE VARIABLE fi-sub AS CHARACTER FORMAT "X(20)":U 
     LABEL "Sub" 
      VIEW-AS TEXT 
     SIZE 20 BY .62
     FGCOLOR 10  NO-UNDO.

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

DEFINE BUTTON BUTTON-1 
     LABEL "Button 1" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fill 1" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fill 2" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brw-vagas FOR 
      ttjob SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brw-vagas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-vagas Win-Client _FREEFORM
  QUERY brw-vagas DISPLAY
      ttjob
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 99 BY 10
         TITLE "Browse 1" ROW-HEIGHT-CHARS .76 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frm-rodape
     f-sub AT ROW 1.95 COL 88 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     bt-sub AT ROW 3.14 COL 90.6 WIDGET-ID 10
     fi-host AT ROW 1.71 COL 9.8 COLON-ALIGNED WIDGET-ID 2
     fi-port AT ROW 2.81 COL 9.8 COLON-ALIGNED WIDGET-ID 4
     fi-role AT ROW 3.86 COL 9.8 COLON-ALIGNED WIDGET-ID 6
     fi-sub AT ROW 3.86 COL 33.4 COLON-ALIGNED WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 18.14
         SIZE 101.6 BY 3.86
         FONT 3 WIDGET-ID 700.

DEFINE FRAME frm-cabec
     bt-C AT ROW 1.24 COL 67 WIDGET-ID 32
     bt-R AT ROW 1.24 COL 75.6 WIDGET-ID 30
     bt-U AT ROW 1.24 COL 84.2 WIDGET-ID 2
     bt-D AT ROW 1.24 COL 92.8 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 101.6 BY 2.57 WIDGET-ID 800.

DEFINE FRAME frm-home
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 3.48
         SIZE 101.4 BY 14.67
         FONT 3 WIDGET-ID 400.

DEFINE FRAME frm-L
     f-UnomeL AT ROW 5.05 COL 31.8 NO-LABEL WIDGET-ID 10
     f-senhaL AT ROW 6.48 COL 29.8 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     bt-L AT ROW 8.14 COL 31.8 WIDGET-ID 20
     bt-VC AT ROW 8.14 COL 55.8 WIDGET-ID 22
     RECT-10 AT ROW 3.62 COL 25 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 101 BY 14.52
         FONT 3
         TITLE "" WIDGET-ID 500.

DEFINE FRAME frm-C
     f-host AT ROW 5.05 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     f-port AT ROW 6.48 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     f-role AT ROW 7.91 COL 39 NO-LABEL WIDGET-ID 12
     bt-con AT ROW 9.81 COL 44.6 WIDGET-ID 8
     RECT-8 AT ROW 2.62 COL 21 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 101 BY 14.52
         FONT 3
         TITLE "" WIDGET-ID 600.

DEFINE FRAME frm-U
     f-Unome AT ROW 2.76 COL 31 COLON-ALIGNED WIDGET-ID 6
     f-nome AT ROW 3.86 COL 31 COLON-ALIGNED WIDGET-ID 4
     f-senha AT ROW 4.91 COL 31 COLON-ALIGNED WIDGET-ID 8
     f-email AT ROW 6.81 COL 31 COLON-ALIGNED WIDGET-ID 10
     f-telefone AT ROW 8 COL 31 COLON-ALIGNED WIDGET-ID 12
     f-Form AT ROW 9.76 COL 31 COLON-ALIGNED WIDGET-ID 14
     f-exp AT ROW 10.95 COL 31 COLON-ALIGNED WIDGET-ID 16
     RECT-4 AT ROW 2.19 COL 4 WIDGET-ID 34
     RECT-5 AT ROW 9.33 COL 4 WIDGET-ID 36
     RECT-6 AT ROW 6.48 COL 4 WIDGET-ID 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 3.57
         SIZE 101.6 BY 14.52
         FONT 3 WIDGET-ID 300.

DEFINE FRAME frm-V
     FILL-IN-1 AT ROW 1.95 COL 6 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-2 AT ROW 1.95 COL 35 COLON-ALIGNED WIDGET-ID 6
     BUTTON-1 AT ROW 1.95 COL 85 WIDGET-ID 4
     brw-vagas AT ROW 4.1 COL 2 WIDGET-ID 1000
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 3.48
         SIZE 101.6 BY 14.71
         TITLE "Frame C" WIDGET-ID 900.


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
         WIDTH              = 101.2
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
/* SETTINGS FOR FRAME frm-cabec
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

ASSIGN 
       fi-sub:READ-ONLY IN FRAME frm-rodape        = TRUE.

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
/* SETTINGS FOR FRAME frm-V
                                                                        */
/* BROWSE-TAB brw-vagas BUTTON-1 frm-V */
ASSIGN 
       brw-vagas:RESIZABLE IN FRAME frm-V              = TRUE
       brw-vagas:ALLOW-COLUMN-SEARCHING IN FRAME frm-V = TRUE
       brw-vagas:COLUMN-RESIZABLE IN FRAME frm-V       = TRUE
       brw-vagas:ROW-RESIZABLE IN FRAME frm-V          = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Win-Client)
THEN Win-Client:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-vagas
/* Query rebuild information for BROWSE brw-vagas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttjob.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brw-vagas */
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


&Scoped-define FRAME-NAME frm-cabec
&Scoped-define SELF-NAME bt-C
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-C Win-Client
ON CHOOSE OF bt-C IN FRAME frm-cabec /* bt-C */
DO:
        IF rle eq "1" THEN 
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


&Scoped-define FRAME-NAME frm-cabec
&Scoped-define SELF-NAME bt-D
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-D Win-Client
ON CHOOSE OF bt-D IN FRAME frm-cabec /* bt-D */
DO:
        IF rle eq "1" THEN 
            Fc-Apagar().

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-L
&Scoped-define SELF-NAME bt-L
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-L Win-Client
ON CHOOSE OF bt-L IN FRAME frm-L /* Login */
DO:
        Fc-Login().  
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-cabec
&Scoped-define SELF-NAME bt-R
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-R Win-Client
ON CHOOSE OF bt-R IN FRAME frm-cabec /* bt-R */
DO:
        IF op-CRUD ne 2 THEN 
            Fc-Ler().
       
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-rodape
&Scoped-define SELF-NAME bt-sub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sub Win-Client
ON CHOOSE OF bt-sub IN FRAME frm-rodape
DO:
        assign 
            user_id = input frame frm-rodape f-sub.
        display user_id @ fi-sub 
            with frame frm-rodape.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-cabec
&Scoped-define SELF-NAME bt-U
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-U Win-Client
ON CHOOSE OF bt-U IN FRAME frm-cabec /* bt-U */
DO:
        IF rle eq "1" THEN 
            Fc-Atualizar().

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-L
&Scoped-define SELF-NAME bt-VC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-VC Win-Client
ON CHOOSE OF bt-VC IN FRAME frm-L /* Cadastrar */
DO:
        IF rle eq "1" THEN  
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


&Scoped-define SELF-NAME m_Home
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Home Win-Client
ON CHOOSE OF MENU m_Home /* Home */
DO:
        frame frm-home:hidden = false.

        frame frm-u:hidden = true. 
        frame frm-l:hidden = true.
        frame frm-c:hidden = true. 
  
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_job
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_job Win-Client
ON CHOOSE OF MENU-ITEM m_job /* Job */
DO:

        frame frm-u:hidden = true.   
        frame frm-home:hidden = true.
        frame frm-v:hidden = false.
        op-CRUD = 2.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Login
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Login Win-Client
ON CHOOSE OF MENU-ITEM m_Login /* Login */
DO:
        frame frm-L:hidden = false.
        frame frm-home:hidden = false.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Logout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Logout Win-Client
ON CHOOSE OF MENU-ITEM m_Logout /* Logout */
DO:           
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
   
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frm-home
&Scoped-define BROWSE-NAME brw-vagas
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
  ENABLE bt-C bt-R bt-U bt-D 
      WITH FRAME frm-cabec IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-cabec}
  DISPLAY f-UnomeL f-senhaL 
      WITH FRAME frm-L IN WINDOW Win-Client.
  ENABLE RECT-10 f-UnomeL f-senhaL bt-L bt-VC 
      WITH FRAME frm-L IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-L}
  VIEW FRAME frm-home IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-home}
  DISPLAY FILL-IN-1 FILL-IN-2 
      WITH FRAME frm-V IN WINDOW Win-Client.
  ENABLE FILL-IN-1 FILL-IN-2 BUTTON-1 brw-vagas 
      WITH FRAME frm-V IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-V}
  DISPLAY f-Unome f-nome f-senha f-email f-telefone f-Form f-exp 
      WITH FRAME frm-U IN WINDOW Win-Client.
  ENABLE RECT-4 RECT-5 RECT-6 f-Unome f-nome f-senha f-email f-telefone f-Form 
         f-exp 
      WITH FRAME frm-U IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-U}
  DISPLAY f-sub fi-host fi-port fi-role fi-sub 
      WITH FRAME frm-rodape IN WINDOW Win-Client.
  ENABLE f-sub bt-sub fi-host fi-port fi-role fi-sub 
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
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mudadeoperacao Win-Client 
PROCEDURE mudadeoperacao :
/*------------------------------------------------------------------------------
         Purpose:
         Notes:
        ------------------------------------------------------------------------------*/  
/*  case op-CRUD:
      when 1 then 
          do.
              assign
                    
                  bt-R:sensitive in frame frm-u = yes
                  bt-U:sensitive in frame frm-u = yes
                  bt-D:sensitive in frame frm-u = no.

              /* limpara a tela */
              clear frame frm-u.
  
          /* posiciona o cursor no primeiro campo da chave */
              //apply "entry" to {&List-2} in frame frm-u.

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
             // apply "entry" to {&List-4} in frame frm-u.

          end.
  
  end case.  
 
*/
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
    //Fc-Token().
    ASSIGN 
        oClient = ClientBuilder:Build():Client
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)).
    oUri:Path = "/users/" + user_id.

    oReq = RequestBuilder:Delete(oUri)
              :AddHeader("Authorization", "Bearer " + token)
              :AcceptJson()
              :Request.

    oResp = oClient:Execute(oReq).
    
    IF oResp:StatusCode = 200 THEN 
    DO:
        assign 
            mensagem = oJsonRespObj:GetCharacter("message").
        MESSAGE "Exclusão de dados efetuada com sucesso." skip mensagem 
            VIEW-AS ALERT-BOX INFO.
        RETURN TRUE.
    END.
    IF oResp:StatusCode eq 401 THEN 
    do:
        assign 
            mensagem = oJsonRespObj:GetCharacter("message").
        MESSAGE "Falha na Exclusão (Não Autorizado): " skip mensagem 
            VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    end.
    IF oResp:StatusCode eq 403 THEN 
    do:
        assign 
            mensagem = oJsonRespObj:GetCharacter("message").
        MESSAGE "Falha na Exclusão (Proibido): " skip mensagem 
            VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    end.

    IF oResp:StatusCode eq 404 THEN 
    do:
        assign 
            mensagem = oJsonRespObj:GetCharacter("message").
        MESSAGE "Falha na Exclusão (Não Encontrado): " skip  mensagem 
            VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    end.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Aplicar Win-Client 
FUNCTION Fc-Aplicar RETURNS LOGICAL
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
            assign 
                mensagem = oJsonRespObj:GetCharacter("message").
            MESSAGE "Cadastro efetuado com sucesso: " mensagem 
                VIEW-AS ALERT-BOX INFO.
            RETURN TRUE.
        end.
        IF oResp:StatusCode eq 409 THEN 
        do:
            assign 

                mensagem = oJsonRespObj:GetCharacter("message").
            MESSAGE "Falha no Cadastro (Conflito): " mensagem 
                VIEW-AS ALERT-BOX ERROR.

        end.
        IF oResp:StatusCode eq 422 THEN 
        do:
            assign 
                mensagem = oJsonRespObj:GetCharacter("message") 
                codigo   = oJsonRespObj:GetCharacter("code") 
                detalhes = oJsonRespObj:GetCharacter("details").
            MESSAGE "Falha na Atualização (Dados Inválidos): " mensagem SKIP codigo SKIP detalhes 
                VIEW-AS ALERT-BOX ERROR.
 
        end.
        ELSE 
        DO :
            MESSAGE "Erro desconhecido no Cadastro. Status: " oResp:StatusCode 
                VIEW-AS ALERT-BOX ERROR.


        END.
    end. 
    CATCH e AS Progress.Lang.Error:
        MESSAGE "Erro: " e:GetMessage(1) VIEW-AS ALERT-BOX.
    END CATCH.

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
    //Fc-Token().
    assign 
        oClient = ClientBuilder:Build():Client       
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)). /* URI("metodo", "dominio", "porta") */
    oUri:Path = "/users/" + user_id.  
        
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
            
            MESSAGE "Atualização de dados efetuada com sucesso." VIEW-AS ALERT-BOX INFO.

        end.
        IF oResp:StatusCode eq 401 THEN 
        do:
            assign 
                mensagem = oJsonRespObj:GetCharacter("message").
            MESSAGE "Falha na Atualização (Não Autorizado): " mensagem VIEW-AS ALERT-BOX ERROR.
    
        end.

        IF oResp:StatusCode eq 403 THEN 
        do:
            assign 
                mensagem = oJsonRespObj:GetCharacter("message").
            MESSAGE "Falha na Atualização (Proibido): " mensagem VIEW-AS ALERT-BOX ERROR.
       
        end.
        IF oResp:StatusCode eq 404 THEN 

        do:
            assign 
                mensagem = oJsonRespObj:GetCharacter("message").
            MESSAGE "Falha na Atualização (Não Encontrado): " mensagem 
                VIEW-AS ALERT-BOX ERROR.
        end.
        IF oResp:StatusCode eq 422 THEN 
        do:
            assign 
                mensagem = oJsonRespObj:GetCharacter("message") 
                codigo   = oJsonRespObj:GetCharacter("code") 
                detalhes = oJsonRespObj:GetCharacter("detail").

            MESSAGE "Falha no Cadastro (Dados Inválidos): " mensagem SKIP codigo SKIP detalhes 
                VIEW-AS ALERT-BOX ERROR.
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
            assign 
                mensagem = oJsonRespObj:GetCharacter("message").
            MESSAGE "Cadastro efetuado com sucesso: " mensagem 
                VIEW-AS ALERT-BOX INFO.
            RETURN TRUE.
        end.
        IF oResp:StatusCode eq 409 THEN 
        do:
            assign 

                mensagem = oJsonRespObj:GetCharacter("message").
            MESSAGE "Falha no Cadastro (Conflito): " mensagem 
                VIEW-AS ALERT-BOX ERROR.

        end.
        IF oResp:StatusCode eq 422 THEN 
        do:
            assign 
                mensagem = oJsonRespObj:GetCharacter("message") 
                codigo   = oJsonRespObj:GetCharacter("code") 
                detalhes = oJsonRespObj:GetCharacter("details").
            MESSAGE "Falha na Atualização (Dados Inválidos): " mensagem SKIP codigo SKIP detalhes 
                VIEW-AS ALERT-BOX ERROR.
 
        end.
        ELSE 
        DO :
            MESSAGE "Erro desconhecido no Cadastro. Status: " oResp:StatusCode 
                VIEW-AS ALERT-BOX ERROR.


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
        rle   = input frame frm-C f-role.
           
    frame frm-c:hidden = true.
    
    display host @ fi-host
        porta @ fi-port 
        IF rle eq "1" THEN "user" ELSE "companie" @ fi-role
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
    frame frm-v:hidden = true.
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
   // Fc-Token().
    ASSIGN 
        oClient = ClientBuilder:Build():Client
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)).
    oUri:Path = "/users/" + user_id.

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
                ttcli.education  = oJsonRespObj:GetCharacter("education").
            MESSAGE "Leitura de dados efetuada com sucesso." VIEW-AS ALERT-BOX INFO.
        end.
        IF oResp:StatusCode eq 401 THEN 
        do:          
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
                . 
            MESSAGE mensagem
                VIEW-AS ALERT-BOX.
        end.
        IF oResp:StatusCode eq 403 THEN 
        do:         
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
                . 
            MESSAGE mensagem
                VIEW-AS ALERT-BOX.
        end.
        IF oResp:StatusCode eq 404 THEN 
        do:
            assign 
                mensagem = oJsonRespObj:GetCharacter("message")    
                . 
            MESSAGE mensagem
                VIEW-AS ALERT-BOX.
        end.
    end.    
    ELSE 
    DO:
        MESSAGE "Erro desconhecido na Leitura. Status:" oResp:StatusCode 
            VIEW-AS ALERT-BOX ERROR.

    END.
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
                expira_em = oJsonRespObj:GetInt64("expires_in").
                
            MESSAGE "Login efetuado com sucesso!" 
                VIEW-AS ALERT-BOX .
            Fc-token().
            IF rle eq "1" THEN
            do:
                frame frm-home:hidden = true.
                frame frm-U:hidden = false.
            end.
        end.
        ELSE 
        DO :            
            assign
                mensagem = oJsonRespObj:GetCharacter("message").

            MESSAGE "Falha no Login: " mensagem 
                VIEW-AS ALERT-BOX ERROR.

        end.  
    end.
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
    //Fc-Token().
    ASSIGN 
        oClient   = ClientBuilder:Build():Client
        oUri      = URI:Parse(metodo + "://" + host + ":" + STRING(porta)) /* URI("metodo", "dominio", "porta") */
        oUri:Path = "/logout/" + user_id .

    oReq = RequestBuilder:Post(oUri)
              :AddHeader("Authorization", "Bearer " + token)
              :AcceptJson()
              :Request.

    oResp = oClient:Execute(oReq).

    IF oResp:StatusCode = 200 THEN 
    DO:
        MESSAGE "Logout efetuado." VIEW-AS ALERT-BOX INFO.
        ASSIGN 
            mensagem = oJsonRespObj:GetCharacter("message")
            token    = "".
        RETURN TRUE.
    END.
    ELSE 
    DO:
        assign  
            mensagem = oJsonRespObj:GetCharacter("message").
        MESSAGE "Falha no logout. Código: "skip mensagem 
            VIEW-AS ALERT-BOX ERROR.
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
    DEFINE VARIABLE iSep1     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSep2     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cPayload  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE mDecoded  AS MEMPTR    NO-UNDO.
    DEFINE VARIABLE lcDecoded AS LONGCHAR  NO-UNDO.
    DEFINE VARIABLE id        AS CHARACTER NO-UNDO.


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
    user_id = substring(lcDecoded,8,1) .
    id = lcDecoded .
    display user_id @ fi-sub 
        with frame frm-rodape.
    MESSAGE id
        VIEW-AS ALERT-BOX.
/*DEFINE VARIABLE payload         AS CHARACTER NO-UNDO.
DEFINE VARIABLE oJsonPayload    AS JsonObject NO-UNDO.
DEFINE VARIABLE myParser         as ObjectModelParser no-undo.   
DEFINE VARIABLE iSep1           AS INTEGER   NO-UNDO.
DEFINE VARIABLE iSep2           AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPayload        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mDecoded        AS MEMPTR    NO-UNDO.
DEFINE VARIABLE lcDecoded       AS LONGCHAR NO-UNDO.
   
myParser = NEW ObjectModelParser().
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
    
/* Converte o payload decodificado para JsonObject e extrai o 'sub' */
oJsonPayload = CAST(myParser:Parse(lcDecoded),JsonObject).
ASSIGN user_id = oJsonPayload:GetInteger("sub"). /* ARMAZENA O ID */
    
/* Remove a mensagem de debug desnecessária */
 MESSAGE user_id VIEW-AS ALERT-BOX. 

RETURN TRUE.*/
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

