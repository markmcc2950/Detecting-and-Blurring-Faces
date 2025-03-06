function img_filtered = gaussian_filter(x_box, y_box, img, kernel)
    shift_u = floor(size(kernel,2)/2);
    shift_v = floor(size(kernel,1)/2);
    for u = (1 + shift_u): (size(img, 2) - shift_u)
        for v = (1 + shift_v): (size(img, 1) - shift_v)
            x1 = u - shift_u; x2 = u + shift_u;
            y1 = v - shift_v; y2 = v + shift_v;
            patch = img(y1:y2, x1:x2);
            
            patch = patch(:);
            kernel = kernel(:)';
            value = kernel*patch;
            output(v,u) = value;
        end
    end
    img_filtered = output;
end
