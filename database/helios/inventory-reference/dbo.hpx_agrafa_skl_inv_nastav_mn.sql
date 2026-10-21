-- Referencni snimek exportu 18. 10. 2026; NENASAZOVAT jako migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_skl_inv_nastav_mn]
@IDInvRd INT

AS

UPDATE TabInvItem
SET
  MnozstviInv = MnozstviSklad,
  MnozstviMJ = MnozstviSklad
WHERE ID = @IDInvRd
GO
