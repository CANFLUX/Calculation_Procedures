% LW_OUT_1_1_1 correction:

% Period affected: 2021-Oct-08 to 2022-Oct-12

%*************************************************************************
%           IMPORTANT NOTES (March 2026, Rosie)
%*************************************************************************
% Memo: Because of a fault in the CR1000 program, the LW_OUT_1_1_1 readings
%       were wrong. Issue is documented on Teams in: 
%       "ECOFLUX_Group/General/Projects/2021-DSM Delta Salt Marsh/Field log, checklist & tower documentation/DSM_inifile_clarification_20260306_0318.pptx"
%       Tzu-Yi used data to derive two relationships (see below and see
%       documentation), program used to derive relationships is: 
%       "ECOFLUX_Group/General/Projects/2021-DSM Delta Salt Marsh/Field log, checklist & tower documentation/Proc_DSM_LWout_correction_with_RBM.m"

% Periods:
% p0: 2022/10/12 11:00 - 2023/02/15 12:00 : Used to calculate fitting coefficients
% p1: 2021/10/08 15:00 - 2022/06/07 19:30 : LW_OUT_1_1_1 estimated by DSM(SWin, SWout, LWin, G, TS-5cm)
% p2: 2022/06/07 20:00 - 2022/10/12 11:00 : LW_OUT_1_1_1 calibrated using RBM LW_OUT_1_1_1 data
%*************************************************************************

% Revisions:
% Rosie 6 Feb 2026
% Cleaned up comments to make more clear.

%% Define time info
t1 = datenum(2021,10,8,15,0,0);
t2 = datenum(2022,1,1,0,0,0);   % mark the end of 2021 (so correct data is loaded for each year)
t3 = datenum(2022,6,7,19,0,0);
t4 = datenum(2022,10,12,11,0,0);  % no data affected later than this datetime

p1 = find(clean_tv>=t1 & clean_tv<=t2);     % 15:00 on 8 Oct 2021 --> 00:00 on 1 Jan 2022 
p2 = find(clean_tv>t2 & clean_tv<=t3);      % 00:30 on 1 Jan 2022 --> 19:00 on 7 June 2022
p3 = find(clean_tv>t3 & clean_tv<=t4);      % 19:30 on 7 June 2022 --> 11:00 on 12 Oct 2022

%% Call coefficients of fitting models
   % coefficients were calculated individually and copied to here.

coe_1 = [235.5937, 0.1427, -0.1694, 0.2550, 1.3807, 3.9517]; 
                          % model_1: DSM(SWin, SWout, LWin, G, TS_1)➜DSM(LWout)
coe_2 = [1.1917, 0.8632]; % model_2: (NetRad)RBM➜DSM
coe_3=[-25.9254,1.0691];  % model_3: (LWo)RBM➜DSM

%% Correct wrong data

if yearIn == 2021
    
    % p1: DSM(SWin, SWout, LWin, G, TS-5cm) ➜ DSM(LWo) ➜ DSM(NetRad)
    X=[SW_IN_1_1_1(p1), SW_OUT_1_1_1(p1), LW_IN_1_1_1(p1), TS_1(p1), G_1(p1)];
    LW_OUT_1_1_1(p1)=coe_1(1)+X*coe_1(2:end)';
    NETRAD_1_1_1(p1)=SW_IN_1_1_1(p1)-SW_OUT_1_1_1(p1)+LW_IN_1_1_1(p1)-LW_OUT_1_1_1(p1);

elseif yearIn == 2022

    % p2: DSM(SWin, SWout, LWin, G, TS-5cm) ➜ DSM(LWo) ➜ DSM(NetRad)
    X=[SW_IN_1_1_1(p2), SW_OUT_1_1_1(p2), LW_IN_1_1_1(p2), TS_1(p2), G_1(p2)];
    LW_OUT_1_1_1(p2)=coe_1(1)+X*coe_1(2:end)';
    NETRAD_1_1_1(p2)=SW_IN_1_1_1(p2)-SW_OUT_1_1_1(p2)+LW_IN_1_1_1(p2)-LW_OUT_1_1_1(p2);

    % p2: RBM ➜ DSM
    % (1) NETRAD_1_1_1    
    X=RBM_NETRAD_1_1_1(p3);
    NETRAD_1_1_1(p3)=coe_2(1)+X*coe_2(2:end)';

    % (2) LW_OUT_1_1_1
    X=RBM_LW_OUT_1_1_1(p3);
    LW_OUT_1_1_1(p3)=coe_3(1)+X*coe_3(2:end)';
else
    return
end
