mydir = 'H:\IP\sysid_data';
myfiles = dir(fullfile(mydir, "*.mat"));

for k = 1:length(myfiles)
    basefilename = myfiles(k).name;
    fullfilename = fullfile(mydir, basefilename);
    fprintf(1, 'reading %s\n', fullfilename);
    
    % Load and unpack the data
    olddata = load(fullfilename);
    theta = olddata.data(:, 3);
    newtheta = theta*1.39;
    cur = olddata.data(:,5);
    newcur = cur + 0.013588224070498;

    data = [olddata.data(:,1), olddata.data(:,2), newtheta, olddata.data(:,4), newcur];
    save("sysid_data_cal\" + basefilename, "data");
end