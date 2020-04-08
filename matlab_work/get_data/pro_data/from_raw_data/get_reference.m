clear

Start = 1;
End = 25;

for i = Start:1:End
    filename_char = sprintf('for_1st_train/%d.mat', i);
    filename(i) = string(filename_char);
    load(filename(i));
    rec(i) = rec1;
    
    reference(i,:) = rec(i).posx';
   
end

save_name = sprintf('reference.mat');
save(save_name, 'reference');
