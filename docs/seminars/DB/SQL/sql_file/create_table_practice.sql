CREATE TABLE syain_master (
       no                INTEGER NOT NULL,
       name              VARCHAR(100),
       age               INTEGER,
       tel               VARCHAR(100),
       address           VARCHAR(100),
       salary            INTEGER,
       siten_code        INTEGER,
       syouhin_cd        INTEGER,
       PRIMARY KEY (no)
);

CREATE TABLE Arbeit (
       no                INTEGER NOT NULL,
       name              VARCHAR(100),
       age               INTEGER,
       tel               VARCHAR(100),
       address           VARCHAR(100),
       salary            INTEGER,
       siten_code        INTEGER,
       syouhin_cd        INTEGER,
       PRIMARY KEY (no)
);

CREATE TABLE syouhin (
       code              INTEGER NOT NULL,
       syouhin_cd        INTEGER NOT NULL,
       syouhinmei        VARCHAR(100),
       maker             VARCHAR(100),
       tanka             INTEGER,
       kazu              INTEGER,
       rank              CHAR(1),
       PRIMARY KEY (code, syouhin_cd)
);

CREATE TABLE zaiko (
       code              INTEGER NOT NULL,
       syouhin_cd        INTEGER NOT NULL,
       kazu              INTEGER,
       PRIMARY KEY (code, syouhin_cd)
);
