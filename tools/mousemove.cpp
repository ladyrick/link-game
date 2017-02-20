#include<windows.h>
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
		mexErrMsgTxt("��Ҫ����������\m");
	if (nlhs > 1)
		mexErrMsgTxt("����ֵ̫�࣡\m");
	if (!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]))
		mexErrMsgTxt("�����������Ϊ���֣�\m");
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
