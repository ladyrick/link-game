#include<windows.h>
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
		mexErrMsgTxt("需要两个参数！\m");
	if (nlhs > 1)
		mexErrMsgTxt("返回值太多！\m");
	if (!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]))
		mexErrMsgTxt("输入参数必须为数字！\m");
	bool flag;
	int X, Y;
	X = int(*(double*)(mxGetData(prhs[0])));
	Y = int(*(double*)(mxGetData(prhs[1])));
	flag = SetCursorPos(X, Y);
	double *r;
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	r = mxGetPr(plhs[0]);
	
	if (flag)
		*r = 1;
	else 
		*r = 0;
}
