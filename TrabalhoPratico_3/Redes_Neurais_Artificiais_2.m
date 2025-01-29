% Conjunto de dados
K = 40;

% Importa dados
Data_multi

% Visualização das Classes
A = X_A';
B = X_B';
C = X_C';

% A : square - s
plot(A(1,:), A(2,:), 'bs')
grid on
hold on

% B : +
plot(B(1,:),B(2,:), 'r+')

% C: o
plot(C(1,:),C(2,:), 'ko')
hold off

% W1: 4x3
W1 = 2 * rand(4,3) - 1;

% W2: 5(=4+bias)x3
W2 = 2 * rand(3,5) - 1;

% Bias=+1
bias_A = ones(K,1);

% Adiciona o vetor de bias ao conjunto A
X_A = [X_A, bias_A];
% Conjunto  de saida da classe A
T_A = ones(K,3) .*[1 0 0];

bias_B = ones(K,1);

% Adiciona o vetor de bias ao conjunto B
X_B = [X_B,bias_B];
% Conjunto  de saida da classe B
T_B = ones(K, 3) .* [0 1 0];

% Adiciona o vetor de bias ao conjunto C
bias_C = ones(K,1);
X_C=[X_C, bias_C];

% Conjunto  de saida da classe C
T_C = ones(K,3) .* [0 0 1];

% Concatenação dos três vetores de entrada
X = [ X_A;
      X_B; 
      X_C];
%Concatenação dos três vetores de saida
T = [ T_A; 
      T_B; 
      T_C];

% ------------------------------------

N= 3 * K;                    % Número de total de amostras
n_epochs = 10000;            % Número de épocas
SSE = zeros(1, n_epochs);    % Inicialização da soma do erro quadrático
alpha = 0.9;                 % Taxa de aprendizagem

for epoch = 1:n_epochs
    sum_sq_error=0;
    for k = 1:N
        x = X(k, :)';
        t = T(k, :)';

        % Soma da camada de entrada
        g1 = W1 * x;
        % Saida da camada de entrada
        y1 = sig(g1);

        % Com bias na camada escondida
        y1_b = [y1
                1];
        
        % Soma da camada de saida
        g2 = W2 * y1_b;
        % Saida da camada de saida
        y2 = sig(g2);
        % Erro da camada de saida
        e = t - y2;
        % Delta da camada de saida
        delta2 = y2.*(1-y2).*e;

        % Atualização do SSE
        sum_sq_error = sum_sq_error + sum(e.^2);

        % Erro da camada escondida
        e1 = W2' * delta2;
        % Tirando o bias
        e1_b = e1(1:4);

        % Atualização dos pesos
        dW2 = alpha * delta2 * y1_b';
        W2 = W2 + dW2;

        delta1 = y1 .* (1-y1) .* e1_b;

        dW1 = alpha * delta1 * x';
        W1 = W1 + dW1;
    end
    SSE(epoch) = (sum_sq_error) / N;
    fprintf(1, 'E = %d\t SSE = %3.6f\n', epoch, SSE(epoch));
end
y_plot = zeros(N,3);


% Teste da RN
for k=1:N
    x = X(k,:)';
    g1 = W1 * x;
    % Sigmoide
    y1 = sig(g1);
    % y1 adiciona com entrada de bias
    y1_b = [y1
            1];
    %Soma e saida
    g2 = W2 * y1_b;
    y2 = sig(g2);
    %gráfico
    y_plot(k,:) = y2;
end

% Limite para a classificação
limite = 0.9;
y_bin = y_plot > limite

X_teste_with_bias = [X_teste, ones(size(X_teste, 1), 1)]; % Add bias to X_teste

y_test = zeros(size(X_teste, 1), 3);

for i = 1:size(X_teste_with_bias, 1)
    x_test = X_teste_with_bias(i, :)';

    % Forward pass
    g1_test = W1 * x_test;
    y1_test = sig(g1_test);

    y1_b_test = [y1_test; 1];

    g2_test = W2 * y1_b_test;
    y2_test = sig(g2_test);

    y_test(i, :) = y2_test;

   
end


figure;

% Adiciona pontos das classes A, B e C
plot(A(1,:), A(2,:), 'bs');
grid on;
hold on;
plot(B(1,:), B(2,:), 'r+');
plot(C(1,:), C(2,:), 'ko');

% Adiciona pontos de teste com diferentes marcadores para cada classe
for i = 1:size(X_teste, 1)
    if y_test(i, 1) >= 0.5
        scatter(X_teste(i, 1), X_teste(i, 2), 100, 'b', 'd', 'filled');
    elseif y_test(i, 2) >= 0.5
        scatter(X_teste(i, 1), X_teste(i, 2), 100, 'r', 'd', 'filled');
    elseif y_test(i, 3) >= 0.5
        scatter(X_teste(i, 1), X_teste(i, 2), 100, 'k', 'd', 'filled');
    end
end


text(mean(A(1,:)), max(A(2,:)), 'Classe A', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')
text(mean(B(1,:)), max(B(2,:)), 'Classe B', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')
text(mean(C(1,:)), max(C(2,:)), 'Classe C', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')


title('Resultado do Teste');
legend('Clasee A', 'Classe B', 'Classe C');
hold off;


figure
It=1:1:n_epochs;
plot(It,SSE,'r-','LineWidth', 2)
xlabel('Época')
ylabel('SSE')
title('Função de ativação : Sigmóide')

function [s] = sig(x)
    s=1./(1+exp(-x));
end