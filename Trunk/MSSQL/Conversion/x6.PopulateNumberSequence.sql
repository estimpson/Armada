set identity_insert FT.NumberSequence on

insert
	FT.NumberSequence
(	NumberSequenceID
,	Name
,	HelpText
,	NumberMask
,	NextValue
,	LastUser
,	LastDT
)
select
	*
from
	fxAztec.FT.NumberSequence ns

set identity_insert FT.NumberSequence off

select
	*
from
	FT.NumberSequence ns