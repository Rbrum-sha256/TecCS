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
using Progress.Json.ObjectModel.ObjectModelParser.
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
def temp-table ttCom
    field name     as char
    field business as char
    field username as char
    field password as char
    field street   as char
    field number   as char
    field city     as char
    field state    as char
    field email    as char
    field phone    as char
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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 RECT-14 f-Titulo f-area ~
f-salario f-dsc f-Cid f-est 
&Scoped-Define DISPLAYED-OBJECTS f-Titulo f-area f-salario f-dsc f-Cid ~
f-est 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-2 f-Titulo f-Unome f-Titulo 
&Scoped-define List-4 f-dsc f-cidade f-dsc f-est 
&Scoped-define List-6 f-Titulo f-Unome f-area f-nome f-Titulo f-salario ~
f-senha f-area f-dsc f-Cid f-rua f-salario f-cidade f-dsc f-Est f-Cid f-est ~
f-email f-est f-telefone 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Ap Win-Client 
FUNCTION Fc-Ap RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Apagar Win-Client 
FUNCTION Fc-Apagar RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-At Win-Client 
FUNCTION Fc-At RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Atualizar Win-Client 
FUNCTION Fc-Atualizar RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-CA Win-Client 
FUNCTION Fc-CA RETURNS LOGICAL
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Fc-Le Win-Client 
FUNCTION Fc-Le RETURNS LOGICAL
    (  ) FORWARD.

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
       MENU-ITEM m_Companie     LABEL "&Companie"     .


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

DEFINE BUTTON bt-ant 
     LABEL "<" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-C 
     LABEL "bt-C" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-D 
     LABEL "bt-D" 
     SIZE 8 BY 1.91 TOOLTIP "Elimina Registro".

DEFINE BUTTON bt-pri 
     LABEL "<<" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-pro 
     LABEL ">" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-R 
     LABEL "bt-R" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-U 
     LABEL "bt-U" 
     SIZE 8 BY 1.91.

DEFINE BUTTON bt-ult 
     LABEL ">>" 
     SIZE 8 BY 1.91 TOOLTIP "Elimina Registro".

DEFINE VARIABLE f-cidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cidade" 
     VIEW-AS FILL-IN 
     SIZE 59.8 BY .95
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-email AS CHARACTER FORMAT "X(30)":U 
     LABEL "E-mail" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 59.8 BY .95
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-nome AS CHARACTER FORMAT "X(256)":U 
     LABEL "Empresa" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-num AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Num" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1.1 NO-UNDO.

DEFINE VARIABLE f-rua AS CHARACTER FORMAT "X(256)":U 
     LABEL "Rua" 
     VIEW-AS FILL-IN 
     SIZE 38.8 BY .95
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

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 3.38.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 4.29.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 4.05.

DEFINE VARIABLE f-area AS CHARACTER FORMAT "X(256)":U 
     LABEL "Area" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Cid AS CHARACTER FORMAT "X(30)":U 
     LABEL "Cidade" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-dsc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descricao" 
     VIEW-AS FILL-IN 
     SIZE 59.8 BY 2.14
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-salario AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Saario" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Titulo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Titulo" 
     VIEW-AS FILL-IN 
     SIZE 53.4 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 4.29.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 4.05.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.86.

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

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 4.29.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 4.05.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.86.


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
     bt-pri AT ROW 1.24 COL 3 WIDGET-ID 34
     bt-ant AT ROW 1.24 COL 11.6 WIDGET-ID 38
     bt-pro AT ROW 1.24 COL 20.2 WIDGET-ID 40
     bt-ult AT ROW 1.24 COL 28.8 WIDGET-ID 36
     bt-C AT ROW 1.24 COL 60.4 WIDGET-ID 32
     bt-R AT ROW 1.24 COL 69 WIDGET-ID 30
     bt-U AT ROW 1.24 COL 77.6 WIDGET-ID 2
     bt-D AT ROW 1.24 COL 86.2 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 101.6 BY 2.57 WIDGET-ID 800.

DEFINE FRAME frm-E
     f-Unome AT ROW 3 COL 31 COLON-ALIGNED WIDGET-ID 6
     f-nome AT ROW 4.1 COL 31 COLON-ALIGNED WIDGET-ID 4
     f-senha AT ROW 5.14 COL 31 COLON-ALIGNED WIDGET-ID 8
     f-num AT ROW 6.95 COL 77.8 COLON-ALIGNED WIDGET-ID 42
     f-rua AT ROW 7 COL 31.2 COLON-ALIGNED WIDGET-ID 14
     f-cidade AT ROW 8.19 COL 31.2 COLON-ALIGNED WIDGET-ID 16
     f-est AT ROW 9.33 COL 31 COLON-ALIGNED WIDGET-ID 44
     f-email AT ROW 11.1 COL 31 COLON-ALIGNED WIDGET-ID 10
     f-telefone AT ROW 12.29 COL 31 COLON-ALIGNED WIDGET-ID 12
     RECT-7 AT ROW 2.43 COL 4 WIDGET-ID 34
     RECT-9 AT ROW 6.71 COL 4 WIDGET-ID 36
     RECT-11 AT ROW 10.76 COL 4 WIDGET-ID 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 3.48
         SIZE 101.8 BY 14.81 WIDGET-ID 900.

