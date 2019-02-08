% 11/25/2018
% clear,clc

s = rng;
% Sys: 

% Helathy
A1 = [0.9, 0,   0,   0,   0,   0,   0,   0;...
      0,   1/2, 0,   1/2, 0,   0,   0,   0;...
      1/3, 0,   1/3, 1/3, 0,   0,   0,   0;...
      0,   1/3, 1/3, 1/3, 0,   0,   0,   0;...
      0,   0,   0,   0,   1/3, 1/3, 1/3, 0;...
      0,   0,   0,   0,   1/3, 1/3, 0,   1/3;...
      0,   0,   0,   0,   1/2, 0,   1/2, 0;...
      0,   0,   0,   0,   0,   1/2, 0,   1/2]; 
K1 = zeros(8,1);
K1(1) = 0.3; 
  
A2 = [0.9, 0,   0,   0,   0,   0,   0,   0;...
      1/2, 1/2, 0,   0,   0,   0,   0,   0;...
      0,   0,   1/2, 0,   1/2, 0,   0,   0;...
      0,   0,   0,   1/2, 0,   1/2, 0,   0;...
      0,   0,   1/2, 0,   1/2, 0,   0,   0;...
      0,   0,   0,   1/2, 0,   1/2, 0,   0;...
      0,   0,   0,   0,   0,   0,   1/2, 1/2;...
      0,   0,   0,   0,   0,   0,   1/2, 1/2]; 
K2 = zeros(8,1);
K2(1) = 0.3; 

A3 = A1;
K3 = K1;
K3(1) = 0.6; 

A4 = A2;
K4 = K2;
K4(1) = 0.6; 


% blocking
Tb = 15; 
AA1 = A1^Tb;
AA2 = A2^Tb;
AA3 = A3^Tb;
AA4 = A4^Tb;
KK1 = K1;
KK2 = K2;
KK3 = K3;
KK4 = K4;
for i = 1:1:Tb-1
    KK1 = A1*KK1 + K1;
    KK2 = A2*KK2 + K2;
    KK3 = A3*KK3 + K3;
    KK4 = A4*KK4 + K4;
end



% Faulty
A1_f = [0.9, 0,   0,   0,   0,   0,   0,   0;...
      0,   1/2, 0,   1/2, 0,   0,   0,   0;...
      1/3, 0,   1/3, 1/3, 0,   0,   0,   0;...
      0,   1/3, 1/3, 1/3, 0,   0,   0,   0;...
      0,   0,   0,   0,   1/3, 1/3, 1/3, 0;...
      0,   0,   0,   0,   1/3, 1/3, 0,   1/3;...
      0,   0,   0,   0,   1/2, 0,   1/2, 0;...
      0,   0,   0,   0,   0,   1/2, 0,   1/2]; 
K1_f = zeros(8,1);
K1_f(1) = 0.3; 
  
A2_f = [0.9, 0,   0,   0,   0,   0,   0,   0;...
      1/2, 1/2, 0,   0,   0,   0,   0,   0;...
      0,   0,   1,   0,   0,   0,   0,   0;...
      0,   0,   0,   1,   0,   0,   0,   0;...
      0,   0,   0,   0,   1,   0,   0,   0;...
      0,   0,   0,   0,   0,   1,   0,   0;...
      0,   0,   0,   0,   0,   0,   1/2, 1/2;...
      0,   0,   0,   0,   0,   0,   1/2, 1/2]; 
K2_f = zeros(8,1);
K2_f(1) = 0.3; 

A3_f = A1_f;
K3_f = K1_f;
K3_f(1) = 0.6; 

A4_f = A2_f;
K4_f = K2_f;
K4_f(1) = 0.6; 


% blocking
Tb = 15; 
AA1_f = A1_f^Tb;
AA2_f = A2_f^Tb;
AA3_f = A3_f^Tb;
AA4_f = A4_f^Tb;
KK1_f = K1_f;
KK2_f = K2_f;
KK3_f = K3_f;
KK4_f = K4_f;
for i = 1:1:Tb-1
    KK1_f = A1_f*KK1_f + K1_f;
    KK2_f = A2_f*KK2_f + K2_f;
    KK3_f = A3_f*KK3_f + K3_f;
    KK4_f = A4_f*KK4_f + K4_f;
end



% TT = 100; 
TT = 40*15;
set_pnt = 3*ones(TT,1);
set_pnt(19*15:36*15) = 6;
% set_pnt(45:58) = 34;
% set_pnt(77:95) = 34;

topo = [];
XX = [];
SS = [];

t = 1; 

% To = 1;
To = 48*15;

