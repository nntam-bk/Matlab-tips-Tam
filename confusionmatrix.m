x = 0:10;
y = repmat(x',50,1);
yp = y;
yt = categorical(y); % true 
ran_num = randperm(length(y));
for i = 1:15
step = randi([-3,3],1);
if abs(yp(ran_num(i))-yp(ran_num(i)+step))>3
yp(ran_num(i)) = yp(ran_num(i));
else
yp(ran_num(i)) = yp(ran_num(i)+step);
end
end
yp = categorical(yp);
plotconfusion(yp,yt)
