/*
Lavet af Martin Pugdal Pedersen
*/
use superliga
drop table if exists matches
drop table if exists teams
go
create table teams (
	id char(3) primary key,
	name varchar(40),
	nomatches int,
	ourgoals int,
	othergoals int,
	points int
)
create table matches (
	id int identity(1,1),
	homeid char(3) foreign key references teams(id),
	outid char(3) foreign key references teams(id),
	homegoal int,
	outgoal int,
	matchdate date
)
go
insert into teams values('agf','AGF',0,0,0,0)
insert into teams values('fck','FC København',0,0,0,0)
insert into teams values('rfc','Randers FC',0,0,0,0)
insert into teams values('vib','Viborg',0,0,0,0)
insert into teams values('lyn','Lyngby',0,0,0,0)
insert into teams values('ob','OB',0,0,0,0)
insert into teams values('fcm','FC Midtjylland',0,0,0,0)
insert into teams values('bif','Brøndby IF',0,0,0,0)
insert into teams values('fcn','FC Nordsjælland',0,0,0,0)
insert into teams values('vej','Vejle',0,0,0,0)
insert into teams values('sil','Silkeborg',0,0,0,0)
insert into teams values('hvi','Hvidovre',0,0,0,0)
go

-- Indsæt triggere her

-- delopgave 1 - trigger
CREATE OR ALTER TRIGGER game_finished_then_update_teams_stats
ON matches
AFTER INSERT
AS
BEGIN
    DECLARE @home_team_id CHAR(3);
    DECLARE @away_team_id CHAR(3);
    DECLARE @home_goals INT;
    DECLARE @away_goals INT;

    SELECT @home_team_id = homeid,
           @away_team_id = outid,
           @home_goals = homegoal,
           @away_goals = outgoal
    FROM inserted;

    UPDATE teams
    SET nomatches = nomatches + 1,
        ourgoals = ourgoals + @home_goals,
        othergoals = othergoals + @away_goals,
        points = points +
		CASE
			WHEN @home_goals > @away_goals THEN 3
			WHEN @home_goals = @away_goals THEN 1
			ELSE 0
		END
    WHERE id = @home_team_id

    UPDATE teams
    SET
		nomatches = nomatches + 1,
        ourgoals = ourgoals + @away_goals,
        othergoals = othergoals + @home_goals,
        points = points + 
		CASE
			WHEN @away_goals > @home_goals THEN 3
			WHEN @away_goals = @home_goals THEN 1
			ELSE 0
		END
    WHERE id = @away_team_id
END
go

-- delopgave 2 - trigger
CREATE OR ALTER TRIGGER game_removed_then_update_teams_stats
ON matches
AFTER DELETE
AS
BEGIN
    DECLARE @home_team_id CHAR(3);
    DECLARE @away_team_id CHAR(3);
    DECLARE @home_goals INT;
    DECLARE @away_goals INT;

    SELECT
		@home_team_id = homeid,
        @away_team_id = outid,
		@home_goals = homegoal,
		@away_goals = outgoal
    FROM deleted;

    UPDATE teams
    SET nomatches = nomatches - 1,
        ourgoals = ourgoals - @home_goals,
        othergoals = othergoals - @away_goals,
        points = points -
		CASE
			WHEN @home_goals > @away_goals THEN 3
			WHEN @home_goals = @away_goals THEN 1
			ELSE 0
		END
    WHERE id = @home_team_id;

    UPDATE teams
    SET
		nomatches = nomatches - 1,
        ourgoals = ourgoals - @away_goals,
        othergoals = othergoals - @home_goals,
        points = points - 
		CASE
			WHEN @away_goals > @home_goals THEN 3
			WHEN @away_goals = @home_goals THEN 1
			ELSE 0
		END
    WHERE id = @away_team_id
END
go

-- delopgave 3 -- trigger
CREATE OR ALTER TRIGGER game_edited_then_update_teams_stats
ON matches
AFTER UPDATE
AS
BEGIN
    DECLARE @home_team_id CHAR(3);
    DECLARE @away_team_id CHAR(3);
    DECLARE @home_goals INT;
    DECLARE @away_goals INT;
	DECLARE @match_date DATE;

    SELECT @home_team_id = homeid,
           @away_team_id = outid,
           @home_goals = homegoal,
           @away_goals = outgoal,
		   @match_date = matchdate
    FROM deleted;

    DELETE FROM matches
    FROM matches
    WHERE matches.id = (SELECT id FROM deleted)

    INSERT INTO matches (homeid, outid, homegoal, outgoal, matchdate)
    SELECT @home_team_id, @away_team_id, @home_goals, @away_goals, @match_date
    FROM inserted
