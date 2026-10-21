-- Referencni snimek exportu 18. 10. 2026; NENASAZOVAT jako migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_skl_inv_aktualizuj_uc_stav]
@IDInvHd INT

AS

-- doplnit stav skladu 

UPDATE TabInvItem
SET TabInvItem.MnozstviSklad = TabStavSkladu.Mnozstvi
FROM TabStavSkladu
WHERE TabInvItem.IDSklad = TabStavSkladu.ID AND TabInvItem.IDDoklad = @IDInvHd
GO
