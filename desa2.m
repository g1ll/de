%Algoritmo de otimização Differential Evolution
function res = desa2(fo,L,U)
    D = length(L);      %Dimensão do problema (número de variáveis)
    NP = 10;            %Número de indivíduos na população (Number Population)
    CR = 0.9;           %Parâmetro de Cruzamento (Crossover Constant  [0,1])
    F = 1.5;            %Fator de mutação (Factor of Differential Variation [0,2])
    NG = 200;            %Numero de gerações
    T0 = 100;		%Sa temp
    R = 1;
    rc=0;
    fprintf('\nRestrições\n'); 
    L
    U
    
    fprintf('\nDimensão:\n');
    D
    
    fprintf('\nTamanho da População:\n');
    NP
    
    fprintf('\nParâmetros de Cruzamento e Mutação:\n');   
    [CR F]
    
    more off
    format free
    ct = inf;
    T = T0;
    %Geração da População Inicial
    for i = 1:NP
        for j = 1:D
            x1(i,j) = normrnd((U(j)-L(j))/2+(L(j)),rand()*((U(j)-L(j))/2)); %Distribuição Normal e Desvio Aleatório            
            while (x1(i,j)==0)
                x1(i,j) = normrnd((U(j)-L(j))/2+(L(j)),rand()*((U(j)-L(j))/2)); %Distribuição Normal e Desvio Aleatório            
            end
            %aplicando restrições
            if(x1(i,j)>U(j))
                x1(i,j)=U(j);
            elseif(x1(i,j)<L(j))
                x1(i,j)=L(j);
            end
            
        end
        c1(i) = fo(x1(i,:));
	
	%Adaptação DESA
	%Selecionar o melhor 
        if(ct>=c1(i))
           ct= c1(i);
           opt=x1(i,:);
           optb = opt;
        end
	
    end
    p = x1;
    
    fprintf('\nPopulação  Inicial:\n');
    x1
    
    fprintf('\nCusto da População Inicial:\n');
    c1'

 
	
    c = zeros(1,D);
    dataPlot = [];
   for g = 1:NG
        for i=1:NP
            %Sorteando indices dos vetores escolhidos aleatoriamente
            a= randi(NP); while (a==i) a=randi(NP); end;
            b= randi(NP); while (b==i || b==a)  b= randi(NP); end;
	    
            %DE Clássico sorteia um terciro vetor aleatório
            if(rand()>T/T0)%relacionar com a temperatura maior menor aceitação
              c = randi(NP); while (c==i || c==b || c==a) c= randi(NP); end;
              c = x1(c,:);
            else
              for j = 1:D
               %DESA adaptação para criar um terceiro vetor apartir do melhor ponto atual 
               c(j) = normrnd(opt(j),rand()*((U(j)-L(j))/2)*T/T0);
              end
            end
            j= D-floor(rand()*D); %Escolhendo uma variável aleatória para a mutação
            %j,a,b,c            
            for k = 1:D                                
                if (rand()<CR || k==D)                    
                    trial(j)=c(j)+F*(x1(a,j)-x1(b,j));
                    while(trial(j)>U(j)|| trial(j)<L(j))
                      trial(j)=normrnd((U(j)-L(j))/2+(L(j)),rand()*((U(j)-L(j))/2));
                    end
                else
                    trial(j)=x1(i,j);
                end
                r= D-floor(rand()*D);while (r==j) r= D-floor(rand()*D); end;
                j=r;
                %j=mod((j+1),D);%?
            end
            trial;
            %Avaliar a população
            ct = fo(trial);
            dE = ct-c1(i);
            %aceitaçao p boltzmam
            if(dE<0)
                x2(i,:) = trial;
                c1(i) = ct;
                if(ct<=fo(opt))
                  opt = x2(i,:);
                  if(ct<=fo(optb))
		                optb = opt;
	                end
                end
            else
                if(rand()<exp(-dE/T))
                  x2(i,:) = trial;
                  c1(i)= ct;
                   opt = x2(i,:);
                else
                  x2(i,:) = x1(i,:);
                end
            end
            
            %if(fo(opt)>=c1(i))
		         %opt = x2(i,:);
	          %end                   
      end                 
      x1 = x2;
	
%---------------------------------
	%Adaptação DESA atualiza temperatura
	%T = T*RT %Classical 0.9 
    	%T = T*0.75 %Fast
   	 %T = T*0.95 %Exponential
    	%T = T0/log(cIter)  %Botlzman
   	 %BotlzExp
   	 %init_temp(tc)*0.95^((k(tc)-nk(tc))-init_temp(tc)*0.5);
    	Te = T0*0.95^(rc-(T0/2)) %Exponential
    	Tb = T0/log(rc)  %BotlzExp
    	if(Te<Tb)
    	  T = Te;
    	else
    	  T = Tb;
   	 end
   	 if(rc>NG/2 && R)
       rc = 0;
    	 fprintf('\nReannealing:\n');
    	  T=T0;
        for i = 1:NP
          for j = 1:D
              x1(i,j) = normrnd((U(j)-L(j))/2+(L(j)),rand()*((U(j)-L(j))/2)); %Distribuição Normal e Desvio Aleatório            
              while (x1(i,j)==0)
                  x1(i,j) = normrnd((U(j)-L(j))/2+(L(j)),rand()*((U(j)-L(j))/2)); %Distribuição Normal e Desvio Aleatório            
              end
              %aplicando restrições
              if(x1(i,j)>U(j))
                  x1(i,j)=U(j);
              elseif(x1(i,j)<L(j))
                  x1(i,j)=L(j);
              end
              
          end
          c1(i) = fo(x1(i,:));
        end
   	 end
