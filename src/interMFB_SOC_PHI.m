function [crank_target, MFB_target] = interMFB_SOC_PHI(Cases, SOC_list, SOC_target, Phi_target)
% interMFB_SOC_PHI - Double interpolation of an MFB curve at fixed SOC and phi
%
% Inputs:
%   - Cases       : table containing CaseID, Phi, SOC
%   - SOC_list    : list of available SOC values (e.g., -10:1:10)
%   - SOC_target  : SOC value for final interpolation
%   - Phi_target  : phi value for final interpolation
%
% Outputs:
%   - crank_target : interpolated crank angle vector
%   - MFB_target   : corresponding interpolated MFB curve

    MFB_SOC = cell(1, length(SOC_list));

    for j = 1:length(SOC_list)
        row = Cases(Cases.SOC == SOC_list(j), :);
        case_number = row.CaseID;
        phi_list = zeros(1, length(case_number));
        MFB_all = cell(1, length(case_number));

        for i = 1:length(case_number)
            scriptFolder = pwd;
            filename = sprintf("MFB_case_%d.txt", case_number(i));
            FilePath = fullfile(scriptFolder, 'data', filename);
            MFB_all{i} = readtable(FilePath, 'Delimiter', '	', 'PreserveVariableNames', true);
            phi_list(i) = Cases.Phi(Cases.CaseID == case_number(i));
        end

        [crank_phi, MFB_phi] = interMFB_PHI(MFB_all, Phi_target, phi_list, SOC_list(j));

        MFB_SOC{j} = table(crank_phi', MFB_phi', 'VariableNames', {'crank_angle', 'MFB'});
    end

    [crank_target, MFB_target] = interMFB_SOC_2(MFB_SOC, SOC_target, SOC_list);
end