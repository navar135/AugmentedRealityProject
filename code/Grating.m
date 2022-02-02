g = gabor([5 10],[0 90]);
figure;
for p = 1:length(g)
    imshow(real(g(p).SpatialKernel),[]);
    lambda = g(p).Wavelength;
    theta  = g(p).Orientation;
end