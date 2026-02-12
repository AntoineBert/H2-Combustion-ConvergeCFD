function [crank_target, MFB_target] = interMFB_SOC(MFB_all, SOC_target, SOC_list)
    % interMFB_SOC - Interpolation of an MFB curve as a function of SOC
    %
    % Description:
    %   Performs interpolation of MFB curves at fixed MFB values by applying
    %   a horizontal translation in crank angle, then interpolates across
    %   different SOC values to obtain the target MFB curve.
    %
    % Inputs:
    %   - MFB_all    : cell array containing MFB tables for each SOC
    %   - SOC_target : target SOC value for interpolation
    %   - SOC_list   : list of available SOC values
    %
    % Outputs:
    %   - crank_target : interpolated crank angle vector
    %   - MFB_target   : corresponding interpolated MFB curve

    % === Interpolation on crank angle at fixed MFB (horizontal translation) ===
    MFB_ref = linspace(0, 1, 1000);  % 1000 MFB points from 0 to 1
    crank_interp_matrix = zeros(length(SOC_list), length(MFB_ref));
    
    for i = 1:length(SOC_list)
        crank = MFB_all{i}{:,1} - 10;
        MFB = MFB_all{i}{:,2};
        
        % Remove duplicates in MFB to avoid interpolation errors
        [MFB_clean, idx_unique] = unique(MFB, 'stable');
        crank_clean = crank(idx_unique);
        
        % Interpolation without error
        crank_interp_matrix(i,:) = interp1(MFB_clean, crank_clean, MFB_ref, 'linear', 'extrap');
    end
    
    crank_target_full = interp1(SOC_list, crank_interp_matrix, SOC_target, 'linear');
    MFB_ref_full = MFB_ref;
    
    % Restrict crank_target to the range [SOC_target, 130]
    valid_idx = crank_target_full >= SOC_target & crank_target_full <= 130;
    crank_target = crank_target_full(valid_idx);
    MFB_target = MFB_ref_full(valid_idx);
end