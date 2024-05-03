-- 1. What grades are stored in the database?
SELECT name FROM grade;

-- 2. What emotions may be associated with a poem?
SELECT name FROM emotion;

-- 3. How many poems are in the database?
SELECT COUNT(id) FROM poem;

-- 4. Sort authors alphabetically by name. What are the names of the top 76 authors?
SELECT name FROM author
ORDER BY name ASC
LIMIT 76;

-- 5. Starting with the above query, add the grade of each of the authors.
SELECT author.name, grade.name FROM author
LEFT JOIN grade
	ON author.gradeid = grade.id
ORDER BY author.name ASC
LIMIT 76;

-- 6. Starting with the above query, add the recorded gender of each of the authors.
SELECT author.name, grade.name, gender.name FROM author
LEFT JOIN grade
	ON author.gradeid = grade.id
LEFT JOIN gender
	ON author.genderid = gender.id
ORDER BY author.name ASC
LIMIT 76;

-- 7. What is the total number of words in all poems in the database?
SELECT SUM(wordcount) FROM poem;

-- 8. Which poem has the fewest characters?
SELECT title, charcount FROM poem
WHERE charcount IN (
	SELECT MIN(charcount) FROM poem);

-- 9. How many authors are in the third grade?
SELECT COUNT(author.id) FROM author
LEFT JOIN grade
	ON author.gradeid = grade.id
GROUP BY grade.name
HAVING grade.name = '3rd Grade';

-- 10. How many total authors are in the first through third grades?
SELECT grade.name, COUNT(author.id) FROM author
LEFT JOIN grade
	ON author.gradeid = grade.id
GROUP BY grade.name
HAVING grade.name = '1st Grade'
	OR grade.name = '2nd Grade'
	OR grade.name = '3rd Grade'
ORDER BY grade.name ASC;

-- 11. What is the total number of poems written by fourth graders?
SELECT grade.name, COUNT(poem.id) FROM poem
LEFT JOIN author
	ON poem.authorid = author.id
LEFT JOIN grade
	ON author.gradeid = grade.id
GROUP BY grade.name
HAVING grade.name = '4th Grade';

-- 12. How many poems are there per grade?
SELECT grade.name, COUNT(poem.id) FROM poem
LEFT JOIN author
	ON poem.authorid = author.id
LEFT JOIN grade
	ON author.gradeid = grade.id
GROUP BY grade.name
ORDER BY grade.name;

-- 13. How many authors are in each grade? (Order your results by grade starting with 1st Grade)
SELECT grade.name, COUNT(author.id) FROM author
LEFT JOIN grade
	ON author.gradeid = grade.id
GROUP BY grade.name
ORDER BY grade.name;

-- 14. What is the title of the poem that has the most words?
SELECT title, wordcount FROM poem
WHERE wordcount IN (
	SELECT MAX(wordcount) FROM poem);

-- 15. Which author(s) have the most poems? (Remember authors can have the same name.)
SELECT author.id, author.name, COUNT(poem.id) FROM poem
LEFT JOIN author
	ON poem.authorid = author.id
GROUP BY author.id
HAVING COUNT(poem.id) = (SELECT MAX(cnt) FROM (
	SELECT COUNT(poem.id) AS cnt 
	FROM poem
	LEFT JOIN author
		ON poem.authorid = author.id
	GROUP BY author.id)
);

-- 16. How many poems have an emotion of sadness?
SELECT emotion.name, COUNT(poem.id) FROM poem
LEFT JOIN poememotion
	ON poem.id = poememotion.poemid
LEFT JOIN emotion
	ON emotion.id = poememotion.emotionid
GROUP BY emotion.id
HAVING emotion.name = 'Sadness';

-- 17. How many poems are not associated with any emotion?
SELECT COUNT(poem.id)
FROM poem
LEFT JOIN poememotion
	ON poem.id = poememotion.poemid
GROUP BY poememotion.id
HAVING poememotion.id ISNULL;

-- 18. Which emotion is associated with the least number of poems?
SELECT emotion.name, COUNT(poem.id)
FROM poem
LEFT JOIN poememotion
	ON poem.id = poememotion.poemid
LEFT JOIN emotion
	ON emotion.id = poememotion.emotionid
GROUP BY emotion.id
HAVING COUNT(poem.id) = (SELECT MIN(cnt) FROM (
	SELECT COUNT(poem.id) AS cnt
	FROM poem
	JOIN poememotion
		ON poem.id = poememotion.poemid
	GROUP BY poememotion.emotionid
));

-- 19. Which grade has the largest number of poems with an emotion of joy?
SELECT grade.name, emotion.name, COUNT(poem.id) FROM poem
LEFT JOIN author
	ON poem.authorid = author.id
LEFT JOIN grade
	ON author.gradeid = grade.id
LEFT JOIN poememotion
	ON poem.id = poememotion.poemid
LEFT JOIN emotion
	ON emotion.id = poememotion.emotionid
GROUP BY grade.name, emotion.name
HAVING emotion.name = 'Joy'
	AND COUNT(poem.id) = (SELECT MAX(cnt) FROM (
		SELECT COUNT(poem.id) AS cnt
		FROM poem
		LEFT JOIN author
			ON poem.authorid = author.id
		LEFT JOIN poememotion
			ON poem.id = poememotion.poemid
		GROUP BY author.gradeid, poememotion.emotionid
	));

-- 20. Which gender has the least number of poems with an emotion of fear?
SELECT gender.name, emotion.name, COUNT(poem.id)
FROM poem
LEFT JOIN author
	ON author.id = poem.authorid
LEFT JOIN gender
	ON gender.id = author.genderid
LEFT JOIN poememotion
	ON poememotion.poemid = poem.id
LEFT JOIN emotion
	ON emotion.id = poememotion.emotionid
GROUP BY gender.name, emotion.name
HAVING emotion.name = 'Fear'
	AND COUNT(poem.id) = (SELECT MIN(cnt) FROM (
		SELECT COUNT(poem.id) AS cnt
		FROM poem
		LEFT JOIN author
			ON poem.authorid = author.id
		LEFT JOIN poememotion
			ON poem.id = poememotion.poemid
		LEFT JOIN emotion
			ON emotion.id = poememotion.emotionid
		GROUP BY author.genderid, emotion.name
		HAVING emotion.name = 'Fear'
	));

