#include<windows.h>
#include "mex.h"

//����1���������޲�����
//����Ϊ1��������һ�ε����������ȡ������ڡ�
//����Ϊ0���޲��������ȡ������Ļ��

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	bool bshowmatlab = false;
	//mexPrintf("������굥������ȡ�Ĵ��ڡ�\n");
	if(nrhs==0)//������������м���
		bshowmatlab = false;
	else if(nrhs>1)
		mexErrMsgTxt("Need 1 argument or none!\n");
	else if(!mxIsDouble(prhs[0]))
		mexErrMsgTxt("The input argument must be a number!\n");
	else if(*(double*)(mxGetData(prhs[0]))==0)
		bshowmatlab=false;
	else
		bshowmatlab=true;
	
	HWND DeskWnd;
	
	if(bshowmatlab)
	{		
		//��������
		mexPrintf("������굥������ȡ�Ĵ��ڡ�\n");
/*        MSG msg;
    for (int i=0;i<10;i++) {
        Sleep(20);
        if (GetMessage(&msg,NULL,0,0)) {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
    }
 */
		while(!((!GetSystemMetrics(SM_SWAPBUTTON)
			&& (GetAsyncKeyState(VK_LBUTTON)&0xf000))
			|| (GetSystemMetrics(SM_SWAPBUTTON)
			&& (GetAsyncKeyState(VK_RBUTTON)&0xf000))))
			Sleep(10);

		Sleep(100);//��ͣһ��ʱ�䣬�ȴ����ڼ���
		DeskWnd=GetForegroundWindow();//��ȡ����ھ��
		if (!DeskWnd)
			DeskWnd=GetDesktopWindow();//��ȡ���洰�ھ��
	}
	else
	{
		DeskWnd=GetDesktopWindow();//��ȡ���洰�ھ��
	}
	
	
	RECT DeskRC;
	GetClientRect(DeskWnd,&DeskRC);//��ȡ���ڴ�С
	HDC DeskDC=GetDC(DeskWnd);//��ȡ����DC
	HBITMAP DeskBmp=CreateCompatibleBitmap(DeskDC,DeskRC.right-DeskRC.left,
		DeskRC.bottom-DeskRC.top);//����λͼ
	if(DeskBmp==0)
		mexErrMsgTxt("Fail to create a compatible bitmap!\n");
	HDC memDC=CreateCompatibleDC(DeskDC);//����DC
	if(!SelectObject(memDC,DeskBmp))//�Ѽ���λͼѡ�����DC��
		mexErrMsgTxt("Compatible Bitmap Selection!\n");

	if (!BitBlt(memDC,DeskRC.left,DeskRC.top,
		DeskRC.right-DeskRC.left,DeskRC.bottom-DeskRC.top,
		DeskDC,DeskRC.left,DeskRC.top,SRCCOPY))//����DC
		mexErrMsgTxt("Screen to Compat Blt Failed!\n");
		
	char *pchar,*mloc;
	int dims[3],cx,cy;
	cx = DeskRC.right-DeskRC.left;
	cy = DeskRC.bottom-DeskRC.top;
	dims[0]=cy;//ע��cx,cy��˳��
	dims[1]=cx;
	dims[2]=3;
	//mexPrintf("X = %d, Y = %d;\n", cx, cy);
	plhs[0]=mxCreateNumericArray(3,dims,mxUINT8_CLASS,mxREAL);
	pchar=(char*)mxGetData(plhs[0]);
	BITMAP bmInfo;
	DWORD bmDataSize;
	char *bmData;//λͼ����
	GetObject(DeskBmp,sizeof(BITMAP),&bmInfo);//����λͼ�������ȡλͼ��Ϣ
	bmDataSize=bmInfo.bmWidthBytes*bmInfo.bmHeight;//����λͼ���ݴ�С
	bmData=new char[bmDataSize];//��������
	
	BITMAPINFOHEADER bih;//λͼ��Ϣͷ
	bih.biSize=40;
	bih.biWidth=bmInfo.bmWidth;
	bih.biHeight=bmInfo.bmHeight;
	bih.biPlanes=1;
	bih.biBitCount=24;
	bih.biCompression=0;
	bih.biSizeImage=bmDataSize;
	bih.biXPelsPerMeter=3780;
	bih.biYPelsPerMeter=3780;
	bih.biClrUsed=0;
	bih.biClrImportant=0;
	
	
	GetDIBits(DeskDC,DeskBmp,0,bmInfo.bmHeight,bmData,
		(BITMAPINFO *)&bih,DIB_RGB_COLORS);//��ȡλͼ���ݲ���
    
	int i,j,k;
	for(k=0;k<3;k++)
	for(j=0;j<cy;j++)
	for(i=0;i<cx;i++)
	{
		pchar[i*cy+(cy-j)+k*cx*cy]=
			bmData[(j*cx+i)*3+(cx%4)*j+2-k];
	}

	delete bmData;
	return;
}