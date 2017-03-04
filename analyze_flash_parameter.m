function analyze_flash_parameter

% thres=0.02*max(a);
[peaks,num]=finding_peak_swelling(a,2,2,0.5);
[peak_intervals,interval_range]=peak_interval(a,peaks);

parameter=cell(1,num);
parameter_new=cell(1,num);

start_arr=zeros(1,num);
peak_arr=zeros(1,num);
end_arr=zeros(1,num);

for j=0:num-1
    [parameter{j+1},parameter_new{j+1}]=analyze_flash_parameter1(peak_intervals{j+1},interval_range(1,j+1),1);
    
    start_arr(j+1)=parameter_new{j+1}(15);
    peak_arr(j+1)=parameter_new{j+1}(16);
    end_arr(j+1)=parameter_new{j+1}(17);
end

plot(0:length(a)-1,a,'-',floor(start_arr),a(floor(start_arr)+1),'r*',floor(peak_arr),a(floor(peak_arr)+1),'g*',floor(end_arr),a(floor(end_arr)+1),'b*');



function [parameter,parameter_new]=analyze_flash_parameter1(flash_trace,t_offset,time_interval)

len=length(flash_trace);
gradient=gradient_trace(flash_trace);

[peakv,posv]=max(flash_trace);
posv=posv-1;
npoint_front=posv;
npoint_back=len-posv;

%case of peak at both ends.
if posv==0 || posv==len-1
    [peaki,num]=finding_peak_swelling(flash_trace,2,2,0.5);
    if num==0
        parameter=zeros(1,29);
        parameter_new=zeros(1,29);
        return
    end
    if num>1
        [peakv,indi]=max(flash_trace(peaki+1));
        indi=indi-1;
        posv=peaki(indi+1);
    else
        peakv=flash_trace(peaki(1));
        posv=peaki(1);
    end
end

% vally point as start reference: 5%max point
tleft_temp=finding_intersection(flash_trace(1:posv+1),0.5*(getthreshold(flash_trace(1:posv+1))+peakv));

pvally=max(finding_vally(flash_trace(1:tleft_temp+1)),0);
vally_front=flash_trace(pvally+1);
u5max=0.95*vally_front+0.05*peakv;
pos_5max=finding_intersection(flash_trace(pvally+1:posv+1),u5max)+pvally;
basal=u5max;

upcurve=flash_trace(pvally+1:posv+1);
downcurve=flash_trace(posv+1:end);

% lines through peaks and endpoint
lines=line_2points([posv,peakv],[len-1,flash_trace(len)]);

% Area under curve, used to define end base
auc_raw=mean(flash_trace(posv+1:len)-flash_trace(len));
auc_lines=mean(lines-flash_trace(len));
ratio_auc=auc_raw./auc_lines;

% another way to estimate basal_end
index_underhalf=find(downcurve < 0.5*(peakv+flash_trace(len)))-1;
if length(index_underhalf)>=max(0.5*(len-posv),3)
    basal_end=mean(flash_trace(len-1-round(0.2*npoint_back)+1:len));
else
    basal_end=flash_trace(len);
end

vallyendhalf=finding_intersection(downcurve,0.5*(peakv+basal_end));
if vallyendhalf==-1;vallyendhalf=0;end
[vallyend,num_vally_end]=finding_vally_swelling(downcurve(floor(vallyendhalf)+1:end),2,2);
if vallyend(1)<2
    tend=finding_intersection(downcurve(floor(vallyendhalf(1))+1:end),basal_end)+posv+vallyendhalf(1)-1;
else
    tend=min(vallyend(1)+posv+vallyendhalf(1),len)-1;
%     disp(vallyend(1)+vallyendhalf(1))
    basal_end=downcurve(floor(vallyend(1)+vallyendhalf(1))+1);
end

u5max_end=0.05*basal_end+0.95*peakv;
% tstart defined as the intersection of 5% max and the curve
% possible pvally is the local minimum
tstart=finding_intersection(upcurve,u5max)+pvally;

