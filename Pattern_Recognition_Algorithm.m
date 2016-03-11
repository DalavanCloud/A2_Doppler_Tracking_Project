%Step 1: Scan the image
filename = 'Test.PNG';
Image = imread(filename);
Image_Gray_Tone = rgb2gray(Image);
%Image_Rotated_Crop = imrotate(Image, 0, 'crop');
Gray_Image_Transformed = edge(Image_Gray_Tone, 'canny');
figure, imshow(Image);
figure, imshow(Image_Gray_Tone);
figure, imshow(Gray_Image_Transformed);

[row, col] = find(Gray_Image_Transformed == 1);
D = [col, row];

syms a1 x a2
a = {a1, a2};
p = size(a);
f = symfun(a1*x+a2, [a x]);

P = zeros(0,size(a,1)+1);
All_Curves_Detected = zeros(0,size(a,1));

k_min = 100;
delta = 0;
m_min = 10;
n_t = 2;

n = 2;

c1 = zeros(0,1);
c2 = zeros(0,1);

k = 0;
%Step 2: Iterate
%% 
while k <= k_min
    
    %Take some points
    index = randi(size(D,1),2,1);
    points = D(index,:);
    
    %Step 3: Get a parameter
    formulas = f(a{:}, points(:,1)) == points(:,2);
    
    p_raw_temporary = struct2cell(solve(formulas, a{:}));
    for i = 1:size(p_raw_temporary,2)
        p = p_raw_temporary(i);
    end
    if(size(p,1) >= 1)
        %Step 4: If this is in P (p_c = p or |p_c - p| <= delta), go to 6, else go to 5
        if(size(P,1) >= 1)
            distances = sqrt(sum(P.*P));
            [c1,c2] = find(distances <= delta);
        else
            c = zeros(0,size(p,2));
        end
        c1
        c2
        if(size(c1,1) >= 1 && size(c2,1) >= 1)
            %Step 6
            'Step 6'
            P(c1,c2) = P(c1,3) + 1;
            if(P(c1,3) > n_t)
                [d1,d2] = find(D(:,2) == f(p1,D(:,1),p2));
                if(size(d1,1) >= m_min && size(d2,1) >= m_min)
                    %Step 8
                    'Step 8'
                    D = D - D(d1,d2);
                    P = zeros(0,3);
                    k = -1;

                    %Step 9
                    'Step 9'
                    All_Curves_Detected(size(All_Curves_Detected,1),2) = p.';
                else
                    P = P - P(c1,c2);
                end
            end
        else
            %Step 5
            %'Step 5'
            P(size(P,1) + 1,:) = [p.' 1];
        end
        %Step 5: Add p to P with count 1, go to 7

        %Step 6: Increase the count of p, if the count is above n_t, go to 8, else
        %go to 7

        %Step 7: k = k + 1, if k > k_max, stop, else go to 2
        k = k + 1;

        %Step 8: Remove all the point of D on the line with p, P = null, k = 0. If
        %mpc > m_min, go to 9, else, this is a false line, put all the points back
        %and take p_c from P

        %Step 9: A line represented by p is detected and set P = null and k = 0, go
        %to step 2
    end
end

