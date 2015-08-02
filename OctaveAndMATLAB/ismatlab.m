function result = ismatlab()
%ISMATLAB Check if we're in MatLab
%
% Returns 1 if the code is running in MatLab, 0 if not.
%
% Example:
%   if ismatlab()
%     % Do something here that works in MatLab...
%   else
%     % Do something here that works in Octave...
%   end

  result = 0;
  %v = ver;
  
  %for i = 1:length(v)
  %  if ~isempty(find(strcmpi(v(i).Name, 'MATLAB'), 1))
  %    result = 1;
  %    break;
  %  end
  %end
  
  % Faster method...
  if ~isempty(strfind(version, 'R201'))
      result = 1;
  end
end
  
