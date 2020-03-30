#   Ruth Brennan - 17329846

#Matrices
exercise =  [[[0.891, 8],   [0.009, 8],     [0.1, 0]],
            [[0.18, 0],     [0.72, 0],      [0.1, 0]],
            [[0, 0],        [0, 0],         [1, 0]]]

relax =     [[[0.693, 10],  [0.297, 10],    [0.01, 0]],
            [[0, 5],        [0.99, 5],      [0.01, 0]],
            [[0, 0],        [0, 0],         [1, 0]]]

#States
S = ['fit', 'unfit', 'dead']

#Get inputs n,G and s
n = input("Enter a value for n:")
g = input("Enter a value for G (0 < G < 1): ")
s = input("Enter a value for s (fit, unfit, dead): ")

#Ensure inputs are valid
try:
    n = int(n)
    g = float(g)
    if g <= 0 or g >= 1:
        raise Exception
    if s not in S:
        raise Exception
except:
	print("Invalid inputs")
	exit(1)

#change state so that it can be used to access matrix as needed
if s == "fit" or s == "Fit":
    s = 0
elif s == "unfit" or s == "Unfit":
    s = 1
else:
    s = 2

#q0
def q0(s, a):
    if a == "exercise":
        temp = (exercise[s][0][0] * exercise[s][0][1]) + (exercise[s][1][0] * exercise[s][1][1])
    else:
        temp = (relax[s][0][0] * relax[s][0][1]) + (relax[s][1][0] * relax[s][1][1])
    return temp

#max between the qn of two inputs
def M(s, n):
    temp1 = qn(s, "exercise", n)
    temp2 = qn(s, "relax", n)
    return max(temp1, temp2)

#qn
def qn(s, a, n):
    if n == 0:
        return q0(s, a)
    temp = q0(s, a)
    if a == "exercise":
        temp1 = g * ((exercise[s][1][0] * M(1, n - 1)) + (exercise[s][0][0] * M(0, n - 1)))
    else:
        temp1 = g * ((relax[s][0][0] * M(0, n - 1)) + (relax[s][1][0] * M(1, n - 1)))
    return temp + temp1

#Print out the results
print("Exercise: " + str(qn(s, "exercise", n)))
print("Relax: " + str(qn(s, "relax", n)))