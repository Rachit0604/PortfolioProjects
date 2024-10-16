-- Standardizing Data Formate

SELECT SaleDateConverted,CONVERT(DATE,SaleDate)
FROM PortfolioProject. .NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

-- Populate Property Address Data

SELECT *
FROM PortfolioProject. .NashvilleHousing
--where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject. .NashvilleHousing  a
join PortfolioProject. .NashvilleHousing  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject. .NashvilleHousing  a
join PortfolioProject. .NashvilleHousing  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

--Breaking out Address into individual Columns (Address, States, City)


SELECT PropertyAddress
FROM PortfolioProject. .NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as City
from PortfolioProject. .NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity =   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))  


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)  

Select *
from NashvilleHousing


select OwnerAddress
from NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as OwnerAddress
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as OwnerCity
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as OwnerState
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE  NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select *
from NashvilleHousing


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Changing Y and N to YES and NO in 'Sold As Vacant' Field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
	 ------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- REMOVING DUPLICATES 
WITH Row_NumCTE as (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
              PropertyAddress,
			  SaleDate,
			  SalePrice,
			  LegalReference
			  order by UniqueID)  row_num
FROM NashvilleHousing
)
Select *
FROM Row_NumCTE
WHERE  row_num > 1

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Deleting Unused Columns

select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress,OwnerAddress,TaxDistrict,SaleDate