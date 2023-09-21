SET NOCOUNT ON
Select convert(varchar (255), hn.BrowseTitle) as BTitle
    , convert(varchar(10), q.CreationDate, 120) as CreationDate
    , hr.SysHoldRequestID
    , q.PatronID
    , hn.PickupOrganizationID
    , convert(varchar(10), hn.HoldTillDate, 120) as HoldTillDate
    , convert(varchar(20), p.Barcode) as PBarcode
From
    Results.polaris.NotificationQueue q (nolock)
    join Results.polaris.HoldNotices hn (nolock) on q.ItemRecordID=hn.ItemRecordID and q.PatronID=hn.PatronID and q.NotificationTypeID=hn.NotificationTypeID
    join Polaris.polaris.Patrons p (nolock) on q.PatronID=p.PatronID
    left join Polaris.polaris.SysHoldRequests hr on q.PatronID=hr.PatronID and q.ItemRecordID=hr.TrappingItemRecordID
Where
    (q.DeliveryOptionID=3 OR q.DeliveryOptionID=8)
    and hn.HoldTillDate>GETDATE()
Order By 
    p.Barcode