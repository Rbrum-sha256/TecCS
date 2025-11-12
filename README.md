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