DEFINE FRAME frm-home
     f-Titulo AT ROW 2.52 COL 21.6 COLON-ALIGNED WIDGET-ID 6
     f-area AT ROW 3.62 COL 21.6 COLON-ALIGNED WIDGET-ID 4
     f-salario AT ROW 4.67 COL 21.6 COLON-ALIGNED WIDGET-ID 8
     f-dsc AT ROW 6.57 COL 21.4 COLON-ALIGNED WIDGET-ID 16
     f-Cid AT ROW 9.57 COL 21.6 COLON-ALIGNED WIDGET-ID 10
     f-est AT ROW 10.67 COL 21.6 COLON-ALIGNED WIDGET-ID 14
          LABEL "Estado" FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 44 BY .95
          FGCOLOR 9 
     RECT-12 AT ROW 1.95 COL 11.6 WIDGET-ID 34
     RECT-13 AT ROW 9.1 COL 11.6 WIDGET-ID 36
     RECT-14 AT ROW 6.24 COL 11.6 WIDGET-ID 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 3.48
         SIZE 102.4 BY 14.67
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
         SIZE 102 BY 14.52
         FONT 3
         TITLE "" WIDGET-ID 500.

DEFINE FRAME frm-C
     f-host AT ROW 5.05 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     f-port AT ROW 6.48 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     f-role AT ROW 7.91 COL 39 NO-LABEL WIDGET-ID 12
     bt-con AT ROW 9.81 COL 44.6 WIDGET-ID 8
     RECT-8 AT ROW 2.38 COL 21 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 3.14
         SIZE 102 BY 12.38
         FONT 3
         TITLE "" WIDGET-ID 600.

DEFINE FRAME frm-v
     f-Titulo AT ROW 2.52 COL 21.6 COLON-ALIGNED WIDGET-ID 6
          LABEL "Titulo" FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 53.4 BY 1
          FGCOLOR 9 
     f-area AT ROW 3.62 COL 21.6 COLON-ALIGNED WIDGET-ID 4
          LABEL "Area" FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 42 BY 1
          FGCOLOR 9 
     f-salario AT ROW 4.67 COL 21.6 COLON-ALIGNED WIDGET-ID 8
          LABEL "Saario" FORMAT "->>,>>9.99":U
          VIEW-AS FILL-IN 
          SIZE 22 BY 1
          FGCOLOR 9 
     f-dsc AT ROW 6.57 COL 21.4 COLON-ALIGNED WIDGET-ID 16
          LABEL "Descricao" FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 59.8 BY 2.14
          FGCOLOR 9 
     f-Cid AT ROW 9.57 COL 21.6 COLON-ALIGNED WIDGET-ID 10
          LABEL "Cidade" FORMAT "X(30)":U
          VIEW-AS FILL-IN 
          SIZE 39 BY 1
          FGCOLOR 9 
     f-Est AT ROW 10.67 COL 21.6 COLON-ALIGNED WIDGET-ID 14
          LABEL "Estado" FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 44 BY .95
          FGCOLOR 9 
     RECT-15 AT ROW 1.95 COL 11.6 WIDGET-ID 34
     RECT-16 AT ROW 9.1 COL 11.6 WIDGET-ID 36
     RECT-17 AT ROW 6.24 COL 11.6 WIDGET-ID 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 3.48
         SIZE 101.6 BY 14.62
         TITLE "Frame D" WIDGET-ID 1000.


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
/* SETTINGS FOR FRAME frm-cabec
                                                                        */
/* SETTINGS FOR FRAME frm-E
                                                                        */
/* SETTINGS FOR FILL-IN f-cidade IN FRAME frm-E
   4 6                                                                  */
/* SETTINGS FOR FILL-IN f-email IN FRAME frm-E
   6                                                                    */
/* SETTINGS FOR FILL-IN f-est IN FRAME frm-E
   4 6                                                                  */
/* SETTINGS FOR FILL-IN f-nome IN FRAME frm-E
   6                                                                    */
/* SETTINGS FOR FILL-IN f-rua IN FRAME frm-E
   6                                                                    */
