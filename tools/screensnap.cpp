#include<windows.h>
#include "mex.h"

//传入1个参数或无参数。
//参数为1，则请求一次点击操作，截取点击窗口。
//参数为0或无参数，则截取整个屏幕。

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	bool bshowmatlab = false;
	//mexPrintf("请用鼠标单击欲截取的窗口。\n");
	if(nrhs==0)//对输入参数进行检验
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
		//检测鼠标点击
		mexPrintf("请用鼠标单击欲截取的窗口。\n");
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

		Sleep(100);//暂停一段时间，等待窗口激活
		DeskWnd=GetForegroundWindow();//获取激活窗口句柄
		if (!DeskWnd)
			DeskWnd=GetDesktopWindow();//获取桌面窗口句柄
	}
	else
	{
		DeskWnd=GetDesktopWindow();//获取桌面窗口句柄
	}
	
	
	RECT DeskRC;
	GetClientRect(DeskWnd,&DeskRC);//获取窗口大小
	HDC DeskDC=GetDC(DeskWnd);//获取窗口DC
	HBITMAP DeskBmp=CreateCompatibleBitmap(DeskDC,DeskRC.right-DeskRC.left,
		DeskRC.bottom-DeskRC.top);//兼容位图
	if(DeskBmp==0)
		mexErrMsgTxt("Fail to create a compatible bitmap!\n");
	HDC memDC=CreateCompatibleDC(DeskDC);//兼容DC
	if(!SelectObject(memDC,DeskBmp))//把兼容位图选入兼容DC中
		mexErrMsgTxt("Compatible Bitmap Selection!\n");

	if (!BitBlt(memDC,DeskRC.left,DeskRC.top,
		DeskRC.right-DeskRC.left,DeskRC.bottom-DeskRC.top,
		DeskDC,DeskRC.left,DeskRC.top,SRCCOPY))//拷贝DC
		mexErrMsgTxt("Screen to Compat Blt Failed!\n");
		
	char *pchar,*mloc;
	int dims[3],cx,cy;
	cx = DeskRC.right-DeskRC.left;
	cy = DeskRC.bottom-DeskRC.top;
	dims[0]=cy;//注意cx,cy的顺序
	dims[1]=cx;
	dims[2]=3;
	//mexPrintf("X = %d, Y = %d;\n", cx, cy);
	plhs[0]=mxCreateNumericArray(3,dims,mxUINT8_CLASS,mxREAL);
	pchar=(char*)mxGetData(plhs[0]);
	BITMAP bmInfo;
	DWORD bmDataSize;
	char *bmData;//位图数据
	GetObject(DeskBmp,sizeof(BITMAP),&bmInfo);//根据位图句柄，获取位图信息
	bmDataSize=bmInfo.bmWidthBytes*bmInfo.bmHeight;//计算位图数据大小
	bmData=new char[bmDataSize];//分配数据
	
	BITMAPINFOHEADER bih;//位图信息头
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
		(BITMAPINFO *)&bih,DIB_RGB_COLORS);//获取位图数据部分
    
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