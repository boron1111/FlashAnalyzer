function retrieveAllFlashesFromMatFile(paths)

% global allFlashes filenames allROIs allTMRMTraces allcpYFPTraces
% 用于存放全部的flash相关数据
allFlashes=[];
filenames={};
allROIs=[];
allTMRMTraces=[];
allcpYFPTraces=[];
filenameCount=0;

% 每一个path，由参数传入
for id=1:length(paths)
    disp(paths{id})
    pathname=['E:\yupeng\',paths{id},'\'];
    % 170314的数据没有写底物
    if strcmp(paths{id},'170314')
        filename=dir([pathname,'*.mat']);
    else
        filename=dir([pathname,'*.mat']);
    end
    
    fileDate=convertsixDigDateTomatDate(paths{id});
    
    % 每一个文件
    for id1=1:length(filename)
        % 加载status变量到工作空间
        load([pathname,filename(id1).name])
        
        % ROI长度不是100的话，就跳过
        if length(status.image)~=100
            disp(['length is ',num2str(length(status.image))])
            continue
        end        
        
        % 文件名的序号，存到信息里作文件名ID
        filenameCount=filenameCount+1;
        
        % 文件名和文件日期
        filenames=cat(1,filenames,{filename(id1).name,fileDate});
        
        % temperature直接从文件名中提取
        temperature=extractTemperature(filename(id1).name);

        if status.count
            data=[];

            % 每一个ROI
            for ida=1:status.count
                cpYFPMean=mean(status.flashsignal{ida}{status.cpYFPCh});
                TMRMMean=mean(status.flashsignal{ida}{status.TMRMCh});
                cpYFPStd=std(status.flashsignal{ida}{status.cpYFPCh});
                TMRMStd=std(status.flashsignal{ida}{status.cpYFPCh});
                allROIs=cat(1,allROIs,[filenameCount,...  %文件编号
                    ida,...  %ROI编号
                    cpYFPMean,...
                    TMRMMean,...
                    temperature,...
                    cpYFPStd,...
                    TMRMStd]);
                try
                    allTMRMTraces=cat(1,allTMRMTraces,status.flashsignal{ida}{status.TMRMCh});
                    allcpYFPTraces=cat(1,allcpYFPTraces,status.flashsignal{ida}{status.cpYFPCh});
                catch
                    beep
                end
                
                % 每一个Flash
                for ida1=1:length(status.signalpoint{ida}.ind)
                    data=cat(1,data,...
                        [filenameCount,...  % 文件名的ID
                        ida,...  % ROI的ID
                        status.signalpoint{ida}.ind(ida1),...  %cpYPF顶点时刻，3
                        status.signalpoint{ida}.base(ida1),...  %cpYFP起点时刻，4
                        status.signalpoint{ida}.down(ida1),...  %cpYFP终点时刻，5
                        status.signalpoint{ida}.pea(ida1),...
                        status.signalpoint{ida}.basepea(ida1),...
                        status.signalpoint{ida}.downpea(ida1),...
                        status.signalpoint{ida}.tind(ida1),... %TMRM的一套，这是最低点，9
                        status.signalpoint{ida}.tbase(ida1),...
                        status.signalpoint{ida}.tdown(ida1),...
                        status.signalpoint{ida}.tpea(ida1),...
                        status.signalpoint{ida}.tbasepea(ida1),...
                        status.signalpoint{ida}.tdownpea(ida1),temperature]);  %上面为各个参数
                end
            end
            allFlashes=cat(1,allFlashes,data);
        end
    end
end

% 生成文件信息，包括文件日期，盘数编号，视野编号和温度
fileinfo=zeros(length(filenames),4);
for id=1:length(filenames)
    str_temp=regexp(filenames{id},'[0-9]+','match');
    % 有些没有写温度的就是25度
    if length(str_temp)==2
        str_temp{3}='25';
    end
    fileinfo(id,:)=[filenames{id,2} str2double(str_temp)];
end
clear str_temp

save('data.mat','allFlashes','filenames','allROIs','fileinfo',...
    'allTMRMTraces','allcpYFPTraces','paths')

function matDate=convertsixDigDateTomatDate(sixDigStr)

matDate=datenum(str2double(['20',sixDigStr(1:2)]),...
    str2double(sixDigStr(3:4)),...
    str2double(sixDigStr(5:6)));

function temperature=extractTemperature(filename)

% filename='HeLa_IsoMito_cpYFP_TMRM_dish_01_frame_01_newATP_25';
str_temp=regexp(filename,'[0-9]+','match');
if length(str_temp)==2
    temperature=25;
else
    temperature=str2double(str_temp{3});
end