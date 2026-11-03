function h = sha256_file(file)
fid = fopen(file,'rb');
assert(fid>=0,'Project:FileOpen','无法打开文件：%s',file);
cleanup = onCleanup(@() fclose(fid));
md = java.security.MessageDigest.getInstance('SHA-256');
while true
    b = fread(fid,1024*1024,'*uint8');
    if isempty(b), break; end
    md.update(typecast(b,'int8'));
end
v = typecast(md.digest(),'uint8');
h = lower(reshape(dec2hex(v,2).',1,[]));
end
