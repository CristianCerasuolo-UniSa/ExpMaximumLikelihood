function [] = varyingS(min, max, step, N, s1, t, nMC)

assert(min < max, 'min must be lesser than max')

num_tests = (max-min)/step + 1; % Number of iterations
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
for s2 = min:step:max
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


    i = i+1;
end

%%%% Compare performance with different values of s2 fixing s1
fig1 = "MSE varying sigma";
figure('name', fig1)
hold on
grid
plot(min:step:max, MSEs_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 1')
plot(min:step:max, MSEs_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Censoring 2')
plot(min:step:max, MSEs_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Arithmetic Mean')
plot(min:step:max, MSEs_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'ML')
xline(s1, 'g', 'Variance $$\sigma_1^2$$ (fixed)', 'interpreter', 'latex');
xline(3*s1, 'r', 'Critical threshold $$(3 \sigma_1^2)$$', 'interpreter', 'latex');
titles = ['$$\sigma^2_1$$ = ', num2str(s1), ' $$N$$ = ', num2str(N), ...
    ' $$\theta$$ = ', num2str(t), ' MC = ', num2str(nMC)];
title(titles,'interpreter', 'latex', 'FontSize', 20)
xlabel({'$$\sigma_2^2$$'}, 'interpreter', 'latex', 'FontSize',18)
ylabel('MSE', 'interpreter', 'latex','FontSize', 18)
legend('Censoring 1', 'Censoring 2', 'Arithmetic Mean', 'ML',...
    'location', 'northeast')

saveas(gcf, fig1, 'png')



%%%% Compare differences with theoretical error with different values of N
fig2 = 'Pratical vs theoretical varying sigma';
figure('name', fig2)
subplot(2, 2, 1)
plot(min:step:max, MSEs_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
plot(min:step:max, vars_1, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel({'$$\sigma^2_2$$'}, 'interpreter', 'latex', 'FontSize', 18)
ylabel({'MSE'}, 'interpreter', 'latex')
xline(s1, 'g', {'Variance $$\sigma_1^2$$ (fixed)'}, 'interpreter', 'latex');
title('Censoring 1')
legend('MSE', 'Variance')

subplot(2, 2, 2)
plot(min:step:max, MSEs_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
plot(min:step:max, vars_2, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('$$\sigma_2^2$$', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
xline(s1, 'g', 'Variance $$\sigma_1^2$$ (fixed)', 'interpreter', 'latex');
title('Censoring 2')
legend('MSE', 'Variance')


subplot(2, 2, 3)
plot(min:step:max, MSEs_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
plot(min:step:max, vars_ave, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('$$\sigma_2^2$$', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
xline(s1, 'g', 'Variance $$\sigma^2_1$$ (fixed)', 'interpreter', 'latex');
xline(3*s1, 'r', 'Critical threshold $$(3 \sigma_1^2)$$', 'interpreter', 'latex');
title('Arithmetic Mean')
legend('MSE', 'Variance')


subplot(2, 2, 4)
plot(min:step:max, MSEs_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
plot(min:step:max, vars_ML, '-d', 'linewidth', 2, 'DisplayName', 'Variance') 
xlabel('$$\sigma_2^2$$', 'interpreter', 'latex', 'FontSize', 18)
ylabel('MSE', 'interpreter', 'latex')
xline(s1, 'g', 'Variance $$\sigma_1^2$$ (fixed)', 'interpreter', 'latex');
title('ML')
legend('MSE', 'Variance')

sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)

saveas(gcf, fig2, 'png')


%%%% Compare the estimation of the paramether theta against the true value
fig3 = 'Estimation varying sigma';
figure('name', fig3)
subplot(2, 2, 1)
plot(min:step:max, aves_1, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('$$\sigma_2^2$$', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
xline(s1, 'g', 'Variance $$\sigma_1^2$$ (fixed)', 'interpreter', 'latex');
title('Censoring 1')

subplot(2, 2, 2)
plot(min:step:max, aves_2, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('$$\sigma_2^2$$', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
xline(s1, 'g', 'Variance $$\sigma_1^2$$ (fixed)', 'interpreter', 'latex');
title('Censoring 2')


subplot(2, 2, 3)
plot(min:step:max, aves_ave, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('$$\sigma_2^2$$', 'interpreter', 'latex', 'FontSize', 18)
ylabel('$$\hat \theta$$', 'interpreter', 'latex')
xline(s1, 'g', 'Variance $$\sigma_1^2$$ (fixed)', 'interpreter', 'latex');
xline(3*s1, 'r', 'Critical threshold $$(3 \sigma_1^2)$$', 'interpreter', 'latex');
title('Arithmetic Mean')


subplot(2, 2, 4)
plot(min:step:max, aves_ML, '-o', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'MSE')
hold on
grid
yline(t, 'b', 'True value - Mean')
xlabel('$$\sigma_2^2$$', 'interpreter', 'latex', 'FontSize', 18)
ylabel({'$$\hat \theta$$'}, 'interpreter', 'latex')
xline(s1, 'g', {'Variance $$\sigma_1^2$$ (fixed)'}, 'interpreter', 'latex');
title('ML')

sgtitle(titles, 'interpreter', 'latex', 'FontSize', 20)

saveas(gcf, fig3, 'png')

end

