function envelope_extraction(audio_file)
    % 读取音频文件
    [signal, Fs] = audioread("架子鼓镲片单音.mp3");
    fprintf('The sampling rate of the audio file is: %d Hz\n', Fs);


    if size(signal, 2) > 1  
        signal=mean(signal,2);
    end
    
    
    % 提取包络
    env = envelope(signal);
    
    % 可视化包络曲线
    figure;
    plot(env);
    title('Envelope of the Audio Signal');
    xlabel('Sample Number');
    ylabel('Amplitude');
    
    % 打印包络长度
    env_length = length(env);
    fprintf('The length of the envelope is: %d\n', env_length);
    
    % 确保包络长度至少为3
    if env_length < 3
        error('The envelope length is less than 3.');
    end

    % 分析包络曲线的ADSR
    % 这里简单地展示了如何找到ADSR的各个部分，可以根据需要进一步详细分析
    attack = find(env == max(env), 1);
    decay = find(env(attack:end) < max(env)/2, 1) + attack - 1;
    sustain = find(env(decay:end) > max(env)/3, 1, 'last') + decay - 1;
    release = find(env(sustain:end) < max(env)/10, 1) + sustain - 1;

    fprintf('ADSR analysis: Attack = %d, Decay = %d, Sustain = %d, Release = %d\n', ...
        attack, decay, sustain, release);
    
    % 生成一个纯音信号
    duration = length(signal) / Fs;
    t = linspace(0, duration, length(signal));
    pure_tone = sin(2 * pi * 440 * t);  % 440Hz的纯音

    % 重采样包络使其长度与纯音信号一致
    env_resampled = resample(env, length(pure_tone), length(env));

    % 将纯音信号的包络修改为乐器包络
    modified_signal = pure_tone .* env_resampled';

    % 保存修改后的音频
    audiowrite('modified_signal.wav', modified_signal, Fs);
end
