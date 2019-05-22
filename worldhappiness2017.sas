*/
SAS Presentation 
Kelso, Josh, Brian, Ryan
STAT 520;

data happy; 
infile 'C:\Users\Josh\Desktop\520 Presentation\worldhappiness2017.csv' dlm = ',' firstobs = 2; 
input Country $ HappinessRank	HappinessScore	Whiskerhigh	Whiskerlow	EconomyGDPperCapita	Family	HealthLifeExpectancy Freedom Generosity	TrustGovernmentCorruption DystopiaResidual; 
run; 

title "Summary Statistics"; 
proc means data=happy maxdec=2; 
var HappinessScore EconomyGDPperCapita Family HealthLifeExpectancy Freedom Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 
 
proc corr data=happy plots=matrix(histogram) PLOTS(MAXPOINTS= 7000); 
var	EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

proc princomp data=happy out=happypca; 
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom Generosity TrustGovernmentCorruption DystopiaResidual; 
run;
 
proc sgplot data=happypca; 
scatter x=prin1 y=prin2/datalabel=country;
run;

proc factor data=happy  method = prin rotate= varimax plots = (scree initloadings preloadings loadings); 
var EconomyGDPperCapita Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

proc discrim data=happy outstat=happystat method=normal pool=NO listerr;
priors proportional;
class country;
var EconomyGDPperCapita Family HealthLifeExpectancy Freedom	Generosity;
title 'Using Linear Discriminant Function';
run;

proc cluster data=happy method=complete outtree=tree;
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
copy Country;
run;

proc tree data=tree n=7 spaces=.15 out=out;
id Country;
run;

proc sort data=out;
by Country;
run;

proc sort data=happy;
by Country;
run;

data happy_clus;
merge happy out;
by Country;
run;

proc sort data= happy_clus;
by cluster;
run;

proc print data=happy_clus;
id Country;
by cluster;
run;

proc means data = happy_clus maxdec=3;
class cluster;
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
run;

%macro show;
proc freq;
tables cluster*species / nopercent norow nocol plot=none;
run;
proc candisc noprint out=can;
class cluster;
var EconomyGDPperCapita: Family: HealthLifeExpectancy: Freedom: Generosity:;
run;
proc sgplot data=happy_clus;
scatter y=can2 x=can1 / group=cluster;
run;
%mend;


/*proc glm data=happy;
title 'method 1';
class Country;
*model day1 day2 day3 = lab /nouni;
model = Country; 
manova h=Country; 
run;
quit;