x0 = [4.1 4.2 3.3 4 3.5 2.2 2.7 3.8]';
i_r = 1;
RR = [1 2 1 1 2 1 2 2 1 2 2 2 2 1 2 1 2 2 2 2 2 1 2 2];
rng(s);


while t <= TT
    % r = ceil(rand(1,1)*2);
    r = RR(i_r)*15;
    if t == 1
        topo_t = 1;
        xt = x0;
    else
        if topo_t == 1
            topo_t = 2;
        else
            topo_t = 1;
        end
    end
    for tt = 1:r
        t
        if t == 571
            xxx = 999;
        end
        if (t > TT)
            break;
        else
            if t < To
                AAa1 = A1; KKk1 = K1;
                AAa2 = A2; KKk2 = K2;
                AAa3 = A3; KKk3 = K3;
                AAa4 = A4; KKk4 = K4;
            else
                AAa1 = A1_f; KKk1 = K1_f;
                AAa2 = A2_f; KKk2 = K2_f;
                AAa3 = A3_f; KKk3 = K3_f;
                AAa4 = A4_f; KKk4 = K4_f;
            end
        end
        if t <= 19*15
            wt = (0.02*rand(8,1)-0.01);
        else
            if t < 330
                wt = [-0.1*rand(4,1); 0.1*rand(4,1)];
            else
                wt = (0.2*rand(8,1)-0.1);
            end
        end
        if set_pnt(t) == 3 && topo_t == 1
            % 1
            xt1 = AAa1*xt + KKk1 + wt;
            SS = [SS, [1 0 0 0]'];
        end
        if set_pnt(t) == 3 && topo_t == 2
            % 2
            xt1 = AAa2*xt + KKk2 + wt;
            SS = [SS, [0 1 0 0]'];
        end
        if set_pnt(t) == 6 && topo_t == 1
            % 3
            xt1 = AAa3*xt + KKk3 + wt;
            SS = [SS, [0 0 1 0]'];
        end
        if set_pnt(t) == 6 && topo_t == 2
            % 4
            xt1 = AAa4*xt + KKk4 + wt;
            SS = [SS, [0 0 0 1]'];
        end
        t = t + 1;
        topo(end+1) = topo_t;
        XX = [XX, xt];
        xt = xt1;
        
        % detection
        % N = min(t,30*15);
        % w = sdpvar(repmat(8,1,N),repmat(1,1,N));
        % 
        % constraints = [];
        % objective = 0;
        % for ttt = t-N+1:1:t-2
        %     sss = ttt - (t-N);
        %     constraints = [constraints, XX(:,ttt+1) == SS(1,ttt)*(A1*XX(:,ttt) + K1 + w{sss}) ...
        %         + SS(2,ttt)*(A2*XX(:,ttt) + K2 + w{sss}) ...
        %         + SS(3,ttt)*(A3*XX(:,ttt) + K3 + w{sss}) ...
        %         + SS(4,ttt)*(A4*XX(:,ttt) + K4 + w{sss})]; 
        %     constraints = [constraints, -0.1 <= w{sss} <= 0.1]; 
        % end
        % ops = sdpsettings('verbose',1,'solver','GUROBI','GUROBI.MIPGap',1e-3);
        % optimize(constraints,objective,ops);% 
    end
    

    i_r = i_r + 1;
end

fz1 = 15; 
f1 = subplot(2,1,1);
stairs(1:TT, set_pnt,'Linewidth',2,'Linestyle','--','Color',[0,0,0]);
hold on
% plot([8*15 8*15], [-10, 20],'Linewidth',2, 'Linestyle',':','Color',[1,0,0]);
% plot([318 318], [-10 20],'Linewidth',2, 'Linestyle',':','Color',[0,0,1]);
for i = 1:8
    plot(1:TT, XX(i,:),'Linewidth',1,'Color',[1-i/8, 0.5, i/8]);
    hold on
end
axis([1,40*15,2,7]);
ylabel('UAV altitude', 'Fontsize',fz1);
% xlabel('t', 'Fontsize',fz1);
set(gca,'xtick',[0:5*15:40*15],'Fontsize',fz1)
set(gca,'ytick',[2:1:7],'Fontsize',fz1)
set(gca,'fontsize',fz1)

f2 = subplot(2,1,2);
stairs(1:TT, topo,'Linewidth',1);
axis([1,40*15,0.5,2.5]);
ylabel('Topology', 'Fontsize',fz1);
xlabel('t', 'Fontsize',fz1);
set(gca,'xtick',[0:5*15:40*15],'Fontsize',fz1)
set(gca,'ytick',[1,2],'Fontsize',fz1)
set(gca,'fontsize',fz1)
