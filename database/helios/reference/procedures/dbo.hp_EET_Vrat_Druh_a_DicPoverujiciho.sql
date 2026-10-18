-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_EET_Vrat_Druh_a_DicPoverujiciho]
@StavEET              TINYINT,
@IDZboSklad           INT,
@EET_dic_poverujiciho NVARCHAR(12) OUT,
@DruhEET              TINYINT OUT,
@JeTxtPolozka         BIT = 0
AS
DECLARE @EET_Pouzivat_dic_poverujiciho BIT,
@EET_Pouzivat_Pouzite_zbozi BIT,
@EET_Pouzivat_Cestovni_sluzba BIT,
@EET_Pouzivat_Cerpani BIT
SELECT @EET_Pouzivat_dic_poverujiciho = PouzivatDic_Poverujiciho,
@EET_Pouzivat_Pouzite_zbozi    = PouzivatPouziteZbozi,
@EET_Pouzivat_Cestovni_sluzba  = PouzivatCestovniSluzbu,
@EET_Pouzivat_Cerpani          = PouzivatCerpani
FROM TabHGlob
IF @JeTxtPolozka = 0
SELECT @EET_dic_poverujiciho = (CASE WHEN @StavEET > 1 THEN NULL ELSE
CASE WHEN s.EET_cb_dic_poverujiciho = 0 AND @EET_Pouzivat_dic_poverujiciho = 1 THEN z.EET_dic_poverujiciho
WHEN s.EET_cb_dic_poverujiciho = 1 AND @EET_Pouzivat_dic_poverujiciho = 1 THEN s.EET_dic_poverujiciho
ELSE NULL
END
END),
@DruhEET              = (CASE WHEN @StavEET > 1 THEN 0 ELSE
CASE s.DruhEET WHEN 5 THEN
CASE WHEN z.DruhEET = 2 AND @EET_Pouzivat_Pouzite_zbozi   = 0 THEN 1
WHEN z.DruhEET = 3 AND @EET_Pouzivat_Cestovni_sluzba = 0 THEN 1
WHEN z.DruhEET = 4 AND @EET_Pouzivat_Cerpani         = 0 THEN 1
ELSE z.DruhEET
END ELSE
CASE WHEN s.DruhEET = 2 AND @EET_Pouzivat_Pouzite_zbozi   = 0 THEN 1
WHEN s.DruhEET = 3 AND @EET_Pouzivat_Cestovni_sluzba = 0 THEN 1
WHEN s.DruhEET = 4 AND @EET_Pouzivat_Cerpani         = 0 THEN 1
ELSE s.DruhEET
END
END
END  )
FROM TabKmenZbozi z
JOIN TabStavSkladu s ON z.ID = s.IDKmenZbozi
LEFT JOIN TabKmenZboziDodatek d ON d.ID = z.ID
WHERE s.ID = @IDZboSklad
ELSE
SELECT @EET_dic_poverujiciho = NULL, @DruhEET = (CASE WHEN @StavEET > 1 THEN 0 ELSE 1 END)
GO
