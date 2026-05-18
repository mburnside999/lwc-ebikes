/* create root level */
List<MB_Root_Level__c> roots = new List<MB_Root_level__c>();
List<MB_Child_Level_1_LU__c> level1lus = new List<MB_Child_Level_1_LU__c>();
List<MB_Child_Level_1_MD__c> level1mds = new List<MB_Child_Level_1_MD__c>();
List<MB_Child_Level_1_LU_AUTO__c> level1autos = new List<MB_Child_Level_1_LU_AUTO__c>();
List<MB_Child_Level_2_LU_1_LU__c> level2lus = new List<MB_Child_Level_2_LU_1_LU__c>();

String PREFIX = 'Privacy-Target-';
//String PREFIX='Mask-Target-';

delete [SELECT id FROM MB_Root_Level__c WHERE name LIKE :PREFIX + '%'];
delete [
    SELECT id
    FROM MB_Child_Level_1_LU__c
    WHERE name LIKE :PREFIX + '%'
];
//delete [SELECT id FROM MB_Child_Level_1_MD__c where mb_root_level__r.name like :PREFIX+'%'];
delete [
    SELECT id
    FROM MB_Child_Level_1_LU_AUTO__c
    WHERE mb_root_level__r.name LIKE :PREFIX + '%'
];
delete [
    SELECT id
    FROM MB_Child_Level_2_LU_1_LU__c
    WHERE name LIKE :PREFIX + '%'
    LIMIT 10000
];

for (Integer i = 0; i < 10; i++) {
    MB_Root_Level__c root = new MB_Root_Level__c();
    root.name = PREFIX + 'Root-' + i;
    root.f1__c = 'Text-' + i;
    root.f2__C = Date.Today();
    root.f3__c = 'LongText-' + i;
    root.archive_me__c = false;
    roots.add(root);
}

insert roots;

for (MB_Root_Level__c root : [SELECT id, name FROM MB_Root_Level__c]) {
    for (Integer i = 0; i < 10; i++) {
        MB_Child_Level_1_LU__c level1lu = new MB_Child_Level_1_LU__c();
        level1lu.name = root.name + '-Level1LU-' + i;
        level1lu.f1__c = 'Text-' + i;
        level1lu.f2__C = Date.Today();
        level1lu.f3__c = 'LongText-' + i;
        level1lu.mb_root_level__c = root.id;
        level1lu.archive_me__c = false;
        level1lus.add(level1lu);
    }
}

insert (level1lus);

for (MB_Root_Level__c root : [SELECT id, name FROM MB_Root_Level__c]) {
    for (Integer i = 0; i < 10; i++) {
        MB_Child_Level_1_MD__c level1md = new MB_Child_Level_1_MD__c();
        level1md.name = root.name + '-Level1MD-' + i;
        level1md.f1__c = 'Text-' + i;
        level1md.f2__C = Date.Today();
        level1md.f3__c = 'LongText-' + i;
        level1md.archive_me__c = false;
        level1md.mb_root_level__c = root.id;

        level1mds.add(level1md);
    }
}

insert (level1mds);

System.debug(level1lus);

for (MB_Root_Level__c root : [SELECT id FROM MB_Root_Level__c]) {
    for (Integer i = 0; i < 10; i++) {
        MB_Child_Level_1_LU_AUTO__c level1auto = new MB_Child_Level_1_LU_AUTO__c();
        //level1md.name=
        level1auto.f1__c = 'Text-' + i;
        level1auto.f2__C = Date.Today();
        level1auto.f3__c = 'LongText-' + i;
        level1auto.archive_me__c = false;
        level1auto.mb_root_level__c = root.id;

        level1autos.add(level1auto);
    }
}

insert (level1autos);

for (MB_Child_Level_1_LU__c level1 : [
    SELECT id, name
    FROM MB_Child_Level_1_LU__c
]) {
    for (Integer i = 0; i < 10; i++) {
        MB_Child_Level_2_LU_1_LU__c level2lu = new MB_Child_Level_2_LU_1_LU__c();
        level2lu.name = level1.name + '-Level2LU-' + i;
        level2lu.f1__c = 'Text-' + i;
        level2lu.f2__C = Date.Today();
        level2lu.f3__c = 'LongText-' + i;
        level2lu.archive_me__c = false;
        level2lu.mb_child_level_1_lu__c = level1.id;
        level2lus.add(level2lu);
    }
}

insert (level2lus);
