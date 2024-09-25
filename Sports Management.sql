use manu;
-- 1. Teams Table
CREATE TABLE Teams (
    TeamID INT PRIMARY KEY AUTO_INCREMENT,
    TeamName VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    CoachName VARCHAR(100)
);

-- 2. Players Table
CREATE TABLE Players (
    PlayerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(30), -- e.g., 'Forward', 'Midfielder', 'Goalkeeper'
    TeamID INT,
    JerseyNumber INT,
    Age INT,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

-- 3. Matches Table
CREATE TABLE Matches (
    MatchID INT PRIMARY KEY AUTO_INCREMENT,
    Team1ID INT, -- Reference to the first team
    Team2ID INT, -- Reference to the second team
    MatchDate DATE,
    Venue VARCHAR(100),
    Team1Score INT,
    Team2Score INT,
    FOREIGN KEY (Team1ID) REFERENCES Teams(TeamID),
    FOREIGN KEY (Team2ID) REFERENCES Teams(TeamID)
);

-- 4. PlayerStatistics Table
CREATE TABLE PlayerStatistics (
    StatID INT PRIMARY KEY AUTO_INCREMENT,
    PlayerID INT,
    MatchID INT,
    Goals INT DEFAULT 0,
    Assists INT DEFAULT 0,
    MinutesPlayed INT,
    YellowCards INT DEFAULT 0,
    RedCards INT DEFAULT 0,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID)
);
-- Inserting Teams
INSERT INTO Teams (TeamName, City, CoachName) 
VALUES 
('Red Dragons', 'New York', 'John Doe'),
('Blue Tigers', 'Los Angeles', 'Jane Smith');

-- Inserting Players
INSERT INTO Players (FirstName, LastName, Position, TeamID, JerseyNumber, Age) 
VALUES 
('Michael', 'Jordan', 'Forward', 1, 23, 30),
('LeBron', 'James', 'Forward', 2, 6, 35),
('Kobe', 'Bryant', 'Guard', 1, 24, 32),
('Stephen', 'Curry', 'Guard', 2, 30, 33);

-- Inserting Matches
INSERT INTO Matches (Team1ID, Team2ID, MatchDate, Venue, Team1Score, Team2Score)
VALUES 
(1, 2, '2024-09-25', 'Madison Square Garden', 105, 98);

-- Inserting Player Statistics
INSERT INTO PlayerStatistics (PlayerID, MatchID, Goals, Assists, MinutesPlayed, YellowCards, RedCards) 
VALUES 
(1, 1, 30, 5, 48, 0, 0), -- Michael Jordan
(2, 1, 28, 7, 50, 0, 0), -- LeBron James
(3, 1, 22, 4, 45, 1, 0), -- Kobe Bryant
(4, 1, 25, 3, 49, 0, 0); -- Stephen Curry

-- List All Players
SELECT * FROM Teams;

-- List All Players in a Specific Team
SELECT FirstName, LastName, Position, JerseyNumber 
FROM Players
WHERE TeamID = 1; -- Replace '1' with the desired TeamID

-- Get All Matches With Their Scores
SELECT 
    MatchID, 
    (SELECT TeamName FROM Teams WHERE TeamID = Matches.Team1ID) AS Team1,
    (SELECT TeamName FROM Teams WHERE TeamID = Matches.Team2ID) AS Team2,
    MatchDate, 
    Team1Score, 
    Team2Score, 
    Venue 
FROM Matches;

-- Get PlayerStatisticks for a Specific Match
SELECT 
    Players.FirstName, 
    Players.LastName, 
    PlayerStatistics.Goals, 
    PlayerStatistics.Assists, 
    PlayerStatistics.MinutesPlayed,
    PlayerStatistics.YellowCards,
    PlayerStatistics.RedCards
FROM PlayerStatistics
JOIN Players ON PlayerStatistics.PlayerID = Players.PlayerID
WHERE PlayerStatistics.MatchID = 1; -- Replace '1' with the desired MatchID

-- Find the Top Scores in the Season
SELECT 
    Players.FirstName, 
    Players.LastName, 
    SUM(PlayerStatistics.Goals) AS TotalGoals
FROM PlayerStatistics
JOIN Players ON PlayerStatistics.PlayerID = Players.PlayerID
GROUP BY Players.PlayerID
ORDER BY TotalGoals DESC;





