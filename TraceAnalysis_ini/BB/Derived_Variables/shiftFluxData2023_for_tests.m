%function trace_str = shiftFluxData2023(trace_str)

%% This flag is used only for testing
flagFirstTime = true;
% if the user puts a break point on "return"
% this section can be executed many times
% and this section here assures that the trace_str
% always resets to original. 
% Kept it here for educational purposes - can be removed
if flagFirstTime
    trace_backup = trace_str;
    flagFirstTime = false;
else
    trace_str = trace_backup;
end

fName = mfilename;
% Do the shift only for 2023
if year(trace_str(1).timeVector(1)) ~= 2023
    return
end

% for this to work properly all the data needs to be
% loaded up in trace_str. That means that this function
% should be called at the end of the FirstStage.ini file
% Check:
N = length(trace_str);

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

% Create indexes of points that need to be shifted *left* 
% Here the program does the shift *left*. Adapt if shift right is needed.

dataType = 'Flux';
tv_dt = datetime(trace_str(1).timeVector,'ConvertFrom','datenum');
indShift = find(tv_dt>= "Jul 21, 2023" & tv_dt <= "Aug 22, 2023 10:30 AM");
timeShiftHHours = 19;
%timeShiftHHours = 15;
trace_str = shiftLeftTraceStr(trace_str,indShift,timeShiftHHours,dataType,thisTraceN);

indShift = find(tv_dt>= "Mar 29, 2023 1:00 AM" & tv_dt <= "Apr 14, 2023 01:00 PM");
timeShiftHHours = 21;
trace_str = shiftLeftTraceStr(trace_str,indShift,timeShiftHHours,dataType,thisTraceN);

% make it "false" to remove plotting. 
if 1==1

    cntTrace = 44; % H
    %cntTrace = 68; % T_SONIC
    
    oldData = trace_str(cntTrace).data_old;
    newData = trace_str(cntTrace).data;
    figure(10)
    subplot(2,1,2)
    plot(tv_dt,newData-oldData,'.')
    ax(1) = gca;
    ylim([-10 10])
    title([trace_str(cntTrace).variableName '  (after-before)'])
    zoom on
    
    subplot(2,1,1)
    plot(tv_dt,newData,tv_dt,oldData,'o')
    title(trace_str(cntTrace).variableName)
    ax(2)= gca;
    legend('shifted','original')
    zoom on
    
    figure(11)
    TA = trace_str(2).data;
    airT = trace_str(68).data-273.15;
    plot(tv_dt,TA,'o',tv_dt,airT,'x')
    ax(3)= gca;
    legend('MET_T','Sonic_T shifted')
    
    zoom on
    
    linkaxes(ax,'x')
end
%%
return



% Helper functions


function trace_str = shiftLeftTraceStr(trace_str,indShift,timeShiftHHours,dataType,thisTraceN)
    nTraces = length(trace_str);
    currentYear = year(trace_str(1).timeVector(1));
    for cntTraces = 1:nTraces       
        % shift only the data of the same type ('Flux','Met',...)
        if strcmpi(trace_str(cntTraces).ini.measurementType,dataType) & cntTraces ~= thisTraceN
            % check if current trace_str is of TimeVector and skip if it is
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


