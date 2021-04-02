function varargout = NumericalCategorical(varargin)
% NUMERICALONLY_TEST MATLAB code for NumericalOnly_Test.fig
%      NUMERICALONLY_TEST, by itself, creates a new NUMERICALONLY_TEST or raises the existing
%      singleton*.
%
%      H = NUMERICALONLY_TEST returns the handle to a new NUMERICALONLY_TEST or the handle to
%      the existing singleton*.
%
%      NUMERICALONLY_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NUMERICALONLY_TEST.M with the given input arguments.
%
%      NUMERICALONLY_TEST('Property','Value',...) creates a new NUMERICALONLY_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NumericalOnly_Test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NumericalOnly_Test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NumericalOnly_Test

% Last Modified by GUIDE v2.5 27-Aug-2015 21:18:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NumericalCategoricalOpeningFcn, ...
                   'gui_OutputFcn',  @NumericalCategoricalOutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before NumericalOnly_Test is made visible.
function NumericalCategoricalOpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NumericalOnly_Test (see VARARGIN)

% Choose default command line output for NumericalOnly_Test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NumericalOnly_Test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NumericalCategoricalOutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear;
% clc;
global cate_area;
cate_col=cate_area;
disp('cate_col=');
disp(cate_col);

global k_min;
kkk_min=k_min;

global k_max;
kkk_max=k_max;

global test_table;
file_name=test_table;

global origin_table;
original_table=origin_table;

global test_sheet;
test_Sheet_name1=test_sheet;

global origin_sheet;
original_Sheet_name2=origin_sheet;

global num_area;
all_field=num_area;
%categorical_field='I1:I1484';
global maximput_times;
imputation_times=maximput_times; % maximal imputation times

%Step 1
[num, txt, raw] = xlsread(file_name,test_Sheet_name1,all_field);
A=raw;
%A=num;

%Step 2
mpos = [] ; % Array to store missing patterns' positation
count=0;
for i = 1 :size(A,1)
    for  j = 1 : size(A,2)
        disp(A{i,j})
        if isnan(A{i,j})
            %mpos = [mpos ; [i-1,j-1]];
            pos = [mpos ; [i,j]];
            count=count+1;
        end
    end
end
if count==0
    disp('The table has been imputed before, you need replaced it with the original one!');
    return;
end
% disp('Initial Data');
% disp(A);
name = 'Number of missing data';
fprintf('%s is %d: \n', name, count);

%Step 3
%The First Imputation Iteration
%Treatments to Continous
B=num; %store the numerical statistics
mean1=nanmean(B);
[rowlen1,collen1]=size(B);
for i=1:rowlen1
    for j=1:collen1
        if ~ismember(j,cate_col)%if j col is num
            if(isnan(B(i,j)))
                B(i,j)=mean1(j);
            end
        end
    end
end

C=txt;%store the categorical statistics
[C_row,C_col]=size(C);
% disp('C_col=');
% disp(C_col);
readerr=size(A,2)-C_col;
if(readerr>0)% modify read error
    tempp={};
    for i=1:size(A,1)
        tempp=[tempp;'null'];   
    end
    for j=1:readerr
        C=[tempp,C];
    end
end
% disp(size(C));
[num_original, txt_original, raw_original] = xlsread(original_table,original_Sheet_name2,all_field);
[C_row_or,C_col_or]=size(txt_original);


readerr=size(A,2)-C_col_or;
if(readerr>0)% modify read error
    tempp={};
    for i=1:size(A,1)
        tempp=[tempp;'null'];   
    end
    for j=1:readerr
        txt_original=[tempp,txt_original];
    end
