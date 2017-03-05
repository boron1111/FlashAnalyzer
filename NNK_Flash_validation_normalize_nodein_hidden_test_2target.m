% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by NPRTOOL
% Created Tue Jul 14 18:02:11 CST 2015
%
% This script assumes these variables are defined:
%
%   a - input data.
%   b - target data.

%��һ����1��ʾ��flash���ڶ�����1��ʾ��flash
%�ؼ�������������Ԫ������validation�������ݹ��򻯵ķ�ʽ
%%

clear all
clc
%%
%file read

%[filename,filepath]=uigetfile('*.txt');
%file=[filepath,filename]

%file='E:\CLUSTERING DATASETS\20151210 plate 74nlo\clustering data 2 manual check.csv';
% file='E:\CLUSTERING DATASETS\20151210 plate 74nlo\clustering data 2 manual check_newbasal.csv';
file='C:\CLUSTERING DATASETS\20151210 plate 74nlo\all.csv';
data2=load(file);
[m,n]=size(data2);

%%
%parameter normalization
for i=1:n-1
    meanv=mean(data2(:,i));
    std=sqrt(sum((data2(:,i)-meanv).^2)/(m-1));
    data(:,i)=(data2(:,i)-meanv)/std;
    data(:,i)=1.0./(1+exp(-data(:,i)));
    maxv=max(data(:,i));
    minv=min(data(:,i));
    data(:,i)=(data(:,i)-minv)/(maxv-minv)*2-1;
    character(:,i)=[meanv,std,maxv,minv];
end


%%
%sample set
% len=round(0.9*m) % training size
% %inputs = data(1:len,[3:8,10,13,14])';
% inputs = data(1:len,1:n-1)'; %training input
% targets = [[data2(1:len,n)],1-[data2(1:len,n)]]'; % training targets
% c=data(len+1:end,1:n-1)'; %predict dataset
% %c=data(:,[3:8,10,13,14])';
% label=data2(len+1:end,n)';
%%
%random training set
%sample set
%ind=rand(m,1);
 load('C:\Users\ljhis007\Desktop\variables.mat', 'ind');
ind_train=find(ind<=0.9);
ind_test=find(ind>0.9);
len=max(size(ind_train)) % training size
%inputs = data(1:len,[3:8,10,13,14])';
inputs = data(ind_train,1:n-1)'; %training input
targets = [[data2(ind_train,n)]]';%,1-[data2(ind_train,n)]]'; % training targets
c=data(ind_test,1:n-1)'; %predict dataset
label=data2(ind_test,n)';

%%
% Create a Pattern Recognition Network
for circle=1:100
circle
hiddenLayerSize = [13,8,floor(circle / 10)+3];%circle*10;%[10,30];
net = patternnet(hiddenLayerSize);
%net = newff(inputs,targets,10,{'tansig','purelin'},'trainlm');

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.max_fail=25;
net.trainParam.epochs=1000;
%net.trainParam.lr=0.1;
net.trainParam.goal=0.00001;
%%
%��õ���Ԫ����Ϊ30����õ�׼ȷ����0.93����õ�fail����1000��
%%
% Train the Network
tic
[net,tr,Y,E,Pf,Af] = train(net,inputs,targets);
toc
time=toc;
% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

%%
% Plots
% Uncomment these lines to enable various plots.
h1=figure(1); plotperform(tr)
h2=figure(2); plottrainstate(tr)
h3=figure(3); plotconfusion(targets,outputs)
h4=figure(4); ploterrhist(errors)

%%
%result display
res_score=net(c);
res=round(net(c));
% figure(1);
% plot(data2(:,n),'r*');
% figure(2);
% plot(res(1,:),'b+');


%%
%performance of prediction
v_l=sum(label);
v_r=sum(res(1,:));

tp=sum(label & res(1,:));
pre=tp/v_r;
recall=tp/v_l;