% halfmax before and end
halfmax=0.5*(basal+peakv);
halfmax_end=0.5*(basal_end+peakv);

% t_half: defined as intersection of 50%max and upcurve and downcurve

t_half1=finding_intersection(upcurve,halfmax)+pvally;
t_half2=finding_intersection(downcurve,halfmax_end)+posv;

% modifing the tstart
if (posv-t_half1)<0.5*(t_half1-tstart) && (peakv-basal)/basal>=0.1
    temp=flash_trace(round((tstart+posv)/2)+1:t_half1+1);
    vally_temp=finding_vally(temp);
    if vally_temp(1)~=-1;tstart=vally_temp(length(vally_temp));end
end

% t_start modification, first point where gradient turn
if t_half1>3
    gradientup=convol_center_edgeTruncate(flash_trace(1:t_half1+1),[-1,1]);
    ind=find(gradientup<=0)-1;
    if isempty(ind);ind=0;end
    numofgrandientup=length(ind);
    tstart=ind(numofgrandientup);
end

% 90% max
u90max=0.1*basal+0.9*peakv;
u90max_end=0.1*basal_end+0.9*peakv;
t_901=finding_intersection(upcurve,u90max)+pvally;
t_902=finding_intersection(downcurve,u90max_end)+posv;

% 10%max
u10max=0.9*basal+0.1*peakv;
u10max_end=0.9*basal_end+0.1*peakv;
t_101=finding_intersection(upcurve,u10max)+pvally;
t_102=finding_intersection(downcurve,u10max_end)+posv;

%slopes at both sides
tstartsp=max([tstart,round(t_101)]);
k_left_m=(peakv-flash_trace(tstartsp+1))/(posv-tstartsp)/time_interval;
k_right_m=(peakv-u10max_end)/(t_102-posv)/time_interval;

k_left_max=max(gradient(round(t_101)+1:posv+1))/time_interval;
k_right_max=-min(gradient(posv+2:max([round(t_102),posv+1])+1))/time_interval;

% signal mass
signal_mass=time_interval*(sum(flash_trace(round(tstart)+1:posv+1)-basal)+...
    sum(flash_trace(posv+2:max([round(tend),posv+1])+1)-basal_end));
signal_mass_normalized=signal_mass/(round(tend)-round(tstart)+1);

% FDHM, full duration of half maximum
% timetopeak, time to rise to peak from tstart
% RT50, time to rise to halfmax from tstart
% DT50, time to decay to halfmax from tpeak

FDHM=(t_half2-t_half1)*time_interval;
timetopeak=(posv-tstart)*time_interval;
RT50=(t_half1-tstart)*time_interval;
DT50=(t_half2-posv)*time_interval;
DF_F0=(peakv-basal)/basal;

xup=(0:posv-round(t_101))+round(t_101);
xdown=(0:round(t_102)-posv)+posv;

parameter=[basal,basal_end,tstart,peakv,posv,halfmax,halfmax_end,t_half1,t_half2,...
    u90max,u90max_end,t_901,t_902,u10max,u10max_end,t_101,t_102,...
    tend,k_left_m,k_right_m,k_left_max,k_right_max,signal_mass,signal_mass_normalized,...
    DF_F0,FDHM,RT50,DT50,timetopeak];

parameter_new=[basal,basal_end,...
    peakv,k_left_m,k_right_m,k_left_max,k_right_max,...
    DF_F0,FDHM,RT50,DT50,timetopeak,...
    signal_mass,signal_mass_normalized,tstart+t_offset,posv+t_offset,tend+t_offset,...
    halfmax,halfmax_end,t_half1+t_offset,t_half2+t_offset,...
    u90max,u90max_end,t_901+t_offset,t_902+t_offset,...
    u10max,u10max_end,t_101+t_offset,t_102+t_offset];

function [vally_new,num]=finding_vally(trace)

len=length(trace);
vally=zeros(1,len);
num=0;
for i=2:len-3
    if trace(i+1)<min(trace(i-1:i)) && trace(i+1)<min(trace(i+2:i+3))
        num=num+1;
        vally(i+1)=i;
    end
