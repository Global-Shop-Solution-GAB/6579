CREATE TABLE "GCG_6579_CUSTOM_LBLS" (
 "LID" IDENTITY,
 "USER_ID" CHAR(7),
 "TXID" INTEGER NOT NULL,
 "ORDERNO" NUMERIC(2,0),
 "LABEL" VARCHAR(50) NOT NULL,
 "CONTROLTYPE" INTEGER NOT NULL,
 "FIELDLENGTH" INTEGER,
 "DEFAULTTEXT" VARCHAR(30) );