function formFlashInfo

f=figure('Menubar','none','Toolbar','none','position',[466 241 981 813]);
th = uitoolbar(f);
a1=axes('position',[0.1300 0.5838 0.7750 0.3412]);
a2=axes('position',[0.1300 0.1100 0.7750 0.3412]);

uipushtool(th,'cdata',imread('.\flashinfobitmaps\TMRMf0.bmp'),'tooltipstring','TMRM F0 range')
uipushtool(th,'cdata',imread('.\flashinfobitmaps\TMRMvalley.bmp'),'tooltipstring','TMRM valley')
uipushtool(th,'cdata',imread('.\flashinfobitmaps\TMRMRecoveryRate.bmp'),'tooltipstring','TMRM recovery range');
uipushtool(th,'cdata',imread('.\flashinfobitmaps\cpYFPStart.bmp'),'tooltipstring','cpYFP start point');
uipushtool(th,'cdata',imread('.\flashinfobitmaps\cpYFPPeak.bmp'),'tooltipstring','cpYFP peak point');
uipushtool(th,'cdata',imread('.\flashinfobitmaps\cpYFPEnd.bmp'),'tooltipstring','cpYFP end point');