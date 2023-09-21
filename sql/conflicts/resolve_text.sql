/*Find all patron accounts using the same phone number as a patron account that was modified today.
  If the account that was modified this week is using texting notifications,
  the script will update all other accounts using same number for text for phone notifications to the same method as the
  recently update account.

  Updates Phone1CarrierID to:
  AT&T

  */
/*@TODO: Remove unnecessary variables.
  @TODO: Add documentation.*/
SET NOCOUNT ON
DECLARE @TheDate date;
DECLARE @carrier int;
SET @TheDate = DATEADD(d, -1, GETDATE());
SET @carrier = $(Provider);
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
          --AND phonevoice1 = '2709935018'
          AND Phone1CarrierID = @carrier
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
	    Phone1CarrierID = @carrier
        WHERE PatronID = @PatronID;
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