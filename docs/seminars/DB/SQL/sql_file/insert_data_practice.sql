-- <syain_master>

INSERT INTO syain_master(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (1,'比嘉 哲平',45,null,'那覇市首里大名町',243000,1,1);
INSERT INTO syain_master(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (2,'山田 慎一',25,'222-2222','豊見城市真玉橋',98000,3,2);
INSERT INTO syain_master(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (3,'金城 まゆみ',24,'333-3333','南風原町大名',125000,2,2);
INSERT INTO syain_master(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (4,'城間 真澄',35,'444-4444','那覇市国場',204000,2,2);
INSERT INTO syain_master(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (5,'山城 亮介',55,null,'浦添市大平',270000,2,2);
INSERT INTO syain_master(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (6,'田原 美由紀',30,'666-6666','宜野湾市愛知',197000,3,3);

-- <Arbeit>

INSERT INTO Arbeit(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (1,'知念 雅人',21,null,'西原町嘉手苅',110000,1,1);
INSERT INTO Arbeit(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (2,'下地 綾乃',20,'777-7777','中城村南上原',81000,2,1);
INSERT INTO Arbeit(no,name,age,tel,address,salary,siten_code,syouhin_cd) VALUES (3,'平良 祐作',19,'888-8888','与那原町与那原',77000,3,1);

-- <syouhin>
INSERT INTO syouhin(code,syouhin_cd,syouhinmei,maker,tanka,kazu,rank) VALUES (1,1,'やわらか本ソーキ','くわっちー精肉店',500,1100,'B');
INSERT INTO syouhin(code,syouhin_cd,syouhinmei,maker,tanka,kazu,rank) VALUES (1,2,'とろとろ軟骨ソーキ','くわっちー精肉店',400,1200,'A');
INSERT INTO syouhin(code,syouhin_cd,syouhinmei,maker,tanka,kazu,rank) VALUES (2,1,'がっつり三枚肉','まーさんミート',300,1300,'B');
INSERT INTO syouhin(code,syouhin_cd,syouhinmei,maker,tanka,kazu,rank) VALUES (2,2,'味付けてびち','まーさんミート',800,1100,'C');
INSERT INTO syouhin(code,syouhin_cd,syouhinmei,maker,tanka,kazu,rank) VALUES (3,1,'八重山かまぼこ','うみんちゅ鮮魚店',200,1600,'B');
INSERT INTO syouhin(code,syouhin_cd,syouhinmei,maker,tanka,kazu,rank) VALUES (3,2,'宮古かまぼこ','うみんちゅ鮮魚店',300,1500,'A');
INSERT INTO syouhin(code,syouhin_cd,syouhinmei,maker,tanka,kazu,rank) VALUES (3,3,'野菜かまぼこ','うみんちゅ鮮魚店',350,700,'D');

-- <zaiko>
INSERT INTO zaiko(code,syouhin_cd,kazu) VALUES (1,1,2300);
INSERT INTO zaiko(code,syouhin_cd,kazu) VALUES (1,2,2400);
INSERT INTO zaiko(code,syouhin_cd,kazu) VALUES (2,1,2500);
INSERT INTO zaiko(code,syouhin_cd,kazu) VALUES (2,2,2300);
INSERT INTO zaiko(code,syouhin_cd,kazu) VALUES (3,1,2800);
INSERT INTO zaiko(code,syouhin_cd,kazu) VALUES (3,2,2700);
INSERT INTO zaiko(code,syouhin_cd,kazu) VALUES (3,3,1700);
