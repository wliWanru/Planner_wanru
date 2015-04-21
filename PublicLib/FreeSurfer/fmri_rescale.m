function [ypost, oldmean] = fmri_rescale(ypre,newmean,TPExclude)
% [ypost oldmean] = fmri_rescale(ypre,newmean,TPExclude)
%
% Rescales slices on a run-by-run basis.  The scaling factor for each
% run is f = newmean/mean(run) where mean(run) is the mean computed
% over all voxels at all time-points (ie, the global mean for the run).
% This forces the global mean to be the same for all runs.
% The oldmean for each slice is returned.
% If TPExclude is passed as an argument, data points that correspond
% to TPExclude==1 are ignored.  They are replaced with newmean in
% ypost.  The dimensions of TPExclude should be nTP by nRuns.
%
% Comments or questions: analysis-bugs@nmr.mgh.harvard.edu
%
% $Id: fmri_rescale.m,v 1.1 2003/03/04 20:47:40 greve Exp $

if(nargin ~= 2 & nargin ~= 3)
  msg = 'USAGE: [ypost, oldmean] = fmri_rescale(ypre,newmean,<TPExclude>)';
  qoe(msg);  error(msg);
end

%% Get dimensions of functional slices
[nRows nCols nTP nRuns] = size(ypre);

if(nargin == 3)
  if(size(TPExclude,1) ~= nTP)
    msg = 'ypre and TPExclude differ in the number of time points';
    qoe(msg);  error(msg);
  elseif(size(TPExclude,2) ~= nRuns)
    msg = 'ypre and TPExclude differ in the number of runs';
    qoe(msg);  error(msg);
  end
end

%% Set all of the outputs to be the new mean %%%
ypost = newmean*ones(size(ypre));

%% Go through each run %%%
for r = 1:nRuns,

  if(nargin == 3) % Use exclusions %
    iTPInclude = find(TPExclude(:,r)==0);
    oldmean(r) = mean(reshape1d(ypre(:,:,iTPInclude,r)));
    ypost(:,:,iTPInclude,r) = (newmean/oldmean(r))*ypre(:,:,iTPInclude,r);

  else % Dont use exclusions %
    oldmean(r) = mean(reshape1d(ypre(:,:,:,r)));
    ypost(:,:,:,r) = (newmean/oldmean(r))*ypre(:,:,:,r);
  end

end

return;