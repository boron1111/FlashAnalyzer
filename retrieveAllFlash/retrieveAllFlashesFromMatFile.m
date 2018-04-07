function retrieveAllFlashesFromMatFile(paths)

% global allFlashes filenames allROIs allTMRMTraces allcpYFPTraces
% ���ڴ��ȫ����flash�������
allFlashes=[];
filenames={};
allROIs=[];
allTMRMTraces=[];
allcpYFPTraces=[];
filenameCount=0;

% ÿһ��path���ɲ�������
for id=1:length(paths)
    disp(paths{id})
    pathname=['E:\yupeng\',paths{id},'\'];
    % 170314������û��д����
    if strcmp(paths{id},'170314')
        filename=dir([pathname,'*.mat']);
    else
        filename=dir([pathname,'*.mat']);
    end
    
    fileDate=convertsixDigDateTomatDate(paths{id});
    
    % ÿһ���ļ�
    for id1=1:length(filename)
        % ����status�����������ռ�
        load([pathname,filename(id1).name])
        
        % ROI���Ȳ���100�Ļ���������
        if length(status.image)~=100
            disp(['length is ',num2str(length(status.image))])
            continue
        end        
        
        % �ļ�������ţ��浽��Ϣ�����ļ���ID
        filenameCount=filenameCount+1;
        
        % �ļ������ļ�����
        filenames=cat(1,filenames,{filename(id1).name,fileDate});
        
        % temperatureֱ�Ӵ��ļ�������ȡ
        temperature=extractTemperature(filename(id1).name);

        if status.count
            data=[];

            % ÿһ��ROI
            for ida=1:status.count
                cpYFPMean=mean(status.flashsignal{ida}{status.cpYFPCh});
                TMRMMean=mean(status.flashsignal{ida}{status.TMRMCh});
                cpYFPStd=std(status.flashsignal{ida}{status.cpYFPCh});
                TMRMStd=std(status.flashsignal{ida}{status.cpYFPCh});
                allROIs=cat(1,allROIs,[filenameCount,...  %�ļ����
                    ida,...  %ROI���
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
                
                % ÿһ��Flash
                for ida1=1:length(status.signalpoint{ida}.ind)
                    data=cat(1,data,...
                        [filenameCount,...  % �ļ�����ID
                        ida,...  % ROI��ID
                        status.signalpoint{ida}.ind(ida1),...  %cpYPF����ʱ�̣�3
                        status.signalpoint{ida}.base(ida1),...  %cpYFP���ʱ�̣�4
                        status.signalpoint{ida}.down(ida1),...  %cpYFP�յ�ʱ�̣�5
                        status.signalpoint{ida}.pea(ida1),...
                        status.signalpoint{ida}.basepea(ida1),...
                        status.signalpoint{ida}.downpea(ida1),...
                        status.signalpoint{ida}.tind(ida1),... %TMRM��һ�ף�������͵㣬9
                        status.signalpoint{ida}.tbase(ida1),...
                        status.signalpoint{ida}.tdown(ida1),...
                        status.signalpoint{ida}.tpea(ida1),...
                        status.signalpoint{ida}.tbasepea(ida1),...
                        status.signalpoint{ida}.tdownpea(ida1),temperature]);  %����Ϊ��������
                end
            end
            allFlashes=cat(1,allFlashes,data);
        end
    end
end

% �����ļ���Ϣ�������ļ����ڣ�������ţ���Ұ��ź��¶�
fileinfo=zeros(length(filenames),4);
for id=1:length(filenames)
    str_temp=regexp(filenames{id},'[0-9]+','match');
    % ��Щû��д�¶ȵľ���25��
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