function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
%reshape y to be 5000x10
%m1 = zeros(size(X,1),num_labels);
%for f = 1:size(y,1)
%    m1(f,y(f)) = 1;
%end;
%y = m1; %y is now a 5000x10 (where the columns represent binary digit representation)
I = eye(num_labels);
y_mat = I(y,:);

a1 = [ones(m, 1) X];
z2 = a1 * Theta1';
a2 = sigmoid(z2);
a2 = [ones(m, 1) a2];
z3 = a2 * Theta2';
a3 = sigmoid(z3);


for n = 1:m
    yn = y_mat(n,:)';
    a3n = a3(n,:)';
    J = J + ( -yn'*log(a3n) - (1-yn)'*log(1-a3n) );
end
% cost function with regularization:
reg = (lambda / (2*m)) * (sum((Theta1(size(Theta1,1)+1:end)).^2) + sum((Theta2(size(Theta2,1)+1:end)).^2));
J = (1/m) * J;
J = J + reg;

for t = 1:m
    a3t = a3(t,:)';
    y_ex = y_mat(t,:)';
    z2t = z2(t,:)';
    d3 = (a3t - y_ex); % 10x1 - 10x1 = 10x1
    d2 = (Theta2' * d3) .* sigmoidGradient([1; z2t]); % 26x10 * 10x1 = 25x1 .* 25x10
    d2 = d2(2:end);
    %Theta1_grad = Theta1_grad + d2 * a1(t, :);
    %Theta2_grad = Theta2_grad + d3 * a2(t, :);
    Theta1_grad = Theta1_grad + (d2 * a1(t, :)); % (25x401) + (25x1 * 1x401) = 25x401
    Theta2_grad = Theta2_grad + (d3 * a2(t, :)); % (10x26) + (10x1 * 1x26) = 10x26
end

% backprop continued
Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;

Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + lambda / m * Theta1(:, 2:end);
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + lambda / m * Theta2(:, 2:end);

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
