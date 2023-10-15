/* cleaning data in sql queries */

-------------------------------------------------------------------


Select * from  [dbo].[Nashville Housing ] 

--Update [Nashville Housing ] set Saledate = convert(Date, SaleDate ) alter table [Nashville Housing ] add newdate convert(Date, SaleDate)
-------------------------------------------------------------------------------------------------------------------------------------------

--Popular proberty Address data 

Select PropertyAddress
from [dbo].[Nashville Housing ]
where PropertyAddress is null 
order by ParcelID

Select a.ParcelID , a.PropertyAddress ,b.ParcelID ,  b.PropertyAddress , ISNULL(  a.PropertyAddress ,  b.PropertyAddress)
from [dbo].[Nashville Housing ] a
join [dbo].[Nashville Housing ] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where  a.PropertyAddress is null 
---------------------------------------------------------------------------------------------------------------------------------------------------

--bREAKING OUT ADDress into individual coloumn ( Addrss , city , state )

Select 
SUBSTRING(PropertyAddress , 1 , CHARINDEX( ',' , PropertyAddress) -1 ) as Address ,
SUBSTRING(PropertyAddress ,  CHARINDEX( ',' , PropertyAddress) +1 , len(PropertyAddress) ) as NewAddress
from [dbo].[Nashville Housing ]




 alter table [Nashville Housing ]
 Add PropertySplitAddress Nvarchar(255);


Update [Nashville Housing ] 
set PropertySplitAddress = SUBSTRING( PropertyAddress , 1, CHARINDEX(',' , PropertyAddress ) -1 ) 



alter table [Nashville Housing ]
Add PropertySplitCity	Nvarchar(255);

Update [Nashville Housing ] 
set PropertySplitCity = SUBSTRING( PropertyAddress , CHARINDEX(',' , PropertyAddress ) +1 , LEN(PropertyAddress))


select *
from [dbo].[Nashville Housing ]

--Simpler way


select OwnerAddress
from [dbo].[Nashville Housing ]


Select 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3) AS Address, 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)AS City,
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1) AS State 
from [dbo].[Nashville Housing ]


 alter table [Nashville Housing ]
 Add OwnerSplitAddress Nvarchar(255);


Update [Nashville Housing ] 
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)


alter table [Nashville Housing ]
Add OwnerSplitCity	Nvarchar(255);

Update [Nashville Housing ] 
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)


alter table [Nashville Housing ]
Add OwnerSplitState	Nvarchar(255);

Update [Nashville Housing ] 
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)



select *
from [dbo].[Nashville Housing ]


----------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in Sold as Vacant" field 


Select Distinct(SoldAsVacant), count(SoldAsVacant)
from [dbo].[Nashville Housing ] 
group by SoldAsVacant
order by  SoldAsVacant

Select SoldAsVacant
, CASE WHEN SoldAsVacant = '0' then 'Yes' 
	   When SoldAsVacant = '1' then 'No' 
	   END
from [dbo].[Nashville Housing ] 


UPDATE [Nashville Housing ] 
SET SoldAsVacant=  CASE
       WHEN SoldAsVacant = '0' then 'Yes' 
	   When SoldAsVacant = '1' then 'No' 
	   END
from [dbo].[Nashville Housing ] 

---------------------------------------------------------------------------------------------------------------------------------------
--Remove Duplicates 

with RowNumCTE AS(
select *,
	row_number() over  (
	partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference 
				 ORDER BY 
				   UniqueID
				   ) as row_num

from [dbo].[Nashville Housing ]
--order by ParcelID
)
Delete
From RowNumCTE
WHERE row_num > 1
--order by PropertyAddress

select *
from [dbo].[Nashville Housing ]

------------------------------------------------------------------------------------------------------------------------------------
--Delete unused Coloumns 


select *
from [dbo].[Nashville Housing ]


alter table [dbo].[Nashville Housing ]
DROP COLUMN OwnerAddress , TaxDistrict , PropertyAddress 






