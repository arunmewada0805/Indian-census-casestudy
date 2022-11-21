select * from project.dbo.data1;
select * from project.dbo.data2;

--remove null values
select * from project.dbo.data1 where state is null;
update project.dbo.data1 set State = 'abc' where Growth is null;
delete project.dbo.data1 where state='abc';

-- remove null values
select * from project.dbo.data2 where District is null;
update project.dbo.data2 set State = 'abc' where district is null;
delete project.dbo.data2 where state='abc';


--number of rows into our dataset

select count(*) from project..data1
select count(*) from project..data2

-- dataset for jharkhand and bihar

select * from project..Data1 where state in ('Jharkhand' , 'Bihar')

--population of India

select sum(population) as Population from project..Data2

-- avg growth 

select avg(growth)*100 from project..Data1

select state,avg(growth)*100 from project..Data1 group by state;

--avg sex rario

select state,round(avg(Sex_Ratio),0) avg_sex_ratio from project..Data1 group by state order by avg_sex_ratio desc;

-- avg literacy rate

select state,round(avg(Literacy),0) avg_literacy_ratio from project..Data1 group by state order by avg_literacy_ratio desc;

select state,round(avg(Literacy),0) avg_literacy_ratio from project..Data1 
group by state having round(avg(Literacy),0)>90 order by avg_literacy_ratio desc;

--top 3 state showing higest growth ratio

select top 3 state,avg(growth)*100 avg_growth from project..Data1 group by state order by avg_growth desc; 

--bottom 3 state showing higest growth rate

select top 3 state,avg(growth)*100 avg_growth from project..Data1 group by state order by avg_growth asc;

--bottom 3 state showing lowest sex ratio

select top 3 state,round(avg(Sex_Ratio),0) avg_sex_ratio from project..Data1 group by state order by avg_sex_ratio asc;
  
-- states starting with letter a

select distinct state from project..Data1 where lower(state) like 'm%';
select distinct state from project..Data1 where lower(state) like 'm%' and lower(state) like '%a'


-- joining both table

select a.district, a.state, a.sex_ratio, b.population from project..data1 a inner join project..data2 b on a.district=b.district



-- TOTAL MALES AND FEMALES

-- Calculation to get number of Males and Females
'''
females/males = sex_ratio   ....eqn. 1
females + Males = population     .....eqn. 2
females = population - males ....eqn. 3

(population - males) = (sex_ratio)*males
# poplation = males(sex_ratio + 1)
# males =  population/(sex_ratio + 1)
# females = population - population/(sex_ratio + 1)

females = population(1-1/(sex_ratio+1)
females = (population*(sex_ratio))/(sex_ratio+1)
'''


--DISTRICT WISE
select c.district, c.state, round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district, a.state, a.sex_ratio/1000 sex_ratio, b.population from project..data1 a inner join project..data2 b on a.district=b.district) c

--STATE WISE
select d.state, sum(d.males) total_males, sum(d.females) total_females from
(select c.district, c.state, round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district, a.state, a.sex_ratio/1000 sex_ratio, b.population from project..data1 a inner join project..data2 b on a.district=b.district) c)
 d group by d.state;




 --total literacy rate
 # Calculation to get literacy rate
 ''' 
 literacy_ratio = total literate people / population
 total literate people = literacy_ratio * population
 total illiterate people = (1 - literacy_ratio) * population
 '''


select c.state,sum(literate_people) total_literate_people, sum(illiterate_people) total_iliterate_people from
 (select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
 round((1-d.literacy_ratio)* population,0) illiterate_people from
 (select a.district, a.state, a.literacy/100 literacy_ratio, b.population from project..data1 a 
 inner join project..data2 b on a.district=b.district) d) c
 group by c.state




 -- population in previous censun and current census district wise

 select d.district, d.state, round(d.population/(1+d.growth),0) previous_census_population, d.population current_census_population from
 (select a.district, a.state, a.growth growth, b.population from project..data1 a inner join project..data2 b on a.district=b.district) d

 --population in previous censun and current census state wise

select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from 
 (select d.district, d.state, round(d.population/(1+d.growth),0) previous_census_population, d.population current_census_population from
 (select a.district, a.state, a.growth growth, b.population from project..data1 a inner join project..data2 b on a.district=b.district) d) e
 group by e.state

 --population of India in previous censun and current census

 select sum(f.previous_census_population) previous_census_population, sum(f.current_census_population) current_census_population from
(select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from 
 (select d.district, d.state, round(d.population/(1+d.growth),0) previous_census_population, d.population current_census_population from
 (select a.district, a.state, a.growth growth, b.population from project..data1 a inner join project..data2 b on a.district=b.district) d) e
 group by e.state) f




 --poulation vs area

 select g.total_area/g.previous_census_population as previous_census_population_vs_area , g.total_area/g.current_census_population as
 current_census_population_as_area from
 (select q.*, r.total_area from 

(select '1' as keyy, n.* from
 (select sum(f.previous_census_population) previous_census_population, sum(f.current_census_population) current_census_population from
(select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from 
 (select d.district, d.state, round(d.population/(1+d.growth),0) previous_census_population, d.population current_census_population from
 (select a.district, a.state, a.growth growth, b.population from project..data1 a inner join project..data2 b on a.district=b.district) d) e
 group by e.state) f) n)q

 inner join

(select '1' as keyy,z.* from (
 select sum(area_km2) total_area from project..data2)z) r on q.keyy=r.keyy) g



 --window function

 output top 3 district from each state with highest literacy rate

select a.* from 
 (select district, state, literacy, rank() over(partition by state order by literacy desc) rnk from project..data1) a
 where a.rnk in (1,2,3) order by state