%%create a vector of random 0 or 1 with p>0.55 for 1

select = [];
x = rand(1,480);
for i = 1:480
    if x(i)<=0.55
        select(i)=1;
    else 
        select(i)=0;
    end
end


