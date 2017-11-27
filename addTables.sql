/* 
 * 	INSTRUCTIONS FOR USE
 *
 * This Procedure creates a number of tables for a given range.
 * example addTables(1,1,1,10,0)
 * The above creates tables in the TMTABLEAREA 1 (this is the first digit)
 * With the Table image From the TMCOLLECTION Table with the TMCOLLECTIONID of 1 (this is the second digit)
 * With the DEFTABLENO of 1 (this is the third digit) to 10 (This is the forth digit)
 * The make a grid the setting is binary, so 1 is create a grid and 0 is not to create a grid (this is the fifth digit)
 *
 * addTables(TMTABLEAREAID, TMCOLLECTIONID, Staring DEFTABLENO, Ending DEFTABLENO, GRID on/off 1/0)
 */
SET TERM ^ ;
CREATE PROCEDURE addTables(
	tabAreaID INTEGER,
	tableImageID INTEGER,
	tableNoStart INTEGER,
	tableNoEnd INTEGER,
	grid INTEGER
	)	
AS

declare variable thecount INTEGER; 	/* Used to check if there is images and areas */
declare variable centx INTEGER; 	/* Starting position of X axis on grid */
declare variable centy INTEGER; 	/* Starting position of Y axis on grid */
declare variable xoffset INTEGER;	/* Offset spaceing for X axis */
declare variable yoffset INTEGER;	/* Offset spaceing for Y axis */
declare variable stcentx INTEGER;	/* Storage for the starting position for X axis */
declare variable endcentx INTEGER;	/* Ending position of Y axis on grid */ 

BEGIN

	/* === Advanced settings for the add table script. Only change these if you are sure of what you are doing (or you can test in an empty database) === */	
	centx = 100;	/* X axis start point */
	centy = 100;	/* Y axis start point */
	xoffset = 100;	/* X axis spaceing */
	yoffset = 100;	/* Y axis spaceing */
	endcentx = 600;	/* Y axis end point */
	
	/* Check if there is a Area */
	select count(TMTABLEAREAID)
	FROM TMTABLEAREA
	INTO :thecount;
	
	/* Create a tablearea if there is none */
	IF (thecount = 0) THEN 
	BEGIN
		INSERT INTO TMTABLEAREA (TMTABLEAREAID, AREANAME, AREAWIDTH, AREAHEIGHT, IMAGEFILENAME, TMTABLEAREAORDER, WHENUPD, WHENDELETED, LOGINID, OUTLETID, LIST, BOOKINGTYPE, ACCFILTERID) 
		VALUES ('1', 'Tables', '600', '600', 'bkground.bmp', '1', NULL, NULL, '1', '1', '0', NULL, NULL);
		tabAreaID = 1;
	END	
	
	thecount = 0;
	
	/* Check if there is a table image */
	select count(TMIMAGECOLLECTIONID)
	FROM TMIMAGECOLLECTION
	INTO :thecount;
	
	/* Create an image if there is none */
	IF (thecount = 0) THEN
	BEGIN
		INSERT INTO TMIMAGECOLLECTION (TMIMAGECOLLECTIONID, COLLECTIONNAME, COLLECTIONPATH, WHENUPD, WHENDELETED, LOGINID) 
		VALUES ('1', 'square', 'square.bmp', '10.10.2014, 11:54:36.000', NULL, '1');
		tableImageID = 1;
	END
	
	/* Add the Tables, set with no grid */
	IF (:grid = 0) THEN
	while (tableNoStart <= tableNoEnd) do 	
	BEGIN
		INSERT INTO TMTABLE 
		(TMTABLEID, TMTABLEAREAID, TMCOLLECTIONID, DEFANGLE, DEFCENTERX, DEFCENTERY, DEFTABLENO, ANGLE, CENTERX, CENTERY, GROUPID, PARENTTMTABLEID, WHENUPD, WHENDELETED, LOGINID) 
		VALUES (NULL, :tabAreaID , :tableImageID , '0', :centx, :centy, :tableNoStart , '0', :centx, :centy, NULL, NULL, NULL, NULL, '1');		
		tableNoStart =	tableNoStart + 1;
	END
	
	/* 
	 * Add the tables if adding the tables without a grid has not run. This is checked by the while loop exiting if the previous while loop ran.
	 * Set the store variable for the starting point of the Y axis 
	 */
	stcentx = centx;
	while (tableNoStart <= tableNoEnd) do
	BEGIN		
		
		/* Reset centx and increse centy by the offset when the line is full */ 
		IF (centx > endcentx) THEN
		BEGIN
			centx = stcentx; 
			centy = centy + yoffset;
		END
			
		INSERT INTO TMTABLE 
		(TMTABLEID, TMTABLEAREAID, TMCOLLECTIONID, DEFANGLE, DEFCENTERX, DEFCENTERY, DEFTABLENO, ANGLE, CENTERX, CENTERY, GROUPID, PARENTTMTABLEID, WHENUPD, WHENDELETED, LOGINID) 
		VALUES (NULL, :tabAreaID , :tableImageID , '0', :centx, :centy, :tableNoStart , '0', :centx, :centy, NULL, NULL, NULL, NULL, '1');

		tableNoStart =	tableNoStart + 1;
		centx = centx + xoffset;		
	END
END
^

/* ====== MAKE YOUR CHANGES IN THE PROCDURE BELOW ====== */

SET TERM ; ^

EXECUTE PROCEDURE addTables(1,1,1,20,1);
DROP PROCEDURE addTables;

COMMIT;