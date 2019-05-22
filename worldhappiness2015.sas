*/
SAS Presentation 
Kelso, Josh, Brian, Ryan
STAT 520;

data happy1; 
infile 'C:\Users\Josh\Desktop\520 Presentation\worldhappiness2015.csv' dlm = ',' firstobs = 2; 
input Country $ HappinessRank HappinessScore StandardError EconomyGDPperCapita Family HealthLifeExpectancy Freedom Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

title "Summary Statistics"; 
proc means data=happy1 maxdec=2; 
run; 
 
proc corr data=happy1 plots=matrix(histogram) PLOTS(MAXPOINTS= 7000); 
var	EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

proc princomp data=happy1 out=happy1pca; 
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom Generosity TrustGovernmentCorruption DystopiaResidual; 
run;
 
proc sgplot data=happy1pca; 
scatter x=prin1 y=prin2/datalabel=country;
run;

proc factor data=happy1  method = prin rotate= varimax plots = (scree initloadings preloadings loadings); 
var EconomyGDPperCapita Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

proc discrim data=happy1 outstat=happy1stat method=normal pool=NO listerr;
priors proportional;
class country;
var EconomyGDPperCapita Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
title 'Using Linear Discriminant Function';
run;

proc cluster data=happy1 method=complete outtree=tree;
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
id Country;
run;

proc tree data=tree n=7 spaces=.15 out=out;
id Country;
run;

proc sort data=out;
by Country;
run;

proc sort data=happy1;
by Country;
run;

data happy1_clus;
merge happy1 out;
by Country;
run;


proc sort data= happy1_clus;
by cluster;
run;

proc print data=happy1_clus;
id Country;
by cluster;
run;

proc means data = happy1_clus maxdec=3;
class cluster;
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
run;
