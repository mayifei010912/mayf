function save_rgb_preview(file, rgb, gain)
imwrite(uint8(255*min(max(double(rgb)*gain,0),1)),file);
end
