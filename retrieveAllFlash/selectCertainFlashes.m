% allFlash���д����������ǣ�1���ļ�ID����2��ROI ID����3��14�����β���������ȥretrieveAllFlashesFromMatFile���ң���15���¶�
% allROI���д����������ǣ�1���ļ�ID����2��ROI ID����3��cpYFP��ֵ����4��TMRM��ֵ����5���¶�
% ��6��cpYFP��׼���7��TMRM��׼��

%%
clear
load('IsoMitoHeart_atp');
clear paths

%%
% ��cpYFPӫ��С��һ����ֵ��ROIȥ��
removedROI=allROIs(:,3)<1;

% ������ROI
cleanedROI=allROIs;
cleanedROI(removedROI,:)=[];

% �����ÿ���ļ���ROI����
% cleanedROIcount=zeros(size(filenames,1),1);
% for id=1:length(filenames);
%     cleanedROIcount(id)=sum(cleanedROI(:,1)==id);
% end

% ������flash��Ӧ��һ���߼��;����ϣ�ȡ1��ʾҪȥ�����
removedFlash=false(size(allFlashes,1),1);

removedROI_fileID=allROIs(removedROI,1);
removedROI_ROIID=allROIs(removedROI,2);

for id=1:length(removedROI_fileID)
    removedFlash(allFlashes(:,1)==removedROI_fileID(id) & allFlashes(:,2)==removedROI_ROIID(id))=1;
end
cleanedFlash=allFlashes;
cleanedFlash(removedFlash,:)=[];

clear id removedROI removedFlash removedROI_fileID removedROI_ROIID
clear allFlashes allROIs

%%
% ����flash�ĸ�������
F0_cpYFP=cleanedFlash(:,7);
dF_F0_cpYFP=(cleanedFlash(:,6)-cleanedFlash(:,7))./F0_cpYFP;
F0_TMRM=cleanedFlash(:,13);
dF_F0_TMRM=(cleanedFlash(:,12)-cleanedFlash(:,13))./F0_TMRM;
time1_cpYFP=cleanedFlash(:,3)-cleanedFlash(:,4);
time1_TMRM=cleanedFlash(:,9)-cleanedFlash(:,10);
time2_cpYFP=cleanedFlash(:,5)-cleanedFlash(:,3);
time2_TMRM=cleanedFlash(:,11)-cleanedFlash(:,9);

%%
% �Ȱ�flash��ROI���¶ȷ�Ϊ9���飬ÿ���¶��ж��ʵ�����ڣ������ж��dish��ÿ��dish�ж��frame������
% Ҫ����������cell������ROI��flash������
flash_index=cell(9,1);
ROI_index=cell(9,1);
for id=1:9
    % ���¶��µ�ʵ������
    daytemp=fileinfo(fileinfo(:,4)==id*5,:);
    % ͳ��һ��һ���ж��ٸ���
    daytab=tabulate(daytemp(:,1));
    if isempty(daytab); continue; end
    daytab(daytab(:,2)==0,:)=[];
    % ÿ��cell�ĳ�Ա������ʵ��������cell
    flash_index{id}=cell(size(daytab,1),1);
    ROI_index{id}=cell(size(daytab,1),1);
    % ��ʵ����������
    for id_day=1:length(flash_index{id})
        % ���¶��¸���������
        dishtemp=daytemp(daytemp(:,1)==daytab(id_day),:);
        % ͳ��һ���ж�����
        dishtab=tabulate(dishtemp(:,2));
        dishtab(dishtab(:,2)==0,:)=[];
        % Ϊÿ�̽���һ��cell
        flash_index{id}{id_day}=cell(size(dishtab,1),1);
        ROI_index{id}{id_day}=cell(size(dishtab,1),1);
        % ����������
        for id_dish=1:length(flash_index{id}{id_day})
            % ���¶��¸��������̵�frame
            frametemp=dishtemp(dishtemp(:,2)==dishtab(id_dish),:);
            % Ϊÿ��frame����һ��cell
            flash_index{id}{id_day}{id_dish}=cell(size(frametemp,1),1);
            ROI_index{id}{id_day}{id_dish}=cell(size(frametemp,1),1);
            % ��frame����
            for id_frame=1:length(flash_index{id}{id_day}{id_dish})
                fileID=find(fileinfo(:,1)==frametemp(id_frame,1) &...
                    fileinfo(:,2)==frametemp(id_frame,2) &...
                    fileinfo(:,3)==frametemp(id_frame,3));
                flash_index{id}{id_day}{id_dish}{id_frame}=find(cleanedFlash(:,1)==fileID);
                ROI_index{id}{id_day}{id_dish}{id_frame}=find(cleanedROI(:,1)==fileID);
            end
        end
    end
