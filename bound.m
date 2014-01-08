function r = bound(A, lower, upper)

r = (A >= lower & A <= upper).*A + (A < lower)*lower + (A > upper)*upper;