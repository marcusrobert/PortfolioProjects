--Cleaning Data in SQL Queries

Select *
from PortfolioProject.dbo.Sheet1$


-- Standardize Data Format

Select SaleDate, convert(date,SaleDate)
from PortfolioProject.dbo.Sheet1$


Update Sheet1$
Set SaleDate = convert(date,saledate)


alter table Sheet1$
add SaleDateConverted Date;


Update Sheet1$
Set SaleDateConverted = Convert(Date,SaleDate)


Select SaleDateConverted, convert(date,SaleDate)
from PortfolioProject.dbo.Sheet1$

-- Regulate Property Address Data

Select PropertyAddress
from PortfolioProject.dbo.Sheet1$
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Sheet1$ a
join PortfolioProject.dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] = b.[UniqueID ]
where a.PropertyAddress is null




-- Breaking Out Address Into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.Sheet1$

Select Substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 ) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.Sheet1$

update Sheet1$
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress))

alter table Sheet1$
Add PropertySplitCity Nvarchar(255)

Update Sheet1$
set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) + 1, len(PropertyAddress))


Alter table Sheet1$
Add OwnerSplitState Nvarchar(255);

Update Sheet1$
Set OwnerSplitState = Substring(PropertyAddress, Charindex(',', PropertyAddress) + 1, len(PropertyAddress))

Select OwnerAddress
from PortfolioProject.dbo.Sheet1$

Select
Parsename(Replace(OwnerAddress, ',', '.'), 3)
,Parsename(Replace(OwnerAddress, ',', '.', 2)
,Parsename(Replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.Sheet1$


-- Change Y and X into Yes and No in 'hold as vacant' field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.Sheet1$
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
END
from PortfolioProject.dbo.Sheet1$


-- Remove Duplicates

With RowNumCTE as( 
Select *,
	Row_Number() Over(
	Partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by
		UniqueID
		) row_num
from PortfolioProject.dbo.Sheet1$
--order by ParcelID
)

Select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

Delete
from RowNumCTE
where row_num > 1

-- Delete Unused Columns

