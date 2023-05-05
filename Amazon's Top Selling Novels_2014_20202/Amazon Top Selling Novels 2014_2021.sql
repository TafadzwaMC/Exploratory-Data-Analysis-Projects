
SELECT [Ranks]
      ,[Title]
      ,[Price]
      ,[Number_Of_Reviews]
      ,[Ratings]
      ,[Author]
      ,[Cover_Type]
      ,[Year]
      ,[Genre]
  FROM [Amazon_Top_Selling_Novels].[dbo].['best_selling_books_2009-2021_fu$']


--Finding The Total Number Of Books Sold Each Year
--Finding The Year With Most Books Sold
--Finding The Year With Least Books Sold
SELECT 
	COUNT([Genre]) AS "Total Books Sold",
	[Year]
FROM [Amazon_Top_Selling_Novels].[dbo].['best_selling_books_2009-2021_fu$']
WHERE [Year] IS NOT NULL
GROUP BY [Year]
ORDER BY Year ASC;




--Finding Which Year Had the most number of books sold for each genre?
SELECT Genre, Year, "Number Of Books Sold"
FROM 
(
  SELECT Genre, Year, COUNT(*) AS "Number Of Books Sold",
         RANK() OVER (PARTITION BY Genre ORDER BY COUNT(*) DESC) AS Rank
  FROM [Amazon_Top_Selling_Novels].[dbo].['best_selling_books_2009-2021_fu$']
  GROUP BY Genre, Year
) AS Subquery
WHERE Rank = 1 

/*It uses a subquery to first group the books by genre and year and count the number of books sold in each group. 
Then, it ranks the results within each genre by the number of books sold, and selects only the records with a rank of 1,
which correspond to the year with the most number of books sold for each genre.*/




--Finding Average Price Of Each Genre of Books Each Year?
 SELECT 
  ROUND(AVG([Price]),2) AS 'Average Book Price',
  [Year],
  [Genre],
  COUNT(*) AS 'Number Of Books'
FROM [Amazon_Top_Selling_Novels].[dbo].['best_selling_books_2009-2021_fu$']
GROUP BY [Year], [Genre]
--ORDER BY YEAR ASC;




--Finding Which Author Has The Highest Book Rating under what genre each year?
  SELECT
      AVG([Ratings]) AS "Average Book Rating"
      ,[Author]
      ,[Genre]
	  ,[Year]
FROM [Amazon_Top_Selling_Novels].[dbo].['best_selling_books_2009-2021_fu$'] AS b
WHERE b.Ranks = 1
GROUP BY Year, Genre, Author
ORDER BY Year ASC;



  --Finding The Average Rating of each Genre Each Year 
  SELECT
    ROUND(AVG(Ratings),1) AS "Average Book Rating",
    Year,
    Genre,
    COUNT(*) AS "Number Of Books"
FROM [Amazon_Top_Selling_Novels].[dbo].['best_selling_books_2009-2021_fu$'] AS b
GROUP BY Year, Genre
--ORDER BY Year ASC;
