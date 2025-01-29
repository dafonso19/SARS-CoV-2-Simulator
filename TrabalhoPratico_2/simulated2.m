% Definir a função a ser otimizada
f1 = @(x) 4 .* sin(5 .* pi .* x + 0.5).^6 .* exp(log2((x - 0.8).^2));

% Parâmetros do Simulated Annealing
T = 90;         % Temperatura inicial
nRep = 5;      % Número de repetições para cada valor da temperatura
alfa = 0.95;     % Fator de decaimento para a temperatura

% Amplitude do espaço de pesquisa
range = 1;       % Definir a amplitude do espaço de pesquisa

% Amplitude da perturbação
x_radius = range / 100; % Manter a mesma amplitude usada na subida da colina

% Inicialização aleatória da posição inicial
x_current = rand();

% Inicializar vetores para rastrear as soluções
x_values = [];
y_values = [];
iteration_values = [];
T_values = [];
dE_values = [];
alfa_values = [];
p_values = [];

% Loop principal do Simulated Annealing
for w= 1:500

    for i = 1:nRep
        % Avaliar o valor da função na posição atual
        current_value = f1(x_current);

        % Rastrear os valores da função e as posições
        x_values = [x_values, x_current];
        y_values = [y_values, current_value];
        iteration_values = [iteration_values, (length(iteration_values) + 1)]; % Adicionar iteração
        T_values = [T_values, T];
        
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

        % Calcular a diferença de energia (gradiente)
        dE = f1(new_value) - f1(current_value);
        
        % Calcular a probabilidade de aceitar a nova posição
        p = exp(-abs(dE) / T);

        % Verificar se a nova posição é aceita
        if dE > 0 || rand() < p
            x_current = x_new; % Aceita a nova posição
        end
        
        % Rastrear valores adicionais
        dE_values = [dE_values, dE];
        alfa_values = [alfa_values, alfa];
        p_values = [p_values, p];
    end

    % Decaimento da temperatura
    T = alfa * T;
end

% Exibir o resultado
fprintf('Melhor solução encontrada: x = %.4f, f(x) = %.4f\n', x_current, f1(x_current));

% Gráfico na mesma figura
figure;

% Gráfico 1: f(x) em função das iterações
subplot(3, 2, 1);
plot(iteration_values, y_values, 'm', 'LineWidth', 2);
xlabel('Número de Iterações');
ylabel('f(x)');
title('Evolução de f(x) ao Longo das Iterações');
grid on;

% Gráfico 2: Número de iterações em função da temperatura
subplot(3, 2, 2);
plot(iteration_values, T_values, 'b', 'LineWidth', 2);
xlabel('Número de Iterações');
ylabel('Temperatura (T)');
title('Variação da Temperatura');
grid on;
axis([0 length(T_values) 0 100]);


% Gráfico 3: Número de iterações em função do gradiente de energia (dE)
subplot(3, 2, 3);
plot(iteration_values, dE_values, 'r', 'LineWidth', 2);
xlabel('Número de Iterações');
ylabel('dE');
title('Evolução do Gradiente de Energia(dE)');
ylim([-0.1, 0.1]); % Definir o intervalo no eixo y
grid on;


% Gráfico 4: Número de iterações em função de Alfa (Fator de decaimento para a temperatura)
subplot(3, 2, 4);
plot(iteration_values, alfa_values, 'g', 'LineWidth', 2);
xlabel('Número de Iterações');
ylabel('Alfa');
title('Variação do Fator de Decaimento (alfa)');
grid on;

% Gráfico 5: Número de iterações em função da probabilidade (p)
subplot(3, 2, 5);
plot(iteration_values, p_values, 'c', 'LineWidth', 2);
xlabel('Número de Iterações');
ylabel('Probabilidade (p)');
title('Variação da Probabilidade (p)');
grid on;
xlim([0 length(x_values)]);
ylim([0 1]);

% Gráfico 6: x em função de f(x)
subplot(3, 2, 6);
plot(x_values, y_values, 'b', 'LineWidth', 2);
xlabel('x');
ylabel('f(x)');
title('Evolução de x em Função de f(x)');
grid on;

% Gráfico da função e solução encontrada
figure;
xx=linspace(0,1 , 1000);
plot(xx, f1(xx), 'b', 'LineWidth', 2); % Linha da função
hold on;
scatter(x_values, y_values, 'ro', 'filled'); % Pontos das soluções
plot(x_current, f1(x_current), 'g*', 'MarkerSize', 10); % Melhor solução
xlabel('x');
ylabel('f(x)');
title('Solução do Simulated Annealing para a Função f1');
legend('Função', 'Soluções Encontradas', 'Melhor Solução', 'Location', 'Best');
ylim([0 2.0]);
grid on;
hold off;