end

clear daytemp daytab dishtemp dishtab frametemp fileID
clear id id_day id_dish id_frame

%%
% ��ǰ��ֿ���flash��Ƶ�ʺͲ�����ֵ

% ��һ��frameһ��n����Ƶ��
frequency=cell(size(flash_index));
% �Ѳ�ͬ�¶ȵ�frequency����һ��_line����˼�ǰ�����ͬ�¶ȵķŵ�һ������
frequency_line=frequency;

for id=1:length(flash_index)
    frequency{id}=cell(size(flash_index{id}));
    for id_day=1:length(flash_index{id})
        frequency{id}{id_day}=cell(size(flash_index{id}{id_day}));
        for id_dish=1:length(flash_index{id}{id_day});
            frequency{id}{id_day}{id_dish}=cell(size(flash_index{id}{id_day}{id_dish}));
            for id_frame=1:length(flash_index{id}{id_day}{id_dish})
                % ����Ϊֹ��ÿ��frame��һ��Ƶ��
                frequency{id}{id_day}{id_dish}{id_frame}=size(flash_index{id}{id_day}{id_dish}{id_frame},1)/...
                    size(ROI_index{id}{id_day}{id_dish}{id_frame},1);
                frequency_line{id}=cat(1,frequency_line{id},frequency{id}{id_day}{id_dish}{id_frame});
            end
        end
    end
end


% % ��һ��dishһ��n����Ƶ��
% frequency=cell(size(flash_index));
% % �Ѳ�ͬ�¶ȵ�frequency����һ��
% frequency_line=frequency;
% 
% for id=1:length(flash_index)
%     frequency{id}=cell(size(flash_index{id}));
%     for id_day=1:length(flash_index{id})
%         frequency{id}{id_day}=cell(size(flash_index{id}{id_day}));
%         for id_dish=1:length(flash_index{id}{id_day});
%             flashCount=0;
%             ROICount=0;
%             for id_frame=1:length(flash_index{id}{id_day}{id_dish})
%                 % ����Ϊֹ��ÿ��frame���ۼӽ���dish��������
%                 flashCount=flashCount+size(flash_index{id}{id_day}{id_dish}{id_frame},1);
%                 ROICount=ROICount+size(ROI_index{id}{id_day}{id_dish}{id_frame},1);
%             end
%             frequency{id}{id_day}{id_dish}=flashCount/ROICount;
%             frequency_line{id}=cat(1,frequency_line{id},frequency{id}{id_day}{id_dish});
%         end
%     end
% end
% 
% figure
% for id=1:length(frequency_line)
%     subplot(3,3,id)
%     plot(frequency_line{id})
%     title(num2str(id*5));
% end

figure
for id=1:length(frequency)
    subplot(3,3,id)
    hold on
    title(num2str(id*5))
    color='b';
    count=0;
    for id1=1:length(frequency{id})
        length_day=nestedCellLength(frequency{id}{id1});
        plot((1:length_day)+count,...
            frequency_line{id}((1:length_day)+count),[color,'.-'])
        count=count+length_day;
        if strcmp(color,'b')
            color='r';
        else
            color='b';
        end
    end
    hold off
end

%%
% ����ROI��ӫ���ֵ�ľ�ֵ

