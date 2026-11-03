function info=step0_check_raw(cfg)
% 入口零：读取一帧，检查尺寸/颜色排列/文件长度；不做重构、不读目标模板。
root=setup_project(); if nargin<1, cfg=experiment_config(); end
files=resolve_raw_files(cfg.raw.measurementPath,cfg.raw);
[rgb,layout]=read_mvs_raw(files{1},cfg.raw);
runDir=new_run_dir(root,'raw_check');
info.file=files{1}; info.fileSHA256=sha256_file(files{1}); info.layout=layout;
info.minMaxDN=[min(rgb(:)) max(rgb(:))]; info.formatManuallyConfirmed=cfg.raw.formatConfirmed;
info.noReconstructionPerformed=true;
save_rgb_preview(fullfile(runDir,'raw_preview_brightness_only.png'),rgb/layout.maxDN,cfg.display.previewGain);
save(fullfile(runDir,'raw_check.mat'),'info','cfg'); write_json(fullfile(runDir,'raw_check.json'),info);
fprintf('[PASS RAW_LAYOUT_ONLY] %s\n',runDir);
fprintf('仅证明文件按所填格式可读取；颜色排列和物理标定仍需核对。\n');
end
