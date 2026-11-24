USE AdventureWorks_Latihan

SELECT  *
FROM Production.Product;

SELECT NAME, ProductNumber, ListPrice
FROM Production.Product;

SELECT Name AS [Nama Barang], ListPrice AS 'Harga Jual' /*sama aja kalo spasi mau [] atau  '' */
FROM Production.product;

SELECT NAME, 
		ListPrice, 
		(ListPrice*1.1) AS 'Harga Baru'
FROM Production.Product;

SELECT Name +' (PRO.Num'+ ProductNumber+ ') ' AS ProductLengkap /**/
FROM Production.Product;

