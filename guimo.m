%%
clc ;
clear all ;
%%
Tamb = 273.15+20;                              % �����¶� K
T_yanjing = Tamb;
P_amb = 101325;                                % ����ѹ�� Pa
n_T = 0.9;                                    % ͸ƽЧ��
P_H = 7200000;                                 % ���������ѹ�� Pa
nengxiao = 0.8;
P_L = 4600000;                                 % ����������ѹ�� Pa
P_L_out = 4200000;                                 % ����������ѹ�� Pa
pengzhangbi = (P_L_out/P_amb)^(1/3);
if pengzhangbi<3 || pengzhangbi>6
    fprintf('!!!ע�����ͱ�\n')
end
T_hot = 273.15 + 300;                        % ��Դ�¶� K
%% ������
% ������
T3_EX_HOT_IN = T_hot;
T3_EX_COOL_IN = T_yanjing;
T3_EX_HOT_OUT = T3_EX_HOT_IN - nengxiao * (T3_EX_HOT_IN - T3_EX_COOL_IN);      
T3_EX_COOL_OUT = T3_EX_COOL_IN + (T3_EX_HOT_IN-T3_EX_HOT_OUT);


% ͸ƽ
p3_in = P_L_out;
T3_in = T3_EX_COOL_OUT;
h3_in = refpropm('H','T',T3_in,'P',p3_in/1000,'AIR.PPF');      %J/kg
S3_in = refpropm('S','T',T3_in,'P',p3_in/1000,'AIR.PPF');   
S3_out_rev = S3_in;   
p3_out = p3_in/pengzhangbi;
h3_out_rev = refpropm('H','P',p3_out/1000,'S',S3_out_rev,'AIR.PPF');      %J/kg
h3_out = h3_in - n_T*(h3_in-h3_out_rev ) ;
T3_out =  refpropm('T','P',p3_out/1000,'H',h3_out,'AIR.PPF'); 

% �ȹ�
h3_EX_COOL_IN = refpropm('H','T',T3_EX_COOL_IN,'P',p3_in/1000,'AIR.PPF');

Q3 = h3_in - h3_EX_COOL_IN;
w3_out = h3_in-h3_out;

%% �ڶ���
% ������
T2_EX_HOT_IN = T_hot;
T2_EX_COOL_IN = T3_out;
T2_EX_HOT_OUT = T2_EX_HOT_IN - nengxiao * (T2_EX_HOT_IN - T2_EX_COOL_IN);      
T2_EX_COOL_OUT = T2_EX_COOL_IN + (T2_EX_HOT_IN-T2_EX_HOT_OUT);

% ͸ƽ
p2_in = p3_out;
T2_in = T2_EX_COOL_OUT;
h2_in = refpropm('H','T',T2_in,'P',p2_in/1000,'AIR.PPF');      %J/kg
S2_in = refpropm('S','T',T2_in,'P',p2_in/1000,'AIR.PPF');   
S2_out_rev = S2_in;   
p2_out = p2_in/pengzhangbi;
h2_out_rev = refpropm('H','P',p2_out/1000,'S',S2_out_rev,'AIR.PPF');      %J/kg
h2_out = h2_in - n_T*(h2_in-h2_out_rev ) ;
T2_out =  refpropm('T','P',p2_out/1000,'H',h2_out,'AIR.PPF'); 

% �ȹ�
h2_EX_COOL_IN = refpropm('H','T',T2_EX_COOL_IN,'P',p2_in/1000,'AIR.PPF');

Q2 = h2_in - h2_EX_COOL_IN;
w2_out = h2_in-h2_out;

%% ��һ��
% ������
T1_EX_HOT_IN = T_hot;
T1_EX_COOL_IN = T2_out;
T1_EX_HOT_OUT = T1_EX_HOT_IN - nengxiao * (T1_EX_HOT_IN - T1_EX_COOL_IN);      
T1_EX_COOL_OUT = T1_EX_COOL_IN + (T1_EX_HOT_IN-T1_EX_HOT_OUT);

% ͸ƽ
p1_in = p2_out;
T1_in = T1_EX_COOL_OUT;
h1_in = refpropm('H','T',T1_in,'P',p1_in/1000,'AIR.PPF');      %J/kg
S1_in = refpropm('S','T',T1_in,'P',p1_in/1000,'AIR.PPF');   
S1_out_rev = S1_in;   
p1_out = P_amb;
h1_out_rev = refpropm('H','P',p1_out/1000,'S',S1_out_rev,'AIR.PPF');      %J/kg
h1_out = h1_in - n_T*(h1_in-h1_out_rev ) ;
T1_out =  refpropm('T','P',p1_out/1000,'H',h1_out,'AIR.PPF'); 

% �ȹ�
h1_EX_COOL_IN = refpropm('H','T',T1_EX_COOL_IN,'P',p1_in/1000,'AIR.PPF');

Q1 = h1_in - h1_EX_COOL_IN;
w1_out = h1_in-h1_out;

%% ���ʡ�ʱ�����������������
Power = 100*1000000;     % W
t_h = 8*3600;            % s
E_power = Power*t_h;     % J
m_air = Power/(w1_out+w2_out+w3_out);% �������� kg/s
M_air = m_air*t_h;                   % ������ kg
rho_L = refpropm('D','T',T_yanjing,'P',P_L/1000,'AIR.PPF');
rho_H = refpropm('D','T',T_yanjing,'P',P_H/1000,'AIR.PPF');
V = M_air/(rho_H-rho_L);             % �ݻ� m^3

