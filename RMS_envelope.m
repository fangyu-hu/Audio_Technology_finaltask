function envelope_extraction(audio_file)
    % 读取音频文件
    [y, Fs] = audioread("架子鼓镲片单音.mp3");
    
    % 如果音频是双声道，将其转换为单声道
    if size(y, 2) > 1
        y = mean(y, 2);
    end
    
    % 设置帧大小和重叠率
    frame_size = 1024; % 帧大小（样本数）
    overlap = 0.5; % 重叠率（0到1之间）
    
    % 计算步长
    hop_size = floor(frame_size * (1 - overlap));
    
    % 初始化RMS值数组
    num_frames = ceil((length(y) - frame_size) / hop_size) + 1;
    rms_values = zeros(num_frames, 1);
    
    % 分帧并计算每帧的RMS值
    for i = 1:num_frames
        % 当前帧的起始位置
        start_index = (i - 1) * hop_size + 1;
        % 当前帧的结束位置
        end_index = min(start_index + frame_size - 1, length(y));
        
        % 提取当前帧
        frame = y(start_index:end_index);
        
        % 计算RMS值
        rms_values(i) = sqrt(mean(frame.^2));
    end
    
    % 平滑RMS值形成包络
    envelope = smoothdata(rms_values, 'gaussian', 5);
    
    % 可视化原始音频信号和包络曲线
    time = (0:length(y)-1) / Fs;
    figure;
    subplot(2,1,1);
    plot(time, y);
    title('音频信号');
    xlabel('时间 (秒)');
    ylabel('幅值');
    
    % 包络的时间轴
    envelope_time = (0:num_frames-1) * hop_size / Fs;
    subplot(2,1,2);
    plot(envelope_time, envelope, 'r');
    title('包络');
    xlabel('时间 (秒)');
    ylabel('RMS幅值');
end