end
% disp('size(txt_original)');
% disp(size(txt_original));
% %如果C之前用空先补空
% readerr=length(txt_original)-length(C);
% if readerr>0
%     for i=1:readerr
%         C=['null';C];
%     end
% end
% 
% %Treatments to Symbol
% %Data transformation
C_tran=[];%store data after transformation
[rowlen2,collen2]=size(C);
%every col get its unique
for ii=1:collen2
    if ismember(ii,cate_col) %if col=ii is category
        C_tempcol=C(:,ii);
        C_unique=unique(C_tempcol);
        C_unique1=[];%don't have null
        for i=1:length(C_unique)
            if~(strcmp(C_unique{i},'')||strcmp(C_unique{i},'null'))
                %disp('ooooooo');
                C_unique1=[C_unique1;C_unique(i)];%C_unique(i)--'xxx'
            end
        end
        %Categorical--->Numerical
        C_tran_no0=[];%use to calculate mode without empty elements
        for i=1:rowlen2
            flag=0;
            for j=1:length(C_unique1)
                if(strcmp(C_tempcol{i},C_unique1{j}))
                    C_tran=[C_tran;j];
                    C_tran_no0=[C_tran_no0;j];
                    flag=1;
                end
            end
            if flag==0
                C_tran=[C_tran;0];%empty-->0
            end
        end
  
        %calculate mode
        freq=mode(C_tran_no0);
        
        row_index=mpos(:,2)==ii;
        Cate_mpos=mpos(row_index,:);%Cate_mpos only contains col=ii
        [Cate_r,Cate_c]=size(Cate_mpos);
        %impute with freq
        for i=1:Cate_r
            C(Cate_mpos(i,1),ii)=C_unique1(freq);
        end
    end
end
% disp('C');
% disp(C);
%Refresh the database
  for wr_col=1:size(A,2)
            if ismember(wr_col,cate_col)%if category
            if wr_col < 27
                cate_field=[char(64+wr_col),num2str(1),':',char(64+wr_col),num2str(size(A,1))];
            else
            
            cate_field=[char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(1),':',char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(size(A,1))];
            end
                %         disp('cate_field');
                %         disp(cate_field);
                xlswrite(file_name,C(:,wr_col),test_Sheet_name1,cate_field);
            else% if numerical
        if wr_col < 27
            num_field=[char(64+wr_col),num2str(1),':',char(64+wr_col),num2str(size(A,1))];
        else
            
            num_field=[char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(1),':',char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(size(A,1))];
        end                %         disp('num_field');
                %         disp(num_field);
                xlswrite(file_name,B(:,wr_col),test_Sheet_name1,num_field);
            end
        end
% xlswrite(file_name,B,test_Sheet_name1,all_field);
% % xlswrite(file_name,C,Sheet_name,categorical_field);
[num, txt, raw] = xlsread(file_name,test_Sheet_name1,all_field);
% A=raw;
disp('The Result Of First Imputation Iteration:');
% disp(A);

%Calculate NRMS and AE
%Get estimated and original data respectively
%[num_estimate, txt_estimate, raw_estimate] = xlsread(file_name);
% num_estimate=num;
% txt_estimate=txt;
[C_row2,C_col2]=size(txt);


readerr=size(A,2)-C_col2;
if(readerr>0)% modify read error
    tempp={};
    for i=1:size(A,1)
        tempp=[tempp;'null'];   
    end
    for j=1:readerr
        txt=[tempp,txt];
    end
end

% disp('size(txt_estimate)');
% disp(size(txt_estimate));
%caculate NRMS for numerical part
%NRMS 分子
[row_mpos,col_mpos]=size(mpos);
s1=0;
count_numerical=0;
for i=1:row_mpos
    if ~ismember(mpos(i,2),cate_col) % If not in category
        dif=num(mpos(i,1),mpos(i,2))-num_original(mpos(i,1),mpos(i,2));
        s1=s1+dif^2;
%         disp('s1');
%         disp(s1);
        count_numerical=count_numerical+1;
    end
end
numerator=sqrt(s1);

%NRMS 分母
[row_original,col_original]=size(num_original);
s2=0;
for i=1:col_original
    if ~ismember(i,cate_col) % If not in category
        for j=1:row_original
            s2=s2+num_original(j,i)^2;
        end
    end
