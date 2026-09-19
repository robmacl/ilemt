function plot_log(data, mag, time)
    rateType = ["hr","lr", "High Rate", "Low Rate"];
    for j = 1:2
        figure()
        for i = numel(data.Status):-1:1
            subplot(2,1,1)
            plot(time.norm.(rateType{j}).(data.Status{i}), mag.trans.(rateType{j}).(data.Status{i}))
            hold on   
            legend("Motor status: "+data.Status)
            xlabel("Time (s)")
            ylabel("Translational magnitude (m)")
            title("Position Magnitude Over Time with Interference of "+data.Device(1)+" Device on "+rateType{j+2}+" data")
             
            subplot(2,1,2)
            plot(time.norm.(rateType{j}).(data.Status{i}), mag.rot.(rateType{j}).(data.Status{i}))
            hold on
            legend("Motor status: "+data.Status)
            xlabel("Time (s)")
            ylabel("Rotation magnitude (rad)")
            title("Rotation Magnitude Over Time with Interference of "+data.Device(1)+" Device on "+rateType{j+2}+" data")
            
        end
    
        hold off
    end
end