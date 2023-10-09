/*

SQL Portfolio Project 3

Our goal is to clean the Nashville Housing dataset to make it more useable 

*/



-- Standardize Date Format
	-- The CONVERT function is used to convert the values in the "SaleDate" column into the Date format for further analysis
	
	-- The UPDATE clause is used to update the existing "NashvilleHousing" database 

	-- The ALTER TABLE clause is used to add a new columnn with the sales dates converted to the proper format

	-- The UPDATE clause is sued again to update the existing "NashvilleHousing" database with the new column with the converted dates

	-- A query is then utilized to confirm the date in the new "SaleDateConverted" column is in the correct format 

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing



-- Populate Property Address Data

	--While exploring the data, I noticed there are NULL values in the "PropertyAddress" column 
		-- I verify this by running a query with the addition of the WHERE clause and "PropertyAddress is null"

	
	--While further exploring this issue, I noticed the Parcel ID is consistently and uniquely tied to the property address 
		--The Parcel ID's with addresses can be used to populate the same Parcel ID that has a NULL entry in the "PropertyAddress" column 
		--To populate the "PropertyAddress" entries with NULL values, we have to join the table to itself in order to examine and fill the data that is missing 
	
	--The second query below verifies the Parcel ID's with both unique addresses in one row and NULL values in another row. Our goal is to replace the NULL values 
	
	-- The third query below accomplishes this by updating NULL values with the correct address in the "PropertyAddress" column 
	
	-- The fourth query below verifies the database has been updated with the correct addresses in place of the NULL values 


SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null




UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null





SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null



--Breaking out Property Address into Individual Columns (Address and City) 

	--The first query selects the street address (before the comma) and the city (after the comma) from the "PropertyAddress" column 

	--The second query modifies the table and adds the "PropertySplitAddress" column that can be used to store the new split address values 

	--The third query updates the new "PropertySplitAddress" column with the appropriate split address data

	--The fourth query modifies the table and adds the "PropertySplitCity" column that can be used to store the new split city values 

	--The fifth query updates the new "PropertySplitCity" column with the appropriate split city data

	--The sixth query is used to double check and ensure the dataset has been updated correctly with the two new columns containing split property data


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing 


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT*
FROM PortfolioProject.dbo.NashvilleHousing 




--Breaking out Owner Address into Individual Columns (Address, City, and State) 

	--The first query verifies the type of information in the "OwnerAddress" column. Our goal is to split the data into three columns

	--The second query utilizes PARSENAME to split the data in the "OwnerAddress" column into three columns 
		--Note the PARSENAME function is only useful with periods. We replace the commas with periods using the REPLACE function

	--The third query modifies the table and adds the "OwnerSplitAddress" column that can be used to store the new split address values in the NVARCHAR format

	--The fourth query updates the new "OwnerySplitAddress" column with the appropriate split address data

	--The fifth query modifies the table and adds the "OwnerSplitCity" column that can be used to store the new split city values in the NVARCHAR format

	--The sixth query updates the new "OwnerySplitCity with the appropriate split city data

	--The seventh query modifies the table and adds the "OwnerSplitState" column that can be used to store the new split state values in the NVARCHAR format

	--The eighth query updates the new "OwnerySplitState" with the appropriate split state data

	--The ninth query is used to double check and ensure the dataset has been updated correctly with the three new columns containing split owner data



SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing 

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 



-- Change Y and N to Yes and No in "Sold as Vacant" field 
	
	--The first query provide the distinct values in the "SoldAsVacant" column along with the count of each value
		--We order the count in ascending order 
		--The result provides a count of Y, N, Yes, and No
		--The goal is to convert all values to Yes and No for a more accurate and organized count 
		
	--The second query converts all instances of Y and N to Yes and No using the CASE clause 

	--The third query updates the SoldAsVacant column with the converted data 

	--The fourth query verifies the dataset was successfully updated 


SELECT Distinct (SoldAsVacant), Count(SoldAsVacant) 
FROM PortfolioProject.dbo.NashvilleHousing 
GROUP BY SoldAsVacant
ORDER BY 2




SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject.dbo.NashvilleHousing 



UPDATE NashvilleHousing 
SET SoldAsVacant = 
	CASE 
	WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant 
	END




SELECT Distinct (SoldAsVacant), Count(SoldAsVacant) 
FROM PortfolioProject.dbo.NashvilleHousing 
GROUP BY SoldAsVacant
ORDER BY 2



--Remove Duplicates 
	--We want to identify and remove duplicate rows that contain identical data

	--The first query is used to identify duplicate entries in the dataset 
		--This query assigns row numbers to records in the table based on specific column values
			--and then selects all records from this table that have a row number greater than 1, effectively finding duplicate 
				--rows based on those specified columns

	--The second query removes the duplicate entries in the dataset by utilizing the same query with the DELETE clause 

	--The third query verifies the duplicate entries have been removed from the dataset


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
From RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress







WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE
From RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress







WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
From RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress



-- Deleting Unused Columns 
	
	--As part of the data cleaning process we remove any columns that we deem to be unused 
	
	--The first query brings up the dataset for review of which columns to delete 

	--The second query removes the OwnerAddress, TaxDistrict, and PropertyAddress columns using the ALTER TABLE and DROP COLUMN statements

	--The third query removes the SaleDate columns using the ALTER TABLE and DROP COLUMN statements

	--The fourth query confirms the three columns have been removed from the dataset



SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 