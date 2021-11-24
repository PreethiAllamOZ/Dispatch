
-- Alpha samples are drilled core, production sample
--INSERT INTO dbo.GB_SAMPLE_DOWNHOLE(Hole_ID,DEPTH_FROM,DEPTH_TO,Sample_ID,DrillSample_Type,Prospect,GBUpd_GUID)
SELECT Hole_ID,Depth_From,Depth_To,Sample_ID,Sample_Type,Prospect,NEWID() AS GBUpd_GUID
FROM DD20FIS001
WHERE Sample_Group = 'ALPHA';

-- Standard Sample
--INSERT INTO GB_SAMPLE_QAQC(Sample_ID,Sample_Type,Standard_Code,Hole_ID,GBUpd_GUID)
SELECT Sample_ID,'STANDARD' AS Sample_Type,Standard_ID AS Standard_Code,Hole_ID,NEWID() AS GBUpd_GUID
FROM DD20FIS001
WHERE LEN(Standard_ID)>0


-- Lab duplicate, which has same depth interval. But during the lab processing, split the sample into 2 for QAQC
--INSERT INTO GB_SAMPLE_QAQC(Sample_ID,Sample_Type,Sample_ID_orig,Hole_ID,GBUpd_GUID,COMMENTS)
SELECT A.Sample_ID,(CASE WHEN A.Sample_Type like 'CORE%' THEN 'FIELDDUP' ELSE 'PREPDUPA' END) AS Sample_Type,
B.Sample_ID AS Sample_ID_orig,A.Hole_ID,NEWID() AS GBUpd_GUID,A.Sample_Type AS COMMENTS
FROM DD20FIS001 AS A JOIN (SELECT * FROM DD20FIS001 WHERE Sample_Group = 'ALPHA') AS B 
ON A.Hole_ID = B.Hole_ID AND A.DEPTH_FROM = B.DEPTH_FROM AND A.DEPTH_TO = B.DEPTH_TO
WHERE A.Sample_Group = 'DUP'