end

denominator=sqrt(s2); %Professor given ||
%denominator=sqrt(count_numerical); %From the Internet n
NRMS=numerator/denominator;
if isnan(NRMS)
    disp('No numericl part in this table')
else
    disp('NRMS=');
    disp(NRMS);
end
disp('size(txt_original)');
disp(size(txt_original));
% %caculate NRMS for categorical part, We assessed
% %the performance of these prediction procedures
% %through classification accuracy (CA)//AE
s3=0;
count_categorical=0;

for i = 1: C_row2
    for j = 1: C_col2
        if(strcmp(C(i,j),txt_original(i,j)))
            s3=s3+1;
        else
            s3=s3+0;
        end
    end
end
AE=s3/(C_row2 * C_col2);

%Total NRMS through weight
%NRMS_total=count_numerical/row_mpos*NRMS+count_categorical/row_mpos*CA
if isnan(AE)
    disp('No missing data in category');
else
    disp('AE=');
    disp(AE);
end




%From the 2nd imputation GKNN is employed

kth=imputation_times; % largest imputation times

optk_num=0;%optimal k when NRMS is minimal
NRMS_optk_num=0;%At this time,NRMS,AE 
AE_optk_num=0;
optk_cate=0;%optimal k when NRMS is categorical
NRMS_optk_cate=0;
AE_optk_cate=0;

minimal_k_NRMS=1;
maximal_k_AE=0;

