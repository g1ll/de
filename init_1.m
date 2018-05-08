dir = '/media/Dados/Projetos/matlab/opt/de/';
cd '/media/Dados/Projetos/matlab/opt/de/';
addpath(genpath(pwd));
resultado = [];
for n=1:30
  fprintf("\nResultado %d\n",n);
  resultado = [resultado; n desa2(@egg,[-100 -100],[100 100]);];
end

filename = strcat('resultado_desa2_200',datestr(date(),'yyyymmdd'),strftime ("_%H_%M_%S", localtime(time())),'.csv');
csvwrite (strcat(dir,filename), resultado );