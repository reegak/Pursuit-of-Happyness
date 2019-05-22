*/
SAS Presentation 
Kelso, Josh, Brian, Ryan
STAT 520;

data happy2; 
infile 'C:\Users\Josh\Desktop\520 Presentation\worldhappiness2016.csv' dlm = ',' firstobs = 2; 
input Country $ HappinessRank HappinessScore LowerConfidenceInterval UpperConfidenceInterval EconomyGDPperCapita Family	HealthLifeExpectancy Freedom Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

title "Summary Statistics"; 
proc means data=happy2 maxdec=2;
var HappinessScore EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 
 
proc corr data=happy2 plots=matrix(histogram) PLOTS(MAXPOINTS= 7000); 
var	EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

proc princomp data=happy2 out=happy2pca; 
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom Generosity TrustGovernmentCorruption DystopiaResidual; 
run;
 
proc sgplot data=happy2pca; 
scatter x=prin1 y=prin2/datalabel=country;
run;

proc factor data=happy2  method = prin rotate= varimax plots = (scree initloadings preloadings loadings); 
var EconomyGDPperCapita Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual; 
run; 

proc discrim data=happy2 outstat=happy2stat method=normal pool=NO listerr;
priors proportional;
class country;
var EconomyGDPperCapita Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
title 'Using Linear Discriminant Function';
run;

proc cluster data=happy2 method=complete outtree=tree;
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
id Country;
run;

proc tree data=tree n=7 spaces=.15 out=out;
id Country;
run;

proc sort data=out;
by Country;
run;

proc sort data=happy2;
by Country;
run;

data happy2_clus;
merge happy2 out;
by Country;
run;

proc sort data= happy2_clus;
by cluster;
run;

proc print data=happy2_clus;
id Country;
by cluster;
run;

proc means data = happy2_clus maxdec=3;
class cluster;
var EconomyGDPperCapita	Family HealthLifeExpectancy Freedom	Generosity TrustGovernmentCorruption DystopiaResidual;
run;
