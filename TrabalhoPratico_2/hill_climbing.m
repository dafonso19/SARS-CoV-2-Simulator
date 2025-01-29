% Definir a função a ser otimizada
f1 = @(x) 4 .* sin(5 .* pi .* x + 0.5).^6 .* exp(log2((x - 0.8).^2));

% Parâmetros
range = 1; % Amplitude do espaço de pesquisa
x_radius = range / 20   ; % Raio de vizinhança
num_iterations = 480; % Número de iterações
    
% Inicialização aleatória da posição inicial do robô
x_current = rand(); % Inicializa aleatoriamente entre 0 e 1

% Vetores para armazenar histórico
x_history = zeros(1, num_iterations);
y_history = zeros(1, num_iterations);

% Valores de máximo local e global
local_maximum = -inf; % Inicializado com infinito negativo
global_maximum = -inf; % Inicializado com infinito negativo

% Loop principal
for iteration = 1:num_iterations
    % Avaliar o valor da função na posição atual
    current_value = f1(x_current);
    
    % Atualizar o máximo local
    if current_value > local_maximum
        local_maximum = current_value;
    end
    
    % Atualizar o máximo global
    if current_value > global_maximum
        global_maximum = current_value;
        x_maximum = x_current; % Armazenar o valor de x no máximo global
    end
    
    % Armazenar histórico
    x_history(iteration) = x_current;
    y_history(iteration) = current_value;
    
    % Gerar uma nova posição na vizinhança
    x_new = x_current + x_radius * (2 * rand() - 1);
    
    % Verificar se a nova posição está dentro do intervalo permitido
    if x_new < 0
        x_new = 0;
    elseif x_new > 1
        x_new = 1;
    end

    % Avaliar o valor da função na nova posição
    new_value = f1(x_new);
    
    % Verificar se a nova posição é melhor ou igual à atual
    if new_value >= current_value
        x_current = x_new; % Move-se para a nova posição
    end
end

fprintf('Melhor solução encontrada: x = %.4f, f(x) = %.4f\n', x_maximum, global_maximum);

% Plotar o gráfico
x_values = linspace(0, 1, 1000);
y_values = f1(x_values);

figure;
plot(x_values, y_values, 'b', 'LineWidth', 2);
hold on;
scatter(x_history, y_history, 'ro', 'filled');
plot(x_maximum, global_maximum, 'g*', 'MarkerSize', 10);
xlabel('x');
ylabel('f(x)');
title('Subida da Colina (Hill Climbing)');
legend('Função f(x)', 'Hill climbers', 'Achieved Maximum', 'Location', 'NorthEast');
grid on;

% Gráfico de x em função das iterações
figure;
subplot(2, 1, 1);
plot(1:num_iterations, x_history, 'b', 'LineWidth', 2);
hold on;
plot(num_iterations, x_maximum, 'g*', 'MarkerSize', 10);
xlabel('Número de Iterações');
ylabel('x');
title('Evolução de x ao Longo das Iterações');
legend('x Achieved', 'x Maximum', 'Location', 'SouthEast');
grid on;

% Gráfico de y em função das iterações
subplot(2, 1, 2);
plot(1:num_iterations, y_history, 'm', 'LineWidth', 2);
hold on;
plot(num_iterations, global_maximum, 'c*', 'MarkerSize', 10);
xlabel('Número de Iterações');
ylabel('f(x)');
title('Evolução de f(x) ao Longo das Iterações');
legend('f(x) Achieved', 'f(x) Maximum', 'Location', 'SouthEast');
grid on;

hold off;