/* SETTINGS FOR FILL-IN f-senha IN FRAME frm-E
   6                                                                    */
/* SETTINGS FOR FILL-IN f-telefone IN FRAME frm-E
   6                                                                    */
/* SETTINGS FOR FILL-IN f-Unome IN FRAME frm-E
   2 6                                                                  */
/* SETTINGS FOR FRAME frm-home
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-area IN FRAME frm-home
   6                                                                    */
/* SETTINGS FOR FILL-IN f-Cid IN FRAME frm-home
   6                                                                    */
/* SETTINGS FOR FILL-IN f-dsc IN FRAME frm-home
   4 6                                                                  */
/* SETTINGS FOR FILL-IN f-est IN FRAME frm-home
   6                                                                    */
/* SETTINGS FOR FILL-IN f-salario IN FRAME frm-home
   6                                                                    */
/* SETTINGS FOR FILL-IN f-Titulo IN FRAME frm-home
   2 6                                                                  */
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

/* SETTINGS FOR FRAME frm-v
                                                                        */
/* SETTINGS FOR FILL-IN f-area IN FRAME frm-v
   6                                                                    */
/* SETTINGS FOR FILL-IN f-Cid IN FRAME frm-v
   6                                                                    */
/* SETTINGS FOR FILL-IN f-dsc IN FRAME frm-v
   4 6                                                                  */
/* SETTINGS FOR FILL-IN f-Est IN FRAME frm-v
   6                                                                    */
/* SETTINGS FOR FILL-IN f-salario IN FRAME frm-v
   6                                                                    */
/* SETTINGS FOR FILL-IN f-Titulo IN FRAME frm-v
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


&Scoped-define FRAME-NAME frm-cabec
&Scoped-define SELF-NAME bt-ant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ant Win-Client
ON CHOOSE OF bt-ant IN FRAME frm-cabec /* < */
DO:
        IF rle eq "1" THEN 
            Fc-Ler().

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-C
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-C Win-Client
ON CHOOSE OF bt-C IN FRAME frm-cabec /* bt-C */
DO:
        IF rle eq "1" THEN 
            Fc-Cadastrar().
        else
            Fc-Ca().
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
        else 
            Fc-Ap().
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
&Scoped-define SELF-NAME bt-pri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pri Win-Client
ON CHOOSE OF bt-pri IN FRAME frm-cabec /* << */
DO:
        IF rle eq "1" THEN 
            Fc-Cadastrar().

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pro Win-Client
ON CHOOSE OF bt-pro IN FRAME frm-cabec /* > */
DO:
        IF rle eq "1" THEN 
            Fc-Atualizar().

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-R
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-R Win-Client
ON CHOOSE OF bt-R IN FRAME frm-cabec /* bt-R */
DO:
        IF rle eq "1" THEN 
            Fc-Ler().
        else 
            Fc-Le().
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
        else 
            Fc-At().
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ult
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ult Win-Client
ON CHOOSE OF bt-ult IN FRAME frm-cabec /* >> */
DO:
        IF rle eq "1" THEN 
            Fc-Apagar().

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

        frame frm-L:hidden = true.
        frame frm-C:hidden = true.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Companie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Companie Win-Client
ON CHOOSE OF MENU-ITEM m_Companie /* Companie */
DO:
        frame frm-e:hidden = false.
 
        frame frm-home:hidden = true.

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
        frame frm-e:hidden = true.

        frame frm-l:hidden = true.
        frame frm-c:hidden = true. 
  
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

        frame frm-e:hidden = true.   
        frame frm-home:hidden = true.
   
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
  ENABLE bt-pri bt-ant bt-pro bt-ult bt-C bt-R bt-U bt-D 
      WITH FRAME frm-cabec IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-cabec}
  DISPLAY f-UnomeL f-senhaL 
      WITH FRAME frm-L IN WINDOW Win-Client.
  ENABLE RECT-10 f-UnomeL f-senhaL bt-L bt-VC 
      WITH FRAME frm-L IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-L}
  DISPLAY f-host f-port f-role 
      WITH FRAME frm-C IN WINDOW Win-Client.
  ENABLE RECT-8 f-host f-port f-role bt-con 
      WITH FRAME frm-C IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-C}
  DISPLAY f-Unome f-nome f-senha f-num f-rua f-cidade f-est f-email f-telefone 
      WITH FRAME frm-E IN WINDOW Win-Client.
  ENABLE RECT-7 RECT-9 RECT-11 f-Unome f-nome f-senha f-num f-rua f-cidade 
         f-est f-email f-telefone 
      WITH FRAME frm-E IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-E}
  DISPLAY f-Titulo f-area f-salario f-dsc f-Cid f-est 
      WITH FRAME frm-home IN WINDOW Win-Client.
  ENABLE RECT-12 RECT-13 RECT-14 f-Titulo f-area f-salario f-dsc f-Cid f-est 
      WITH FRAME frm-home IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-home}
  DISPLAY f-Titulo f-area f-salario f-dsc f-Cid f-Est 
      WITH FRAME frm-v IN WINDOW Win-Client.
  ENABLE RECT-15 RECT-16 RECT-17 f-Titulo f-area f-salario f-dsc f-Cid f-Est 
      WITH FRAME frm-v IN WINDOW Win-Client.
  {&OPEN-BROWSERS-IN-QUERY-frm-v}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Ap Win-Client 
