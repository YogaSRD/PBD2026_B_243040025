--1
CREATE DATABASE TokoRetailDB;
GO

USE TokoRetailDB;
GO

PRINT 'Database TokoRetailDB berhasil digunakan.';

--2
CREATE TABLE Produk(
	ProdukID INT,
	SKU varchar(15),
	NamaProduk VARCHAR(100),
	Harga DECIMAL(10,2),
	Stok INT
);

EXEC sp_help 'Produk';

--3
CREATE TABLE Pelanggan (
	PelangganID INT IDENTITY(1,1) PRIMARY KEY,

	NamaDepan VARCHAR(50) NOT NULL,
	NamaBelakang VARCHAR(50) NOT NULL,

	Email VARCHAR(100) NOT NULL UNIQUE,

	TanggalDaftar DATE DEFAULT GETDATE()
);
EXEC sp_help 'Pelanggan';

--4
CREATE TABLE PesananHeader(
	PesananID INT IDENTITY(1,1) PRIMARY KEY,

	TanggalPesanan DATETIME2 NOT NULL,

	PelangganID INT NOT NULL,

	StatusPesanan VARCHAR(10) NOT NULL,

	CONSTRAINT Fk_Pesanan_Pelanggan
	FOREIGN KEY (PelangganID)
	REFERENCES Pelanggan(PelangganID),

	CONSTRAINT CHK_StatusPesanan
	CHECK (StatusPesanan IN ('Baru', 'Proses', 'Selesai'))
);

EXEC sp_help 'PesananHeader';

--5
ALTER TABLE Produk 
ALTER COLUMN ProdukID INT NOT NULL; 
GO

ALTER TABLE Produk 
ADD CONSTRAINT PK_Produk PRIMARY KEY (ProdukID);
GO

ALTER TABLE Pelanggan 
ADD NoTelepon VARCHAR(20) NULL; 
GO 

ALTER TABLE Produk 
ALTER COLUMN Harga DECIMAL(10, 2) NOT NULL; 
GO

EXEC sp_help 'Produk'; 
EXEC sp_help 'Pelanggan';

--6
CREATE TABLE PesananDetail ( 
    PesananDetailID INT IDENTITY(1,1) PRIMARY KEY, 
    PesananID INT NOT NULL, 
    ProdukID INT NOT NULL, 
    Jumlah INT NOT NULL, 
     
    CONSTRAINT FK_Detail_Header  
    FOREIGN KEY (PesananID) REFERENCES PesananHeader(PesananID), 
     
    CONSTRAINT FK_Detail_Produk 
    FOREIGN KEY (ProdukID) REFERENCES Produk(ProdukID) 
); 
GO

-- 2. Coba hapus tabel Pelanggan (GAGAL) 
PRINT 'Mencoba menghapus Pelanggan... (Harusnya Gagal)'; 
DROP TABLE Pelanggan; -- Pesan Error: "Could not drop object 'Pelanggan' because it is referenced by a FOREIGN KEY constraint 'FK_Pesanan_Pelanggan'." 
GO 

-- 3. Coba hapus tabel PesananHeader (GAGAL) 
PRINT 'Mencoba menghapus PesananHeader... (Harusnya Gagal)'; 
DROP TABLE PesananHeader; -- Pesan Error: "Could not drop object 'PesananHeader' because it is referenced by a FOREIGN KEY constraint 'FK_Detail_Header'." 
GO

-- 4. Hapus tabel secara berurutan (dari anak ke induk) 
PRINT 'Menghapus PesananDetail (tabel anak) terlebih dahulu...'; 
DROP TABLE PesananDetail; 
GO 

PRINT 'Menghapus PesananHeader (tabel induk dari detail) ...'; 
DROP TABLE PesananHeader; 
GO 

PRINT 'Menghapus Pelanggan (tabel induk dari header)...'; 
DROP TABLE Pelanggan; 
GO
