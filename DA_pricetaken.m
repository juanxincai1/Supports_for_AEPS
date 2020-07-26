%%%完全竞争市场%%%
%%%价格接受者%%%
%%%日前调度，价格采用联合(独立)报价模式下的出清价格%%%
clear
clc
%决策变量
Pch=sdpvar(4,96);%各充电站充电电量
Pdis=sdpvar(4,96);%各充电站放电电量
S=sdpvar(4,96);%广义储能设备电量
%基本参数
load data_potential_DA
Pchmax=[Forecast_CS1(1,1:96);Forecast_CS2(1,1:96);Forecast_CS3(1,1:96);Forecast_CS4(1,1:96)];%充电站充电报量上限
Pdismax=[Forecast_CS1(2,1:96);Forecast_CS2(2,1:96);Forecast_CS3(2,1:96);Forecast_CS4(2,1:96)];%充电站放电报量上限
Smin=[Forecast_CS1(3,1:96);Forecast_CS2(3,1:96);Forecast_CS3(3,1:96);Forecast_CS4(3,1:96)];%充电站电量下限;
Smax=[Forecast_CS1(4,1:96);Forecast_CS2(4,1:96);Forecast_CS3(4,1:96);Forecast_CS4(4,1:96)];%充电站电量上限;
deltaS=[Forecast_CS1(5,1:96);Forecast_CS2(5,1:96);Forecast_CS3(5,1:96);Forecast_CS4(5,1:96)];%充电站电量变化量;
lastS=[Forecast_CS1(5,97);Forecast_CS2(5,97);Forecast_CS3(5,97);Forecast_CS4(5,97)];%第96个时段必须完成的充电量
price=[1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1.10000000000000,1,1,1,1,0.900000000000000,1,0.900000000000000,0.900000000000000,1,1,1,1,1,1,1,1,1,1,1,1,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.800000000000000,0.800000000000000,0.800000000000000,0.800000000000000,0.800000000000000,0.800000000000000,0.800000000000000,0.800000000000000,0.700000000000000,0.700000000000000,0.700000000000000,0.700000000000000,0.500000000000000,0.500000000000000,0.500000000000000,0.500000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.400000000000000,0.500000000000000,0.500000000000000,0.500000000000000,0.500000000000000,0.700000000000000,0.700000000000000,0.700000000000000,0.700000000000000,0.900000000000000,0.900000000000000,0.900000000000000,0.900000000000000];
%约束条件
Constraints=[0<=Pch<=Pchmax,0<=Pdis<=Pdismax,Smin<=S<=Smax,S(:,1)==0.25*0.95*Pch(:,1)-0.25*Pdis(:,1)/0.95+deltaS(:,1),
    S(:,2:96)==S(:,1:95)+0.25*0.95*Pch(:,2:96)-0.25*Pdis(:,2:96)/0.95+deltaS(:,2:96),
    0==S(:,96)+lastS];%充电站约束
%目标函数
Obj=sum(0.25*(Pch-Pdis)*price');%充电站各自目标
%求解模型
ops=sdpsettings('solver','gurobi','gurobi.OptimalityTol',1e-8,'gurobi.FeasibilityTol',1e-8,'gurobi.IntFeasTol',1e-8);
ops.gurobi.MIPGap=1e-8;
solvesdp(Constraints,Obj,ops);
result_DA_pricetaken.Pch=double(Pch);
result_DA_pricetaken.Pdis=double(Pdis);
result_DA_pricetaken.S=double(S);
save('result_DA_pricetaken','result_DA_pricetaken');