% ��һ��frameһ��n����ROI��ӫ��ǿ�Ⱦ�ֵ
fluoMean=cell(size(flash_index));
% �Ѳ�ͬ�¶ȵ�ROI��ӫ��ǿ�Ⱦ�ֵ����һ��
fluoMean_line=fluoMean;

% ��һ��frameһ��n����ROI��ӫ��ǿ�ȱ�׼��
fluoStd=cell(size(flash_index));
% �Ѳ�ͬ�¶ȵ�ROI��ӫ��ǿ�ȱ�׼�����һ��
fluoStd_line=fluoStd;

% ��һ��frameһ��n����ROI��ӫ��ǿ�ȱ���ϵ��
fluoCV=cell(size(flash_index));
% �Ѳ�ͬ�¶ȵ�ROI��ӫ��ǿ�ȱ���ϵ������һ��
fluoCV_line=fluoCV;

for id=1:length(flash_index)
    fluoMean{id}=cell(size(flash_index{id}));
    for id_day=1:length(flash_index{id})
        fluoMean{id}{id_day}=cell(size(flash_index{id}{id_day}));
        for id_dish=1:length(flash_index{id}{id_day});
            fluoMean{id}{id_day}{id_dish}=cell(size(flash_index{id}{id_day}{id_dish}));
            for id_frame=1:length(flash_index{id}{id_day}{id_dish})
                % ����Ϊֹ��ÿ��frame����ROI��ӫ��ǿ�Ⱦ�ֵ�ľ�ֵ��3��cpYFP��4��TMRM
                fluoMean{id}{id_day}{id_dish}{id_frame}=mean(cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},3));
%                 fluoMean{id}{id_day}{id_dish}{id_frame}=mean(cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},4));
                fluoMean_line{id}=cat(1,fluoMean_line{id},fluoMean{id}{id_day}{id_dish}{id_frame});
                % ����Ϊֹ��ÿ��frame����ROI��ӫ��ǿ�ȱ�׼��ľ�ֵ��6��cpYFP��7��TMRM
                fluoStd{id}{id_day}{id_dish}{id_frame}=mean(cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},6));
%                 fluoStd{id}{id_day}{id_dish}{id_frame}=mean(cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},7));
                fluoStd_line{id}=cat(1,fluoStd_line{id},fluoStd{id}{id_day}{id_dish}{id_frame});
                % ����Ϊֹ��ÿ��frame����ROI��ӫ��ǿ�ȱ�׼��ľ�ֵ��6/3��cpYFP��7/4��TMRM
                fluoCV{id}{id_day}{id_dish}{id_frame}=mean(cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},6)./...
                    cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},3));
%                 fluoCV{id}{id_day}{id_dish}{id_frame}=mean(cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},7)./...
%                     cleanedROI(ROI_index{id}{id_day}{id_dish}{id_frame},4));
                fluoCV_line{id}=cat(1,fluoCV_line{id},fluoCV{id}{id_day}{id_dish}{id_frame});
            end
        end
    end
end

% figure;
% for id=1:length(fluoMean_line)
%     subplot(3,3,id)
%     plot(fluoMean_line{id})
%     title(num2str(id*5));
% end

% toShow=fluoMean; toShow_line=fluoMean_line;

% toShow=fluoStd; toShow_line=fluoStd_line;

toShow=fluoCV; toShow_line=fluoCV_line;

figure
for id=1:length(toShow)
    subplot(3,3,id)
    hold on
    title(num2str(id*5))
    color='b';
    count=0;
    for id1=1:length(toShow{id})
        length_day=nestedCellLength(toShow{id}{id1});
        plot((1:length_day)+count,...
            toShow_line{id}((1:length_day)+count),[color,'.-'])
        count=count+length_day;
        if strcmp(color,'b')
            color='r';
        else
            color='b';
        end
    end
    hold off
end
set(gcf,'position',[410   246   902   619])

%%
% ����flash�ĸ��ֲ���;