%% ����
n_C = 0.85;
yabi = (P_H/P_amb)^(1/3);

%% ��һ��ѹ��
T_C1_IN = Tamb;
P_C1_IN = P_amb;
h_C1_in = refpropm('H','T',T_C1_IN,'P',P_C1_IN/1000,'AIR.PPF');      %J/kg
S_C1_in = refpropm('S','T',T_C1_IN,'P',P_C1_IN/1000,'AIR.PPF');   
S_C1_out_rev = S_C1_in;  
p_C1_out = P_C1_IN*yabi;
h_C1_out_rev = refpropm('H','P',p_C1_out/1000,'S',S_C1_out_rev,'AIR.PPF');      %J/kg
h_C1_out = h_C1_in + (h_C1_out_rev-h_C1_in )/n_C ;
T_C1_out =  refpropm('T','P',p_C1_out/1000,'H',h_C1_out,'AIR.PPF'); 


% ��һ������
T_C1_EX_HOT_IN = T_C1_out;
T_C1_EX_COOL_IN = Tamb;
T_C1_EX_HOT_OUT = T_C1_EX_HOT_IN - nengxiao * (T_C1_EX_HOT_IN - T_C1_EX_COOL_IN);      
T_C1_EX_COOL_OUT = T_C1_EX_COOL_IN + (T_C1_EX_HOT_IN-T_C1_EX_HOT_OUT);

% �ȹ�
h_C1_EX_HOT_OUT = refpropm('H','T',T_C1_EX_HOT_OUT,'P',p_C1_out/1000,'AIR.PPF');
Q_C1 = h_C1_out - h_C1_EX_HOT_OUT;
w_C1 = h_C1_out-h_C1_in;

%% �ڶ���ѹ��
T_C2_IN = T_C1_EX_HOT_OUT;
P_C2_IN = p_C1_out;
h_C2_in = refpropm('H','T',T_C2_IN,'P',P_C2_IN/1000,'AIR.PPF');      %J/kg
S_C2_in = refpropm('S','T',T_C2_IN,'P',P_C2_IN/1000,'AIR.PPF');   
S_C2_out_rev = S_C2_in;  
p_C2_out = P_C2_IN*yabi;
h_C2_out_rev = refpropm('H','P',p_C2_out/1000,'S',S_C2_out_rev,'AIR.PPF');      %J/kg
h_C2_out = h_C2_in + (h_C2_out_rev-h_C2_in )/n_C ;
T_C2_out =  refpropm('T','P',p_C2_out/1000,'H',h_C2_out,'AIR.PPF'); 


% �ڶ�������
T_C2_EX_HOT_IN = T_C2_out;
T_C2_EX_COOL_IN = Tamb;
T_C2_EX_HOT_OUT = T_C2_EX_HOT_IN - nengxiao * (T_C2_EX_HOT_IN - T_C2_EX_COOL_IN);      
T_C2_EX_COOL_OUT = T_C2_EX_COOL_IN + (T_C2_EX_HOT_IN-T_C2_EX_HOT_OUT);

% �ȹ�
h_C2_EX_HOT_OUT = refpropm('H','T',T_C2_EX_HOT_OUT,'P',p_C2_out/1000,'AIR.PPF');
Q_C2 = h_C2_out - h_C2_EX_HOT_OUT;
w_C2 = h_C2_out-h_C2_in;

%% ������ѹ��
T_C3_IN = T_C2_EX_HOT_OUT;
P_C3_IN = p_C2_out;
h_C3_in = refpropm('H','T',T_C3_IN,'P',P_C3_IN/1000,'AIR.PPF');      %J/kg
S_C3_in = refpropm('S','T',T_C3_IN,'P',P_C3_IN/1000,'AIR.PPF');   
S_C3_out_rev = S_C3_in;  
p_C3_out = P_H;
h_C3_out_rev = refpropm('H','P',p_C3_out/1000,'S',S_C3_out_rev,'AIR.PPF');      %J/kg
h_C3_out = h_C3_in + (h_C3_out_rev-h_C3_in )/n_C ;
T_C3_out =  refpropm('T','P',p_C3_out/1000,'H',h_C3_out,'AIR.PPF'); 


% ����������
T_C3_EX_HOT_IN = T_C3_out;
T_C3_EX_COOL_IN = Tamb;
T_C3_EX_HOT_OUT = T_C3_EX_HOT_IN - nengxiao * (T_C3_EX_HOT_IN - T_C3_EX_COOL_IN);      
T_C3_EX_COOL_OUT = T_C3_EX_COOL_IN + (T_C3_EX_HOT_IN-T_C3_EX_HOT_OUT);

% �ȹ�
h_C3_EX_HOT_OUT = refpropm('H','T',T_C3_EX_HOT_OUT,'P',p_C3_out/1000,'AIR.PPF');
Q_C3 = h_C3_out - h_C3_EX_HOT_OUT;
w_C3 = h_C3_out-h_C3_in;

%% 
W_chu = (w_C1+w_C2+w_C3)*M_air;
W_shi = (w1_out+w2_out+w3_out)*M_air;

n_ele = W_shi/W_chu ;
