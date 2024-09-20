
% Define material properties
mat_props = {
    'Low carbon steel', 7e6, 240, 179;  % Ferromagnetic mild steel, e.g., 1018
    '416 stainless', 1.7e6, 800, 500;   % Martensitic stainless steel
    '304 stainless', 1.4e6, 1, 1;       % Austenitic stainless steel (paramagnetic)
    '6061 aluminum', 3.8e7, 1, 1;       % Non-magnetic material
    'Titanium', 2.4e6, 1, 1;            % Non-magnetic material
    'Copper', 5.8e7, 1, 1;              % High conductivity, non-magnetic material
    };

% Frequency values
frequencies = [300, 10e3];  % Frequencies in Hz

% Constants
mu_0 = 4 * pi * 1e-7;  % Permeability of free space (H/m)

% Initialize arrays for storing skin depth
skin_depth_300Hz = zeros(size(mat_props, 1), 1);
skin_depth_10kHz = zeros(size(mat_props, 1), 1);

% Loop through each material and calculate skin depth at 300 Hz and 10 kHz
for i = 1:size(mat_props, 1)
    conductivity = mat_props{i, 2};  % Conductivity (S/m)
    mu_300Hz = mu_0 * mat_props{i, 3};  % Permeability at 300 Hz
    mu_10kHz = mu_0 * mat_props{i, 4};  % Permeability at 10 kHz
    
    % Calculate skin depth at 300 Hz
    skin_depth_300Hz(i) = sqrt(2 / (2 * pi * frequencies(1) * mu_300Hz * conductivity));
    
    % Calculate skin depth at 10 kHz
    skin_depth_10kHz(i) = sqrt(2 / (2 * pi * frequencies(2) * mu_10kHz * conductivity));
end

% Create table
materials_table = table(mat_props(:,1), skin_depth_300Hz, skin_depth_10kHz, ...
    'VariableNames', {'Material', 'SkinDepth_300Hz_m', 'SkinDepth_10kHz_m'});

% Display the table
format short e
disp(materials_table);
