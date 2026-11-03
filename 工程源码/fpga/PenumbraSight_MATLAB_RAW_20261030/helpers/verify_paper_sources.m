function report = verify_paper_sources(root)
items = jsondecode(fileread(fullfile(root,'paper_source_manifest.json')));
for k=1:numel(items)
    file = fullfile(root,strrep(items(k).relative_path,'/',filesep));
    assert(strcmp(sha256_file(file),items(k).sha256), ...
        'Project:PaperSourceChanged','论文原件已改变：%s',file);
end
report.filesChecked = numel(items);
report.originalCopiesByteIdentical = true;
report.reconstructionFunction = which('reconstruct_tv_it_cbg');
end
