function [u] = mpc_controller(x_out, MPCparams)
    
    % Do observer..

    
    % Do OTS for reference tracking (of 0)


    % Compute linear part of cost function (dependent on x0)
    f_i = MPCparams.CostMatrices.f * x;

    % Compute bound vector on u (dependent on x0)
    b_i = [MPCparams.Bounds.bx - MPCparams.Bounds.Ax * MPCparams.PredMatrices.T * x; MPCparams.Bounds.bu];

end