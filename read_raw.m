function x=read_raw(name,fmt,height,width)
    fid = fopen(name,'r');
    x = fread(fid,[width,height],fmt);
    fclose(fid);
end

