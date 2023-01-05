SELECT 
         [ID]
        ,[Name] AS 'Competitor Name' -- Renamed Column
        ,CASE WHEN SEX = 'M' THEN 'Male' ELSE 'Female' END AS Sex -- Better name for filters and visualisations
        ,[Age]
		,CASE	WHEN [Age] < 18 THEN 'Under 18'
				WHEN [Age] BETWEEN 18 AND 25 THEN '18-25'
				WHEN [Age] BETWEEN 25 AND 30 THEN '25-30'
				WHEN [Age] > 30 THEN 'Over 30'
		 END AS [Age Grouping]
        ,[Height]
        ,[Weight]
        ,[NOC] AS 'Nation Code' -- Explained abbreviation
        ,LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year' -- Split column to isolate Year, based on space
       ,RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) AS 'Season' -- Split column to isolate Season, based on space
--       ,[Games] -- Comented out as it is not necessary for analysis
--       ,[City] -- Commented out as it is not necessary for the analysis
        ,[Sport]
        ,[Event]
        ,CASE WHEN Medal = 'NA' THEN 'Not Registered' ELSE Medal END AS Medal -- Replaced NA with Not Registered
	
  FROM [olympic_games].[dbo].[athletes_event_results] 
  WHERE RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer' -- Where Clause to isolate Summer Season
  AND LEFT(Games, CHARINDEX(' ', Games) - 1) >= 1990




  --Total Number of Medals Won Each Year Starting From 1990
  SELECT COUNT(Medal) AS Number_Of_Medals_Won 
 ,LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year'
 FROM [olympic_games].[dbo].[athletes_event_results]
 WHERE Medal != 'NA' AND RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer' AND LEFT(Games, CHARINDEX(' ', Games) - 1) >= 1990
 GROUP BY LEFT(Games, CHARINDEX(' ', Games) - 1)
 ORDER BY LEFT(Games, CHARINDEX(' ', Games) - 1) DESC



 --Number Of Medals Won Each Year By Type Of Medal, Starting From 1990
 SELECT COUNT(Medal) AS Number_Of_Medals_Won 
 ,LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year'
 , Medal AS Type_Of_Medal_Won
 FROM [olympic_games].[dbo].[athletes_event_results]
 WHERE Medal != 'NA' AND LEFT(Games, CHARINDEX(' ', Games) - 1) >= 1990 AND RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer'
 GROUP By LEFT(Games, CHARINDEX(' ', Games) - 1), Medal
 ORDER BY LEFT(Games, CHARINDEX(' ', Games) - 1) DESC



 --Countries Having Won The Most Medals In Total Since 1990
   SELECT
   [NOC] AS 'Nation Code' -- Explained abbreviation
   ,LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year' -- Split column to isolate Year, based on space
   ,COUNT(Medal) AS Number_Of_Medals_Won
	
  FROM [olympic_games].[dbo].[athletes_event_results] 
  WHERE RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer' -- Where Clause to isolate Summer Season
  AND  Medal != 'NA' AND LEFT(Games, CHARINDEX(' ', Games) - 1) >= 1990

  GROUP BY [NOC] ,LEFT(Games, CHARINDEX(' ', Games) - 1)
  ORDER BY Number_Of_Medals_Won DESC



 --Average Age Of Competitors Each Year, Grouped by Gender
 SELECT ROUND(AVG(Age), 0) AS Average_Age
 ,LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year'
 --,RIGHT([Games],6) AS Season
 ,CASE WHEN SEX = 'M' THEN 'Male' ELSE 'Female' END AS Gender -- Better name for filters and visualisations

 FROM [olympic_games].[dbo].[athletes_event_results] 
 WHERE RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer' AND LEFT(Games, CHARINDEX(' ', Games) - 1) >= 1990 AND Age IS NOT NULL 
  GROUP BY LEFT(Games, CHARINDEX(' ', Games) - 1), Sex
  ORDER BY LEFT(Games, CHARINDEX(' ', Games) - 1) DESC



   --Total Number Of Participants Each Year By Gender
 SELECT 
 COUNT(Sex) AS Number_Of_Participants
  ,CASE WHEN SEX = 'M' THEN 'Male' ELSE 'Female' END AS Gender -- Better name for filters and visualisations
  ,LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year'
 FROM [olympic_games].[dbo].[athletes_event_results]
 WHERE RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer' AND LEFT([Games], 4) >= 1990
 GROUP By Sex, LEFT(Games, CHARINDEX(' ', Games) - 1)
 ORDER BY Year DESC


 
--Sports With The Most Participants Each Year
SELECT Sport, COUNT(Name) AS No_Of_Participants, LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year'
FROM [olympic_games].[dbo].[athletes_event_results]
WHERE RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer'AND LEFT([Games], 4) >= 1990
GROUP BY Sport, LEFT(Games, CHARINDEX(' ', Games) - 1) 
ORDER BY No_Of_Participants DESC



--Countries With The Most Participants Each Year
SELECT NOC AS Nation_Code
 ,COUNT(Name) AS Number_Of_Participants
 ,LEFT([Games], 4) AS Year

FROM [olympic_games].[dbo].[athletes_event_results]
WHERE LEFT([Games], 4) >= 1990
GROUP BY NOC, LEFT([Games], 4)
ORDER BY Number_Of_Participants DESC
