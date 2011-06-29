%% Huber test

m = 120; n = 512; k = 20; s = 5; % m rows, n cols, k nonzeros, s outliers.
p = randperm(n); x0 = zeros(n,1); x0(p(1:k)) = sign(randn(k,1));
A  = randn(m,n); [Q,R] = qr(A',0);  A = Q';

Err = zeros(m, 1); % outliers
pErr = randperm(m);
Err(pErr(1:s)) = randn(s, 1);

b  = A*x0 + 0.005 * randn(m,1) + Err;
tau = norm(x0,1);


sigma = 0.5;


options.lassoOpts.optTol = 1e-10;
options.lassoOpts.verbosity = 0;
options.tolerance = 1e-7*norm(b);

options.primal = 'lsq';
options.rootFinder = 'newton';
[xL2, info] = gbpdn(A, b, 0, sigma, [], options); 
fprintf('Target tau = %15.7e\n', tau);

%%
options.primal = 'huber';
options.hparaM = 1e-3;
options.hparaT = 1e2;
options.rootFinder = 'newton';
[xHuber,info] = gbpdn(A, b, 0, sigma, [], options); 
fprintf('Target tau = %15.7e\n', tau);



figure(1)
plot(1:n, x0, 1:n, xL2(1:n) + 2, 1:n, xHuber(1:n) - 2);legend('true','l2','huber')

figure(2)
plot(1:m, Err, 1:m, b - A*xL2(1:n)+3, 1:m, b - A*xHuber(1:n)-3);legend('True Outliers', 'l2 residuals', 'Huber Residuals')

