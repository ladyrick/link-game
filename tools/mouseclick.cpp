#include<windows.h>
#include "mex.h"

#define CLICK 1
#define DOWN 2
#define UP 3
#define LEFT 1
#define MIDDLE 2
#define RIGHT 3
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	void errmsg();
	if (nrhs < 2)
		mexErrMsgTxt("�������̫�٣�\n");
	if (nrhs > 2)
		mexErrMsgTxt("�������̫�࣡\n");
	if (nlhs > 0)
		mexErrMsgTxt("����Ҫ����ֵ��\n");
	if (!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]))
		errmsg();
	
	double key,mode;
	key = *(mxGetPr(prhs[0]));
	mode = *(mxGetPr(prhs[1]));
	
	if (key == LEFT)
	{
		if (mode == CLICK)
		{
            //mexPrintf("������\n");
			mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
			mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
		}
		else if (mode == DOWN)
		{
            //mexPrintf("�������\n");
			mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
		}
		else if (mode == UP)
		{
            //mexPrintf("����ɿ�\n");
			mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
		}
		else
		{
			errmsg();
		}
	}
	else if (key == MIDDLE)
	{
		if (mode == CLICK)
		{
            //mexPrintf("�м����\n");
			mouse_event(MOUSEEVENTF_MIDDLEDOWN,0,0,0,0);
			mouse_event(MOUSEEVENTF_MIDDLEUP,0,0,0,0);
		}
		else if (mode == DOWN)
		{
            //mexPrintf("�м�����\n");
			mouse_event(MOUSEEVENTF_MIDDLEDOWN,0,0,0,0);
		}
		else if (mode == UP)
		{
            //mexPrintf("�м��ɿ�\n");
			mouse_event(MOUSEEVENTF_MIDDLEUP,0,0,0,0);
		}
		else
		{
			errmsg();
		}
	}
	else if (key == RIGHT)
	{
		if (mode == CLICK)
		{
            //mexPrintf("�Ҽ����\n");
			mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,0);
			mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,0);
		}
		else if (mode == DOWN)
		{
            //mexPrintf("�Ҽ�����\n");
			mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,0);
		}
		else if (mode == UP)
		{
            //mexPrintf("�Ҽ��ɿ�\n");
			mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,0);
		}
		else
		{
			errmsg();
		}
	}
	else
	{
		errmsg();
	}
}

void errmsg()
{
	//mexPrintf("����������Ϸ���\n");
	//mexPrintf("��һ������key��%d��ʾ�����%d��ʾ�м���%d��ʾ�Ҽ���\n",LEFT,MIDDLE,RIGHT);
	//mexPrintf("�ڶ�������mode��%d��ʾ�����%d��ʾ���£�%d��ʾ�ɿ���\n",CLICK,DOWN,UP);
	mexErrMsgTxt("����������Ϸ���\n");
}