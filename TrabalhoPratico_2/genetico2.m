% Parâmetros
pop_size = 6;
lchrome = 12;
gen = 0;
maxgen = 80;
p_cross = 0.8;
p_mut = 0.04;
x_radius = 1/20;

% Função de aptidão
f1 = @(x) 4 .* sin(5 .* pi .* x + 0.5).^6 .* exp(log2((x - 0.8).^2));

% Função para converter binário para decimal
bin2dec = @(bin) sum(bin .* 2.^(numel(bin)-1:-1:0));

% Inicialização da população (robôs)
CHROME = randi([0 1], pop_size, lchrome);
POP = zeros(pop_size, 1);

% Avaliação da aptidão
for i = 1:pop_size
    x = bin2dec(CHROME(i, :)) / (2^lchrome - 1);
    POP(i) = f1(x);
end

% Evolução
max_values = zeros(maxgen, 1);
average_values = zeros(maxgen, 1);
for gen = 1:maxgen
    % Seleção (troca de informações entre robôs)
    POP_norm = POP / sum(POP);
    parents = zeros(2*pop_size, 1);
    for i = 1:2*pop_size
        parents(i) = find(rand <= cumsum(POP_norm), 1);
    end
    
    % Cruzamento
    offspring = zeros(2*pop_size, lchrome);
    for i = 1:2:2*pop_size
        if rand < p_cross
            cross_point = randi([1 lchrome]);
            offspring(i, 1:cross_point) = CHROME(parents(i), 1:cross_point);
            offspring(i, cross_point+1:end) = CHROME(parents(i+1), cross_point+1:end);
            offspring(i+1, 1:cross_point) = CHROME(parents(i+1), 1:cross_point);
            offspring(i+1, cross_point+1:end) = CHROME(parents(i), cross_point+1:end);
        else
            offspring(i, :) = CHROME(parents(i), :);
            offspring(i+1, :) = CHROME(parents(i+1), :);
        end
    end
    
    % Mutação
    for i = 1:2*pop_size
        for j = 1:lchrome
            if rand < p_mut
                offspring(i, j) = 1 - offspring(i, j);
            end
        end
    end
    
    % Avaliação da aptidão
    POP_new = zeros(2*pop_size, 1);
    for i = 1:2*pop_size
        x = bin2dec(offspring(i, :)) / (2^lchrome - 1);
        POP_new(i) = f1(x);
    end
    
    % Seleção dos melhores
    [~, best] = maxk(POP_new, pop_size);
    CHROME = offspring(best, :);
    POP = POP_new(best);
    
    % Armazenamento dos valores para plotagem
    max_values(gen) = max(POP);
    average_values(gen) = mean(POP);
end

% Plotagem dos resultados
figure;
plot(max_values, 'LineWidth', 2); hold on;
plot(average_values, 'LineWidth', 2);
legend('Max Value', 'Average Value');
xlabel('Geração'); 
ylabel('Valor');  
title('Evolução dos Valores Máximo e Médio ao Longo das Gerações'); 
grid on;



% Subplot para a função de aptidão
figure;

% Grafico 1: Função de aptidão
subplot(2, 2, 1);
x = linspace(0, 1, 100);
y = f1(x);
plot(x, y, 'LineWidth', 2); hold on;
x_values = arrayfun(@(i) bin2dec(CHROME(i, :)) / (2^lchrome - 1), 1:pop_size);
scatter(x_values, POP, 'r', 'filled');
xlabel('x');
ylabel('f1(x)');
title('Função de Aptidão e Distribuição dos Valores de x');
grid on;

% Grafico 2: Histograma da Aptidão Final
subplot(2, 2, 2);
x_values_histogram = arrayfun(@(i) bin2dec(CHROME(i, :)) / (2^lchrome - 1), 1:pop_size);
histogram(x_values_histogram, 'Normalization', 'probability');
xlabel('x');
ylabel('Probabilidade');
title('Distribuição dos Valores de x na População Final');
grid on;


% Gráfico 4: Gráfico de Convergência
subplot(2, 2, 3); 
plot(max_values, 'LineWidth', 2);
xlabel('Geração');
ylabel('Melhor Aptidão');
title('Convergência do Algoritmo Genético');
grid on;

% Calcula x_values_final antes de plotar
x_values_final = arrayfun(@(i) bin2dec(CHROME(i, :)) / (2^lchrome - 1), 1:pop_size);


% Gráfico 5: Histograma da Aptidão Final
subplot(2, 2, 4); 
histogram(POP, 'Normalization', 'probability');
xlabel('Aptidão');
ylabel('Probabilidade');
title('Histograma da Aptidão na População Final');
grid on;