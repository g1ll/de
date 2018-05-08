%Algoritmo de otimização Differential Evolution
function res = de(fo,L,U)
    D = length(L);      %Dimensão do problema (número de variáveis)
    NP = 10;            %Número de indivíduos na população (Number Population)
    CR = 0.9;           %Parâmetro de Cruzamento (Crossover Constant  [0,1])
    F = 1.5;            %Fator de mutação (Factor of Differential Variation [0,2])
    NG = 200;            %Numero de gerações

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
	      if(ct>=c1(i))
            ct= c1(i);
            opt=x1(i,:);
        end
    end
    p = x1;
    
    fprintf('\nPopulação  Inicial:\n');
    x1
    
    fprintf('\nCusto da População Inicial:\n');
    c1'
    
    dataPlot = [];
   for g = 1:NG
        for i=1:NP
            %Sorteando indices dos vetores escolhidos aleatoriamente
            a= NP-floor(rand()*(NP-1)); while (a==i) a=NP-floor(rand()*(NP-1)); end;
            b= NP-floor(rand()*(NP-1)); while (b==i || b==a)  b= NP-floor(rand()*(NP-1)); end;
            c= NP-floor(rand()*(NP-1)); while (c==i || c==b || c==a) c= NP-floor(rand()*(NP-1)); end;
            j= D-floor(rand()*D); %Escolhendo uma variável aleatória para a mutação
            %j,a,b,c            
            for k = 1:D                                
                if (rand()<CR || k==D)                    
                    trial(j)=x1(c,j)+F*(x1(a,j)-x1(b,j));
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
            if(ct<=c1(i))
                x2(i,:) = trial;
                c1(i) = ct;
            else
                x2(i,:) = x1(i,:);
            end 

	          if(fo(opt)>=c1(i))
		         opt = x2(i,:);
	          end          
        end
        x1 = x2;
        
       fprintf('\nPopulação Atual:\n');
       x1 
       fprintf('\nGeração:\n');
       g
	
       fprintf('\nÓtimo:\n');	
	      opt
	
	      fprintf('\nFO Ótimo:\n');	
	      fval = fo(opt)
 
       fprintf('\n------------------------------------------------------------:\n');
       
       %salvando dados
       if isempty(dataPlot)
            dataPlot = [max(c1),min(c1)];
       else
            dataPlot = [dataPlot;max(c1),min(c1)];
       end
        %plotando
        xp = 1:1:length(dataPlot(:,1));
        figure(1);
        plot(xp,dataPlot(:,2)','--gs','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5],'lineWidth',4,xp,dataPlot(:,1)','g-','lineWidth', 4,'MarkerSize',10);
        %ylim([-1 10]);
        set(gca, 'linewidth', 4, 'fontsize', 12);
        
        figure(2); 
        
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
        text(opt(1),opt(2),fo(opt),'\leftarrow O* Ponto Ótimo','HorizontalAlignment','left','FontWeight','bold','Color','black','fontsize',20); 
        set(gca, 'linewidth', 4, 'fontsize', 12);
	      pause(.1);
   end
   
   fprintf('\nPopulação Inicial:\n');
   p
   fprintf('\nPopulação Final:\n');
   x1 
   fprintf('\nGeração Final:\n');
   g
   
   
   fprintf('\nÓtimo:\n');	
   opt
	
	 fprintf('\nFO Ótimo:\n');	
	 fval = fo(opt)
   
   figure(1);
   plot(xp,dataPlot(:,2)','--gs','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5],'lineWidth',4,xp,dataPlot(:,1)','g-','lineWidth', 4,'MarkerSize',10);
        
   figure(2);
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
  text(opt(1),opt(2),fo(opt),'\leftarrow O* Ponto Ótimo','HorizontalAlignment','left','FontWeight','bold','Color','black','fontsize',20);
   res = [opt fval];
end
