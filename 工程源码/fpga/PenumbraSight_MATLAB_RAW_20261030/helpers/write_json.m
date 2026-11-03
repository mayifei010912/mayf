function write_json(file, value)
fid=fopen(file,'w','n','UTF-8');
assert(fid>=0,'Project:FileOpen','无法写入：%s',file);
cleanup=onCleanup(@() fclose(fid));
fprintf(fid,'%s\n',jsonencode(value,'PrettyPrint',true));
end