END
go

-- delopgave 4 -- stored procedure
CREATE OR ALTER PROCEDURE leaderboardAtTheDate
    @selected_date DATE
AS
BEGIN
    SELECT
        t.name,
        COUNT(m.id) AS nomatches,
        SUM(CASE WHEN m.homeid = t.id THEN m.homegoal ELSE m.outgoal END) AS ourgoals,
        SUM(CASE WHEN m.homeid = t.id THEN m.outgoal ELSE m.homegoal END) AS othergoals,
        SUM(
            CASE
                WHEN m.homeid = t.id AND m.homegoal > m.outgoal THEN 3
                WHEN m.homeid = t.id AND m.homegoal = m.outgoal THEN 1
                WHEN m.outid = t.id AND m.outgoal > m.homegoal THEN 3
                WHEN m.outid = t.id AND m.outgoal = m.homegoal THEN 1
                ELSE 0
            END
        ) AS points
	FROM teams t
    LEFT JOIN matches m ON t.id = m.homeid OR t.id = m.outid
    WHERE m.matchdate <= @selected_date
    GROUP BY t.name
    ORDER BY points DESC,
	SUM(CASE
			WHEN m.homeid = t.id THEN m.homegoal - m.outgoal
			WHEN m.outid = t.id THEN m.outgoal - m.homegoal
			ELSE 0
		END
	) DESC,
	SUM(CASE WHEN m.homeid = t.id THEN m.homegoal ELSE m.outgoal END) DESC
END
GO

-- delopgave 5 -- stored procedure
CREATE OR ALTER PROCEDURE teamInLeadingDate
AS
BEGIN
    DECLARE @currentDate DATE;
    DECLARE @maxDate DATE;
    DECLARE @Leaderboard TABLE (
        MatchDate DATE,
        TeamName NVARCHAR(30),
        Points INT,
        OurGoals INT,
        OtherGoals INT,
        GoalDifference INT
    );
    
    SELECT @maxDate = MAX(matchdate) FROM matches;

    SET @currentDate = SELECT MIN(matchdate) FROM matches;

    WHILE @currentDate <= @maxDate
    BEGIN
        INSERT INTO @Leaderboard (MatchDate, TeamName, Points, OurGoals, OtherGoals, GoalDifference)
        SELECT TOP 1
            @currentDate AS MatchDate,
            t.name AS TeamName,
            SUM(
                CASE
                    WHEN m.homeid = t.id AND m.homegoal > m.outgoal THEN 3
                    WHEN m.homeid = t.id AND m.homegoal = m.outgoal THEN 1
                    WHEN m.outid = t.id AND m.outgoal > m.homegoal THEN 3
                    WHEN m.outid = t.id AND m.outgoal = m.homegoal THEN 1
                    ELSE 0
                END
            ) AS Points,
            SUM(CASE WHEN m.homeid = t.id THEN m.homegoal ELSE m.outgoal END) AS OurGoals,
            SUM(CASE WHEN m.homeid = t.id THEN m.outgoal ELSE m.homegoal END) AS OtherGoals,
            SUM(
                CASE
                    WHEN m.homeid = t.id THEN m.homegoal - m.outgoal
                    WHEN m.outid = t.id THEN m.outgoal - m.homegoal
                    ELSE 0
                END
            ) AS GoalDifference
        FROM teams t
        LEFT JOIN matches m ON t.id = m.homeid OR t.id = m.outid
        WHERE m.matchdate <= @currentDate
        GROUP BY t.name
		ORDER BY
			Points DESC, GoalDifference DESC, OurGoals DESC;

        SET @currentDate = SELECT MIN(matchdate) FROM matches WHERE matchdate > @currentDate;
    END

	SET NOCOUNT ON

	SELECT 'On date ' + CONVERT(VARCHAR, l.MatchDate) + ' the leader is ' + l.TeamName
    FROM @Leaderboard as l ORDER BY MatchDate
END
go


