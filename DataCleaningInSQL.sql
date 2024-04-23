/*
Hector de León
Cleaning data in SQL
Project
2024
*/

select * 
from PortfolioProject.dbo.NashvilleHousing

-- standardize date format
select saleDate, convert(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set saleDate = convert(date, SaleDate) --somehow this didnt't work

-- lets make another date column with the right format
ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
set saleDateConverted = CONVERT(date, SaleDate)

select saleDateConverted, convert(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing


-- populate property adress data

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress --ISNULL(a.PropertyAddress,b.PropertyAddress)
--isnull populates the parameter on the left with the content of the parameter on the right in the parameter on the left is null
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]

	select *
from PortfolioProject.dbo.NashvilleHousing

-- breaking out adress into individual columns(Adress, City, State)

	select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as city
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
add Property_Address Nvarchar(255);

Update NashvilleHousing
set Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
add Property_City Nvarchar(255);

Update NashvilleHousing
set Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing

-- now lets split the owner adress

select
parsename(replace(OwnerAddress,',','.'),3)
, parsename(replace(OwnerAddress,',','.'),2)
, parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add Owner_Address Nvarchar(255);

Update NashvilleHousing
set Owner_Address = parsename(replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
add Owner_City Nvarchar(255);

Update NashvilleHousing
set Owner_City = parsename(replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
add Owner_State Nvarchar(255);

Update NashvilleHousing
set Owner_State = parsename(replace(OwnerAddress,',','.'),1)

select *
from PortfolioProject.dbo.NashvilleHousing

-- change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes' --case works like an IF condition and can be done within the SELECT
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes' --case works like an IF condition and can be done within the SELECT
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

	--Done, there is no N and Y anymore ;)

	--Lets remove duplicates now
	-- lets use a cte and window functrions


with rowNumCTE as(
select *
, ROW_NUMBER() over(partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by uniqueID)row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
from rowNumCTE
where row_num>1
--order by PropertyAddress


select *
from PortfolioProject.dbo.NashvilleHousing

-- delete unused columns

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





