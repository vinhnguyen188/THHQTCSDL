--1--
CREATE TABLE Nhap (
SoHDN INT PRIMARY KEY,
MaVT VARCHAR(50) NOT NULL,
SoLuongN INT NOT NULL,
DonGiaN FLOAT NOT NULL,
NgayN DATE NOT NULL
);


CREATE TABLE Xuat (
SoHDX INT PRIMARY KEY,
MaVT VARCHAR(50) NOT NULL,
SoLuongX INT NOT NULL,
DonGiaX FLOAT NOT NULL,
NgayX DATE NOT NULL
);


CREATE TABLE Ton (
MaVT VARCHAR(50) PRIMARY KEY,
TenVT VARCHAR(100) NOT NULL,
SoLuongT INT NOT NULL
);

INSERT INTO Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN)
VALUES
(1, 'VT001', 10, 5000, '2022-04-20'),
(2, 'VT002', 20, 8000, '2022-04-21'),
(3, 'VT003', 15, 10000, '2022-04-22');

INSERT INTO Xuat (SoHDX, MaVT, SoLuongX, DonGiaX, NgayX)
VALUES
(1, 'VT001', 5, 8000, '2022-04-20'),
(2, 'VT002', 10, 12000, '2022-04-21'),
(3, 'VT003', 8, 15000, '2022-04-22');

INSERT INTO Ton (MaVT, TenVT, SoLuongT)
VALUES
('VT001', 'Vật tư số 1', 50),
('VT002', 'Vật tư số 2', 30),
('VT003', 'Vật tư số 3', 20),
('VT004', 'Vật tư số 4', 40);
--2--
CREATE FUNCTION TinhTienBan(@mavt VARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT Xuat.MaVT, Ton.TenVT, Xuat.NgayX, SUM(Xuat.SoLuongX * Xuat.DonGiaX) AS TienBan
    FROM Xuat
    JOIN Ton ON Xuat.MaVT = Ton.MaVT
    WHERE Xuat.MaVT = @mavt
    GROUP BY Xuat.MaVT, Ton.TenVT, Xuat.NgayX;
	SELECT * FROM TinhTienBan('VT001');
--3--
CREATE FUNCTION TinhTongTienNhap(@MaVT VARCHAR(50), @NgayNhap DATE)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TongTien FLOAT;
    SELECT @TongTien = SUM(SoLuongN*DonGiaN)
    FROM Nhap
    WHERE MaVT = @MaVT AND NgayN = @NgayNhap;
    RETURN @TongTien;
END;
SELECT dbo.TinhTongTienNhap('VT001', '2022-04-20') AS TongTienNhap;
--4--
CREATE TRIGGER update_Ton_After_Insert
ON Nhap
AFTER INSERT
AS
BEGIN
    DECLARE @MaVT VARCHAR(50), @SoLuongN INT;
    DECLARE cur CURSOR FOR SELECT MaVT, SoLuongN FROM inserted;
    
    OPEN cur;
    
    FETCH NEXT FROM cur INTO @MaVT, @SoLuongN;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT * FROM Ton WHERE MaVT = @MaVT)
        BEGIN
            UPDATE Ton SET SoLuongT = SoLuongT + @SoLuongN WHERE MaVT = @MaVT;
        END
        ELSE
        BEGIN
            ROLLBACK;
            RAISERROR('Mã VT chưa có mặt trong bảng Ton', 16, 1);
            RETURN;
        END
        
        FETCH NEXT FROM cur INTO @MaVT, @SoLuongN;
    END
    
    CLOSE cur;
    DEALLOCATE cur;
END;