%---------------------------------

       fprintf('\nGeração:\n');
       g

       fprintf('\nTemperatura:\n');
       T
	
       fprintf('\nÓtimo:\n');	
	     optb
	
	    fprintf('\nFO Ótimo:\n');	
	    fval = fo(optb)

	    fprintf('\nVizinho Otimo:\n');		
	    c	
	
      % fprintf('\nPopulação Atual:\n');
       %x1 
       
       fprintf('\n------------------------------------------------------------:\n');
       
       %salvando dados
       if isempty(dataPlot)
            dataPlot = [max(c1),min(c1),T];
       else
            dataPlot = [dataPlot;max(c1),min(c1),T];
       end
        %plotando
        xp = 1:1:length(dataPlot(:,1));
        figure(1);
        plot(xp,dataPlot(:,2)','--gs','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5],'lineWidth',4,xp,dataPlot(:,1)','g-','lineWidth', 4,'MarkerSize',10);
        %ylim([-1 10]);
        set(gca, 'linewidth', 4, 'fontsize', 12);
        
        figure(2);
        plot(xp,dataPlot(:,3)','-r','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5],'lineWidth',4);
        ylim([-1 T0]);
        set(gca, 'linewidth', 4, 'fontsize', 12);
        
        figure(3); 
        
        [x,y] = meshgrid(min(L):max(U)*0.01:max(U));
        %fo1
        %z = x.^2+y.^2;
        %egg
        z = -(y+47) .* sin(sqrt(abs(y+x/2+47))) -x .* sin(sqrt(abs(x-(y+47))));
        surf(x,y,z);
        %view(180,90);        
        view(-30,130);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        for i=1:NP
          text(p(i,1),p(i,2),fo(p(i,:)),'*','HorizontalAlignment','left','FontWeight','bold','Color','red','fontsize',20); 
        end
        for i=1:NP
          text(x1(i,1),x1(i,2),fo(x1(i,:)),'*','HorizontalAlignment','left','FontWeight','bold','Color','green','fontsize',20); 
        end  
        text(opt(1),opt(2),fo(opt),'\leftarrow O* Melhor Atual','HorizontalAlignment','left','FontWeight','bold','Color','blue','fontsize',20);
        text(optb(1),optb(2),fo(optb),'\leftarrow O* Ponto Ótimo','HorizontalAlignment','left','FontWeight','bold','Color','black','fontsize',20);
        set(gca, 'linewidth', 4, 'fontsize', 12);
	      pause(.1);
        rc++;
   end
   
   fprintf('\nPopulação Inicial:\n');
   p
   fprintf('\nPopulação Final:\n');
   x1 
   fprintf('\nGeração Final:\n');
   g
   
   fprintf('\nMelhor Solução:\n');
    opt
   fprintf('\nSolução Ótima:\n');
   optb
   fprintf('\nCusto Mínimo:\n');
   fo(optb)
   min(c1)
   figure(1);
   plot(xp,dataPlot(:,2)','--gs','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5],'lineWidth',4,xp,dataPlot(:,1)','g-','lineWidth', 4,'MarkerSize',10);
    
    figure(2);
   plot(xp,dataPlot(:,3)','-r','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5],'lineWidth',4);
   ylim([-1 T0]);
   set(gca, 'linewidth', 4, 'fontsize', 12);
   figure(3);
 [x,y] = meshgrid(min(L):max(U)*0.01:max(U));
   %fo1
  %z = x.^2+y.^2;
  %egg
  z = -(y+47) .* sin(sqrt(abs(y+x/2+47))) -x .* sin(sqrt(abs(x-(y+47))));
  surf(x,y,z);
  %view(180,90);
  view(-30,130);
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
  for i=1:NP
      text(p(i,1),p(i,2),fo(p(i,:)),'*','HorizontalAlignment','left','FontWeight','bold','Color','red','fontsize',20); 
  end
  for i=1:NP
      text(x1(i,1),x1(i,2),fo(x1(i,:)),'*','HorizontalAlignment','left','FontWeight','bold','Color','green','fontsize',20); 
  end  
  text(opt(1),opt(2),fo(opt),'\leftarrow O* Melhor Atual','HorizontalAlignment','left','FontWeight','bold','Color','blue','fontsize',20);
  text(optb(1),optb(2),fo(optb),'\leftarrow O* Ponto Ótimo','HorizontalAlignment','left','FontWeight','bold','Color','black','fontsize',20);
  res = [optb fval];
end
