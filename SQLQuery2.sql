USE AdventureWorks2022
GO
--T?o m?t th? t?c l?u tr? l?y ra to�n b? nh�n vi�n v�o l�m theo n?m c� tham s? ??u v�o l� m?t n?m
CREATE PROCEDURE sp_DisplayEmployeesHireYear
	@HireYear int
AS 
SELECT*FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate)=@HireYear
GO
--?? ch?y th? t?c n�y c?n ph?i truy?n tham s? v�o l� n?m m� nh�n vi�n v�o l�m
EXECUTE sp_DisplayEmployeesHireYear 2009
GO
--T?o th? t?c l?u tr? ??m s? ng??i v�o l�m trong m?t n?m x�c ??nh c� tham s? ??u v�o l� m?t n?m
-- tham s? ??u ra l� s? ng??i v�o l�m trong n?m n�y
CREATE PROCEDURE sp_EmployeesHireYearCount
	@HireYear int,
	@Count int OUTPUT
	AS 
	SELECT @Count=COUNT(*)FROM HumanResources.Employee
	WHERE DATEPART(YY, HireDate)=@HireYear
	GO
	--Ch?y th? t?c l?u tr? c?n ph?i truy?n v�o 1 tham s? ??u v�o v� m?t tham s? ??u ra.
	DECLARE @Number int
	EXECUTE  sp_EmployeesHireYearCount 2009, @Number OUTPUT
	PRINT @Number
	GO
	--T?o th? t?c l?u tr? ??m s? ng??i v�o l�m trong m?t n?m x�c ??nh c� tham s? ??u v�o l� m?t n?m, h�m tr? v? s? ng??i v�o l�m n?m ?�
	CREATE PROCEDURE sp_EmployeesHireYearCount2
		@HireYear int
		AS 
		DECLARE @Count int
		SELECT @Count= COUNT(*) FROM HumanResources.Employee
		WHERE DATEPART(YY, HireDate)=@HireYear
		RETURN @Count
		GO
--Ch?y th? t?c l?u tr? c?n ph?i truy?n v�o 1 tham s? ??u v� l?y v? s? ng??i l�m trong n?m ?�.
		DECLARE @Number int
		EXECUTE @Number = sp_EmployeesHireYearCount2 2009
		PRINT @Number
		GO
--T?o b?ng t?m #Students		
CREATE TABLE #Students
(
RollNo varchar(6) CONSTRAINT PK_Students PRIMARY KEY,
FullName nvarchar(100),
Birthday datetime constraint DF_StudentsBirthday DEFAULT 
DATEADD(yy, -18, GETDATE())
)
GO
--T?o th? t?c l?u tr? t?m ?? ch�n d? li?u v�o b?ng t?m
CREATE PROCEDURE #spInsertStudents
@rollNo varchar(6),
@fullName nvarchar(100),
@birthday datetime
AS BEGIN
IF(@birthday IS NULL)
SET @birthday=DATEADD(YY, -18, GETDATE())
INSERT INTO #Students(RollNo, FullName, Birthday)
VALUES(@rollNo, @fullName, @birthday)
END
GO
--S? d?ng th? t?c l?u tr? ?? ch�n d? li?u v�o b?ng t?m
EXEC #spInsertStudents 'A12345', 'abc', NULL
EXEC #spInsertStudents 'A54321', 'abc', '12/24/2011'
SELECT * FROM #Students
--T?o th? t?c l?u tr? t?m ?? x�a d? li?u t? b?ng t?m theo RollNo
CREATE PROCEDURE #spDeleteStudents
@rollNo varchar(6)
AS BEGIN
DELETE FROM #Students WHERE RollNo=@rollNo
END
DROP PROCEDURE #spDeleteStudents
--X�a d? li?u s? d?ng th? t?c l?u tr?
EXECUTE #spDeleteStudents 'A12345'
GO
--T?o m?t th? t?c l?u tr? s? dung l?nh RETURN ?? tr? v? m?t s? nguy�n
CREATE PROCEDURE Cal_Square @num int=0 
AS 
BEGIN
RETURN (@num * @num);
END
GO
--Ch?y th? t?c l?u tr?
DECLARE @square int;
EXEC @square = Cal_Square 10;
PRINT @square;
GO
--Xem ??nh ngh?a th? t?c l?u tr? b?ng h�m OBJECT_DEFINITION
SELECT 
OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')) 
AS DEFINITION
GO
--Xem ??nh ngh?a th? t?c l?u tr? b?ng
SELECT definition FROM sys.sql_modules
WHERE 
object_id=OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO
--Th? t?c l?u tr? h? th?ng xem c�c th�nh ph?n m� th? t?c l?u tr? ph? thu?c
sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
GO
USE AdventureWorks2022
GO
--T?o th? t?c l?u tr? sp_DisplayEmployees
CREATE PROCEDURE sp_DisplayEmployees 
AS
SELECT * FROM HumanResources.Employee
GO
--Thay ??i th? t?c l?u tr? sp_DisplayEmployees
ALTER PROCEDURE sp_DisplayEmployees 
AS
SELECT * FROM HumanResources.Employee
WHERE Gender='F'
GO
--Ch?y th? t?c l?u tr? sp_DisplayEmployees
EXEC sp_DisplayEmployees
GO
--X�a m?t th? t?c l?u tr?
DROP PROCEDURE sp_DisplayEmployees
GO
CREATE PROCEDURE sp_EmployeeHire
AS
BEGIN
--Hi?n th?
EXECUTE sp_DisplayEmployeesHireYear 1999
DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount 1999, @Number OUTPUT
PRINT N'S? nh�n vi�n v�o l�m n?m 1999 l�: ' + 
CONVERT(varchar(3),@Number)
END
GO
--Ch?y th? t?c l?u tr?
EXEC sp_EmployeeHire GO
--Thay ??i th? t?c l?u tr? sp_EmployeeHire c� kh?i TRY ... CATCH
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
BEGIN TRY
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
--L?i x?y ra ? ?�y c� th? t?c sp_EmployeesHireYearCount ch? truy?n 2 tham s? m� ta truy?n 3
EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, '123'
PRINT N'S? nh�n vi�n v�o l�m n?m l�: ' + CONVERT(varchar(3),@Number)
END TRY
BEGIN CATCH
PRINT N'C� l?i x?y ra trong khi th?c hi?n th? t?c l?u tr?'
END CATCH
PRINT N'K?t th�c th? t?c l?u tr?'
END
GO
--Ch?y th? t?c sp_EmployeeHire
EXEC sp_EmployeeHire 2009
--Xem th�ng b�o l?i b�n Messages kh�ng ph?i b�n Result
GO
--Thay ??i th? t?c l?u tr? sp_EmployeeHire s? d?ng h�m @@ERROR
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
--L?i x?y ra ? ?�y c� th? t?c sp_EmployeesHireYearCount ch? truy?n 2 tham s? m� ta truy?n 3
EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, '123'
IF @@ERROR <> 0
PRINT N'C� l?i x?y ra trong khi th?c hi?n th? t?c l?u tr?'
PRINT N'S? nh�n vi�n v�o l�m n?m l�: ' + 
CONVERT(varchar(3),@Number)
END
GO
--Ch?y th? t?c sp_EmployeeHire
EXEC sp_EmployeeHire 2009
--Xem th�ng b�o l?i b�n Messages kh�ng ph?i b�n Result