for kkk=kkk_min:kkk_max %kkk means current k
%     kkk=10;
    former_NRMS=1;
    former_AE=0;
    disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    disp('k=');
    disp(kkk);
    for w=2:kth
        %The Second Imputation Iteration --knn core algorithm核心算法
        B=num;
        C=txt;   
        calculate_times=0;
        for n=1:rowlen2 % n is the row number of referencial instance(need to be imputed contains; ?? in Table4)为被参照的行 Table4带??
            dif1=[];%store the result of x0(p)-xi(p)
            grg1=[];%store the result of mean(grc1)
            mposcol=1;
            row_index=mpos(:,mposcol)==n;
            newmpos=mpos(row_index,:);%newmpos only contains row=n
            [newr,newc]=size(newmpos);
            if newr==collen2 % if the whole line is empty
                continue;
            end
            if newr~=0 %safe time
            for m=1:rowlen2 % m is the row number of current operating instance(observed)为当前操作的行
                if n~=m %Calculate GRG
                    grc1=[];%store the result of gray relational coefficient(GRC)
                    for ii=1:size(A,2)
                        if ~ismember(ii,cate_col) % Calculate numerical part distance
                            dif1=B(n,ii)-B(m,ii);
                            
                            col_miss1=find(newmpos(:,2)==ii);%judge if col=ii is missing判断i是否是missing那一列
                            if isempty(col_miss1)%if missing data not includes col=ii, calculate its GRC如果不是missing那列就加上其GRC
                                grc1=[grc1,(0+0.5*1)/(abs(dif1)+0.5*1)];
                                %                             disp(grc1);
                            end
                            
                            
                        else % Append categorical part distance
                        
                            col_miss2=find(newmpos(:,2)==ii);
                            if isempty(col_miss2) %if missing data excludes categorical statistics, plus category distance 如果Missing不含第六列,第六列需要算
                                if(strcmp(C(n,ii),C(m,ii)))%if they are in the same category
                                    difs1=0;
                                else
                                    difs1=1;
                                end % plus categorical GRC 加上第六列的GRC
                                grcs1=(0+0.5*1)/(abs(difs1)+0.5*1);
                                grc1=[grc1,grcs1];
                                %     disp('gracr1----------------------------------------------');
                                %     disp(gracr1);
                            end
                            %                         end
                        end
                    end
                    grg1=[grg1,mean(grc1)];
                    %                  disp('grg1----------------------------------------------');
                    %                  disp(grg1);
                end
                %      disp('Detail Result --------------------------------------------------------------------');
                %      disp(n);
                %      disp('grg1:');
                %      disp(grg1);
                
            end
            %             if isnan(grg1)
            %                 continue;
            %             end
            %find k largest store in kneighbor
            kneighbor=[];
            for i=1:kkk
                c=find(grg1==max(grg1));
                %         disp('c:');
                %         disp(c);
                if length(c)>1
                    c=c(1,1);
                end
                grg1(1,c)=0;
                if n<=c
                    neighbor=c+1;%nearneibor represents the row number of the nearest nearneibor
                else
                    neighbor=c;
                end
                kneighbor=[kneighbor;neighbor];
            end
            %imputation补全
            %disp('newmpos');
            %disp(newmpos);
            for t=1:newr
                if ismember(newmpos(t,2),cate_col) %deal with categorical statistics如果missing的数据为字符
                    Cate_2=[];%store col=newmpos(t,2) k elements
                    C_unique=unique(C(:,newmpos(t,2)));
                    C_unique1=[];%don't have null
                    for ii=1:length(C_unique)
                        if~(strcmp(C_unique{ii},'')||strcmp(C_unique{ii},'null'))
                            %                             disp('ooooooo');
                            C_unique1=[C_unique1;C_unique(ii)];%C_unique(i)--'xxx'
                        end
                    end
                    for i=1:kkk
                        for p=1:length(C_unique1)
                            if(strcmp(C(kneighbor(i),newmpos(t,2)),C_unique1(p)))
                                Cate_2 = [Cate_2 ; p];
                            end
                            %disp('C(kneighbor(i),newmpos(t,2))')
                            %disp(C(kneighbor(i),newmpos(t,2)));
                        end
                    end
                    %disp('Cate_2');
                    %disp(Cate_2);
                    freq2_ID=mode(Cate_2);
                    freq2_value=C_unique1(freq2_ID);
                    %disp('freq2_value');
                    %disp(freq2_value);
                    C(newmpos(t,1),newmpos(t,2))=freq2_value;
                    %                     C{newmpos(t,1)+1,newmpos(t,2)+1}=C{nearneibor+1,newmpos(t,2)+1};
                    %                     disp(C);
                else %deal with numerical statistics
                    s1=0;
                    for i=1:kkk
                        s1=s1+B(kneighbor(i),newmpos(t,2));
                        %B(newmpos(t,1),newmpos(t,2))=B(nearneibor,newmpos(t,2));
                    end
                    mean1=s1/kkk;
                    %disp('mean1');
                    %disp(mean1);
                    B(newmpos(t,1),newmpos(t,2))=mean1;
                end
            end
            calculate_times=calculate_times+1;
            %output interval results
            if rem(calculate_times,500)==0
                disp('*********** calculate_times=');
                disp(calculate_times);
                disp('n=');
                disp(n);
                disp('kneighbor=');
                disp(kneighbor);
                disp('Time:');
                disp(fix(clock));
            end
            end
        end
        
        %Refresh the database
        %Rewrite database
        %Refresh the database
          for wr_col=1:size(A,2)
            if ismember(wr_col,cate_col)%if category
            if wr_col < 27
                cate_field=[char(64+wr_col),num2str(1),':',char(64+wr_col),num2str(size(A,1))];
            else
            
            cate_field=[char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(1),':',char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(size(A,1))];
            end
                %         disp('cate_field');
                %         disp(cate_field);
                xlswrite(file_name,C(:,wr_col),test_Sheet_name1,cate_field);
            else% if numerical
        if wr_col < 27
            num_field=[char(64+wr_col),num2str(1),':',char(64+wr_col),num2str(size(A,1))];
        else
            
            num_field=[char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(1),':',char(64+uint8(wr_col / 26)),char(64+wr_col-26),num2str(size(A,1))];
        end                %         disp('num_field');
                %         disp(num_field);
                xlswrite(file_name,B(:,wr_col),test_Sheet_name1,num_field);
            end
        end
        
        %Read database again
        [num, txt, raw] = xlsread(file_name,test_Sheet_name1,all_field);
        %A=raw;
        [C_row3,C_col3]=size(txt);
        
        readerr=size(A,2)-C_col3;
        if(readerr>0)% modify read error
            tempp={};
            for i=1:size(A,1)
                tempp=[tempp;'null'];
            end
            for j=1:readerr
                txt=[tempp,txt];
            end
        end
        disp('=============================================================================================================')
        str_output=['The Result Of', num2str(w),'th Imputation Iteration:'];
        disp(str_output);
        %disp('The Result Of %sth Imputation Iteration:',kth);
        %disp(A);
        
        %Calculate NRMS and AE
            
        %caculate NRMS for numerical part
        %NRMS 分子
       [row_mpos,col_mpos]=size(mpos);
        s1=0;
        count_numerical=0;
        for i=1:row_mpos
            if ~ismember(mpos(i,2),cate_col) % If not in category
                dif=num(mpos(i,1),mpos(i,2))-num_original(mpos(i,1),mpos(i,2));
                s1=s1+dif^2;
                count_numerical=count_numerical+1;
            end
        end
        numerator=sqrt(s1);
        
        %NRMS 分母
        [row_original,col_original]=size(num_original);
        s2=0;
        for i=1:col_original
             if ~ismember(i,cate_col) % If not in category
                for j=1:row_original
                    s2=s2+num_original(j,i)^2;
                end
             end
        end
        
        denominator=sqrt(s2); %Professor given ||
        %denominator=sqrt(count_numerical); %From the Internet n
        NRMS=numerator/denominator;
        if isnan(NRMS)
            disp('No numericl part in this table')
        else
            disp('NRMS=');
            disp(NRMS);
        end
        
        %caculate NRMS for categorical part, We assessed
        %the performance of these prediction procedures
        %through classification accuracy (CA)//AE
        s3=0;
        count_categorical=0;
        
        for i = 1: C_row2
            for j = 1: C_col2
                if(strcmp(C(i,j),txt_original(i,j)))
                    s3=s3+1;
                else
                    s3=s3+0;
                end
            end
        end
        AE=s3/(C_row2 * C_col2);
        %Total NRMS through weight
        %NRMS_total=count_numerical/row_mpos*NRMS+count_categorical/row_mpos*CA
        if isnan(AE)
            disp('No missing data in category');
        else
            disp('AE=');
            disp(AE);
        end
        disp('Time:');
        disp(fix(clock));
        % If further Iteration is needed
        flag_loop=1;
        if(NRMS==former_NRMS&&AE==former_AE)
            flag_loop=0;
        end
        if(NRMS>former_NRMS||AE<former_AE)
            flag_loop=0;
        end
        if flag_loop==0    
            disp('Total Imputation Iteration Times=');
            disp(w);
            break;
        end
        former_NRMS=NRMS;
        former_AE=AE;
    end
       
    if NRMS<minimal_k_NRMS
        NRMS_optk_num=NRMS;
        AE_optk_num=AE;
        optk_num=kkk;
        minimal_k_NRMS=NRMS;
    end
    
    if AE>maximal_k_AE
        NRMS_optk_cate=NRMS;
        AE_optk_cate=AE;
        optk_cate=kkk;
        maximal_k_AE=AE;
    end
    
