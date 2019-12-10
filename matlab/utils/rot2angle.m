function [fi,teta,psi]=rot2angle(R)
rs=sqrt((R(3,2)^2)+(R(3,3)^2));
if (R(1,1)==0 || R(3,3)==0 || rs==0)
    fprintf('Error: second argument must be >0')
end

fi=atan(R(2,1)/R(1,1));
if(R(2,1)>0 && R(1,1)>0)
    fprintf('Angle fi in the first quadrant')
else if(R(2,1)>0 && R(1,1)<0)
        fprintf('Angle fi in the second quadrant')
    else if(R(2,1)<0 && R(1,1)<0)
            fprintf('Angle fi in the third quadrant')
        else if(R(2,1)<0 && R(1,1)>0)
                fprintf('Angle fi in the fourth quadrant')
            end
        end
    end
end

            

teta=atan(-R(3,1)/rs);
if(R(3,1)>0 && rs>0)
    fprintf('Angle teta in the first quadrant')
else if(R(3,1)>0 && rs<0)
        fprintf('Angle teta in the second quadrant')
    else if(R(3,1)<0 && rs<0)
            fprintf('Angle teta in the third quadrant')
        else if(R(3,1)<0 && rs>0)
                fprintf('Angle teta in the fourth quadrant')
            end
        end
    end
end

psi=atan(R(3,2)/R(3,3));
if(R(3,2)>0 && R(3,3)>0)
    fprintf('Angle psi in the first quadrant')
else if(R(3,2)>0 && R(3,3)<0)
        fprintf('Angle psi in the second quadrant')
    else if(R(3,2)<0 && R(3,3)<0)
            fprintf('Angle psi in the third quadrant')
        else if(R(3,2)<0 && R(3,3)>0)
                fprintf('Angle psi in the fourth quadrant')
            end
        end
    end
end
    