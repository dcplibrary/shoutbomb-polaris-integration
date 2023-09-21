/* log_text_conflicts finds all accounts with text notifications that were updated within the past week.
   If there are other accounts associated with the same phone number but are set to voice notifcations,
   those accounts are output to text_conflicts.log
 */
SET NOCOUNT ON
DECLARE @TheDate date;
/*Sets the variable @TheDate to one week ago */
SET @TheDate = DATEADD(d, -1, GETDATE());

SELECT PatronID
     , PhoneVoice1
     , UpdateDate
     , DeliveryOptionID
     , Phone1CarrierID
     , TxtPhoneNumber
FROM Polaris.Polaris.PatronRegistration
    /*DeliveryOptionID = 3 selects patrons with voice notification option.*/
WHERE DeliveryOptionID = 3
    /*PhoneVoice1 IN ... selects patrons with the same phone number as the patron in the following select.*/
  AND PhoneVoice1 IN
    /*Select all patron accounts that were modified this week with conflicting text notifications*/
      (SELECT PhoneVoice1
       FROM Polaris.Polaris.PatronRegistration
           /*UpdateDate > @TheDate selects accounts that modified in the past week.*/
       WHERE UpdateDate > @TheDate
           /*DeliveryOptionID = 8 selects patrons with text notification option.*/
         AND DeliveryOptionID = 8
         /*TxtPhoneNumber corresponds with PhoneVoice#.  Should also be 1 as in PhoneVoice1. */
         AND TxtPhoneNumber = 1
           /*ExpirationDate > DATEADD(d, -1, GETDATE()) selects accounts that are not expired.*/
         AND ExpirationDate > DATEADD(d, -1, GETDATE()))
ORDER BY UpdateDate DESC;