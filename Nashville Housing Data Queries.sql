---Cleaning Data in SQL queries

Select * from dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------------------

---Standardize Date Format

Select SaleDate, CONVERT(Date, Saledate) 
from dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
add SALEDATECONVERTED DATE;

Update dbo.NashvilleHousing
SET SALEDATECONVERTED=CONVERT(Date, Saledate)

----DELETE SALEDATE COLUMN AS WE HAVE CONVERTED SALEDATE COLUMN NOW and rename column using store procedure

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate

--rename column using store procedure
EXEC SP_RENAME 'NashvilleHousing.SALEDATECONVERTED', 'SaleDate', 'Column'; 

---------------------------------------------------------------------------------------------------------------------

---Populate property address data; THERE WERE NULL VALUES IN property address COLUMN DUE TO DUPLICATE VALUES IN PARCELID
--WE HAVE TO UPDATE Same ADDRESS IN NULL CELLS USING SELF JOIN AND ISNULL FUNCTION

Select PropertyAddress 
from dbo.NashvilleHousing
where Propertyaddress is null
--order by ParcelID

Select A.Parcelid, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from NashvilleHousing a  
JOIN NashvilleHousing b
on A.parcelid=B.parcelid
AND A.[UniqueID ] <> B.[UniqueID ]
where a.PropertyAddress is null

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing A
JOIN NashvilleHousing B
ON A.parcelid=B.parcelid
AND A.[UniqueID ] <> B.[UniqueID ]
where a.PropertyAddress is null


---------------------------------------------------------------------------------------------------------------------

---BREAKOUT address INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

Select PropertyAddress 
from dbo.NashvilleHousing


---Splitting address and city from property address column

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)  AS ADDRESS,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(Propertyaddress))  AS ADDRESS
from dbo.NashvilleHousing 


---Creating Splitaddress column
ALTER TABLE dbo.NashvilleHousing
add PropertysplitAddress nvarchar(255);

Update dbo.NashvilleHousing
SET PropertysplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


---Creating SplitCity column

ALTER TABLE dbo.NashvilleHousing
add Propertysplitcity nvarchar(255);

Update dbo.NashvilleHousing
SET Propertysplitcity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(propertyaddress))

--Alternate way to do split the column using PARSENAME function

Select 
Parsename(replace(PropertyAddress, ',', '.'), 2),
Parsename(replace(PropertyAddress, ',', '.'), 1)
from dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------------------

---Splitting address, city and Month from Owner address column

Select Owneraddress from dbo.NashvilleHousing
where Owneraddress is not null

Select 
Parsename(replace(Owneraddress, ',', '.'), 3) as ownersplitaddress,
Parsename(replace(Owneraddress, ',', '.'), 2) as ownersplitCity,
Parsename(replace(Owneraddress, ',', '.'), 1) as ownersplitState
from dbo.NashvilleHousing

Alter table dbo.NashvilleHousing
add  ownersplitaddress nvarchar(255);

update dbo.NashvilleHousing
Set ownersplitaddress = Parsename(replace(Owneraddress, ',', '.'), 3)

Alter table dbo.NashvilleHousing
add  ownersplitCity nvarchar(255);

update dbo.NashvilleHousing
Set ownersplitCity = Parsename(replace(Owneraddress, ',', '.'), 2)

Alter table dbo.NashvilleHousing
add  ownersplitState nvarchar(255);

update dbo.NashvilleHousing
Set ownersplitState = Parsename(replace(Owneraddress, ',', '.'), 1)

--Result
Select 
	Owneraddress,
	ownersplitaddress,
	ownersplitCity,
	ownersplitstate
	from dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------
---Cleaning up SoldAsVacant column using case statment

Select 
Distinct(SoldAsVacant),
count(SoldAsVacant)
from dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

---using case statment replace Y to Yes and N to No

Select SoldAsVacant,
Case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END
from NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END

-------------------------------------------------------------------------------------------------------------------------
--Remove duplicate (using CTE and Windows function)

With RowNumCTE as (
Select	*,
		ROW_NUMBER() Over (
	Partition BY ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				order BY UniqueID) row_num
from NashvilleHousing
--Order by ParcelID
)

Select * from RowNumCTE
--Delete 
where row_num >1


-----Delete unwanted columns from table

Select * from NashvilleHousing

-- Alter and Drop

Alter table NashvilleHousing
drop column Propertyaddress, Owneraddress, taxdistrict 

