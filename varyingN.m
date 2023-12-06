function [] = varyingN(min, max, step, s1, s2, t, nMC)
% Fissando la varianza degli stimatori, il parametro da stimare theta,
% vogliamo valutare come varia l'errore con diverse misure di N che vanno
% da min a max con passo step. 

assert(min <= max, 'min must be lesser than max')

% Skip the firs iteration if starting point is 0
if min == 0
    min = min + step;
end


num_tests = floor((max-min)/step + 1); % Number of iterations
MSEs_ML = zeros(num_tests, 1);
MSEs_ave = zeros(num_tests, 1);
MSEs_2 = zeros(num_tests, 1);
MSEs_1 = zeros(num_tests, 1);

vars_1 = zeros(num_tests, 1);
vars_2 = zeros(num_tests, 1);
vars_ML = zeros(num_tests, 1);
vars_ave = zeros(num_tests, 1);

aves_1 = zeros(num_tests, 1);
aves_2 = zeros(num_tests, 1);
aves_ave = zeros(num_tests, 1);
aves_ML = zeros(num_tests, 1);


i = 1;
for N = min:step:max
    %%%% Start simulation with N samples
    [MSE_ML, MSE_plain, MSE_1, MSE_2,...
    avML, avplain, av1, av2, var_1, var_2, var_ML, var_ave ...
    ]=twotranches(N, s1, s2, t, nMC);

    %%%% Take each MSE and add to vector
    MSEs_ML(i) = MSE_ML;
    MSEs_ave(i) = MSE_plain;
    MSEs_1(i) = MSE_1;
    MSEs_2(i) = MSE_2;

    %%%% Take the value of theoretical error in each test
    vars_1(i) = var_1;
    vars_2(i) = var_2;
    vars_ave(i) = var_ave;
    vars_ML(i) = var_ML;

    %%%% Take the average value estimated in Montecarlo simulation for each
    %%%% estimator
    aves_1(i) = av1;
    fprintf("N: %d AV1: %.3d\n", N, av1)
    aves_2(i) = av2;
    aves_ave(i) = avplain;
    aves_ML(i) = avML;


    i = i+1;
end

%%%% Compare performance with different values of N
fig1 = 'MSE varying N';
figure('name', fig1)
hold on
grid
plot(min:step:max, MSEs_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 1')
plot(min:step:max, MSEs_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 2')
plot(min:step:max, MSEs_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
plot(min:step:max, MSEs_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'ML')
titles = ['$$\sigma_1^2$$ = ', num2str(s1), ' $$\sigma_2^2$$ = ', num2str(s2), ...
    ' $$\theta$$ = ', num2str(t), ' MC = ', num2str(nMC)];
title(titles, 'interpreter', 'latex', 'FontSize', 20)
xlabel('N', 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex', 'FontSize', 18)
legend('Censoring 1', 'Censoring 2', 'Arithmetic Mean', 'ML',...
    'location', 'northeast')

saveas(gcf, fig1, 'png')

%%%% Compare differences with theoretical error with different values of N
fig2 = 'Pratical vs theoretical varying N';
figure('name', fig2)
subplot(2, 2, 1)
plot(min:step:max, MSEs_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
plot(min:step:max, vars_1, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
title('Censoring 1')
legend('MSE', 'Variance')

subplot(2, 2, 2)
plot(min:step:max, MSEs_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
plot(min:step:max, vars_2, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
title('Censoring 2')
legend('MSE', 'Variance')


subplot(2, 2, 3)
plot(min:step:max, MSEs_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
plot(min:step:max, vars_ave, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
title('Arithmetic Mean')
legend('MSE', 'Variance')


subplot(2, 2, 4)
plot(min:step:max, MSEs_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
plot(min:step:max, vars_ML, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
title('ML')
legend('MSE', 'Variance')

sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)

saveas(gcf, fig2, 'png')


%%%% Compare the estimation of the paramether theta against the true value
fig3 = 'Estimation varying N';
figure('name', fig3)
subplot(2, 2, 1)
plot(min:step:max, aves_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('Censoring 1')

subplot(2, 2, 2)
plot(min:step:max, aves_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('Censoring 2')


subplot(2, 2, 3)
plot(min:step:max, aves_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('Arithmetic Mean')


subplot(2, 2, 4)
plot(min:step:max, aves_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('ML')

sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)

saveas(gcf, fig3, 'png')


