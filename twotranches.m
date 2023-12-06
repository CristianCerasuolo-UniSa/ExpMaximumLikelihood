function [avStruct, MSEStruct, varStruct]=twotranches(N, s1, s2, t, nMC)
% Function that take two sample of data from a gaussian variable with equal
% length N/2 and variance s1 and s2. These sample are with mean t.
% A number of nMC montecarlo simulations are performed and 4 estimators are
% being tested computing estimation and correspondeing MSE.

% s1 and s2 are variances of the two tranches

p = s2/(s1+s2);

for ii=1:nMC
    %%%% Generate the data
    x1 = normrnd(t,sqrt(s1),1,N/2); % First tranch
    x2 = normrnd(t,sqrt(s2),1,N/2); % Second tranch
    x = [x1, x2]; % Concatenate in same row

    %%%% Estimate
    %%% ML Estimator
    tML(ii) = p*mean(x1)+(1-p)*mean(x2);
    %%% Plain arithmetic mean
    tplain(ii) = mean(x);
    %%% Censoring approaches
    t1(ii) = mean(x1);
    t2(ii) = mean(x2);


end

%%%% Check unbiased
avStruct.ML = mean(tML);
avStruct.plain = mean(tplain);
avStruct.cens1 = mean(t1);
avStruct.cens2 = mean(t2);

%%%% Compute the error
MSEStruct.ML = mean((tML-t).^2);
MSEStruct.plain = mean((tplain-t).^2);
MSEStruct.cens1 = mean((t1-t).^2);
MSEStruct.cens2 = mean((t2-t).^2);

%%%% Compute the variance from theory
varStruct.ML = 2*s1*s2/(N*(s1+s2));
varStruct.plain = (s1+s2)/(2*N);
varStruct.cens1 = 2*s1/N;
varStruct.cens2 = 2*s2/N;

% figure
% subplot(4,1,1)
% plot(1:nMC, tML, '-bo', 1:nMC, t*ones(1,nMC), '--r',...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% xlabel('MC runs', 'fontsize', 18)
% ylabel('MLE', 'fontsize',18)
% axis([1 nMC t-1 t+1])
% grid
% 
% 
% subplot(4,1,2)
% plot(1:nMC, tplain, '-bo', 1:nMC, t*ones(1,nMC), '--r',...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% xlabel('MC runs', 'fontsize', 18)
% ylabel('Arithmetic mean', 'fontsize',18)
% axis([1 nMC t-1 t+1])
% grid
% 
% 
% subplot(4,1,3)
% plot(1:nMC, t1, '-bo', 1:nMC, t*ones(1,nMC), '--r',...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% xlabel('MC runs', 'fontsize', 18)
% ylabel('Censoring 1', 'fontsize',18)
% axis([1 nMC t-1 t+1])
% grid
% 
% 
% subplot(4,1,4)
% plot(1:nMC, t2, '-bo', 1:nMC, t*ones(1,nMC), '--r',...
%     'markersize', 10, 'markerface', 'r', 'linewidth', 2)
% xlabel('MC runs', 'fontsize', 18)
% ylabel('Censoring 2', 'fontsize',18)
% axis([1 nMC t-1 t+1])
% grid

end