end

%output results
disp('--------------------Final Result-----------------');
if ~isnan(NRMS)
    disp('Optimal K for numerical part K=')
    disp(optk_num);
    disp('NRMS=');
    disp(NRMS_optk_num);
    if isnan(AE)
        disp('No missing data in category');
    else
        disp('AE=');
        disp(AE_optk_num);
    end
end

if ~isnan(AE)
    disp('Optimal K for categorical part K=')
    disp(optk_cate);
    
    if isnan(NRMS)
        disp('No numericl part in this table')
    else
        disp('NRMS=');
        disp(NRMS_optk_cate);
    end
    if isnan(AE)
        disp('No missing data in category');
    else
        disp('AE=');
        disp(AE_optk_cate);
    end
end



function Edit_kmin_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_kmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp('min_Callback');
global k_min;
k_min=str2double(get(hObject,'String'));

% Hints: get(hObject,'String') returns contents of Edit_kmin as text
%        str2double(get(hObject,'String')) returns contents of Edit_kmin as a double


% --- Executes during object creation, after setting all properties.
function Edit_kmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_kmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%disp('min_CreateFcn');
global k_min; %Set default value
k_min=1;
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_kmax_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_kmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global k_max;
k_max=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of Edit_kmax as text
%        str2double(get(hObject,'String')) returns contents of Edit_kmax as a double


