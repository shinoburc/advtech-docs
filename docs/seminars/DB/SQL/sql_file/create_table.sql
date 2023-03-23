CREATE TABLE syain_master (
       no                INTEGER NOT NULL,
       name              VARCHAR(100),
       age               INTEGER,
       tel               VARCHAR(100),
       address           VARCHAR(100),
       siten_code        INTEGER,
       PRIMARY KEY (no)
);

CREATE TABLE Arbeit (
       no                INTEGER NOT NULL,
       name              VARCHAR(100),
       age               INTEGER,
       tel               VARCHAR(100),
       address           VARCHAR(100),
       siten_code        INTEGER,
       PRIMARY KEY (no)
);

CREATE TABLE syouhin (
       code              INTEGER NOT NULL,
       syouhinmei        VARCHAR(100),
       maker             VARCHAR(100),
       tanka             INTEGER,
       kazu              INTEGER,
       PRIMARY KEY (code)
);

CREATE TABLE zaiko (
       code              INTEGER NOT NULL,
       kazu              INTEGER,
       PRIMARY KEY (code)
);

