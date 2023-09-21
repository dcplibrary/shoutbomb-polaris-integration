SET NOCOUNT ON
Select pr.PatronID
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
    Polaris.ItemCheckouts ic (nolock)
    join Polaris.Polaris.PatronRegistration pr (nolock) on ic.PatronID=pr.PatronID
    join Polaris.Polaris.Patrons p (nolock) on pr.PatronID=p.PatronID
    join Polaris.Polaris.CircItemRecords cir (nolock) on ic.ItemRecordID=cir.ItemRecordID
    join Polaris.Polaris.BibliographicRecords br (nolock) on cir.AssociatedBibRecordID=br.BibliographicRecordID
Where
    (pr.DeliveryOptionID=3 or pr.DeliveryOptionID=8) and
    convert(varchar (11),ic.DueDate, 101)=convert(varchar (11), getdate()+3, 101) and
    cir.MaterialTypeID!=12
Order By 
    ic.PatronID