-- 1
insert into matches values('fcm','hvi',1,0,'2023-7-21')
insert into matches values('lyn','fck',1,2,'2023-7-22')
insert into matches values('agf','vej',1,0,'2023-7-23')
insert into matches values('ob','rfc',2,2,'2023-7-23')
insert into matches values('sil','bif',1,2,'2023-7-23')
insert into matches values('fcn','vib',4,1,'2023-7-24')
-- 2
insert into matches values('vib','lyn',2,2,'2023-7-28')
insert into matches values('vej','fck',2,3,'2023-7-29')
insert into matches values('fcm','sil',2,0,'2023-7-30')
insert into matches values('rfc','hvi',2,2,'2023-7-30')
insert into matches values('bif','ob',1,2,'2023-7-30')
insert into matches values('agf','fcn',1,3,'2023-7-31')
-- 3
insert into matches values('sil','vej',2,1,'2023-8-4')
insert into matches values('fck','rfc',4,0,'2023-8-5')
insert into matches values('hvi','agf',0,2,'2023-8-6')
insert into matches values('lyn','fcm',4,1,'2023-8-6')
insert into matches values('fcn','bif',3,1,'2023-8-6')
insert into matches values('ob','vib',1,2,'2023-8-7')
-- 4
insert into matches values('fck','ob',2,1,'2023-8-11')
insert into matches values('vej','fcm',1,2,'2023-8-13')
insert into matches values('rfc','fcn',0,5,'2023-8-13')
insert into matches values('bif','lyn',3,0,'2023-8-13')
insert into matches values('agf','sil',2,2,'2023-8-13')
insert into matches values('vib','hvi',0,0,'2023-8-14')
-- 5
insert into matches values('hvi','fck',0,2,'2023-8-18')
insert into matches values('sil','fcn',2,0,'2023-8-20')
insert into matches values('lyn','rfc',1,0,'2023-8-20')
insert into matches values('fcm','bif',0,1,'2023-8-20')
insert into matches values('ob','agf',1,1,'2023-8-20')
insert into matches values('vib','vej',2,1,'2023-8-21')
-- 6
insert into matches values('rfc','vib',1,0,'2023-8-25')
insert into matches values('fck','sil',1,3,'2023-8-26')
insert into matches values('agf','lyn',1,0,'2023-8-27')
insert into matches values('hvi','ob',1,5,'2023-8-27')
insert into matches values('fcn','fcm',3,0,'2023-8-27')
insert into matches values('vej','bif',0,1,'2023-8-28')
-- 7
insert into matches values('ob','vej',1,2,'2023-9-1')
insert into matches values('sil','hvi',1,0,'2023-9-3')
insert into matches values('lyn','fcn',1,1,'2023-9-3')
insert into matches values('bif','rfc',3,1,'2023-9-3')
insert into matches values('fck','vib',2,0,'2023-9-3')
insert into matches values('fcm','agf',1,1,'2023-9-3')
-- 8
insert into matches values('vib','fcm',2,2,'2023-9-15')
insert into matches values('fcn','fck',2,2,'2023-9-16')
insert into matches values('vej','rfc',1,2,'2023-9-17')
insert into matches values('hvi','lyn',0,1,'2023-9-17')
insert into matches values('agf','bif',0,3,'2023-9-17')
insert into matches values('ob','sil',0,3,'2023-9-18')
-- 9
insert into matches values('lyn','vej',1,1,'2023-9-22')
insert into matches values('sil','vib',2,0,'2023-9-24')
insert into matches values('bif','fck',2,3,'2023-9-24')
insert into matches values('rfc','agf',1,1,'2023-9-24')
insert into matches values('fcm','ob',2,1,'2023-9-24')
insert into matches values('fcn','hvi',0,0,'2023-9-25')
-- 10
insert into matches values('fck','fcm',0,2,'2023-9-30')
insert into matches values('vej','fcn',0,0,'2023-10-1')
insert into matches values('rfc','sil',1,0,'2023-10-1')
insert into matches values('hvi','bif',0,3,'2023-10-1')
insert into matches values('vib','agf',2,1,'2023-10-1')
insert into matches values('ob','lyn',1,2,'2023-10-2')
-- 11
insert into matches values('sil','lyn',5,0,'2023-10-6')
insert into matches values('fcn','ob',0,1,'2023-10-8')
insert into matches values('vej','hvi',3,1,'2023-10-8')
insert into matches values('bif','vib',1,0,'2023-10-8')
insert into matches values('fcm','rfc',2,2,'2023-10-8')
insert into matches values('agf','fck',1,1,'2023-10-8')
-- 12
insert into matches values('hvi','sil',1,2,'2023-10-20')
insert into matches values('fck','vej',2,1,'2023-10-21')
insert into matches values('lyn','agf',0,2,'2023-10-22')
insert into matches values('vib','fcn',0,2,'2023-10-22')
insert into matches values('rfc','bif',2,2,'2023-10-23')
insert into matches values('ob','fcm',1,2,'2023-10-23')
-- 13
insert into matches values('fcm','lyn',2,1,'2023-10-27')
insert into matches values('fck','hvi',4,0,'2023-10-28')
insert into matches values('vej','vib',1,1,'2023-10-29')
insert into matches values('sil','ob',0,0,'2023-10-29')
insert into matches values('bif','fcn',2,1,'2023-10-29')
insert into matches values('agf','rfc',2,1,'2023-10-30')
-- 14
insert into matches values('lyn','ob',2,2,'2023-11-4')
insert into matches values('fcn','vej',1,0,'2023-11-5')
insert into matches values('vib','sil',2,1,'2023-11-5')
insert into matches values('rfc','fck',2,4,'2023-11-5')
insert into matches values('hvi','fcm',1,4,'2023-11-5')
insert into matches values('bif','agf',1,1,'2023-11-6')
-- 15
insert into matches values('sil','rfc',1,1,'2023-11-10')
insert into matches values('fck','bif',0,0,'2023-11-12')
insert into matches values('vej','lyn',1,0,'2023-11-12')
insert into matches values('fcm','fcn',2,0,'2023-11-12')
insert into matches values('ob','hvi',0,2,'2023-11-12')
insert into matches values('agf','vib',2,0,'2023-11-12')
-- 16
insert into matches values('hvi','vej',1,1,'2023-11-24')
insert into matches values('vib','fck',2,1,'2023-11-25')
insert into matches values('fcn','agf',0,0,'2023-11-26')
insert into matches values('rfc','ob',0,1,'2023-11-26')
insert into matches values('lyn','bif',3,3,'2023-11-26')
insert into matches values('sil','fcm',1,4,'2023-11-27')
--17
insert into matches values('rfc','vej',0,0,'2023-12-1')
insert into matches values('ob','fcn',1,1,'2023-12-3')
insert into matches values('lyn','sil',2,0,'2023-12-3')
insert into matches values('bif','hvi',4,0,'2023-12-3')
insert into matches values('fck','agf',1,2,'2023-12-3')
insert into matches values('fcm','vib',5,1,'2023-12-4')
--18
insert into matches values('vib','ob',1,2,'2024-2-16')
insert into matches values('fcn','lyn',3,2,'2024-2-18')
insert into matches values('hvi','rfc',1,3,'2024-2-18')
insert into matches values('sil','fck',0,3,'2024-2-18')
insert into matches values('bif','fcm',1,0,'2024-2-18')
insert into matches values('vej','agf',0,0,'2024-2-19')
go


