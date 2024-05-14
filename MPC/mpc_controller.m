function u = mpc_controller(x, MPCparams)
    % Inputs:
    % x:            observer state at current time [nx x 1]
    % MPCparams:    struct with all offline MPC calculations
    %
    % Outputs:
    % u:            optimal input at current time [1 x 1]
    
    % Initialize u
    u = zeros(1,1);

    % Compute linear part of cost function (dependent on x0)
    f_i = MPCparams.CostMatrices.f * x;

    % Compute bound vector on u (dependent on x0)
    b_i = [MPCparams.Bounds.bx - MPCparams.Bounds.Ax * MPCparams.PredMatrices.T * x; MPCparams.Bounds.bu];
    
    % Do the optimization
    %coder.extrinsic('quadprog');
    [u_opt, ~, exitflag, ~] = quadprog(MPCparams.CostMatrices.H, f_i, MPCparams.Bounds.A, b_i, [], [], [], [], zeros(size(f_i)), optimoptions('quadprog', Display='off', Algorithm='active-set'));

    if exitflag ~= 1
        disp("WARNING: exitflag = " + exitflag);
    end

    u = u_opt(1);

end