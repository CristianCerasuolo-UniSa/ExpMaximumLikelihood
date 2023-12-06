function [] = varyingNLogly(min, max, mult, s1, s2, t, nMC)
% Fissando la varianza degli stimatori, il parametro da stimare theta,
% vogliamo valutare come varia l'errore con diverse misure di N che vanno
% da min a max con passo step. 

assert(min <= max, 'min must be lesser than max')

tests = min * (mult.^(0:(log(max/min)/log(mult)+1)));
num_tests = length(tests); % Number of iterations

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


for i = 1:length(tests)
    N = tests(i);
    %%%% Start simulation with N samples
    [AVE, MSE, VAR]=...
        twotranches(N, s1, s2, t, nMC);

    %%%% Take each MSE and add to vector
    MSEs_ML(i) = MSE.ML;
    MSEs_ave(i) = MSE.plain;
    MSEs_1(i) = MSE.cens1;
    MSEs_2(i) = MSE.cens2;

    %%%% Take the value of theoretical error in each test
    vars_1(i) = VAR.cens1;
    vars_2(i) = VAR.cens2;
    vars_ave(i) = VAR.plain;
    vars_ML(i) = VAR.ML;

    %%%% Take the average value estimated in Montecarlo simulation for each
    %%%% estimator
    aves_1(i) = AVE.cens1;
    aves_2(i) = AVE.cens2;
    aves_ave(i) = AVE.plain;
    aves_ML(i) = AVE.ML;
end

%%%% Compare performance with different values of N
fig1 = 'MSE varying N';
figure('name', fig1)
semilogx(tests, MSEs_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 1')
hold on
grid
semilogx(tests, MSEs_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 2')
semilogx(tests, MSEs_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
semilogx(tests, MSEs_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'ML')
titles = ['$$\sigma_1^2$$ = ', num2str(s1), ' $$\sigma_2^2$$ = ', num2str(s2), ...
    ' $$\theta$$ = ', num2str(t), ' MC = ', num2str(nMC)];
title(titles, 'interpreter', 'latex', 'FontSize', 20)
xlabel('N', 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex', 'FontSize', 18)
legend('Censoring 1', 'Censoring 2', 'Arithmetic Mean', 'ML',...
    'location', 'northeast')

saveas(gcf, fig1, 'png')


fig1 = 'MSE varying N log scale';
figure('name', fig1)
loglog(tests, MSEs_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 1')
hold on
grid
loglog(tests, MSEs_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 2')
loglog(tests, MSEs_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
loglog(tests, MSEs_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'ML')
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
semilogx(tests, MSEs_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
semilogx(tests, vars_1, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
title('Censoring 1')
legend('MSE', 'Variance')

subplot(2, 2, 2)
semilogx(tests, MSEs_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
semilogx(tests, vars_2, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
title('Censoring 2')
legend('MSE', 'Variance')


subplot(2, 2, 3)
semilogx(tests, MSEs_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
semilogx(tests, vars_ave, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
title('Arithmetic Mean')
legend('MSE', 'Variance')


subplot(2, 2, 4)
semilogx(tests, MSEs_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
semilogx(tests, vars_ML, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
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
semilogx(tests, aves_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('Censoring 1')

subplot(2, 2, 2)
semilogx(tests, aves_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('Censoring 2')


subplot(2, 2, 3)
semilogx(tests, aves_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('Arithmetic Mean')


subplot(2, 2, 4)
semilogx(tests, aves_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('N', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
title('ML')

sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)

saveas(gcf, fig3, 'png')