FUNCTION Fc-Ap RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    //Fc-Token().
    ASSIGN 
        oClient = ClientBuilder:Build():Client
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)).
    oUri:Path = "/companies/" + user_id.

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
    IF oResp:StatusCode eq 409 THEN 
    do:
        assign 
            mensagem = oJsonRespObj:GetCharacter("message").
        MESSAGE "Falha na Exclusão (Não Encontrado): " skip mensagem 
            VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    end.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-At Win-Client 
FUNCTION Fc-At RETURNS LOGICAL
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
    oUri:Path = "/companies/" + user_id.  
        
    /* Cria objeto Json e popula ele */
    oJsonObj = NEW JsonObject().
    oJsonObj:Add("name", input frame frm-E f-nome).
    oJsonObj:Add("business", input frame frm-E f-nome).
    oJsonObj:Add("password", input frame frm-E f-Senha).
    oJsonObj:Add("street", input frame frm-E f-rua).
    oJsonObj:Add("number", input frame frm-E f-num).
    oJsonObj:Add("city", input frame frm-E f-cidade).
    oJsonObj:Add("state", input frame frm-E f-est).
    oJsonObj:Add("phone", input frame frm-E f-telefone).
    oJsonObj:Add("email", input frame frm-E f-email + formatado).

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
            assign 
                mensagem = oJsonRespObj:GetCharacter("message").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Atualizar Win-Client 
FUNCTION Fc-Atualizar RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-CA Win-Client 
FUNCTION Fc-CA RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    assign 
        oClient = ClientBuilder:Build():Client   
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)). /* URI("metodo", "dominio", "porta") */
    oUri:Path = "/companies".  
        
    /* Cria objeto Json e popula ele */
    oJsonObj = NEW JsonObject().
    oJsonObj:Add("name", input frame frm-E f-nome).
    oJsonObj:Add("business", input frame frm-E f-nome).
    oJsonObj:Add("username", input frame frm-E f-Unome).
    oJsonObj:Add("password", input frame frm-E f-Senha).
    oJsonObj:Add("street", input frame frm-E f-rua).
    oJsonObj:Add("number", input frame frm-E f-num).
    oJsonObj:Add("city", input frame frm-E f-cidade).
    oJsonObj:Add("state", input frame frm-E f-est).
    oJsonObj:Add("phone", input frame frm-E f-telefone).
    oJsonObj:Add("email", input frame frm-E f-email + formatado).
  
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
                mensagem = oJsonRespObj:GetCharacter("message") .
            MESSAGE "Falha na Atualização (Dados Inválidos): " mensagem SKIP codigo SKIP detalhes 
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
    frame frm-l:hidden = true.
    frame frm-e:hidden = true.
    //frame frm-trab:hidden = true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Fc-Le Win-Client 
FUNCTION Fc-Le RETURNS LOGICAL
    (  ):
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    //Fc-Token().
    ASSIGN 
        oClient = ClientBuilder:Build():Client
        oUri    = URI:Parse(metodo + "://" + host + ":" + STRING(porta)).
    oUri:Path = "/companies/" + user_id .

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

            CREATE ttcom.
            assign 
                ttcom.name     = oJsonRespObj:getCharacter("name") 
                ttcom.business = oJsonRespObj:getCharacter("business")
                ttcom.username = oJsonRespObj:getCharacter("username")  
                ttcom.street   = oJsonRespObj:getCharacter("street")
                ttcom.number   = oJsonRespObj:getCharacter("number")
                ttcom.city     = oJsonRespObj:getCharacter("city")
                ttcom.state    = oJsonRespObj:getCharacter("state")
                ttcom.phone    = oJsonRespObj:getCharacter("phone")
                ttcom.email    = oJsonRespObj:getCharacter("email")
                .
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
                frame frm-E:hidden = true.
              
            end.
            ELSE 
            DO :
                frame frm-home:hidden = true.
              
                frame frm-E:hidden = false.      
            END. 
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

