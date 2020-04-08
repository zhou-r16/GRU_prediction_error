Start = 1;
End = 20;

for i = Start:1:End
    filename = string(sprintf('%d.mat', i));
    load(filename);
    save(string(sprintf('../for_implement/%d.mat', i+100)),'rec1');
end