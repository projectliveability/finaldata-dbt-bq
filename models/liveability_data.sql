{{ config(materialized='table') }}

WITH final_liveability AS (

  WITH choices AS (
  	SELECT SPLIT(ui2.user_interests,',') as OPTION
  	      ,RANK() over (
  		   ORDER BY ui2.created_date DESC
  		   ) AS rank_no2 
  	FROM `streamdata.user_input` ui2
  )
  
  SELECT * FROM (
  	SELECT
  		 ccare.name as name   
  		,ccare.Categories as category   
		,'Red' as cat_colour
  		,ccare.address as address    
  		,ccare.city as city     
  		,ccare.postcode as postcode    
  		,ccare.latitude as Latitude
  		,ccare.longitude as longitude
  	FROM transform_batchdata.childcarecentre ccare
  	UNION ALL
  	SELECT
  		 hosp.name as name   
  		,hosp.categories as category 
		,'Blue' as cat_colour
  		,hosp.address as address    
  		,hosp.city as city     
  		,hosp.postcode as postcode    
  		,hosp.latitude as Latitude
  		,hosp.longitude as longitude
  	FROM transform_batchdata.hospitals hosp
  	UNION ALL 
  	SELECT
  		 rel.name as name   
  		,rel.category as category  
		,'Green' as cat_colour
  		,rel.address as address    
  		,rel.suburb as city     
  		,rel.postcode as postcode    
  		,rel.latitude as Latitude
  		,rel.longitude as longitude
  	FROM transform_batchdata.religiousorganizations rel 
  	UNION ALL 
  	SELECT
  		 res.name as name   
  		,res.categories as category 
		,'Yellow' as cat_colour
  		,res.address as address    
  		,res.city as city     
  		,res.postcode as postcode    
  		,res.latitude as Latitude
  		,res.longitude as longitude
  	FROM transform_batchdata.restaurants res 
  	UNION ALL 
  	SELECT
  		 sch.name as name   
  		,sch.categories as category
		,'Orange' as cat_colour
  		,sch.address as address    
  		,sch.city as city     
  		,sch.postcode as postcode    
  		,sch.latitude as Latitude
  		,sch.longitude as longitude
  	FROM transform_batchdata.schools sch
  	UNION ALL  
  	SELECT
  		 shop.name as name
  		,shop.categories as category
		,'Pink' as cat_colour
  		,shop.address as adress
  		,shop.city as city
  		,shop.postcode as postcode
  		,shop.latitude as latitude
  		,shop.longitude as longitude
  	FROM transform_batchdata.shoppingcentre shop
  	UNION ALL 
  	SELECT
  		 sport.name as name
  		,sport.categories as category
		,'Purple' as cat_colour
  		,sport.address as adress
  		,sport.city as city
  		,sport.postcode as postcode
  		,sport.latitude as latitude
  		,sport.longitude as longitude
  	FROM transform_batchdata.sportsclubs sport
  
  )
  WHERE postcode = (
    WITH location AS (
  	  SELECT  ui1.confirm_new_postcode as postcode			
  			  ,RANK() OVER (
  				 ORDER BY ui1.created_date DESC
       		   ) AS rank_no1
  	    FROM `streamdata.user_input` ui1
  	)	
  	SELECT location.Postcode
  	  FROM location
  	 WHERE location.rank_no1 = 1
  	)
  
  AND category IN UNNEST(
        (SELECT choices.OPTION 
  		   FROM choices
  		  WHERE choices.rank_no2 = 1
  		) )
)
select * from final_liveability

