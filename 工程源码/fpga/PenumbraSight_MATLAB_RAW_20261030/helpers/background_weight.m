function [alpha, mode]=background_weight(capture, whichGroup, hasAfter)
if ~hasAfter, alpha=0; mode='single_before_black; no temporal drift correction'; return; end
assert(ismember(whichGroup,{'measurement','white'}));
t0=capture.darkBeforeTime; t1=capture.darkAfterTime;
if strcmp(whichGroup,'measurement'), t=capture.measurementTime; fallback=capture.fallbackMeasurementAlpha;
else, t=capture.whiteTime; fallback=capture.fallbackWhiteAlpha; end
if all(isfinite([t0 t1 t]))
 assert(t1>t0,'Project:CaptureTimes','后黑屏时间应晚于前黑屏。');
 assert(t>=t0 && t<=t1,'Project:UnbracketedCapture','测量时间不在前后黑屏之间，不能无记录地外推背景。');
 alpha=(t-t0)/(t1-t0); mode='capture_time_linear_interpolation';
else
 alpha=fallback; mode='explicit_fallback_weight; actual times not provided';
 warning('Project:UnknownCaptureTimes','未提供完整采集时间，%s背景使用配置权重%.3f。',whichGroup,alpha);
end
assert(isscalar(alpha) && isfinite(alpha) && alpha>=0 && alpha<=1);
end
