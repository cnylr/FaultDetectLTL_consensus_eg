% 11/25/2018
clear,clc

addpathes

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







% constraint: 
X_min = zeros(8,1);
X_max = 10*ones(8,1);

W_min = -0.1*ones(8,1);
W_max = 0.1*ones(8,1);

W_f_min = -0.1*ones(8,1);
W_f_max = 0.1*ones(8,1);

% Formulation
N = 31; % 0.001 - 0.001 44 infeasible

x = sdpvar(repmat(8,1,N+1),repmat(1,1,N+1));

w = sdpvar(repmat(8,1,N),repmat(1,1,N));
w_f = sdpvar(repmat(8,1,N),repmat(1,1,N));

s = binvar(repmat(4,1,N),repmat(1,1,N));
s_f = binvar(repmat(4,1,N),repmat(1,1,N));

s12 = binvar(repmat(1,1,N),repmat(1,1,N));
s34 = binvar(repmat(1,1,N),repmat(1,1,N));
s13 = binvar(repmat(1,1,N),repmat(1,1,N));
s24 = binvar(repmat(1,1,N),repmat(1,1,N));

constraints = [X_min <= x{1} <= X_max];
objective = 0;
for t = 1:N
    
    Model1 = [x{t+1} == AA1*x{t} + KK1 + w{t}];
    Model2 = [x{t+1} == AA2*x{t} + KK2 + w{t}];
    Model3 = [x{t+1} == AA3*x{t} + KK3 + w{t}];
    Model4 = [x{t+1} == AA4*x{t} + KK4 + w{t}];
    
    Model1_f = [x{t+1} == AA1_f*x{t} + KK1_f + w_f{t}];
    Model2_f = [x{t+1} == AA2_f*x{t} + KK2_f + w_f{t}];
    Model3_f = [x{t+1} == AA3_f*x{t} + KK3_f + w_f{t}];
    Model4_f = [x{t+1} == AA4_f*x{t} + KK4_f + w_f{t}];

    constraints = [constraints, ...
      implies(s{t}(1), Model1), ...
      implies(s{t}(2), Model2), ...
      implies(s{t}(3), Model3), ...
      implies(s{t}(4), Model4), ...
      implies(s_f{t}(1), Model1_f), ...
      implies(s_f{t}(2), Model2_f), ...
      implies(s_f{t}(3), Model3_f), ...
      implies(s_f{t}(4), Model4_f)];
    
    % comment out this line for more general case: no common switching
    constraints = [constraints, s{t} == s_f{t}];

    constraints = [constraints, sum(s{t}) == 1, sum(s_f{t}) == 1, ...
       X_min <= x{t} <= X_max, ...
       W_min <= w{t} <= W_max, ...
       W_f_min <= w_f{t} <= W_f_max];
   
   constraints = [constraints, s12{t} <= s{t}(1) + s{t}(2),...
                               s12{t} >= s{t}(1), s12{t} >= s{t}(2),...
                               s34{t} <= s{t}(3) + s{t}(4),...
                               s34{t} >= s{t}(3), s34{t} >= s{t}(4),...
                               s13{t} <= s{t}(1) + s{t}(3),...
                               s13{t} >= s{t}(1), s13{t} >= s{t}(3),...
                               s24{t} <= s{t}(2) + s{t}(4),...
                               s24{t} >= s{t}(2), s24{t} >= s{t}(4)];
end
constraints = [constraints, X_min <= x{t+1} <= X_max];






% switching logic constraint
M13 = 4; % number of auto states, 'M-1 = 3': init, 'M = 4': bad
q_spec13 = binvar(repmat(M13,1,N+1),repmat(1,1,N+1));
M24 = 4; 
q_spec24 = binvar(repmat(M24,1,N+1),repmat(1,1,N+1));
M12 = 23; 
q_spec12 = binvar(repmat(M12,1,N+1),repmat(1,1,N+1));
M34 = 23; 
q_spec34 = binvar(repmat(M34,1,N+1),repmat(1,1,N+1));
Mx12 = 11;
qx_spec12 = binvar(repmat(Mx12,1,N+1),repmat(1,1,N+1));
Mx34 = 11;
qx_spec34 = binvar(repmat(Mx34,1,N+1),repmat(1,1,N+1));