% --- Executes during object creation, after setting all properties.
function Edit_kmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_kmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global k_max;%Set default value
k_max=10;
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_ImputationTimes_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_ImputationTimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global maximput_times;
maximput_times=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of Edit_ImputationTimes as text
%        str2double(get(hObject,'String')) returns contents of Edit_ImputationTimes as a double


% --- Executes during object creation, after setting all properties.
function Edit_ImputationTimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_ImputationTimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global maximput_times;
maximput_times=2;
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_TestTable_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_TestTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_table;
test_table=get(hObject,'String');
% Hints: get(hObject,'String') returns contents of Edit_TestTable as text
%        str2double(get(hObject,'String')) returns contents of Edit_TestTable as a double


% --- Executes during object creation, after setting all properties.
function Edit_TestTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_TestTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global test_table;
test_table='Simple1.xlsx';
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_OriginalTable_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_OriginalTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_OriginalTable as text
%        str2double(get(hObject,'String')) returns contents of Edit_OriginalTable as a double
global origin_table;
origin_table=get(hObject,'String');
% --- Executes during object creation, after setting all properties.
function Edit_OriginalTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_OriginalTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global origin_table;
origin_table='Adult.xlsx';
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_TestSheet_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_TestSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_sheet;
test_sheet=get(hObject,'String');
% Hints: get(hObject,'String') returns contents of Edit_TestSheet as text
%        str2double(get(hObject,'String')) returns contents of Edit_TestSheet as a double


% --- Executes during object creation, after setting all properties.
function Edit_TestSheet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_TestSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global test_sheet;
test_sheet='Sheet1';
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Originalsheet_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Originalsheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global origin_sheet;
origin_sheet=get(hObject,'String');
% Hints: get(hObject,'String') returns contents of Edit_Originalsheet as text
%        str2double(get(hObject,'String')) returns contents of Edit_Originalsheet as a double


% --- Executes during object creation, after setting all properties.
function Edit_Originalsheet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Originalsheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global origin_sheet;
origin_sheet='adult';
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_NumericalField_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_NumericalField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global num_area;
num_area=get(hObject,'String');
% Hints: get(hObject,'String') returns contents of Edit_NumericalField as text
%        str2double(get(hObject,'String')) returns contents of Edit_NumericalField as a double


% --- Executes during object creation, after setting all properties.
function Edit_NumericalField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_NumericalField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global num_area;
num_area='A1:O30162';
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_CategoricalColumn_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_CategoricalColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cate_area;
cate_area=str2num(get(hObject,'String'));
% disp('cate_area');
% disp(cate_area);
% Hints: get(hObject,'String') returns contents of Edit_CategoricalColumn as text
%        str2double(get(hObject,'String')) returns contents of Edit_CategoricalColumn as a double


% --- Executes during object creation, after setting all properties.
function Edit_CategoricalColumn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_CategoricalColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global cate_area;
cate_area=[2,4,6,7,8,9,10,14,15];
% disp('cate_area');
% disp(cate_area);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
