[signal, Fs] = audioread('池頼広 - オフェンスⅠ (进攻I).mp3'); % 替换为你的音频文件名  
if size(signal, 2) > 1  
    signal = mean(signal, 2); % 转换为单声道  
end

frameLen = round(0.025 * Fs); % 帧长，25ms  
frameStep = round(0.01 * Fs); % 帧移，10ms  
win = hamming(frameLen); % 使用汉明窗  
frames = myenframe(signal, frameLen, frameStep, win, 'nodelay');

minLag = 10; % 最小延迟（避免计算太近的样本）  
maxLag = round(0.01 * Fs); % 最大延迟，通常设置为帧长的一半或更短  
  
% 初始化基频数组  
fundamentalFrequencies = zeros(size(frames, 2), 1);  
  
for i = 1:size(frames, 2)  
    frame = frames(:, i);  
    % 计算自相关  
    autocorr = xcorr(frame, 'biased');  
    autocorr = autocorr(minLag:maxLag); % 截取我们关心的部分  
      
    % 找到自相关的第一个峰值（除了零延迟点）  
    [~, idx] = max(autocorr(2:end));  
    idx = idx + minLag - 1; % 修正索引  
      
    % 计算基频  
    if idx > 0  
        fundamentalFrequencies(i) = Fs / idx;  
    else  
        fundamentalFrequencies(i) = NaN; % 如果没有找到峰值，设为NaN  
    end  
end


% 去除NaN值以改善绘图  
validIndices = ~isnan(fundamentalFrequencies);  
t = (0:frameStep:(frameStep*(size(frames, 2)-1)))/Fs; % 时间轴  
  
figure;  
plot(t(validIndices), fundamentalFrequencies(validIndices));  
xlabel('Time (s)');  
ylabel('Fundamental Frequency (Hz)');  
title('Fundamental Frequency Over Time');  
grid on;


% 使用中值滤波平滑基频曲线  
smoothedFrequencies = medfilt1(fundamentalFrequencies, 3);  
  
% 绘制平滑后的曲线  
figure;  
plot(t, smoothedFrequencies);  
xlabel('Time (s)');  
ylabel('Smoothed Fundamental Frequency (Hz)');  
title('Smoothed Fundamental Frequency Over Time');  
grid on;