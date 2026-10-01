% This script fixes a problem that appeared in BB1 Flux data 
% During two time periods the SmartFlux seems to have lost it's
% clock synchronisation. That introduced a time-shift in the EC data.
% This function fixes that issue
%
% Zoran Nesic               File created:       Sep 29, 2026
%                           Last modification:  Sep 29, 2026


% Do the shift only for 2023, return for any other year
if year(trace_str(1).timeVector(1)) ~= 2023
    return
end

% for this to work properly all the data needs to be
% loaded up in trace_str. That means that this function
% should be called at the end of the FirstStage.ini file
% Check if that's the case:
N = length(trace_str);

% the name of this script.
fName = mfilename;
for thisTraceN = 1:N
    if isfield(trace_str(thisTraceN).ini,'Evaluate1')
        if strcmp(trace_str(thisTraceN).ini.Evaluate1,fName)
            break;
        end
    end
end
if thisTraceN ~= N
    fprintf(2,'Warning: the call to %s should be at the end of the ini file!\n',fName)
end

% Create indexes of points that need to be shifted to the *left* 
% Adapt if shift to the right is needed.

% First period that requires the shift
dataType = 'Flux';
tv_dt = datetime(trace_str(1).timeVector,'ConvertFrom','datenum');
indShift = find(tv_dt>= "Jul 21, 2023" & tv_dt <= "Aug 22, 2023 10:30 AM");
timeShiftHHours = 19;
trace_str = shiftLeftTraceStr(trace_str,indShift,timeShiftHHours,dataType,thisTraceN);

% Second period that requires the shift
indShift = find(tv_dt>= "Mar 29, 2023 1:00 AM" & tv_dt <= "Apr 14, 2023 01:00 PM");
timeShiftHHours = 21;
trace_str = shiftLeftTraceStr(trace_str,indShift,timeShiftHHours,dataType,thisTraceN);

return

%==============================
% Helper functions

function trace_str = shiftLeftTraceStr(trace_str,indShift,timeShiftHHours,dataType,thisTraceN)
% Inputs
%   trace_str       - data structure with all the trace data and ini info
%   indShift        - index of the points tha need to be shifted
%   timeShiftHHours - the number of 30-min periods to shift
%   dataType        - 'Met', 'Flux' or such. Same as property "measurementType" in ini files
%   thisTraceN      - the location of the trace (traces_str(thisTraceN)) that called this script. Not to be shifted. 

    nTraces = length(trace_str);
    currentYear = year(trace_str(1).timeVector(1));
    for cntTraces = 1:nTraces       
        % shift only the data of the same type ('Flux','Met',...)
        if strcmpi(trace_str(cntTraces).ini.measurementType,dataType) & cntTraces ~= thisTraceN
            % check if current trace_str is of TimeVector/clean_tv type (datanum -type) 
            % and skip if it is.
            if year(trace_str(cntTraces).data(1)) ~= currentYear
                dataIn = trace_str(cntTraces).data;
                data_shifted = dataIn;
                data_shifted(indShift-timeShiftHHours) = data_shifted(indShift);
                data_shifted(indShift(end) - (0:(timeShiftHHours-1))) = NaN;
                trace_str(cntTraces).data = data_shifted;
            end
        end
    end
end