% % ��һ��frameһ��n���������ֵ
% para=cell(size(flash_index));
% % �Ѳ�ͬ�¶ȵ�flash��������һ��
% para_line=para;
% 
% % ��Ҫ����Ĳ�������para_origin
% para_origin=dF_F0_cpYFP;
% 
% for id=1:length(flash_index)
%     para{id}=cell(size(flash_index{id}));
%     for id_day=1:length(flash_index{id})
%         para{id}{id_day}=cell(size(flash_index{id}{id_day}));
%         for id_dish=1:length(flash_index{id}{id_day});
%             para{id}{id_day}{id_dish}=cell(size(flash_index{id}{id_day}{id_dish}));
%             for id_frame=1:length(flash_index{id}{id_day}{id_dish})
%                 % ����Ϊֹ��ÿ��frame����flash�Ĳ���
% %                 para{id}{id_day}{id_dish}{id_frame}=para_origin(flash_index{id}{id_day}{id_dish}{id_frame});
%                 % ÿ��frame�е�flash������ƽ��ֵ
%                 para{id}{id_day}{id_dish}{id_frame}=mean(para_origin(flash_index{id}{id_day}{id_dish}{id_frame}));
%                 para_line{id}=cat(1,para_line{id},para{id}{id_day}{id_dish}{id_frame});
%             end
%         end
%     end
% end

%%
% �����excel���

% toExcel_line=para_line;
% toExcel_line=frequency_line;
% toExcel_line=fluoCV_line;
% toExcel_line=fluoMean_line;
toExcel_line=fluoCV_line;
% 
% for id=1:9
%     lengths=length(toExcel_line{id});
% end
% toExcel=cell(max(lengths),9);

for id=1:9
    for id1=1:length(toExcel_line{id})
        toExcel{id1,id}=num2str(toExcel_line{id}(id1));
    end
end
xlswrite1(toExcel,'',{'5','10','15','20','25','30','35','40','45'});

figure;
for id=1:length(toExcel_line)
    subplot(3,3,id)
    plot(toExcel_line{id})
    title(num2str(id*5));
end


%%
% ��������flash��ʼ��ķֲ�ͼ
% base=allFlashes(:,4);
% figure
% hist(base,1:100)

%%
% ��flash���¶ȷֿ�������ʼ��ķֲ�ͼ
% temp_col=allFlashes(:,15);
% flash=cell(9,1);
% figure;
% for id=1:9 
%     flash{id}=allFlashes(temp_col==id*5,:);
%     base=flash{id}(:,4);
%     subplot(3,3,id);
%     hist(base,1:100);
% %     title([num2str(id*5),'��','  From ',num2str(size(flash{id},1)),' flashes']);
%     title([num2str(id*5),'��']);
% end

%%
% �������е����ݲ������¶�ʱflash��ƽ��������
% m=size(allFlashes,1)/size(allROIs,1);

%%
% % ��ROI���¶ȷֿ�
% ROI=cell(9,1);
% for id=1:9
%     ROI{id}=allROIs(allROIs(:,5)==id*5,:);
% end
% 
% % ����ÿ��ROI��flash�ĸ��������벴�ɷֲ�����ֵ���Աȣ����¶ȷ���
% flashCounts=cell(9,1);
% for idt=1:9
%     flashCounts{idt}=zeros(size(ROI{idt},1),1);
%     for id=1:size(ROI{idt},1)
%         % ��allFlash�аѶ�Ӧ�ļ�ID��ROI ID��trace���ҳ���
%         flashCounts{idt}(id)=sum(allFlashes(:,1)==ROI{idt}(id,1) & allFlashes(:,2)==ROI{idt}(id,2));
%     end
%     [n,~]=hist(flashCounts{idt},0:5);
%     total=size(flashCounts{idt},1);
%     m=(n(1)*0+n(2)*1+n(3)*2+n(4)*3+n(5)*4+n(6)*5)/total;
% %     disp(m)
%     n_exp=pdf('poisson',0:5,m)*total;
%     subplot(3,3,idt);
%     plot(0:5,n,0:5,n_exp);
%     xlim([0 5]);
%     set(gca,'xtick',0:5)
% %     title(['temperature: ',num2str(idt*5),'��'])
%     title([num2str(idt*5),'��']);
% end

