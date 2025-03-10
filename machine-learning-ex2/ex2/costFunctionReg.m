function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
h = sigmoid(X * theta);
J = (1/m) * (log(h)'*(-y)-log(1-h)'*(1-y)) + (lambda/(2*m))*sum(theta(2:end).^2);

%separate statement for theta0
grad(1) = (1 / m)*(h-y)'*X(:,1);
for i = 2:size(grad) %gradient calculation
    grad(i) = (1 / m)*(h-y)'*X(:,i) + (lambda/m)*theta(i);
end





% =============================================================

end
