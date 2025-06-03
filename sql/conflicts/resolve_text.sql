/*Find all patron accounts using the same phone number as a patron account that was modified yesterday.
  If the account that was modified today is using texting notifications,
  the script will update all other accounts using same number for phone notifications to text.

  */
/*@TODO: Remove unnecessary variables.
  @TODO: Add documentation.*/
SET NOCOUNT ON
DECLARE @TheDate date;
DECLARE @NoteText nvarchar(255);
DECLARE @NoteDate nvarchar(255);
DECLARE @Note nvarchar(255);
SET @TheDate = DATEADD(d, -1, GETDATE());
SET @NoteText = 'SB to text '; 
SET @NoteDate = CONVERT(varchar, GETDATE(), 110);
SET @Note = CONCAT(@NoteText, @NoteDate);

DECLARE
    @PatronID int,
    @PhoneVoice1 varchar(20),
    @UpdateDate date,
    @DeliveryOptionID int,
    @Phone1CarrierID int,
    @TxtPhoneNumber int;

DECLARE pCursor CURSOR
    FOR
    SELECT PatronID
        ,PhoneVoice1
        ,UpdateDate
        ,DeliveryOptionID
        ,Phone1CarrierID
        ,TxtPhoneNumber

  FROM Polaris.Polaris.PatronRegistration
  /*DeliveryOptionID = 8 selects patrons with phone notification option.*/
  WHERE DeliveryOptionID = 3
    /*ExpirationDate > DATEADD(d, -1, GETDATE()) selects accounts that are not expired.*/
    --AND ExpirationDate  > DATEADD(d, -1, GETDATE())
    /*PhoneVoice1 IN ... selects patrons with the same phone number as the patron in the following select.*/
    AND PhoneVoice1 IN
        /*Select all patron accounts that were modified today, and that have their notifcation option set to texting using AT&T.*/
        (SELECT PhoneVoice1
        FROM Polaris.Polaris.PatronRegistration
        /*UpdateDate > DATEADD(d, -1, GETDATE()) selects accounts that modified today.*/
        WHERE UpdateDate > @TheDate
          /*DeliveryOptionID = 3 selects patrons with phone notification option.*/
          AND DeliveryOptionID = 8
          /*Phone1CarrierID = 1 selects patrons with using AT&T.*/

          AND TxtPhoneNumber = 1
          /*ExpirationDate > DATEADD(d, -1, GETDATE()) selects accounts that are not expired.*/
          AND ExpirationDate  > DATEADD(d, -1, GETDATE())) ORDER BY UpdateDate DESC;
OPEN pCursor;
FETCH NEXT FROM pCursor INTO
    @PatronID,
    @PhoneVoice1,
    @UpdateDate,
    @DeliveryOptionID,
    @Phone1CarrierID,
    @TxtPhoneNumber;
WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE [Polaris].[Polaris].[PatronRegistration]
        SET DeliveryOptionID = 8,
        TxtPhoneNumber = 1,
	    Phone1CarrierID = @Phone1CarrierID
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
            @Phone1CarrierID,
            @TxtPhoneNumber;
    END;
CLOSE pCursor;
DEALLOCATE pCursor;