%%
% �����ȫ��trace��flash�����ʱ��ķֲ������Ƿ���ָ���ֲ�
% ��ÿ���ļ���ʱ�����нӳ�һ��������У���ǳ�flash���
% [ROI_counts,~]=hist(allROIs(:,1),1:max(allROIs(:,1)));
% flash_merge_index=cell(length(ROI_counts),1);
% flash_merge_info=zeros(length(ROI_counts),2); %��һ�з�ROI�������ڶ��з��¶�
% for id=1:length(flash_merge_index)
%     selectedFlashes=allFlashes(allFlashes(:,1)==id,:);
%     flash_merge_index{id}=zeros(size(selectedFlashes,1),1);
%     for id1=1:size(selectedFlashes,1)
%         flash_merge_index{id}(id1)=(selectedFlashes(id1,2)-1)*100+selectedFlashes(id1,3);
%     end
%     flash_merge_info(id,:)=[ROI_counts(id) selectedFlashes(1,15)];    
% end
% 
% % �������������¶����Ƿ����ָ���ֲ�
% flash_merge_interval=cell(length(ROI_counts),1);
% for id=1:length(flash_merge_interval)
%     flash_merge_interval{id}=diff(flash_merge_index{id});
% end
% 
% % ���¶ȷֿ�
% flash_interval_temp=cell(9,1);
% for id=1:9
%     flash_interval_temp{id}=flash_merge_interval(flash_merge_info(:,2)==id*5);
%     flash_interval_temp{id}=cell2mat(flash_interval_temp{id});
%     m=sum(allFlashes(:,15)==id*5)/sum(allROIs(:,5)==id*5);
%     
%     subplot(3,3,id)
%     
%     bin_interval=100;
%     [c,I]=hist(flash_interval_temp{id},(0:bin_interval:max(flash_interval_temp{id}))+bin_interval/2);
%     c_exp=m/100*exp(-m/100*I)*bin_interval*length(flash_interval_temp{id});
%     plot(I,c,'.',I,c_exp,'-');
%     xlim([0 2000])
%     title([num2str(id*5),'��'])
% end

%%
% ����TMRM�½��¼��Ĳ����������ֳܷ�����

% ����ӿ�ʼ�½���������͵��ʱ��
% time1_TMRM=allFlashes(:,9)-allFlashes(:,10);
% % ������͵㵽������ʱ��
% time2_TMRM=allFlashes(:,11)-allFlashes(:,9);
% 
% amplitude_TMRM=allFlashes(:,13)-allFlashes(:,12);
% amplitude_cpYFP=allFlashes(:,6)-allFlashes(:,7);
% 
% time1_cpYFP=allFlashes(:,3)-allFlashes(:,4);
% time2_cpYFP=allFlashes(:,5)-allFlashes(:,3);
% 
% % figure;hist(time1_TMRM,0:max(time1_TMRM));title('time1\_TMRM');
% % figure;hist(time2_TMRM,0:max(time2_TMRM));title('time2\_TMRM');
% % figure;hist(amplitude_TMRM);title('amplitude\_TMRM');
% % figure;hist(amplitude_cpYFP);title('amplitude\_cpYFP');
% % figure;hist(time1_cpYFP,min(time1_cpYFP):max(time1_cpYFP));title('time1\_cpYFP');
% % figure;hist(time2_cpYFP,min(time2_cpYFP) :max(time2_cpYFP));title('time2\_cpYFP');
% 
% figure;plot(time1_TMRM+time2_TMRM)
% ylim([0 45])
% 
% figure;plot(time1_TMRM,amplitude_TMRM,'.')
% figure;plot(time1_TMRM,time2_TMRM,'.')
% 
% ratio1=time2_TMRM./time1_TMRM;
% [c,I]=hist(ratio1(ratio1~=inf),50);
% 
% bar(I,c)
% figure;plot(I,cumsum(c)/max(cumsum(c)),'.-')

%%
% �����������֯flash��Ƶ��
