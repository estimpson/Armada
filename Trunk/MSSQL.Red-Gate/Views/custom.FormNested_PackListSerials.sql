SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [custom].[FormNested_PackListSerials]
as
   SELECT		serial as Serial,
								convert(varchar(50),shipper) as Shipper,
								part  as part
    FROM object  
   WHERE object.shipper is not NULL
            
UNION

  SELECT		serial as Serial,
								shipper as Shipper,
								part  as part
    FROM audit_trail  
   WHERE 
		( audit_trail.type = 'S' ) 
GO
