create database providers;
use providers;


CREATE TABLE Pieces (
 Code INTEGER PRIMARY KEY NOT NULL,
 Name TEXT NOT NULL
 );
CREATE TABLE Providers (
 Code VARCHAR(40) 
 PRIMARY KEY NOT NULL,  
 Name TEXT NOT NULL 
 );
CREATE TABLE Provides (
 Piece INTEGER, 
 FOREIGN KEY (Piece) REFERENCES Pieces(Code),
 Provider VARCHAR(40), 
 FOREIGN KEY (Provider) REFERENCES Providers(Code),  
 Price INTEGER NOT NULL,
 PRIMARY KEY(Piece, Provider) 
 );
 
-- alternative one for SQLite
  /* 
 CREATE TABLE Provides (
 Piece INTEGER,
 Provider VARCHAR(40),  
 Price INTEGER NOT NULL,
 PRIMARY KEY(Piece, Provider) 
 );
 */
 
 
INSERT INTO Providers(Code, Name) VALUES('HAL','Clarke Enterprises');
INSERT INTO Providers(Code, Name) VALUES('RBT','Susan Calvin Corp.');
INSERT INTO Providers(Code, Name) VALUES('TNBC','Skellington Supplies');

INSERT INTO Pieces(Code, Name) VALUES(1,'Sprocket');
INSERT INTO Pieces(Code, Name) VALUES(2,'Screw');
INSERT INTO Pieces(Code, Name) VALUES(3,'Nut');
INSERT INTO Pieces(Code, Name) VALUES(4,'Bolt');

INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'HAL',10);
INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'RBT',15);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'HAL',20);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'RBT',15);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'TNBC',14);
INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'RBT',50);
INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'TNBC',45);
INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'HAL',5);
INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'RBT',7);


-- 5.1 Select the name of all the pieces.
select name from pieces;

-- 5.2  Select all the providers' data.
select * from providers;

-- 5.3 Obtain the average price of each piece (show only the piece code and the average price).
select piece, avg(price) from provides
group by piece;

-- 5.4  Obtain the names of all providers who supply piece 1.
select providers.name from providers
join provides
on providers.code = provides.piece
where provides.piece = 1;

/* With subquery */
 SELECT Name
   FROM Providers
  WHERE Code IN
   (SELECT Provider FROM Provides WHERE Piece = 1);

-- 5.5 Select the name of pieces provided by provider with code "HAL".
select name from pieces
join provides
on provides.piece = pieces.code
and provides.provider = 'HAL';

/* With IN subquery */
 SELECT Name
   FROM Pieces
   WHERE Code IN
     (SELECT Piece FROM Provides WHERE Provider = 'HAL');


 /* With EXISTS subquery */
 SELECT Name
   FROM Pieces
   WHERE EXISTS
   (
     SELECT * FROM Provides
       WHERE Provider = 'HAL'
         AND Piece = Pieces.Code
   );

-- ---------------------------------------------
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Interesting and important one.
-- 5.6 For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price 
-- (note that there could be two providers who supply the same piece at the most expensive price).
select pieces.name as piece, providers.name as provider, price
from pieces
join provides on pieces.Code = piece
join providers on providers.code = provider
where price = (
				select max(price) from provides
                where piece = pieces.code
                );

-- ---------------------------------------------
-- 5.7 Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 7 cents each.
INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'TNBC',7);

-- 5.8 Increase all prices by one cent.
update provides
set price = price+1;

-- 5.9 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
delete from provides
where provider = 'RBT' and piece = 4;

-- 5.10 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces 
    -- (the provider should still remain in the database).
delete from provides
where provider = 'RBT';