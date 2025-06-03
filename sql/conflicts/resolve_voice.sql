/*Find all patron accounts using the same phone number as a patron account that was modified today.
  If an account was modified today and it uses voice notifications and it shares a phone number with other accounts,
  the script will update the other accounts to use voice notifications.

  */
/*@TODO: Remove unnecessary variables.
  @TODO: Add documentation.*/
SET NOCOUNT ON
DECLARE @TheDate date;
DECLARE @NoteText nvarchar(255);
DECLARE @NoteDate nvarchar(255);
DECLARE @Note nvarchar(255);
SET @TheDate = DATEADD(d, -1, GETDATE());
SET @NoteText = 'SB to voice '; 
SET @NoteDate = CONVERT(varchar, GETDATE(), 110);
SET @Note = CONCAT(@NoteText, @NoteDate);

DECLARE
    @PatronID int,
    @PhoneVoice1 varchar(20),
    @UpdateDate date,
    @DeliveryOptionID int,
    @TxtPhoneNumber int;



DECLARE pCursor CURSOR
    FOR
    SELECT PatronID
        ,PhoneVoice1
        ,UpdateDate
        ,DeliveryOptionID
        ,TxtPhoneNumber
  FROM Polaris.Polaris.PatronRegistration
  /*DeliveryOptionID = 8 selects patrons with phone notification option.*/
  WHERE DeliveryOptionID = 8
    /*PhoneVoice1 IN ... selects patrons with the same phone number as the patron in the following select.*/
    AND PhoneVoice1 IN
        /* Select the account the uses the same phone number and was modified today.*/
        (SELECT PhoneVoice1
        FROM Polaris.Polaris.PatronRegistration
        /*UpdateDate > DATEADD(d, -1, GETDATE()) selects accounts that modified today.*/
        WHERE UpdateDate > @TheDate
          /*DeliveryOptionID = 3 selects patrons with phone notification option.*/
          AND DeliveryOptionID = 3
          /*ExpirationDate > DATEADD(d, -1, GETDATE()) selects accounts that are not expired.*/
          AND ExpirationDate  > DATEADD(d, -1, GETDATE())) ORDER BY UpdateDate DESC;
OPEN pCursor;
FETCH NEXT FROM pCursor INTO
    @PatronID,
    @PhoneVoice1,
    @UpdateDate,
    @DeliveryOptionID,
    @TxtPhoneNumber;
WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE [Polaris].[Polaris].[PatronRegistration]
        SET DeliveryOptionID = 3,
        TxtPhoneNumber = NULL
        WHERE PatronID = @PatronID;
		IF EXISTS 
			(SELECT * FROM [Polaris].[Polaris].[PatronCustomDataStrings]
			WHERE PatronID = @PatronID AND PatronCustomDataDefinitionID = '16')
			BEGIN
				UPDATE [Polaris].[Polaris].[PatronCustomDataStrings]
				SET CustomDataEntry = @Note
				WHERE PatronID = @PatronID AND PatronCustomDataDefinitionID = '16'
			END
		ELSE
			BEGIN
				INSERT INTO [Polaris].[Polaris].[PatronCustomDataStrings]
				(PatronID,PatronCustomDataDefinitionID,CustomDataEntry) VALUES
				(@PatronID, '16', @Note);
		END
        FETCH NEXT FROM pCursor INTO
	        @PatronID,
            @PhoneVoice1,
            @UpdateDate,
            @DeliveryOptionID,
            @TxtPhoneNumber;
    END;
CLOSE pCursor;
DEALLOCATE pCursor;