% MATLAB Code for Visualizing Quantized Data

% Your data vector (replace with your actual data)

data = odata;
data(data > 0.2) = [];

% 1. Sort the data
sorted_data = sort(data);

% 2. Plot the sorted data points
figure(2);
plot(sorted_data, 'o-', 'LineWidth', 1.5);
title('Sorted Data Points');
xlabel('Index');
ylabel('Data Value');
grid on;

% 3. Compute differences between successive data points
differences = diff(sorted_data);

% 4. Plot the differences between successive data points
figure(3);
plot(differences, 's-', 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
title('Differences Between Successive Data Points');
xlabel('Index');
ylabel('Difference Value');
grid on;

% 5. Plot histogram of the data points
figure(4);
histogram(sorted_data, 'BinWidth', 1e-3); % Set BinWidth smaller than expected quantization step
title('Histogram of Data Values');
xlabel('Data Value');
ylabel('Frequency');
grid on;

% 6. Plot histogram of the differences
figure(5);
histogram(differences, 'BinMethod', 'auto');
title('Histogram of Differences');
xlabel('Difference Value');
ylabel('Frequency');
grid on;

% Optional: Adjust the BinWidth in the histogram of differences for better resolution
% histogram(differences, 'BinWidth', ...);

% 7. Display basic statistics
mean_difference = mean(differences);
std_difference = std(differences);
fprintf('Mean of differences: %f\n', mean_difference);
fprintf('Standard deviation of differences: %f\n', std_difference);
