function plot_poincare_sphere(s2, s3, s4, color)
    % Plot input data
    plot3(s2, s3, s4, 'o', 'MarkerSize', 10, 'MarkerEdgeColor', color, 'MarkerFaceColor', color)
    hold on

    % Create and plot the Poincare sphere
    [x, y, z] = sphere;
    surf(x, y, z, 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'FaceColor', [0, 0, 1]);
    hold on

    % Equator of the sphere
    plot3(x(z == 0), y(z == 0), z(z == 0), 'k--', 'LineWidth', 2)

    % Set axis properties
    axis equal
    grid on

    % Define polarization states on the Poincare sphere
    polarization_states = [
        1, 0, 0;  % Horizontal polarization (H)
        -1, 0, 0; % Vertical polarization (V)
        0, 1, 0;  % Diagonal polarization (D)
        0, -1, 0; % Anti-diagonal polarization (A)
        0, 0, 1;  % Right circular polarization (R)
        0, 0, -1; % Left circular polarization (L)
    ];

    % Labels for the polarization states
    labels = {'H', 'V', 'D', 'A', 'R', 'L'};

    % Plot arrows for each polarization state
    for i = 1:size(polarization_states, 1)
        state = polarization_states(i, :);
        % Draw the arrow
        quiver3(0, 0, 0, state(1), state(2), state(3), 'k--', 'MaxHeadSize', 0.5, 'AutoScale', 'off', 'LineWidth', 1.5);
        % Add the label
        text(state(1) * 1.3, state(2) * 1.3, state(3) * 1.3, labels{i}, 'FontSize', 10, 'HorizontalAlignment', 'center');
    end

    % Plot vertical circle (through North and South poles)
    theta = linspace(0, 2 * pi, 100);
    x_eq = cos(theta);
    y_eq = zeros(size(theta));
    z_eq = sin(theta);
    plot3(x_eq, y_eq, z_eq, 'k--', 'LineWidth', 1.5);

    % Hold off to prevent further plotting on the same figure
    % hold off
end
