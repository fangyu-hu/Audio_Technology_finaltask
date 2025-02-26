function frames = myenframe(signal, frameLen, frameStep, win, flag)  
% enframe 分割一维信号为重叠帧  
%   INPUTS:  
%       signal - 输入的一维信号  
%       frameLen - 每帧的长度  
%       frameStep - 帧之间的步长（或称为帧移）  
%       win - 可选的窗函数，应与frameLen等长。如果为空，则使用矩形窗（即不应用窗函数）  
%       flag - 字符串，可选参数，'nodelay'表示不延迟第一帧的开始（默认会延迟frameStep/2）  
%  
%   OUTPUTS:  
%       frames - 一个二维数组，其中包含了分割后的帧  
  
    if nargin < 4  
        win = ones(frameLen, 1); % 默认使用矩形窗  
    end  
    if nargin < 5  
        flag = ''; % 默认不使用'nodelay'  
    end  
  
    % 确保窗函数与帧长匹配  
    if length(win) ~= frameLen  
        error('窗函数的长度必须与帧长相等');  
    end  
  
    % 计算总帧数  
    numFrames = floor((length(signal) - frameLen) / frameStep) + 1;  
  
    % 初始化帧矩阵  
    frames = zeros(frameLen, numFrames);  
  
    % 如果没有指定'nodelay'，则调整起始索引以进行居中处理（可选）  
    if strcmp(flag, 'nodelay')  
        idx = 1:frameStep:length(signal)-frameLen+1;  
    else  
        % 计算起始索引以进行居中（如果可能的话）  
        startIdx = ceil((frameStep - frameLen + 1) / 2);  
        endIdx = startIdx + (numFrames-1)*frameStep;  
        if endIdx + frameLen - 1 > length(signal)  
            warning('信号长度不足以进行完全居中，将使用非居中模式');  
            idx = 1:frameStep:length(signal)-frameLen+1;  
        else  
            idx = startIdx:frameStep:endIdx;  
        end  
    end  
  
    % 填充帧矩阵  
    for k = 1:numFrames  
        frames(:, k) = win .* signal(idx(k):idx(k)+frameLen-1);  
    end  
end