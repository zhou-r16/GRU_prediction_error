clear
load('reference.mat');
Start = 25;
% End = 25;

fs = 2000;

for i = Start:1:Start
    comp_name = string(sprintf('../../../data/implement/1st_implement_for_2nd_train/comp_data%d.mat',i));
    load(comp_name);
    sigx = yc;
%     a = reference(i,:)';
    
    figure(1)
    plot(sigx);
    
    figure(2)
    subplot(4,1,1)
    for o=1:1:(length(sigx)-1)
        vx(o)=(sigx(o+1)-sigx(o))*fs;
    end
    vx(length(sigx))=0-sigx(length(sigx))*fs;
    plot(vx)

    subplot(4,1,2)

    for o=1:1:(length(sigx)-1)
        ax(o)=(vx(o+1)-vx(o))*fs;
    end
    ax(length(sigx))=0-vx(length(sigx))*fs;
    plot(ax)

    subplot(4,1,3)

    for o=1:1:(length(sigx)-1)
        jx(o)=(ax(o+1)-ax(o))*fs;
    end
    jx(length(sigx))=0-ax(length(sigx))*fs;
    plot(jx)

    subplot(4,1,4)

    for o=1:1:(length(sigx)-1)
        jjx(o)=(jx(o+1)-jx(o))*fs;
    end
    jjx(length(sigx))=0-jx(length(sigx))*fs;
    plot(jjx)
    
    rec1.posx = sigx';
    rec1.vx = vx;
    rec1.ax = ax;
    rec1.jx = jx;
    
    t = 0:1/fs:90;
    data_in = [t' reference(i,:)'];
    compensation = [t' yc'];
    
end

% 运行Simulink后在命令行执行
% rec1.ex = error_output.Data;save(string(sprintf('for_2nd_train/%d',Start)),'rec1');