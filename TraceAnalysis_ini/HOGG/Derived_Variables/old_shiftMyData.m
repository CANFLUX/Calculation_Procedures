function shiftedData = shiftMyData(clean_tv,originalData,offsetDate,offsetMinutes)
% Time Shift Correction:

% Memo:   Adapted from Tzu-Yi Lu script. Applied to Young and Hogg 
%         sites to fix 1-hour offset from daylight savings

% Revisions:
%
% Feb 4, 2023 (Tzu-Yi)
%    - added memo (details about timestamp lag problem)
%    - removed the 'run_std_dev' part from this script.
% Mar 23, 2023 (Darian)
%    - Altered script inputs to allow specifications for offset date and 
%      number of 30-minute offsets.
%    - Inputs:
%       offsetData: datenum period-end timestamp to be shifted 
%                   e.g. datenum(2021,11,07,03,00,0)
%       offsetMinutes: Number of minutes to be shifted
%                   e.g. 60

offset = offsetMinutes/30; 
tsc=find(clean_tv<=offsetDate); 
if ~isempty(tsc)
    originalData(tsc(1:end-offset)) = originalData(tsc(1+offset:end));
    shiftedData=originalData;
else
    shiftedData=originalData;
end
