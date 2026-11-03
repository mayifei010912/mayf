function key = model_key(cfg)
s.scene = cfg.scene;
s.wall = cfg.wall;
s.source = cfg.source;
s.transport = cfg.transport;
key = sha256_bytes(unicode2native(jsonencode(s),'UTF-8'));
end