end
ind=find(vally>0)-1;
if isempty(ind);ind=0;end
vally_new=vally(ind+1);

function threshold=getthreshold(trace)

threshold=mean(trace);
while 1
    threshold0=threshold;
    aver_w=mean(trace(trace>threshold));
    aver_b=mean(trace(trace<=threshold));
    threshold=(aver_w+aver_b)/2;
    if abs(threshold0-threshold)<0.5;break;end
end

function [peaknew num]=finding_peak_swelling(trace,aoffset,boffset,threshold)

% finding peak swelling
% by default following should be
% threshold=0.5
% aoofset=1
% boffset=1

len=length(trace);
peak=zeros(1,len);

num=0;
for i=0:len-1
    if (i<aoffset) && (i>=2)
        if trace(i+1)>=max(trace(i-1:i))...
                &&trace(i+1)>=max(trace(i+2:i+4))...
                &&max(trace(i+1)-trace(i-1:i))>=threshold...
                &&max(trace(i+1)-trace(i+2:i+4))>=0
            peak(num+1)=i;
            num=num+1;
        end
        continue
    end
    if i>=aoffset && i<len-boffset
        if trace(i+1)>=max(trace(i-aoffset+1:i))...
                &&trace(i+1)>=max(trace(i+2:i+boffset+1))...
                &&max(trace(i+1)-trace(i-aoffset+1:i))>=threshold...
                &&max(trace(i+1)-trace(i+2:i+boffset+1))>=0
            peak(num+1)=i;
            num=num+1;
        end
    end    
end
ind=find(peak>0)-1;
if isempty(ind)
    ind=0;
end
peaknew=peak(ind+1);

function [vallynew,num]=finding_vally_swelling(trace,aoffset,boffset)

len=length(trace);
vally=zeros(1,len);
num=0;

for i=aoffset:len-boffset-1
    if trace(i+1)<=min(trace(i-aoffset+1:i))...
            &&trace(i+1)<=min(trace(i+2:i+boffset+1))
        num=num+1;
        vally(i+1)=i;
    end
end
ind=find(vally>0)-1;
if isempty(ind)
    ind=0;
    num=0;
end
vallynew=vally(ind+1);

function result=gaussian_blur(trace,radius,sigma)

% radius=3;
% sigma=2;

filter=exp(-((0:2*radius)-radius).^2*0.5/sigma.^2);
filter=filter/sum(filter);
result=convol_center_edgeTruncate(trace,filter);

function result=line_2points(point1,point2)

x=point1(1):point2(1);
result=point1(2)+(point2(2)-point1(2))./(point2(1)-point1(1)).*(x-point1(1));

function result=gradient_trace(trace)

result=zeros(size(trace));
result(2:end)=diff(trace);

%{
% function Rt=convol_edgeTruncate(a,b)
% 
% % the same as convol(a,b,center=0,/edge_truncate) in IDL
% Rt=zeros(size(a));
% n=length(a);
% k=length(b);
% for t=0:n-1
% %     if t>=k-1 % for no edge_truncate
%         for i=0:k-1
%             subA=min(max(t-i,0),n-1)+1;
%             Rt(t+1)=Rt(t+1)+a(subA)*b(i+1);
%         end
% %     end
% end
%}

function Rt=convol_center_edgeTruncate(a,b)

% the same as convol(a,b,edge_truncate) in IDL

Rt=zeros(size(a));
n=length(a);
k=length(b);
halfk=floor(k/2);
for t=0:n-1
%     if t>=halfk && t<=n-halfk-1
        for i=0:k-1
            subA=min(max(t+i-halfk,0),n-1)+1;
            Rt(t+1)=Rt(t+1)+a(subA)*b(i+1);
        end
%     end
end

function Rt=finding_intersection(trace,value)

len=length(trace);
% [maxv,pos]=max(trace);
% pos=pos-1;
midpoint=find(trace==value,1)-1;
if ~isempty(midpoint)
    Rt=midpoint;
    return
