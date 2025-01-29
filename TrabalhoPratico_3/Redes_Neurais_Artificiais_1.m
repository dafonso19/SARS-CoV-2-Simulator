n_epochs=2000;      %Numero de epocas
alpha=0.8;   %Fator de aprendizagem
%pesos=rand(-1,1);
SSE=zeros(1,n_epochs);
N=4;     %Numero de amostras
% Amostras de entrada funçao XOR
X = [ 0 0 1;
      0 1 1;
      1 0 1;
      1 1 1 ];
% Saídas da função XOR
T = [ 0
      1
      1
      0 ];

%Inicialização aleatoria dos pesos [-1,1]
% W1- 2x3  W2- 1x3
W1 = 2*rand(2,3) - 1;
W2 = 2*rand(1,3) - 1;
for epoch = 1:n_epochs
    sum_sq_error=0;
    for k = 1:N
        x = X(k,:)';
        t = T(k);

        g1 = W1*x;
        y1 = sig(g1);
        y1_b = [y1
                 1];
        g2 = W2*y1_b;
        y2 = sig(g2);
        e = t - y2;
delta2 = y2.*(1-y2).*e;
sum_sq_error=sum_sq_error+ e^2;
e1 = W2'*delta2;
e1_b = e1(1:2);
delta1 = y1.*(1-y1).*e1_b;
dW2 = alpha*delta2*y1_b';
W2 = W2 + dW2;
dW1 = alpha*delta1*x';
W1 = W1 + dW1;
    end
    SSE(epoch)=(sum_sq_error)/N;
end
for k=1:N
    x = X(k,:)';
    g1 = W1*x;
    y1 = sig(g1);
    y1_b = [y1
            1];
    g2 = W2*y1_b;
    y_plot(k)=sig(g2);
end
y_plot;
It=1:1:n_epochs;
plot(It,SSE,'r-','LineWidth',2)
xlabel('Época')
ylabel('SSE')
title('Função de ativação: Sigmoide')
function [s] = sig(x)
s=1./(1+exp(-x));
end