-- delopgave 1 extra
SELECT name, nomatches, ourgoals, othergoals, points
FROM teams
ORDER BY points DESC, (ourgoals - othergoals) DESC, ourgoals DESC
go

-- delopgave 2 extra
DELETE FROM matches
WHERE
	homeid = 'fcm' AND
	outid = 'hvi' AND
	matchdate = '2023-7-21'
go

-- delopgave 3 extra
--('fck','agf',1,2,'2023-12-3')
UPDATE matches
SET homegoal = 2,
    outgoal = 4,
	homeid = 'fcm'
WHERE
    homeid = 'fck' AND
    outid = 'agf'
    AND matchdate = '2023-12-03'
go

-- delopgave 4 extra
EXEC leaderboardAtTheDate '2023-07-28'
go

-- delopgave 5 extra
EXEC teamInLeadingDate
go

-- delopgave 6 extra
drop table if exists matches
drop table teams
create table teams (
	id char(3) primary key nonclustered,
	name varchar(40),
	nomatches int,
	ourgoals int,
	othergoals int,
	points int,
	-- goal_diff AS (ourgoals - othergoals) PERSISTED
)

-- CREATE CLUSTERED INDEX idx_teams ON teams(points DESC, goal_diff DESC, ourgoals DESC);
CREATE CLUSTERED INDEX idx_teams ON teams(points DESC, ourgoals - othergoals DESC, ourgoals DESC);

select * from teams;