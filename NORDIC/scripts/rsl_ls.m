function filesout = rsl_ls( str, prefix, suffix )
% function filesout = rsl_ls( str[, prefix][, suffix] )
%
%    prefix can be a string or TRUE for fullpath
%
    if nargin < 3
        suffix = '';
    end
    if nargin < 2
        prefix = '';
    else
        if prefix == 1
            prefix = strrep( str, regexprep(str, '^.*/', ''), '' );
        end
    end
    if nargin < 1
        str = '.';
    end
    
    
    
    files = dir(str);
    filesout = {};
    if length(files) < 1
        display('File list is empty.')
        dir(str)
    end
    
    for i = 1:length(files)
        if ~strcmp( files( i ).name(1), '.' )
            filesout{end+1} = sprintf( '%s%s%s', prefix, files( i ).name, suffix );
        end
    end
    
end