% init = 1;
% constraints = [constraints, q_f{1}(init,1) == 1];
for t = 1:N
    constraints = [constraints, sum(q_spec13{t}) == 1, ...
                                sum(q_spec24{t}) == 1, ...
                                sum(q_spec12{t}) == 1, ...
                                sum(q_spec34{t}) == 1, ...
                                sum(qx_spec12{t}) == 1, ...
                                sum(qx_spec34{t}) == 1];
    constraints = [constraints, q_spec13{t}(M13,1) == 0, ...
                                q_spec24{t}(M24,1) == 0, ...
                                q_spec12{t}(M12,1) == 0, ...
                                q_spec34{t}(M34,1) == 0, ...
                                qx_spec12{t}(Mx12,1) == 0, ...
                                qx_spec34{t}(Mx34,1) == 0];
    
    % G^phi: spec13,24
    for spec_idx = [13, 24]
        % ------- i = 1 -------
        i = 1;
        j = 2; 
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))];
        j = 3; 
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))];
        
        constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)',spec_idx, t+1, i)) <= ...
              eval(sprintf('p_spec%d_%d_2_%d', spec_idx,i,t)) ...
            + eval(sprintf('p_spec%d_%d_3_%d', spec_idx,i,t))];
 
        % ------- i = 2 -------
        i = 2;
        j = 3; 
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))];
        constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)',spec_idx, t+1, i)) <= eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t))];
        
        % ------- i = 3 -------
        i = 3;
        j = 1; 
        k = spec_idx;
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];        
        j = 3; 
        k = spec_idx;
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];        

        constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('p_spec%d_%d_1_%d_%d', spec_idx,i,k,t)) ...
                                  + eval(sprintf('p_spec%d_%d_3_%d_%d', spec_idx,i,k,t))];
        
        % ------- i = 4 -------
        i = 4;
        j = 1; 
        k = spec_idx;
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_not', num2str(k), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <= 1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j)) + (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))) - 1];        

        constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('p_spec%d_%d_1_not%d_%d', spec_idx,i,k,t))]; 
    end

    
    % G^phi: spec12,34
    for spec_idx = [12, 34]
        % ------- i = 1 -------
        i = 1;
        j = 22; 
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))];
        constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)',spec_idx, t+1, i)) <= eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t))];
 
        % ------- i = 2:21 -------
        for i = 2:21
            j = 22; 
            eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
            constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))];
            j = i-1; 
            eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
            constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))];
           
            constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)',spec_idx, t+1, i)) <= ...
                eval(sprintf('p_spec%d_%d_22_%d', spec_idx,i,t)) ...
                + eval(sprintf('p_spec%d_%d_%d_%d', spec_idx,i,j,t))];
        end
        
        % ------- i = 22 -------
        i = 22;
        j = 21; 
        k = spec_idx;
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_not', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <= 1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j)) + (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))) - 1];        
        j = 22; 
        k = spec_idx;
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_not', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <= 1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j)) + (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))) - 1];        

        constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('p_spec%d_%d_21_not%d_%d', spec_idx,i,k,t)) ...
                                  + eval(sprintf('p_spec%d_%d_22_not%d_%d', spec_idx,i,k,t))];
                              
                              
        % ------- i = 23 -------
        i = 23; 
        j = 21; 
        k = spec_idx;
        eval(['p_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('p_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('q_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];        

        constraints = [constraints, eval(sprintf('q_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('p_spec%d_%d_21_%d_%d', spec_idx,i,k,t))];
    end
    
    % G^phi: spec x12,x34
    for spec_idx = [12, 34]
        % ------- i = 1:5 -------
        for i = 1:5
            j = i+1; 
            k = spec_idx;
            eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
            constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
            constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
            constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];        

            constraints = [constraints, eval(sprintf('qx_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                        eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t))];
        end
        
        % ------- i = 6 -------
        i = 6;
        j = 7; 
        k = spec_idx;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];        
        j = 8; 
        k = spec_idx;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];  
        
        constraints = [constraints, eval(sprintf('qx_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('px_spec%d_%d_7_%d_%d', spec_idx,i,k,t)) ...
                                  + eval(sprintf('px_spec%d_%d_8_%d_%d', spec_idx,i,k,t))];
                              
        % ------- i = 7 -------
        i = 7; 
        j = 8;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))];
        constraints = [constraints, eval(sprintf('qx_spec%d{%d}(%d)',spec_idx, t+1, i)) <= eval(sprintf('px_spec%d_%d_%d_%d', spec_idx,i,j,t))];
        
        % ------- i = 8 -------
        i = 8;
        j = 9;
        k = spec_idx;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_not', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <= (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t)))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))) - 1];  
        j = 10;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))];
        
        constraints = [constraints, eval(sprintf('qx_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('px_spec%d_%d_9_not%d_%d', spec_idx,i,k,t)) ...
                                  + eval(sprintf('px_spec%d_%d_10_%d', spec_idx,i,t))];
        % ------- i = 9 -------
        i = 9;
        j = 9;
        k = spec_idx;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_not', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <= (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t)))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))) - 1];  
        j = 10;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j), '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d', spec_idx,i,j,t)) == eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))];
        
        constraints = [constraints, eval(sprintf('qx_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('px_spec%d_%d_9_not%d_%d', spec_idx,i,k,t)) ...
                                  + eval(sprintf('px_spec%d_%d_10_%d', spec_idx,i,t))];
        % ------- i = 10 -------
        i = 10;
        j = 1; 
        k = spec_idx;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];        
        j = 10; 
        k = spec_idx;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];  
        
        constraints = [constraints, eval(sprintf('qx_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('px_spec%d_%d_1_%d_%d', spec_idx,i,k,t)) ...
                                  + eval(sprintf('px_spec%d_%d_10_%d_%d', spec_idx,i,k,t))];
        % ------- i = 11 -------
        i = 11;
        for j = 1:7
            k = spec_idx;
            eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_not', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
            constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
            constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) <= (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t)))]; 
            constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_not%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + (1 - eval(sprintf('s%d{%d}(1)',spec_idx, t))) - 1];  
        end
        j = 9;
        k = spec_idx;
        eval(['px_spec', num2str(spec_idx), '_', num2str(i), '_', num2str(j),'_', num2str(k),  '_', num2str(t), ' = ', 'binvar(1,1)']);
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <=  eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) <= eval(sprintf('s%d{%d}(1)',spec_idx, t))]; 
        constraints = [constraints, eval(sprintf('px_spec%d_%d_%d_%d_%d', spec_idx,i,j,k,t)) >= eval(sprintf('qx_spec%d{%d}(%d,1)',spec_idx, t, j)) + eval(sprintf('s%d{%d}(1)',spec_idx, t)) - 1];  
        
        constraints = [constraints, eval(sprintf('qx_spec%d{%d}(%d)', spec_idx, t+1, i)) <= ...
                                    eval(sprintf('px_spec%d_%d_1_not%d_%d', spec_idx,i,k,t)) ...
                                    eval(sprintf('px_spec%d_%d_2_not%d_%d', spec_idx,i,k,t)) ...
                                    eval(sprintf('px_spec%d_%d_3_not%d_%d', spec_idx,i,k,t)) ...
                                    eval(sprintf('px_spec%d_%d_4_not%d_%d', spec_idx,i,k,t)) ...
                                    eval(sprintf('px_spec%d_%d_5_not%d_%d', spec_idx,i,k,t)) ...
                                    eval(sprintf('px_spec%d_%d_6_not%d_%d', spec_idx,i,k,t)) ...
                                    eval(sprintf('px_spec%d_%d_7_not%d_%d', spec_idx,i,k,t)) ...
                                  + eval(sprintf('px_spec%d_%d_9_%d_%d', spec_idx,i,k,t))];
    end
end
constraints = [constraints, sum(q_spec13{t+1}) == 1, ...
                            sum(q_spec24{t+1}) == 1, ...
                            sum(q_spec12{t+1}) == 1, ...
                            sum(q_spec34{t+1}) == 1, ...
                            sum(qx_spec12{t+1}) == 1, ...
                            sum(qx_spec34{t+1}) == 1];
constraints = [constraints, q_spec13{t+1}(M13,1) == 0, ...
                            q_spec24{t+1}(M24,1) == 0, ...
                            q_spec12{t+1}(M12,1) == 0, ...
                            q_spec34{t+1}(M34,1) == 0, ...
                            qx_spec12{t+1}(Mx12,1) == 0, ...
                            qx_spec34{t+1}(Mx34,1) == 0];

ops = sdpsettings('verbose',1,'solver','GUROBI','GUROBI.MIPGap',1e-3);
optimize(constraints,objective,ops);% 

cellfun(@(v)value(v(1)),s)








