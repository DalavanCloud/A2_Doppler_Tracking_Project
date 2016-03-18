%Step 1: Scan the image
filename = 'test.PNG';
Image = imread(filename);
Image_Gray_Tone = rgb2gray(Image);
%Image_Rotated_Crop = imrotate(Image, 0, 'crop');
Gray_Image_Transformed = edge(Image_Gray_Tone, 'canny',0.25);
figure, imshow(Image);
figure, imshow(Image_Gray_Tone);
figure, imshow(Gray_Image_Transformed);

[row, col] = find(Gray_Image_Transformed == 1);
D = [col, row];

syms a1 x a2
a = {a1, a2};
p = size(a);
f = symfun(a1*x+a2, [a x]);

P = zeros(0,size(a,2)+1);
All_Curves_Detected = zeros(0,size(a,2));

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
    index = randperm(size(D,1),size(a,2));
    
    points = D(index,:);
    
    %Step 3: Get a parameter
    formulas = f(a{:}, points(:,1)) == points(:,2);
    
    [p1, p2] = solve(formulas, a{:});
    p = [p1, p2];
    if(size(p1,1) >= 1)
        %Step 4: If this is in P (p_c = p or |p_c - p| <= delta), go to 6, else go to 5
        if(size(P,1) >= 1)
            distances = sqrt(sum((P(:,1:size(P,2)-1) - repmat(p,size(P,1),1)).^2,2));
            distances;
        else
            distances = zeros(0,0);
            c1 = zeros(0,0);
            c2 = zeros(0,0);
        end
        c1;
        c2;
        if(find(distances <= delta))
            [c1,c2] = find(distances <= delta);
            %Step 6
            'Step 6'
            P(c1,3) = P(c1,3) + 1;
            P(c1,3)
            if(P(c1,3) > n_t)
                cell = num2cell(p);
                [d1,d2] = find(D(:,2) == f(cell{:},D(:,1)));
                if(size(d1,1) >= m_min && size(d2,1) >= m_min)
                    %Step 8
                    'Step 8'
                    D(d1,:) = [];
                    P = zeros(0,3);
                    k = -1;

                    %Step 9
                    'Step 9'
                    All_Curves_Detected(size(All_Curves_Detected,1)+1,:) = p;
                else
                    P(c1,:) = [];
                end
            end
        else
            %Step 5
            %'Step 5'
            P(size(P,1) + 1,:) = [p 1];
        end
        %Step 5: Add p to P with count 1, go to 7

        %Step 6: Increase the count of p, if the count is above n_t, go to 8, else
        %go to 7

        %Step 7: k = k + 1, if k > k_max, stop, else go to 2
        k = k + 1;
        
        k

        %Step 8: Remove all the point of D on the line with p, P = null, k = 0. If
        %mpc > m_min, go to 9, else, this is a false line, put all the points back
        %and take p_c from P

        %Step 9: A line represented by p is detected and set P = null and k = 0, go
        %to step 2
    end
end

