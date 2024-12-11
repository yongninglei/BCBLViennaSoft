function GetEDFDataFile(edfFile,EDFLocalFilename)

% End of Experiment; close the file first
% close graphics window, close data file and shut down tracker

Eyelink('Command', 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');

% download data file


try
    fprintf('Receiving data file ''%s''\n', edfFile );
    %status=Eyelink('ReceiveFile');
    % Eyelink('ReceiveFile', [], fullfile(dst_dir,newName), 0);
    status=Eyelink('ReceiveFile','',[EDFLocalFilename '.edf'],0);
    if status > 0
        fprintf('ReceiveFile status %d\n', status);
    end
    if 2==exist(edfFile, 'file')
        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
    end
catch
    fprintf('Problem receiving data file ''%s''\n', edfFile );
end

% Convert data file

EDFStruct=edfmex(EDFLocalFilename);

save([EDFLocalFilename,'.mat'],'EDFStruct');

end