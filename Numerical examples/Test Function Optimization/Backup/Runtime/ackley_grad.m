function [xopt,fopt,niter,gnorm,dx] = grad_descent(varargin)

if nargin==0
    % define starting point
    x0 = [3 3]';
elseif nargin==1
    % if a single input argument is provided, it is a user-defined starting
    % point.
    x0 = varargin{1};
else
    error('Incorrect number of input arguments.')
end
% termination tolerance
tol = 1e-6;
% maximum number of allowed iterations
maxiter = 1000;
% minimum allowed perturbation
dxmin = 1e-6;
% step size ( 0.33 causes instability, 0.2 quite accurate)
alpha = 0.1;
% initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm = inf; x = x0; niter = 0; dx = inf;
% define the objective function
f1 = @(x1,x2) -20*exp(-0.2*sqrt(0.5*(x1.^2+x2.^2)))-exp(0.5*(cos(2*pi*x1)+cos(2*pi*x2)))+exp(1)+20;
syms x1 x2
f = -20*exp(-0.2*sqrt(0.5*(x1^2+x2^2)))-exp(0.5*(cos(2*pi*x1)+cos(2*pi*x2)))+exp(1)+20;
g = gradient(f)
g1 = matlabFunction(g)
g1 = func2str(g1);
g1 = replace(g1,"@(x1,x2)","@(x)");
g1 = replace(g1,["x1","x2"],["x(1)","x(2)"]);
g1 = str2func(g1)
% plot objective function contours for visualization:
% figure(1); clf; ezcontour(f,[-5 5 -5 5]); axis equal; hold on
% redefine objective function syntax for use with optimization:
f2 = @(x) f1(x(1),x(2));
% gradient descent algorithm:
iniTime = clock
while and(gnorm>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    g = g1(x);
    gnorm = norm(g);
    % take step:
    xnew = x - alpha*g;
    % check step
    if ~isfinite(xnew)
        display(['Number of iterations: ' num2str(niter)])
        error('x is inf or NaN')
    end
    % plot current point
    % plot([x(1) xnew(1)],[x(2) xnew(2)],'-*')
    % refresh
    % update termination metrics
    niter = niter + 1;
    dx = norm(xnew-x);
    x = xnew;
    
end

xopt = x
fopt = f2(xopt)
niter = niter - 1
fprintf('elapsed time: %f sec\n', double(etime(clock, iniTime)));
end