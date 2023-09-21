SET NOCOUNT ON
Select nq.PatronID
    , convert(varchar(20), cir.Barcode) as ItemBarcode
    , convert(varchar(255), br.BrowseTitle) as Title
    , convert(varchar(10), ic.DueDate, 120) as DueDate
    , cir.ItemRecordID
    , '' as Dummy1
    , '' as Dummy2
    , '' as Dummy3
    , '' as Dummy4
    , ic.Renewals
    , br.BibliographicRecordID
    , cir.RenewalLimit
    , convert(varchar(20), p.Barcode) as PatronBarcode
From
    Results.Polaris.NotificationQueue nq (nolock)
    join Polaris.Polaris.Patrons p (nolock) on nq.PatronID=p.PatronID
    join Polaris.Polaris.ItemCheckouts ic (nolock) on nq.PatronId=ic.PatronID and nq.ItemRecordId=ic.ItemRecordID
    join Polaris.Polaris.CircItemRecords cir (nolock) on ic.ItemRecordID=cir.ItemRecordID
    join Polaris.Polaris.BibliographicRecords br (nolock) on cir.AssociatedBibRecordID=br.BibliographicRecordID
Where  
    (nq.DeliveryOptionId=3 OR nq.DeliveryOptionId=8)
    and nq.NotificationTypeId in (1,7,8,11,12,13)
    and nq.CreationDate>GETDATE()-1
Order By
    nq.PatronID