%Coupling matrix calculated using dipole model
function [coupling] = fk_coupling (P, so_pos, so_mo, se_pos, se_mo)

     for i = 1:3 %source index 
       for j = 1:3 %sensor index
         
         %sensor position and moment in source coordinates
         sensor_pos = P * [se_pos(:,j); 1];
         sensor_moment = P * [se_mo(:,j); 0];
         
         %vector distance r between source and sensor in source coordinates 
         rSoSe = sensor_pos - [so_pos(:,i); 1];
         %vector r magnitude
         rSoSeMag = norm(rSoSe);
         %vector r unit
         rSoSeUnit = rSoSe ./ rSoSeMag;
        
         %Find magnetic field vector at the sensor location, using the dipole model
         B = (1/rSoSeMag^3) * ...
               (3*dot([so_mo(:,i); 0], rSoSeUnit)*rSoSeUnit - [so_mo(:,i); 0]); 
     
         %coupling matrix using antenna model
         coupling(i, j) = dot(B, sensor_moment); 
        
   
       end
     end
end