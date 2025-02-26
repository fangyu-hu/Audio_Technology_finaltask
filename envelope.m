function env = envelope(signal)
    % signal: 输入的音频信号
    % env: 返回的包络曲线

    % 使用Hilbert变换获取信号的包络
    analyticSignal = hilbert(signal);
    env = abs(analyticSignal);
end
