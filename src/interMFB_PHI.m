function [crank_target, MFB_target] = interMFB_PHI(MFB_all, phi_target, phi_list, SOC)
    % interMFB_PHI - Double interpolation of an MFB curve at fixed SOC and phi
    %
    % Description:
    %   Performs interpolation of MFB curves at fixed SOC by applying a
    %   horizontal translation (crank angle shift), then interpolates
    %   across different phi values to obtain the target MFB curve.
    %
    % Inputs:
    %   - MFB_all    : cell array containing MFB tables for each phi
    %   - phi_target : target phi value for interpolation
    %   - phi_list   : list of available phi values
    %   - SOC        : Start of Combustion used for horizontal translation
    %
    % Outputs:
    %   - crank_target : interpolated crank angle vector
    %   - MFB_target   : corresponding interpolated MFB curve

    % === Interpolation on crank angle at fixed MFB (horizontal translation) ===
    % === Interpolation on crank angle at fixed MFB (horizontal translation) ===
    MFB_ref = linspace(0, 1, 1000);  % 1000 MFB points from 0 to 1
    crank_interp_matrix = zeros(length(phi_list), length(MFB_ref));
    
    for i = 1:length(phi_list)
        crank = MFB_all{i}{:,1} + SOC;  % curve translation at fixed SOC
        MFB = MFB_all{i}{:,2};
    
        % Remove duplicates before interpolation
        [MFB_clean, idx_unique] = unique(MFB, 'stable');
        crank_clean = crank(idx_unique);
    
        crank_interp_matrix(i,:) = interp1(MFB_clean, crank_clean, MFB_ref, 'linear', 'extrap');
    end
    
    % Final interpolation at phi_target
    crank_target_full = interp1(phi_list, crank_interp_matrix, phi_target, 'linear');
    MFB_ref_full = MFB_ref;
    
    % Restrict crank_target to the range [SOC, 130]
    valid_idx = crank_target_full >= SOC & crank_target_full <= 130;
    crank_target = crank_target_full(valid_idx);
    MFB_target = MFB_ref_full(valid_idx);
end