end
if trace(1)>trace(end)
    uppoint=find(trace<value, 1 )-1;
    if isempty(uppoint);uppoint=len-1;end
    downpoint=find(trace(1:uppoint+1)>value, 1, 'last' )-1;
    if isempty(downpoint);downpoint=-1;end
else
    downpoint=find(trace<value, 1, 'last' )-1;
    if isempty(downpoint);downpoint=0;end
    uppoint=find(trace(downpoint+1:end)>value,1)+downpoint-1;
    if isempty(uppoint);uppoint=downpoint-1;end
    Rt=uppoint;
    return
end
if uppoint<downpoint
    temp=uppoint;
    uppoint=downpoint;
    downpoint=temp;
end
if uppoint>=0 && downpoint>=0
    x=(0:99)/99*(uppoint-downpoint)+downpoint;
    fittrace=(trace(uppoint+1)-trace(downpoint+1))/(uppoint-downpoint)*(x-downpoint)+trace(downpoint+1);
    absv=abs(fittrace-value);
    [~,pos]=min(absv);
    pos=pos-1;
    pos=pos/100*(uppoint-downpoint)+downpoint;
    if pos==0.49
        Rt=0.5;
    else
        Rt=pos;
    end
    disp(pos)
else
    Rt=-1;
end
    
function [peak_interval,interval_range]=peak_interval(trace,peaks)

num=length(peaks);
len=length(trace);

peak_interval=cell(1,num);
interval_range=zeros(2,num);

if num==1
    index=find(trace(1:peaks(1)+1)<mean(trace(1:floor(0.9*peaks(1))+1))+std(trace(1:floor(0.9*peaks(1))+1)))-1;
    if isempty(index)
        pstart=0;
    else
        pstart=0.5*max(index);
    end
    
    index_end=find(trace(peaks(1)+1:end)<0.1*mean(trace(peaks(1)+1:end))+0.9*trace(len))-1;
    
    if isempty(index_end)
        pend=len-1;
    else
        pend=min(index_end)+peaks(1);
    end
    peak_interval{1}=trace(floor(pstart)+1:pend+1);
    interval_range(:,1)=[pstart;pend];
else
    for i=0:num-1
        % 判断peak峰的属性，每一个，最后一个还是中间的
        switch i
            case 0
                index=find(trace(1:peaks(1)+1)<mean(trace(1:floor(0.9*peaks(1))+1))+std(trace(1:floor(0.9*peaks(1))+1)))-1;
                if isempty(index)
                    pstart=0;
                else
                    pstart=0.5*max(index);
                end
%                 [vallyv,pos_vally]=min(trace(peaks(1)+1:peaks(2)+1));
%                 pos_vally=pos_vally-1;
%                 pos_vally=pos_vally+peaks(1);
                
                [~,pos_vally2]=min(trace(peaks(i+1)+1:peaks(i+2)+1));
                pos_vally2=pos_vally2-1;
                pos_vally2=pos_vally2+peaks(i+1);
                pend=pos_vally2;
                
            case num-1
                [~,pos_vally]=min(trace(peaks(i)+1:peaks(i+1)+1));
                pos_vally=pos_vally-1;
                pos_vally=pos_vally+peaks(i);
                pstart=pos_vally;
                [~,pos_vally]=min(trace(peaks(i+1)+1:end));
                pos_vally=pos_vally-1;
                pos_vally=pos_vally+peaks(i+1);
                pend=pos_vally;
                
            otherwise
                [~,pos_vally1]=min(trace(peaks(i)+1:peaks(i+1)+1));
                pos_vally1=pos_vally1-1;
                pos_vally1=pos_vally1+peaks(i);
                pstart=pos_vally1;
                [~,pos_vally2]=min(trace(peaks(i+1)+1:peaks(i+2)+1));
                pos_vally2=pos_vally2-1;
                pos_vally2=pos_vally2+peaks(i+1);
                pend=pos_vally2;
        end
        peak_interval{i+1}=trace(floor(pstart(1))+1:pend(1)+1);
        interval_range(:,i+1)=[pstart;pend];
    end
end
    
    
    
    
    
    