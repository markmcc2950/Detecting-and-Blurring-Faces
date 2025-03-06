function plot_match(img1, img2, f1, f2, matches)

    h1 = vl_plotframe(f1(:, matches(1, :))) ;
    h2 = vl_plotframe(f2(:, matches(2, :))) ;

    for y2 = 1:size(matches, 2)
    hold on
        p1 = f1(1:2, matches(1, y2));
        p2 = f2(1:2, matches(2, y2));
        plot([p1(1), p2(1)], [p1(2), p2(2)], 'b-');

    end

    hold off;

end