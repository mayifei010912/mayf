function h = sha256_bytes(bytes)
md = java.security.MessageDigest.getInstance('SHA-256');
md.update(typecast(uint8(bytes(:)), 'int8'));
v = typecast(md.digest(), 'uint8');
h = lower(reshape(dec2hex(v,2).',1,[]));
end
