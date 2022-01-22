-- Data cleaning in SQL
--
select * from SQLprojects..NashvilleHousing

-- Converted SaleDate to Date, and update in data

select SaleDate, CONVERT(Date, SaleDate) as SaleDateConverted
from SQLprojects..NashvilleHousing

update SQLprojects..NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

alter table SQLprojects..NashvilleHousing
add SaleDateConverted Date

update SQLprojects..NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDate, SaleDateConverted 
from SQLprojects..NashvilleHousing

-- Populate Property Address data

select * from SQLprojects..NashvilleHousing
order by 1

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From SQLprojects.dbo.NashvilleHousing a
JOIN SQLprojects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From SQLprojects.dbo.NashvilleHousing a
JOIN SQLprojects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)
-- 1. With propertyaddress.
Select *
From SQLprojects.dbo.NashvilleHousing

select 
	SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
	Substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as City
from SQLprojects..NashvilleHousing

alter table SQLprojects..NashvilleHousing
add PropertyAddressSplitAddress Nvarchar(255)


update SQLprojects..NashvilleHousing
set PropertyAddressSplitAddress = substring( PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table SQLprojects..NashvilleHousing
add PropertyAddressSplitCity nvarchar(255)

update SQLprojects..NashvilleHousing
set PropertyAddressSplitCity = SUBSTRING( PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))


-- 2. With Ownername.

select OwnerAddress from SQLprojects..NashvilleHousing

select 
	parsename(replace(OwnerAddress, ',', '.'), 3) ,
	parsename(replace(OwnerAddress, ',', '.' ), 2),
	parsename(replace(OwnerAddress, ',', '.' ), 1)
from SQLprojects..nashvilleHousing

alter table SQLprojects..nashvilleHousing
add OwnerSplitAddress nvarchar(255)

update SQLprojects..nashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

alter table SQLprojects..nashvilleHousing
add OwnerSplitCity nvarchar(255)

update SQLprojects..nashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)


alter table SQLprojects..nashvilleHousing
add OwnerSplitState nvarchar(255)

update SQLprojects..nashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)

select * from SQLprojects..NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from SQLprojects..NashvilleHousing
group by SoldAsVacant
order by 2 asc

select SoldAsVacant from SQLprojects..NashvilleHousing

select SoldAsVacant,
	CASE 
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	END
from SQLprojects..NashvilleHousing

update SQLprojects..NashvilleHousing
set SoldAsVacant = CASE 
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	END
	
-- Remove Duplicates
select * from NashvilleHousing

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
						)  row_num

From SQLprojects.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- Deleted unused columns

alter table SQLprojects..NashvilleHousing
drop column PropertyAddress, SaleDate, OwnerAddress

select * from SQLprojects..NashvilleHousing

