SELECT
  g.glottocode      AS glottocode,
  g.name            AS name,
  g.macroarea       AS macroarea,
  g.latitude        AS latitude,
  g.longitude       AS longitude,
  d.Language_family AS family,
  d.precipitation   AS precipitation,
  p.tones           AS tones
FROM
  languoids AS g
  JOIN
  (
    -- our view tones:
    SELECT
      p.LanguageCode,
      coalesce(t.tones, 0) AS tones
    FROM
      (SELECT DISTINCT LanguageCode
       FROM phonemes
       WHERE source != 'upsid') AS p
      LEFT OUTER JOIN
      (
        -- our view tones_by_language:
        SELECT
          LanguageCode,
          max(tones) AS tones
        FROM
          (
            -- our view tones_by_inventory:
            SELECT
              InventoryID,
              LanguageCode,
              LanguageName,
              count(*) AS tones
            FROM
              phonemes
            WHERE
              tone = '+'
            GROUP BY
              LanguageCode, InventoryID
          ) AS x
        GROUP BY
          LanguageCode
      ) AS t
        ON
          p.LanguageCode = t.LanguageCode
  ) AS p
    ON
      g.isocodes = p.LanguageCode
  JOIN
  (
    -- our view precipitation_by_glottocode:
    SELECT
      glottocode,
      Language_family,
      avg(precipitation) AS precipitation
    FROM
      precipitation
    WHERE
      glottocode IS NOT NULL
    GROUP BY
      glottocode
  ) AS d
    ON
      d.glottocode = g.glottocode
ORDER BY
  d.Language_family, g.name;
