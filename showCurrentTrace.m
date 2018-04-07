function showCurrentTrace(varargin)

global TraceColor signal TraceToShow
if isempty(signal);return;end

figure;
a=axes;
hold(a,'on');
for j=[1 TraceToShow]
    plot(a,signal{j},'color',TraceColor{j});
end
hold(a,'off');