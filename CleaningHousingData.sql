SELECT *
FROM Project.dbo.NashvilleHousing


--Change Date to standard date format



SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM Project.dbo.NashvilleHousing


--SET the new date format in the table



UPDATE Project.dbo.NashvilleHousing
SET SaleDate - CONVERT(Date,SaleDate)


ALTER TABLE Project.dbo.NashvilleHousing
SET SaleDateConverted - CONVERT(Date,SaleDate)



--Populate Property Address



SELECT *
FROM Project.dbo.NashvilleHousing
order by parcelid




--Self join NashvilleHousing as table a, table b. 
--on parcelID where equals and uniqueId where not equals




SELECT a.parcelid, a.propertyAddress, b.ParcelID, b.propertyAddress, ISNULL(a.propertyAddress,b.propertyAddress)
FROM Project.dbo.NashvilleHousing as a
JOIN Project.dbo.NashvilleHousing as b
	ON a.parcelid=b.parcelid
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.propertyAddress is null



--update the table



UPDATE a
SET propertyAddress = ISNULL(a.propertyAddress,b.propertyAddress)
FROM Project.dbo.NashvilleHousing as a
JOIN Project.dbo.NashvilleHousing as b
	ON a.parcelid=b.parcelid
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.propertyAddress is null




--break out address into individual columns (Address, city, state)
-use replace function to separate out address



SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Project.dbo.NashvilleHousing

ALTER TABLE Project.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

UPDATE Project.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Project.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

UPDATE Project.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Project.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255)

UPDATE Project.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



SELECT DISTINCT(soldasvacant), COUNT(soldasvacant)
from Project.dbo.NashvilleHousing
group by soldasvacant
order by 2


--change "sold as vacant" field- from 'y/n' to 'yes/no'
--case statement if y then change to yes. or n change to no..else leave as soldasvacant



SELECT soldasvacant,
	CASE WHEN soldasvacant = 'Y' THEN 'Yes'
		 WHEN soldasvacant = 'N' THEN 'No'
		 ELSE soldasvacant
		 END
FROM Project.dbo.NashvilleHousing



--update the table with case statement



UPDATE Project.dbo.NashvilleHousing
SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN 'Yes'
		 WHEN soldasvacant = 'N' THEN 'No'
		 ELSE soldasvacant
		 END




--remove duplicates from table
--create rowNumCTE
--delete if row_num is greater than 1


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					)row_num
FROM Project.dbo.NashvilleHousing
)
DELETE
from RowNumCTE
where row_rum > 1
--order by PropertyAddress
select*
from RowNumCTE
where row_rum > 1
order by PropertyAddress



--Delete Unused Columns



SELECT * 
FROM Project.dbo.NashvilleHousing

ALTER TABLE Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Project.dbo.NashvilleHousing
DROP COLUMN SaleDate
