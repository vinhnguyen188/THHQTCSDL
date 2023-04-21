create table Mathang(
mahang nvarchar(50) primary key,
tenhang nvarchar(50),
soluong INT
)

create table Nhatkybanhang(
stt nvarchar(50) primary key,
ngay nvarchar(50), 
nguoimua nvarchar(50), 
mahang nvarchar(50),
soluong INT, 
giaban nvarchar(50)
)

insert into Mathang(mahang,tenhang,soluong)
values('1','Keo','100'),
('2','Banh','200'),
('3','Thuoc','100')

insert into Nhatkybanhang(stt,ngay,nguoimua,mahang,soluong,giaban)
values('1','1999-02-09','ab','2','230','50000')