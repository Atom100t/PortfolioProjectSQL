



--Cleaning Data in SQL Queries


Select *
From PortfolioProject..[Housing ]


-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate)
From PortfolioProject..[Housing ]


Update PortfolioProject..[Housing ]
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Housing
Add SaleDateConverted Date;

Update PortfolioProject..[Housing ]
SET SaleDateConverted = CONVERT(Date,SaleDate)



-- Populate Property Address data

Select *
From PortfolioProject..[Housing ]
Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..[Housing ] a
JOIN PortfolioProject..[Housing ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..[Housing ] a
JOIN PortfolioProject..[Housing ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject..[Housing ]
Where PropertyAddress is null
order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject..[Housing ]


ALTER TABLE PortfolioProject..[Housing ]
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..[Housing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProject..[Housing ]
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..[Housing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))





Select *
From PortfolioProject..[Housing ]





Select OwnerAddress
From PortfolioProject..[Housing ]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject..[Housing ]



ALTER TABLE PortfolioProject..[Housing ]
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..[Housing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject..[Housing ]
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..[Housing ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject..[Housing ]
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..[Housing ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From  PortfolioProject..[Housing ]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From  PortfolioProject..[Housing ]


Update  PortfolioProject..[Housing ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject..[Housing ]




-- Delete Unused Columns



Select *
From PortfolioProject..[Housing ]


ALTER TABLE PortfolioProject..[Housing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate