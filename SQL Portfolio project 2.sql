select * from [dbo].[NashvilleHousing];


--Standardize Date format

select saledate from [dbo].[NashvilleHousing];


select saledate, convert(Date, saledate)
from [dbo].[NashvilleHousing];


update [dbo].[NashvilleHousing] set 
saledate = convert(Date, saledate);

-- or

Alter [dbo].[NashvilleHousing]
Add SaleDateConverted Date;

Update [dbo].[NashvilleHousing]
set SaleDateConverted = convert(Date, saledate);

-- Populate property address data where its null

select * from [dbo].[NashvilleHousing]
--where propertyaddress is null
order by ParcelID;


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
where  a.Propertyaddress is null



update a
set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
where  a.Propertyaddress is null

-- 


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
where  a.Propertyaddress is null



-- Breaking out Address into Individual columns (Address, City, State)


Select PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Street,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , Len(PropertyAddress)) as City
From [dbo].[NashvilleHousing];

Alter Table [dbo].[NashvilleHousing]
Add  PropertyStreet nvarchar(255);

Alter Table [dbo].[NashvilleHousing]
Add  PropertyCity nvarchar(255)

update [dbo].[NashvilleHousing]
set PropertyStreet  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


update [dbo].[NashvilleHousing]
set PropertyCity  = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , Len(PropertyAddress))

-- ParseName to split the String column

select * from [dbo].[NashvilleHousing]

select owneraddress, ParseName(Replace(owneraddress, ',', '.'), 3),
ParseName(Replace(owneraddress, ',', '.'), 2),
trim(ParseName(Replace(owneraddress, ',', '.'), 1))
from [dbo].[NashvilleHousing];


-- Change Y and N to Yes and No in "Sold as vacant"

Select SoldAsVacant , count(1)
from [dbo].[NashvilleHousing]
group by SoldAsVacant

update  [dbo].[NashvilleHousing]
set SoldASVacant = Case When SoldAsVacant = 'N' then 'No'
						When SoldAsVacant = 'Y' then 'Yes' 
					Else SoldASVacant END 

					
Select SoldAsVacant , count(1)
from [dbo].[NashvilleHousing]
group by SoldAsVacant



-- Remove duplicates

With rownumberCTE as (
Select * ,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) as rn
from [dbo].[NashvilleHousing]
)

Delete from rownumberCTE where rn > 1


With rownumberCTE as (
Select * ,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) as rn
from [dbo].[NashvilleHousing]
)

Select * from rownumberCTE where rn > 1

-- Delete unused columns


Alter table  [dbo].[NashvilleHousing] 
drop column OwnerAddress, TaxDistrict, PropertyAddress


select * from  [dbo].[NashvilleHousing] 