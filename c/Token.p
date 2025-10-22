
/*------------------------------------------------------------------------
    File        : Token.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Roberty
    Created     : Wed Oct 22 08:35:53 BRT 2025
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
using Progress.ApplicationServer.*.
BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */
DEFINE INPUT PARAMETER ipToken       AS CHARACTER         NO-UNDO.

DEFINE VARIABLE ckGlobal      AS Chilkat.Global    NO-UNDO.
DEFINE VARIABLE publicKey     AS Chilkat.PublicKey NO-UNDO.
DEFINE VARIABLE jwt           AS Chilkat.Jwt       NO-UNDO.
       
DEFINE VARIABLE cTokenPayload AS CHARACTER         NO-UNDO.       
DEFINE VARIABLE cTokenHeader  AS CHARACTER         NO-UNDO.       
DEFINE VARIABLE oJSONParser   AS ObjectModelParser NO-UNDO.
DEFINE VARIABLE tokenPayload  AS JsonObject        NO-UNDO.
DEFINE VARIABLE tokenHeader   AS JsonObject        NO-UNDO.
DEFINE VARIABLE tokenObject   AS JsonObject        NO-UNDO.

/* ***************************  Main Block  *************************** */

      // Authorize Chilkat Bundle       
ckGlobal = NEW Chilkat.Global().
ckGlobal:UnlockBundle('MyChilkatAuthCode').
   
IF NOT ckGlobal:LastMethodSuccess THEN
  UNDO, THROW NEW PROGRESS.Lang.AppError(ckGlobal:LastErrorText).
 
// Load the Public Key to verify the token
publicKey = NEW Chilkat.PublicKey().         
publicKey:LoadFromFile("PublicKey.pem").
IF NOT publicKey:LastMethodSuccess THEN
  UNDO, THROW NEW PROGRESS.Lang.AppError("Invalid Public Key: " + publicKey:LastErrorText,500).
 
      // Get a JWT instance
jwt = NEW Chilkat.Jwt().
 
IF NOT jwt:LastMethodSuccess THEN
  UNDO, THROW NEW PROGRESS.Lang.AppError("Invalid Token: " + jwt:LastErrorText,500).
 
ASSIGN
  cTokenPayload = jwt:GetPayload(ipToken)
  cTokenHeader  = jwt:GetHeader(ipToken).
   
oJSONParser = NEW ObjectModelParser().
tokenPayload = CAST(oJSONParser:Parse(cTokenPayload),JsonObject).
tokenHeader = CAST(oJSONParser:Parse(cTokenHeader),JsonObject).

tokenObject = NEW JsonObject().
tokenObject:Add("header",tokenHeader).
tokenObject:Add("payload",tokenPayload).
 
RETURN tokenObject.
 
CATCH e AS Progress.Lang.Error :
  UNDO, THROW e.       
END CATCH. 