insert
	FT.MenuItems
(	MenuID
,	MenuItemName
,	ItemOwner
,	Status
,	Type
,	MenuText
,	MenuIcon
,	ObjectClass
)
select
	MenuID = 'AA9A930D-CF14-43E1-9813-5BFF3AA6B64D'
,	MenuItemName = 'FX/OP Vendor Inventory'
,	ItemOwner = 'sys'
,	status = 0
,	type = 1
,	MenuText = 'OP: Vendor Inventory'
,	MenuIcon = 'Custom097!'
,	ObjectClass = 'w_outsideprocessing_vendorinventory'

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = '93944970-B29E-4F60-8889-2CF6435F8599'
,	ChildMenuID = 'AA9A930D-CF14-43E1-9813-5BFF3AA6B64D'
,	Sequence = 6