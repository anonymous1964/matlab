classdef App3 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure  matlab.ui.Figure        % UI Figure
        LabelLamp matlab.ui.control.Label % 灯
        Lamp      matlab.ui.control.Lamp 
    end


    methods (Access = public)
        
  function ReceiveCallback(app,event)     %创建中断响应函数
   global s;
   global a;
   a = fscanf(s)       % 接收数据并显示（无分号）
   I = 'I received'    % 检验是否中断响应函数正常被触发（无分号）
    b=strcmp(a,'2H')
  if(b=='1')
      app.Lamp.Color='red'
  end
  b1=strcmp(a,'1H')
   if(b1=='1')
       app.Lamp.Color='green'
  end
end

    end

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
  delete(instrfindall)      % 关闭串口，此句十分重要，下篇再详细解释
  global s;                 % 全局变量，供串口中断函数使用
  s = serial('com10');       %使用默认设置创建串口s
  fopen(s);                 %打开串口
  set(s,'BytesAvailableFcnMode','Terminator'); %设置中断触发方式
  set(s,'Terminator','H');
  s.BytesAvailableFcn =@ReceiveCallback;       % 定义中断响应函数对象
  for k=1:1:5               % 每两秒发送字符串，循环五次
      fprintf(s,'ChunyuY19');
      pause(2);
  end    
  global a
    b=strcmp(a,'2H')
  if(b=='1')
      app.Lamp.Color='red'
  end
  b1=strcmp(a,'1H')
   if(b1=='1')
       app.Lamp.Color='green'
  end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';
            setAutoResize(app, app.UIFigure, true)

            % Create LabelLamp
            app.LabelLamp = uilabel(app.UIFigure);
            app.LabelLamp.HorizontalAlignment = 'right';
            app.LabelLamp.Position = [103 397 16 15];
            app.LabelLamp.Text = '灯';

            % Create Lamp
            app.Lamp = uilamp(app.UIFigure);
            app.Lamp.Position = [134 394 20 20];
        end
    end

    methods (Access = public)

        % Construct app
        function app = App3()

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