f=2*pre*recall/(recall+pre);
rmse=sum((label-res(1,:)).^2)/max(size(label));

pre
recall
f
rmse
precisions(circle)=pre;
recalls(circle)=recall;
fvalues(circle)=f;

%%
%self defined nnk validation
c;% 14*54331
iw=net.iw{1};%50*14
lw=net.lw{2};%1*50
b=net.b;%
b_hidden=b{1}*double(ones(1,m-len));%50*1
value_hidden=tansig(c'*(iw)'+b_hidden');
%value_hidden=2.000000./(1+exp(-2*(c'*(iw)'+b_hidden')))-1;
hidden_normalize=[max(max(value_hidden)),min(min(value_hidden))];
%value_hidden=(value_hidden-min(min(value_hidden)))/(max(max(value_hidden))-min(min(value_hidden)))*2-1;
% value_hidden=mapminmax(value_hidden);
%%
%����֮ǰע���һ����[-1,1]

b_output=b{2}*double(ones(1,m-len));
output=tansig(value_hidden*lw'+b_output');
%output=2.0./(1+exp(-2*(value_hidden*lw'+b_output)))-1;
%output2=round(output-min(min(output)))/(max(max(output))-min(min(output)));
output2=round((output+1.0000)/2.0000);
output3=output2(:,1);

disp('self computed nnk')
disp('pre')
pre2=sum(label& output3')/sum(output3)
disp('recall')
recall2=sum(label& output3')/sum(label)
disp('f-score')
f2=pre2*recall2*2/(pre2+recall2)
rmse2=sum((label-output3').^2)/max(size(label))
precisions2(circle)=pre2;
recalls2(circle)=recall2;
fvalues2(circle)=f2;

paras=[hiddenLayerSize,net.trainParam.max_fail/1000,net.trainParam.epochs/1000,tp,v_l,v_r,pre,recall,f,pre2,recall2,f2,rmse,rmse2];
status=[num2str(hiddenLayerSize),'_',num2str(net.trainParam.max_fail),'_',num2str(net.trainParam.epochs),'_',num2str(f)]
%%
%save the parameters
%%{

filedir='D:\matlab NNK newbasal\';
a=mkdir(filedir,['2_',status]);
filedir=[filedir,'2_',status];
csvwrite([filedir,'\character normalize.csv'],character);
csvwrite([filedir,'\hidden normalize.csv'],hidden_normalize);
csvwrite([filedir,'\input weight.csv'],iw);
csvwrite([filedir,'\input b.csv'],b{1});
csvwrite([filedir,'\hidden weight.csv'],lw);
csvwrite([filedir,'\hidden b.csv'],b{2});
csvwrite([filedir,'\results.csv'],paras);
csvwrite([filedir,'\time.csv'],time);
save([filedir,'\net.mat'],'net');

saveas(h1,[filedir,'\performance.jpg'],'jpg');
saveas(h2,[filedir,'\trainstate.jpg'],'jpg');
saveas(h3,[filedir,'\confusion.jpg'],'jpg');
saveas(h4,[filedir,'\errorhist.jpg'],'jpg');
save([filedir,'\variables.mat']);
%%}


disp('done')
disp('circle=')

end
csvwrite(['D:\matlab NNK newbasal','\performance of hiddenlayers-precision.csv'],precisions);
csvwrite(['D:\matlab NNK newbasal','\performance of hiddenlayers-precision2.csv'],precisions2);
csvwrite(['D:\matlab NNK newbasal','\performance of hiddenlayers-recalls.csv'],recalls);
csvwrite(['D:\matlab NNK newbasal','\performance of hiddenlayers-recalls2.csv'],recalls2);
csvwrite(['D:\matlab NNK newbasal','\performance of hiddenlayers-fvalues.csv'],fvalues);
csvwrite(['D:\matlab NNK newbasal','\performance of hiddenlayers-fvalues2.csv'],fvalues2);