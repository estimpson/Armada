SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [EDI4010].[LastShipSchedule] AS
		SELECT	Distinct
						css.ShipToCode,
						css.CustomerPart,
						css.CustomerPO,
						ss.CustomerPOLine,
						FxOrder.BlanketOrderNo AS LastFxOrderNo,
						FXorder.ShipToCode AS FxDestination
					
		 FROM EDI4010.CurrentShipSchedules() css
		 JOIN
					EDI4010.ShipSchedules ss ON ss.RawDocumentGUID = css.RawDocumentGUID 
				AND		ss.CustomerPart = css.CustomerPart 
				AND		ss.ShipToCode = css.ShipToCode 
				AND		ISNULL(ss.CustomerPO,'') = ISNULL(css.CustomerPO,'') 
		OUTER APPLY
			( SELECT TOP 1 * 
			FROM  EDI4010.BlanketOrders bo
			WHERE	 bo.EDIShipToCode = css.ShipToCode 
							AND		bo.CustomerPart = css.CustomerPart
							 and
						(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = css.CustomerPO
						)
						AND	(	bo.CheckModelYearPlanning = 0
							or bo.ModelYear862  = css.CustomerModelYear)
							ORDER BY bo.BlanketOrderNo desc )  FXorder
				
            
GO
