% --------------------------------------------------
% All in one go
% --------------------------------------------------

cols = processimage('../images/paolina-small.jpg', 'edge', true);
%                   ^ image path                   ^ type  ^ relax?

% --------------------------------------------------
% Piece by piece... this is faster if you want to run multiple images,
% since initial operators and especially compatibilities take a bit of time
% to generate (and this way only need to be generated once).
% --------------------------------------------------

% First load thyself an image

image = imload('../images/paolina-small.jpg');

% Initial operators for edges

einitopfam = mkinitopfam(); % Makes an initial operator family for edges
einitests = convinitopfam(image, einitopfam, 16, false); % Calculate initial estimates
% The output is an imheight x imwidth x nthetas x ncurvatures array

% Relaxation for edges

ecompatfam = mkcompatfam(); % Make a compatibility family for edges
erelaxed = relax(einitests, ecompatfam, 5, 1, 4, true); % Relax the initial estimates
% The output is an imheight x imwidth x nthetas x ncurvatures array

% Initial operators for lines

linitopfam = mkinitopfam('FeatureType', 'line');
linitests = convinitopfam(image, linitopfam, 16, false);

% Relaxation for lines

lcompatfam = mkcompatfam('FeatureType', 'line');
lrelaxed = relax(linitests, lcompatfam, 5, 1, 4, true);

% --------------------------------------------------
% Displaying things
% --------------------------------------------------

% Display columns (result of convinitopfam and relax)

% If you're on a Mac, you can change the false to true and it will
% automatically open in Preview.app.  In that case, use tempname for the
% filename.  Columns can be either the initial estimates or the relaxations
% from above.

cols2ps('~/Desktop/output.eps', columns, 'Open', false);

% Display edges and lines simultaneously

cols2ps('~/Desktop/combined.eps', edgecols, linecols, 'Open', false);

% Display compatibilities

displaycompats(compatfam, 1, 4, 1:5, 1:6, 1:4, 0.9, 2, 0.0001);