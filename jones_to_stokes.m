function stokes = jones_to_stokes(jones)
    N = size(jones,2);
    Ax = abs(jones(1,:));
    Ay = abs(jones(2,:));
    % delta = angle(jones(2,:))-angle(jones(1,:));           % delta_y-delta_x for mode 1
    
    % stoke vectors for the first mode 
    stokes = zeros(4, N);
    stokes(1,:) = (Ax.^2)+(Ay.^2);
    stokes(2,:) = (Ax.^2)-(Ay.^2);
    stokes(3,:) = 2*real(Ax.*conj(Ay));
    stokes(4,:) = -2*imag(Ax.*conj(Ay));
    stokes = stokes ./ stokes(1,:);
end