%% extractie Stoptaak-data

% (c) Chris Vriend Oct 2014, major revision of version Stella de Wit, okt 2010,
%(origineel script: % Stoptaak_inclLivariab_7juni2011_met31_hand_clean_E_Laura.m)
% Maart 2013 aanpassing Chris Vriend mbt GO trials in SSRT42/SSRT36
% set(gcf,'visible','off') toegevoegd om figure output plots te onderdrukken
%---------------------------------------------------------------------------------------
%SSRT = gemGoRT - SSD (gem stop signal delay: hoe korter des te beter de
%response inhibitie

clear all
clc


% input variables
% -----------------------------------------------------------------------------

% inputdir='M:\Psychiatrie\Onderzoek ZvP\studie_814\Gedragsdata\MRI_Stop_b1\Behavioural_responses\input\'
% outputdir='M:\Psychiatrie\Onderzoek ZvP\studie_814\Gedragsdata\MRI_Stop_b1\Behavioural_responses\output\'

inputdir='N:\documenten\Surfdrive\VUmc_eigen_projecten\'
outputdir='N:\documenten\Surfdrive\VUmc_eigen_projecten\output\'

% Bergen first test
subjects{3}.stop=[1];

% Bergen T0
subjects{4}.stop=[1 2 3 4 5 6 7 8 9 10  ...
    11 12 13 14 15 16 17 18 19 21 22    ...
    23 24 26 27 28 29 33 34 35 36       ...
    38 41 42 43 44 45 46 47 48 49       ...
    50 51 52 53 54 55 56 57 59 60       ...
    61 62 63 64 65 66 67 68 69 70       ...
    72 74 78 80];

% Bergen T1
subjects{5}.stop=[1 3 4 6 7 8 9 10 11       ...
    12 13 14 16 17 18 21 22 26 28 29 33 34  ...
    35 36 42 43 44 45 46 47 48 50 51 52     ...
    53 55 56 57 59 60 61 62 63 64 65 66     ...
    68 70 72 78 80];

% Bergen T2
subjects{6}.stop=[1 3 4 6 7 8 9 10 11 13        ...
    14 16 17 18 21 22 24 26 28 29 33 34 35      ...
    36 42 43 44 45 46 47 48 50 51 53 55 56 57   ...
    59 60 61 63 64 65 66 68 70 72 78 80];

% 814
subjects{1}.stop=[31 35 39 43 45 47 49 53 55 59 63 65 67 69 6 16 18 20 24 34 36 40 44 48 64 66 72 78 86 94];
% 916
subjects{2}.stop=[2 4 8 10  12 14 16 18 20 22 24 26 28 30 32 34 36 40 42 50 52 54 56 58 60 62 64 66 68 70 72 76 ...
    78 80 82 84 86 88 92 94 96 5 7 11 13 15 19 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67 69 71 75 79 81 83 85];

% 429
% excluded 27, 33??

% 429
%  subjects=[1 3 6 8 10 15 16 18 20 24 31 34 35 36 39 40 ...
%      42 43 44 45 47 48 49 53 55 59 63 64 65 66 67 69 72 78 86 92 94 102]



% ---------------------------------------------------------------
%%

for S=[3]
    
    
    
    for x = subjects{1,S}.stop
        
        
        
        if S == 1
            st = '429';
        elseif S == 2
            st = '916';
        elseif S == 3
            st = '';
            timepoint = '_T0';
        elseif S == 4
            st = '';
            timepoint = '_T1';
        elseif S == 5
            st = '';
            timepoint = '_T2';
        end
        
        
        %load study specific files
        %file = ['C:\Documents and Settings\st.dewit\Desktop\Stop_xls\StopSubjOnsets_' num2str(st)];
        %load(file)
        
        %definieer xls bestand met ruwe data
        
        
        if x < 10
            fn = strcat(inputdir,'SST',num2str(st),'_0000', num2str(x),timepoint,'.xls');
        elseif x < 100
            fn = strcat(inputdir,'stop_',num2str(st),'_000', num2str(x),'.xls');
        else
            fn = strcat(inputdir,'stop_',num2str(st),'_', num2str(x),'.xls');
        end
        
        %lees dat bestand
        [NUMERIC,TXT,RAW]=xlsread(fn);
        
        %find kolom nummer van variabelen of interest, hernoem de variabelen
        %behorende bij de kolommen (eval..)
        colname = {'imgGo.OnsetTime', 'imgFixation.OnsetTime', 'StopStim', 'ACC', 'WaitForStart.RTTime', ...
            'imgFixation.RT', 'imgGo.Duration', 'imgStop.OnsetDelay', 'imgGo.OnsetDelay', 'Fix', 'imgStop.OnsetDelay'};
        
        rename = {'Goonsets', 'Fixonsets', 'Stop', 'Acc', 'Wfs', 'RTplus', 'SSDplus', 'StOnsDel', 'GoDelay', 'FixDur', 'StopDelay'};
        
        for c = 1:length(colname)
            n = 0;
            colfound = 0;
            while ~colfound
                n = n+1;
                colfound = length(strmatch(colname{c},TXT{1,n}));
                if n >200
                    break
                end
            end
            
            eval([rename{c} '= NUMERIC(:,n-1);']);
            
        end
        clear('c', 'n', 'colname', 'rename');
        
        %         fin1 = ['D:\stop\Gedrag\Stop_xcel\Stop_Go_list.xls'];
        %         hc = findhand(fin1);
        fin1 = xlsread(strcat(inputdir,'Stop_Go_list.xls'));
        
        % extract go stim
        hc = fin1(1:252,7);

        
        
        %Corrigeer onsets voor relatieve tijd binnen experiment: Goonsets Fixonsets (- Wfs & ./1000) in sec
        Go = (Goonsets - Wfs)./1000;
        Fix = (Fixonsets - Wfs)./1000;
        %zet de GoDurations om naar SSD, alleen op stoptrials, andere trials is 'ie
        %0
        %fout want SSD soms 1000, dus dit klopt niet (Foei Stella!!;
        %opgelost, alleen Go trials op 0 zetten!!)
        u = (Acc.*2)+ (Stop+1);
        u1 = [u, SSDplus];
        o = find((u1(:,1) == 1) | (u1(:,1) == 3));
        
        if length(o)
            SSDplus(o,1) = 0;
        end
        clear('o');
        %1000 (vorige 950 --> 1000 blijven);
        %1000 (vorige 50ms --> 0 worden);
        k = find((u1(:,1) == 2) | (u1(:,1) == 4));
        h = SSDplus(k);
        %h is all stop SSDs
        i = find(h(:,1) == 1000);
        
        if length(i)
            [a,c] = size(i);
            for j = 1:a
                if ((h(i(j)-1) == 50) | (h(i(j)-3) < 250));
                    h(i(j)) = 0;
                else
                    h(i(j)) = 1000;
                end
            end
        end
        
        clear('a', 'c', 'i', 'j');
        [a,c] = size(h)
        for i = 1:a
            j = k(i);
            SSDplus(j) = h(i);
        end
        clear('a', 'c', 'i', 'j', 'h', 'k');
        
        SSD = SSDplus;
        %de delay met correctie voor StopOnsetdelay (is soms 1 ms)
        
        %         SSDdel = SSDplus + StopDelay; BLIJKT FOUT!
        
        % Codering in taak = variabele Acc: 1 = goed, 0 = fout, Stop: 0 = nee (go-trial), 1 = ja (stoptrial).
        % Assign uniek variabele aan elke categorie (u): %(1) foute Go; (2) foute Stop; (3) goede Go; (4) goede Stop
        % zet de variabelen die je per conditie wilt (onsets Go en RT) in een
        % matrix met de unieke variabelen
        
        
        %failedStop min en max RT, NB dit is gerekend vanaf fixatiekruis
        %(dus RTplus) -> anticipatie, wil je ook aantal van weten?
        M = [u, RTplus, GoDelay, FixDur];
        f = find(M(:,1) == 2);
        k = min(M(f,2));
        g = find(M(f,2) == k);
        r = min(M(g,3));
        o = max(M(f,2));
        h = find(M(f,2) == o);
        s = min(M(h,3));
        BehData(x).minRTFailStop = [k - (500+r)];
        BehData(x).maxRTFailStop = [o - (500+s)];
        clear('M', 'f', 'g', 'h', 'k', 'o', 'r', 's');
        
        %NB onsets kunnen worden gegeven vanaf fixatiekruis --> soms al respons
        %vóórdat stimulus in beeld is --> die op 0 zetten
        %(dus RTplus - (FixDur(500ms) + GoOnsetDelay (ca 17ms))
        %ook bij geen respons --> RT = 0 (als mensen <50 ms reageren =
        %natuurlijk ook al anticipatie, maar ja what to do?)
        FixDur1 = (GoDelay + FixDur);
        M = [RTplus, FixDur1];
        m = find(M(:,1) < M(:,2));
        
        
        
        if length(m);
            RTplus(m,1) = 0;
        end
        
        l = find((M(:,1) == M(:,2)) | (M(:,1) > M(:,2)))
        if length(l);
            RTplus(l,1) = (RTplus(l,1) - M(l,2));
        end
        
        clear('m', 'M');
        
        
        %NB RT is dus in ms; en gecorrigeerd voor de Fixation Duration en
        %Go Onset Delay
        RT = RTplus;
        
        X = [u, Go, RT, SSD];
        %hc: 2 = L, 3 = R pijl
        %BehData(x).SSDstart = X(15,4)
        
        %Set up a loop voor het aantal condities:
        %ONSETS.Go
        %ONSETS.Stop
        %ONSETS.cond(1).onsets = FailGo --> .FailGoWithResp; .FailGoNoResp
        %ONSETS.cond(2).onsets = FailStop --> .AccFailStop; .InAccFailStop
        %ONSETS.cond(3).onsets = SucGo
        %ONSETS.cond(4).onsets = SucStop
        %ONSETS.cond(1-4).RTlist = lists all RT
        %ONSETS.cond(1-4).SSDlist = lists all SSD (=0 voor cond 1&3)
        %ONSETS.SSD = lists all SSD's of the stoptrials
        %ONSETS.fix = fixatie onsets
        
        % selecteer alle STOP trials == f
        f = find(X(:,1) == 2 | (X(:,1) == 4));
        c = X(f,2);
        ONSETS(x).Stop = [c'];
        [a, b] = size(f);
        BehData(x).numbStop = a;
        clear('f', 'a', 'b', 'c');
        
        % selecteer alle GO trials == f
        f = find(X(:,1) == 1 | (X(:,1) == 3));
        c = X(f,2);
        ONSETS(x).Go = [c];
        [a, b] = size(f)
        BehData(x).numbGo = a
        clear('f', 'a', 'b', 'c');
        
        ncond = 4;
        for n = 1:ncond
            
            %now find the rows with this particular condition
            f = find(X(:,1) == n);
            
            %aleen als bepaalde conditie bestaat, dan wil je hem opslaan
            if length(f)
                
                %now extract the onsets from these rows and stick them in a structure
                %called ONSETS
                ONSETS(x).cond(n).onsets = X(f,2);
                ONSETS(x).cond(n).RTlist = X(f,3);
                %ONSETS(x).RT(n) = mean(X(f,3));
                ONSETS(x).cond(n).SSDlist = X(f,4);
                %                 ONSETS(x).cond(n).SSDdellist = X(f,5);
                %ONSETS(x).mSSD = mean(X(f,4));
                BehData(x).mRT(n) = mean(X(f,3));
            else
                ONSETS(x).cond(n).onsets = [ ];
                ONSETS(x).cond(n).RTlist = [ ];
                %ONSETS(x).RT(n) = mean(X(f,3));
                ONSETS(x).cond(n).SSDlist = [ ];
                %                 ONSETS(x).cond(n).SSDdellist = [ ];
                %ONSETS(x).mSSD = mean(X(f,4));
                BehData(x).mRT(n) = 0;
            end
        end
        clear('f', 'n', 'q', 'd');
        
        %% Failed Stops:
        for n=2
            %NB sommige failstop al gedrukt voor Go in beeld is,
            %deze wil je niet meenemen, immers nog geen Go signal
            %gezien, SSD is dan niet goed getimed: vraag: wat
            %gebeurt er dan? (denk dat timing op fixatie een
            %probleem is voor accurate SSD bepaling? Ja: dan geteld als fail stop en SSD +50ms [BV: 916_043 trial 91])
            %hc: 2 = left, 3  = right
            f = find(X(:,1) == n);
            %        X = [u, Go, RT, SSD, SSDdel, hc];
            %over hele mx
            Xm = [X(:,:), hc];
            Xf = Xm(f,:);
            g = find(Xf(:,5) == 2);
            [a, b] = size(g);
            BehData(x).numbFailStop_left = a;
            %h = find(Xf(:,6) == 3);
            %                [r, s] = size(h);
            %                 BehData(x).numbFailStop_right = r;
            clear('a', 'b', 'g', 'Xf')
            
            ONSETS(x).cond(2).onsets = X(f,2);
            d = find((X(:,1) == 2) & (X(:,3) > 0)); %
            if length(d) > 0
               ONSETS(x).cond(n).AccFailStop = X(d,2);
            end
            e = find((X(:,1) == 2) & (X(:,3) == 0));
            if length(e)
                ONSETS(x).cond(n).InAccFailStop = X(e,2);
            end
            
            % toevoeging mei 14
            
            abc=f(f<92); %
            def=f(f>=92 & f<154) ;
            ghi=f(f>=154 & f<199);
            jkl=f(f>=199);%
            BehData(x).failedstopRT12list=sort(X(abc,3));
            BehData(x).failedstopRT24list=sort(X(def,3));
            BehData(x).failedstopRT36list=sort(X(ghi,3));
            BehData(x).failedstopRT48list=sort(X(jkl,3));
            
            
            
            BehData(x).mFailStopAccRT = mean(X(d,3));
            BehData(x).medFailStopAccRT = median(X(d,3));
            [a, b] = size(f);
            BehData(x).numbFailStop = a;
            [r, s] = size(d);
            BehData(x).numbAccFailStop = r;
            BehData(x).numbFailStop_pLeft = (BehData(x).numbFailStop_left ./a) *100 ;
            
        end
        clear('f', 'n', 'a', 'b', 'd','e', 'r', 's');
        clear abc def ghi jkl
        %% Succesful Go's: mRT SucGo
        for n = 3
            f = find(X(:,1) == n);
            BehData(x).mSucGoRT = mean(X(f,3));
            BehData(x).SucGORT_ranked=sort(X(f,3)); % toevoeging t.a.v Quantile method
            BehData(x).medSucGoRT = median(X(f,3));
            [c, d] = size(f);
            BehData(x).numbSucGo = c;
            
            BehData(x).dtSucGoRTlist = sort(detrend(X(f,3)));
            BehData(x).dtSucGoRTlist_v2 = sort((X(f,3)-detrend(X(f,3))));
            BehData(x).dtmSucGoRT = mean(detrend(X(f,3)));
            BehData(x).dtmedSucGoRT = median(detrend(X(f,3)));
            
            %------------------------------------
            % toevoeging mei 14
            abc=f(f<92) % sucGO trials tussen stop [0-12] ook GO trials voor eerste stop
            def=f(f>=92 & f<154) % sucGO trials tussen stop [13-24]
            ghi=f(f>=154 & f<199) % sucGO trials tussen stop [25-36]
            jkl=f(f>=199)% % sucGO trials na stop 37 (-48)
            BehData(x).SucGORT12list=sort(X(abc,3));
            BehData(x).SucGORT24list=sort(X(def,3));
            BehData(x).SucGORT36list=sort(X(ghi,3));
            BehData(x).SucGORT48list=sort(X(jkl,3));
            
            
            BehData(x).numbsucgo12=length(abc);
            BehData(x).numbsucgo24=length(def);
            BehData(x).numbsucgo36=length(ghi);
            BehData(x).numbsucgo48=length(jkl);
            
            
            clear abc def ghi jkl
            
            
            g= find(X(:,1) == 1) % 1= foute go
            numbfailgo12=length(g(g<92));
            numbfailgo24=length(g(g>=92 & g<154)); % failgo trials tussen stop [13-24]
            numbfailgo36=length(g(g>=154 & g<199)); % failGO trials tussen stop [25-36]
            numbfailgo48=length(g(g>=199));% % failGO trials na stop 37 (-48)
            
            BehData(x).pfailgo12=numbfailgo12/(numbfailgo12+BehData(x).numbsucgo12);
            BehData(x).pfailgo24=numbfailgo24/(numbfailgo24+BehData(x).numbsucgo24);
            BehData(x).pfailgo36=numbfailgo36/(numbfailgo36+BehData(x).numbsucgo36);
            BehData(x).pfailgo48=numbfailgo48/(numbfailgo48+BehData(x).numbsucgo48);
            
            
            %             %% aanpassingen zodat m/med sucGORT wordt berekend voor alleen GO trials tussen stop[6-48] en [12-48].
            %
            abc = f.*(f>49); % select sucGO trials tussen stop[6-48] voor SSRT42
            def = f.*(f>91); % select sucGO trials tussen stop[12-48]voor SSRT36
            uvw = abc(abc>0); % nieuwe variabele met alleen de regels met goede go trials
            xyz = def(def>0); % nieuwe variabele met alleen de regels met goede go trials
            BehData(x).mSucGoRT42 = mean(X(uvw,3));
            BehData(x).medSucGoRT42 = median(X(uvw,3));
            BehData(x).mSucGoRT36 = mean(X(xyz,3));
            BehData(x).medSucGoRT36 = median(X(xyz,3));
            
            
        end
        clear('f', 'n', 'c', 'd', 'abc','def','uvw','xyz');
        
        
        %% Succesvolle Go's sorteren volgens Li 2009:
        % hij heeft: Go's: post-Go, post-FalseGo, post-SSi(incr RT),
        % post-SSni(not incr RT), post-SEi, post-SEni
        %(en daarnaast F, SE, SS)
        %X = [u, Go, RT, SSD, SSDdel];
        %(u): %(1) foute Go; (2) foute Stop; (3) goede Go; (4) goede Stop
        %pF = 1, psG=3; pGi(3,1), pGni(3,0), pSEi(2,1) pSEni(2,0) pSSi(4,1), pSSni(4,0)
        clear('a');
        n = 3
        f = find(X(:,1) == n);
        [a, c] = size(f);
        m = zeros(a,2);
        mg = zeros(a,1);
        %1st 11 trials: pG decrease maken
        for l = 1:10
            m(l,1) = 3;
            m(l,2) = 0;
            mg(l,1) = X(f(l),3);
        end
        
        for i = 11:1:a;
            %for i = (a-1):a
            %vergelijk RT van Go trial met mediaan RT van 10 Go-trials
            %ervoor --> Niet zo afhankelijk van slope van attentional
            %lapsing (met wrs verschillend effect op mean RT tussen proefpersonen;
            %detrending ook een idee?); en je kijkt toch in directe trial
            %omgeving, maar met mediaan van 10 trials ervoor toch niet zo
            %gevoelig voor outliers
            
            CurMean = median(X(f((i-10):i),3));
            if X(f(i),3) > CurMean;
                m(i,2) = 1;
            else
                m(i,2) = 0;
            end
            
            %pF = 1
            if X((f(i)-1),1) == 1;
                m(i,1) = 1;
            end
            
            %pSE 1e kolom m = 2
            if X((f(i)-1),1) == 2;
                m(i,1) = 2;
            end
            clear('b', 'd', 'e', 'g');
            
            %pSS
            if X((f(i)-1),1) == 4;
                m(i,1) = 4;
            end
            
            %pG = 3
            %pSS
            if X((f(i)-1),1) == 3;
                m(i,1) = 3;
            end
            
            mg(i,1) = CurMean;
            clear('CurMean')
        end
        
        clear('a')
        
        a = figure;
        set(gcf,'visible','off')
        plot(mg);
        if x < 10
            filename1 = strcat(outputdir,'CurMean_time_',num2str(st),'_00',num2str(x));
        elseif x < 100
            filename1 = strcat(outputdir,'CurMean_time_',num2str(st),'_0',num2str(x));
        else
            filename1 = strcat(outputdir,'CurMean_time_',num2str(st),'_',num2str(x));
        end
        %print(a, '-dpsc', filename1);
        %         saveas(a, [filename1 '.fig'])
        saveas(a, [filename1 '.jpeg'])
        close
        clear('a', 'filename1', 'mg');
        
        %X = [u, Go, RT, SSD];
        %MLi: u Onset p-code, in/decr code
        MLi = [X(f,1), X(f,2), m, X(f,3), Xm(f,5)];
        [ML, ix] = sortrows(MLi,[3 4]);
        
        %pF = 1, psG=3; pGi(3,1), pGni(3,0), pSEi(2,1) pSEni(2,0) pSSi(4,1), pSSni(4,0)
        %SE(ONSETS(x).cond(2).ons;),SS(ONSETS(x).cond(4).onsets;),F
        %ONSETS(x).Li(1).all
        %FailGo's en pF-Go's niet meenemen, heel veel mensen hebben dit
        %soort trials niet.
        for n = 2:4;
            f = find(MLi(:,3) == n);
            [a, c] = size(f);
            BehData(x).Li(n).numball = a;
            ONSETS(x).Li(n).all = MLi(f,2);
            if n == 3
                pG_meanRT = mean(MLi(f,5));
                pG_medianRT = median(MLi(f,5));
                
                %splits link en rechts uit
                Xg = MLi(f,:);
                h = find(Xg(:,6) == 2);
                j = find(Xg(:,6) == 3);
                %[a, b] = size(h);
                BehData(x).pG_meanRT_left = mean(MLi(h,5));
                BehData(x).pG_meanRT_right = mean(MLi(j,5));
                pG_meanRT_left = BehData(x).pG_meanRT_left;
                pG_meanRT_right = BehData(x).pG_meanRT_right;
                
                clear('a', 'b', 'h', 'j', 'Xg');
                
            end
            clear('a', 'c', 'f');
            
            f = find((MLi(:,3) == n) & (MLi(:,4) == 1));
            [a, c] = size(f);
            BehData(x).Li(n).numbi = a;
            ONSETS(x).Li(n).i = MLi(f,2);
            if n == 2
                pSEi_meanRT = mean(MLi(f,5));
                pSEi_medianRT = median(MLi(f,5));
            end
            
            if n == 4
                pSSi_meanRT = mean(MLi(f,5));
                pSSi_medianRT = median(MLi(f,5));
            end
            clear('a', 'c', 'f');
            
            f = find((MLi(:,3) == n) & (MLi(:,4) == 0));
            [a, c] = size(f);
            BehData(x).Li(n).numbni = a;
            ONSETS(x).Li(n).ni = MLi(f,2);
            if n == 2
                pSEni_meanRT = mean(MLi(f,5));
                pSEni_medianRT = median(MLi(f,5));
            end
            
            if n == 4
                pSSni_meanRT = mean(MLi(f,5));
                pSSni_medianRT = median(MLi(f,5));
            end
            clear('a', 'c', 'f');
            
        end
        
        f = find((MLi(:,3) == 2) | (MLi(:,3) == 4));
        [a, c] = size(f);
        BehData(x).Li(5).numbpStop = a;
        ONSETS(x).Li(5).pStop = MLi(f,2);
        pStop_meanRT = mean(MLi(f,5));
        pStop_medianRT = median(MLi(f,5));
        clear('a', 'c', 'f');
        clear('n', 'Mli', 'ML', 'ix')
        
        %Succesful Stops: m Stop Signal Delay
        for n = 4
            e = find(X(:,1) == n);
            [v, w] = size(e);
            BehData(x).numbSucStop = v;
        end
        clear('f', 'n', 'v', 'w');
        % voor allee stoptrial: vindt de gemiddelde SSD
        %X = [u, Go, RT, SSD, SSDdel];
        f = find((X(:,1) == 2) | (X(:,1) == 4));
        %SSRT door de tijd
        stops = f;
        B = zeros(length(RT),1);
        
        gort = X(1:(f(1,1)),3);
        ssd = X(f(1,1),4);
        B((1:f(1,1)),1) = gort(:,:)- ssd;
        clear('ssd', 'gort');
        
        for i = 2:length(f);
            gort = X((f((i-1),1)+1):(f(i,1)),3);
            ssd = X(f(i,1),4);
            B(((f(i-1,1))+1):(f(i,1)),1) = gort(:,:)- ssd;
            clear('ssd', 'gort')
        end
        
        %laatste rits, laatste i
        gort = X(((f(i,1))+1):length(RT),3)
        ssd = X(f(i,1),4);
        B(((f(i,1))+1):length(RT)) = gort(:,:)- ssd;
        clear('ssd', 'gort', 'i');
        Xs = [X, B];
        clear('B', 'i')
        
        b = f(24:48,1)
        c = f(12:48,1)
        cc = f(6:48,1)
        ONSETS(x).SSD = X(f,4);
        %         ONSETS(x).SSDdel = X(f,5);
        BehData(x).mSSD = mean(X(f,4));
        
        
        %         BehData(x).mSSDdel = mean(X(f,5));
        %         BehData(x).mSSDdel24 = mean(X(b,5));
        %         BehData(x).mSSDdel36 = mean(X(c,5));
        %         BehData(x).mSSDdel42 = mean(X(cc,5));
        %         BehData(x).medSSDdel42 = median(X(cc,5));
        
        
        %         BehData(x).mSSDdel = mean(X(f,5));
        BehData(x).mSSD24 = mean(X(b,4));
        BehData(x).mSSD36 = mean(X(c,4));
        BehData(x).mSSD42 = mean(X(cc,4));
        BehData(x).medSSD42 = median(X(cc,4));
        
        
        % toevoeging Mei 14
        cc12=f(1:12,1);
        cc24=f(13:24,1);
        cc36=f(25:36,1);
        cc48=f(37:48,1);
        
        %meanSSD
        %         BehData(x).mSSDdel12=mean(X(cc12,5));
        %         BehData(x).mSSDdel24=mean(X(cc24,5));
        %         BehData(x).mSSDdel36=mean(X(cc36,5));
        %         BehData(x).mSSDdel48=mean(X(cc48,5));
        
        BehData(x).mSSD12=mean(X(cc12,4));
        BehData(x).mSSD24=mean(X(cc24,4));
        BehData(x).mSSD36=mean(X(cc36,4));
        BehData(x).mSSD48=mean(X(cc48,4));
        
        
        g= find(X(:,1) == 2) % foute stop
        h= find(X(:,1) == 4) % suc stop
        
        
        
        abc=g(g<93) % foute stop tussen 1-12
        def=h(h<93) % suc stop tussen 1-12
        ghi=g(g>=93 & g<155) % foute stop tussen 13-24
        jkl=h(h>=93 & h<155) % suc stop tussen 13-24
        mno=g(g>=155 & g<200) % foute stop tussen 25-36
        pqr=h(h>=155 & h<200) % suc stop tussen 25-36
        stu=g(g>=200)% % foute stop tussen 37-48
        vwx=h(h>=200)% % suc stop tussen 37-48
        
        if length(abc)+length(def)~=12
            error('ratio suc / fail stop not corect row 856')
        elseif length(ghi)+length(jkl)~=12
            error('ratio suc / fail stop not corect row 856')
            
        elseif length(mno)+length(pqr)~=12
            error('ratio suc / fail stop not corect row 856')
        elseif length(stu)+length(vwx)~=12
            error('ratio suc / fail stop not corect row 856')
        end
        
        BehData(x).pfailstop12=length(abc)/12;
        BehData(x).pfailstop24=length(ghi)/12;
        BehData(x).pfailstop36=length(mno)/12;
        BehData(x).pfailstop48=length(stu)/12;
        
        
        %---------------------------------------
        
        
        
        BehData(x).minSSD = min(X(f,4));
        m = min(X(f,4));
        l = find(X(:,4) == m);
        BehData(x).latestminSSD = max(l);
        BehData(x).earliestminSSD = min(l);
        
        BehData(x).maxSSD = max(X(f,4));
        k = max(X(f,4));
        p = find(X(:,4) == k);
        BehData(x).earliestmaxSSD = min(p);
        BehData(x).latestmaxSSD = max(p);
        clear('k', 'l', 'm', 'p');
        
        
        
        BehData(x).medSSD = median(ONSETS(x).SSD);
        
        
        %maak X met hc, interfereert met SSRT
        %Xs = [u, Go, RT, SSD, SSDdel, SSRT];
        for n = 3
            p = find(Xs(:,1) == n);
            BehData(x).SSRTlist = (Xs(p,5));
            %             BehData(x).meanSSRT = median(X(f,3));
            %             [c, d] = size(f);
            %             BehData(x).numbSucGo = c;
            %             BehData(x).dtSucGoRTlist = detrend(X(f,3))
            %             BehData(x).dtmSucGoRT = mean(detrend(X(f,3)));
            %             BehData(x).dtmedSucGoRT = median(detrend(X(f,3)));
            j = length(p)
            if j > 190
                l = 100;
            else
                l = 50;
            end
            BehData(x).mSSRTall = mean(Xs(p,5));
            BehData(x).mSSRTsplit = mean(Xs(p(l:j),5));
            
            contSSRTall = BehData(x).mSSRTall;
            contSSRTsplit = BehData(x).mSSRTsplit;
            clear('p')
        end
        
        a = figure;
        plot(ONSETS(x).SSD);
        set(gcf,'visible','off');
        if x < 10
            filename1 = strcat(outputdir,'SSD_time_',num2str(st),'_00',num2str(x));
            filename2 = strcat(outputdir,'SSD_hist_',num2str(st),'_00',num2str(x));
            filename3 = strcat(outputdir,'SucGoRT_hist_',num2str(st), '_00',num2str(x));
            filename4 = strcat(outputdir,'SucGoRT_time_',num2str(st),'_00',num2str(x));
            filename5 = strcat(outputdir,'dtSucGoRT_time_',num2str(st),'_00',num2str(x));
            filename6 = strcat(outputdir,'dtSucGoRT_hist_',num2str(st),'_00',num2str(x));
            filename7 = strcat(outputdir,'SSRT_hist_',num2str(st),'_00',num2str(x));
            filename8 = strcat(outputdir,'SSRT_time_',num2str(st),'_00',num2str(x));
        elseif x < 100
            filename1 = strcat(outputdir,'SSD_time_',num2str(st),'_0',num2str(x));
            filename2 = strcat(outputdir,'SSD_hist_',num2str(st),'_0',num2str(x));
            filename3 = strcat(outputdir,'SucGoRT_hist_',num2str(st), '_0',num2str(x));
            filename4 = strcat(outputdir,'SucGoRT_time_',num2str(st),'_0',num2str(x));
            filename5 = strcat(outputdir,'dtSucGoRT_time_',num2str(st),'_0',num2str(x));
            filename6 = strcat(outputdir,'dtSucGoRT_hist_',num2str(st),'_0',num2str(x));
            filename7 = strcat(outputdir,'SSRT_hist_',num2str(st),'_0',num2str(x));
            filename8 = strcat(outputdir,'SSRT_time_',num2str(st),'_0',num2str(x));
        else
            filename1 = strcat(outputdir,'SSD_time_',num2str(st),'_',num2str(x));
            filename2 = strcat(outputdir,'SSD_hist_',num2str(st),'_',num2str(x));
            filename3 = strcat(outputdir,'SucGoRT_hist_',num2str(st), '_',num2str(x));
            filename4 = strcat(outputdir,'SucGoRT_time_',num2str(st),'_',num2str(x));
            filename5 = strcat(outputdir,'dtSucGoRT_time_',num2str(st),'_',num2str(x));
            filename6 = strcat(outputdir,'dtSucGoRT_hist_',num2str(st),'_',num2str(x));
            filename7 = strcat(outputdir,'SSRT_hist_',num2str(st),'_',num2str(x));
            filename8 = strcat(outputdir,'SSRT_time_',num2str(st),'_',num2str(x));
        end
        
        %         print(a, '-dpsc', filename1);
        %         saveas(a, [filename1 '.fig'])
        saveas(a, [filename1 '.jpeg'])
        close
        clear('a');
        b = figure;
        set(gcf,'visible','off')
        hist(ONSETS(x).SSD);
        
        %print(b, '-dpsc', filename2);
        %         saveas(b, [filename2 '.fig'])
        saveas(b, [filename2 '.jpeg'])
        close
        clear('b');
        %save(plot(ONSETS(x).SSD), )
        %hist(ONSETS(x).SSD)
        c = figure
        set(gcf,'visible','off')
        hist(ONSETS(x).cond(3).RTlist);
        %         saveas(c, [filename3 '.fig']);
        saveas(c, [filename3 '.jpeg']);
        close
        clear('c')
        
        d = figure
        set(gcf,'visible','off')
        plot(ONSETS(x).cond(3).RTlist);
        BehData(x).sucGOregression=polyfit(1:1:length(ONSETS(x).cond(3).RTlist),transpose(ONSETS(x).cond(3).RTlist),1)
        %         saveas(d, [filename4 '.fig']);
        saveas(d, [filename4 '.jpeg']);
        close
        clear('d')
        
        e = figure
        set(gcf,'visible','off')
        plot(BehData(x).dtSucGoRTlist);
        %         saveas(e, [filename5 '.fig']);
        saveas(e, [filename5 '.jpeg']);
        close
        clear('e')
        
        e = figure
        set(gcf,'visible','off')
        hist(BehData(x).dtSucGoRTlist);
        %         saveas(e, [filename6 '.fig']);
        saveas(e, [filename6 '.jpeg']);
        close
        clear('e')
        
        e = figure
        set(gcf,'visible','off')
        hist(BehData(x).SSRTlist);
        %         saveas(e, [filename7 '.fig']);
        saveas(e, [filename7 '.jpeg']);
        close
        clear('e')
        
        e = figure
        set(gcf,'visible','off')
        plot(BehData(x).SSRTlist);
        %         saveas(e, [filename8 '.fig']);
        saveas(e, [filename8 '.jpeg']);
        close
        clear('e')
        
        clear ('f');
        %save('b', ['SSD_hist_' num2trs(x)])
        
        %Failed Go's:
        % mean Fail Go RT, waar wél is gedrukt en waar niet is gedrukt (als vóór
        % pijl onset hebben gedrukt dan als "no resp" gecodeerd
        
        n = 1
        g = find(X(:,1) == n);
        if length(g)
            %g = [g]%
            %p = ISEMPTY(g)
            %if p == 0
            %1= g is empty, 0 = g is not empty
            %if p < 1
            
            %over hele mx
            Xg = Xm(g,:);
            h = find(Xg(:,5) == 2);
            [a, b] = size(h);
            BehData(x).numbFailGo_left = a;
            clear('a', 'b', 'h')
            
            [r, c] = size(g);
            BehData(x).numbFailGo = r;
            BehData(x).numbFailGo_pLeft = (BehData(x).numbFailGo_left ./r) *100;
            
            
            h = find((X(:,1) == n) & (X(:,3) > 0));
            ONSETS(x).cond(n).FailGoRTlist = X(h,3);
            ONSETS(x).cond(n).FailGoWithResp = X(h,3);
            [j, k] = size(h);
            BehData(x).numbFailGoWithResp = j;
            if j > 0
                BehData(x).mFailGoWithRespRT = mean(X(h,3));
                BehData(x).medFailGoWithRespRT = median(X(h,3));
            else
                BehData(x).mFailGoWithRespRT = 0;
                BehData(x).medFailGoWithRespRT = 0;
            end
            
            i = find((X(:,1) == n) & (X(:,3) == 0));
            ONSETS(x).cond(n).FailGoNoResp = X(i,3);
            
        else
            BehData(x).numbFailGo = 0;
            BehData(x).numbFailGoWithResp = 0;
            BehData(x).mFailGoWithRespRT = 0;
            BehData(x).medFailGoWithRespRT = 0;
            h = 0;
            i = 0;
            BehData(x).numbFailGo_left = 0;
            BehData(x).numbFailGo_pLeft = 0;
        end
        
        
        clear('n', 'h', 'i', 'k', 'j', 'r', 'c')
        
        BehData(x).startSSD = ONSETS(x).SSD(1);
        % SSRT:
        numbGo = BehData(x).numbGo;
        numbStop = BehData(x).numbStop;
        
        mSSRT = (BehData(x).mSucGoRT - BehData(x).mSSD);
        medSSRT = (BehData(x).mSucGoRT - BehData(x).medSSD);
        %         mSSRTdel = (BehData(x).mSucGoRT - BehData(x).mSSDdel);
        %         medSSRTdel = (BehData(x).mSucGoRT - BehData(x).medSSDdel);
        %
        
        
        SSRT24 = (BehData(x).medSucGoRT - BehData(x).mSSD24);
        SSRT36 = (BehData(x).medSucGoRT - BehData(x).mSSD36);
        SSRT42 = (BehData(x).medSucGoRT - BehData(x).mSSD42);
        mSSD24 = BehData(x).mSSD24;
        mSSD36 = BehData(x).mSSD36;
        mSSD42 = BehData(x).mSSD42;
        medSSD42 = BehData(x).medSSD42;
        
        BehData(x).mSSRT = mSSRT;
        BehData(x).medSSRT = medSSRT;
        % = BehData(x).mSSRT
        %medSSRT = BehData(x).medSSRT
        mSSD = BehData(x).mSSD;
        medSSD = BehData(x).medSSD;
        
        
        
        numbSucGo = BehData(x).numbSucGo;
        mSucGoRT = BehData(x).mSucGoRT;
        medSucGoRT = BehData(x).medSucGoRT;
        
        %aangepast CV
        mSucGoRT36= BehData(x).mSucGoRT36;
        mSucGoRT42 = BehData(x).mSucGoRT42;
        medSucGoRT36 = BehData(x).medSucGoRT36;
        medSucGoRT42 = BehData(x).medSucGoRT42;
        SSRT36_aGO = (BehData(x).medSucGoRT36 - BehData(x).mSSD36);
        SSRT42_aGO = (BehData(x).medSucGoRT42 - BehData(x).mSSD42);
        
        %
        
        dtmSucGoRT = BehData(x).dtmSucGoRT
        dtmedSucGoRT = BehData(x).dtmedSucGoRT
        
        
        numbFailGo = BehData(x).numbFailGo;
        %numbFailGoREsp is empty
        numbFailGoResp = BehData(x).numbFailGoWithResp;
        
        mFailGoRT = BehData(x).mFailGoWithRespRT;
        medFailGoRT = BehData(x).medFailGoWithRespRT;
        
        numbFailStop = BehData(x).numbFailStop;
        numbAccFailStop = BehData(x).numbAccFailStop;
        
        mAccFailStopRT = BehData(x).mFailStopAccRT;
        medAccFailStopRT = BehData(x).medFailStopAccRT;
        numbSucStop = BehData(x).numbSucStop;
        startSSD = ONSETS(x).SSD(1);
        minSSD = BehData(x).minSSD;
        latestminSSD = BehData(x).latestminSSD;
        earliestminSSD = BehData(x).earliestminSSD;
        maxSSD = BehData(x).maxSSD;
        earliestmaxSSD = BehData(x).earliestmaxSSD;
        latestmaxSSD = BehData(x).latestmaxSSD;
        
        minRTFailStop = BehData(x).minRTFailStop;
        maxRTFailStop = BehData(x).maxRTFailStop;
        
        minSSD = BehData(x).minSSD;
        latestminSSD = BehData(x).latestminSSD;
        earliestminSSD = BehData(x).earliestminSSD;
        maxSSD = BehData(x).maxSSD;
        earliestmaxSSD = BehData(x).earliestmaxSSD;
        latestmaxSSD = BehData(x).latestmaxSSD;
        
        
        
        BehData(x).Li(3).pG_meanRT = pG_meanRT;
        BehData(x).Li(3).pG_medianRT = pG_medianRT;
        
        numbpStop = BehData(x).Li(5).numbpStop;
        BehData(x).Li(5).pStop_meanRT = pStop_meanRT;
        BehData(x).Li(5).pStop_medianRT = pStop_medianRT;
        
        % SSRT (SucStop), SSD = mean onsets Stop,
        %RT correct stop = 0
        
        %stop fix onsets ook in de structuur ONSETS
        ONSETS(x).fix = Fix;
        
        numbFailGo_left = BehData(x).numbFailGo_left;
        numbFailGo_pLeft = BehData(x).numbFailGo_pLeft;
        numbFailStop_left = BehData(x).numbFailStop_left;
        numbFailStop_pLeft = BehData(x).numbFailStop_pLeft;
        
        %Duration cond 1-4 zijn altijf 1.5 s, durations fix altijd 0.5 sec
        %met loaden en weer opslaan onsets(x) voeg je pp (x) toe aan het hoofd
        %bestand.
        %save('D:\Stoptaak\Gedrag\Stop_matt\StopSubjOnsets','ONSETS');
        %bitand returns here odd = 1, even = 0, odd = controles (group2), even =
        %OCD (group 1)
        if S == 1
            j = bitand(abs(x),1);
            if j == 1
                group = 2;
            else
                group = 1;
            end
        elseif S == 2
            j = bitand(abs(x),1);
            if j == 1
                group = 1;
            else
                group = 2;
            end
        else
            group = 3;
        end
        
        %maak mx met behav data, voor wegschrijven in xl sheet
        
        mx = [x, group, numbGo, numbStop, numbSucGo, numbFailGo, numbFailGoResp, numbSucStop, numbFailStop, numbAccFailStop, ...
            mSucGoRT, medSucGoRT, mFailGoRT, medFailGoRT, mAccFailStopRT, medAccFailStopRT, minRTFailStop, maxRTFailStop, ...
            mSSD, medSSD, mSSRT, medSSRT, startSSD, minSSD, earliestminSSD, latestminSSD, maxSSD, earliestmaxSSD, latestmaxSSD, ...
            SSRT24, mSSD24, dtmSucGoRT, dtmedSucGoRT, contSSRTall, contSSRTsplit, SSRT36, mSSD36, SSRT42, mSSD42, mSucGoRT36, ...
            mSucGoRT42, medSucGoRT36, medSucGoRT42, SSRT36_aGO, SSRT42_aGO, medSSD42];
        
        
        %NB data die er niet zijn worden van NaN naar 0 omgezet (hoeft
        %eigenlijk niet meer ivm >0w/v variabelen, maar extra check)
        n = isnan(mx);
        nan = find(n(1,:) == 1);
        if length(nan)
            mx(:,nan) = 0
        end
        
        file = strcat(outputdir,'StopSubjOnsets_',num2str(st));
        
        %p, omdat je een titel rij hebt in xls
        p = (x+1);
        cheese =strcat(outputdir,'Stop_BehData_',num2str(st),'.xls');
        stilton=strcat(outputdir,'Stop_BehData_',num2str(st));
        
        
        
        Alphabet=char('a'+(1:26)-1)';
        [I,J]=ndgrid(1:26,1:26);
        I=I'; J=J';
        al=[Alphabet(I(:)), Alphabet(J(:))];
        al=cellstr(upper(al));
        alfa=cellstr(upper(Alphabet));
        al=vertcat(alfa,al);
        %  al={upper(strvcat(Alphabet,al(1:16,:)))};
        
        firstcel = strcat('A',num2str(p));
        lastcel = strcat('I',num2str(p));
        bx=strcat(firstcel,':',lastcel);
        %save study specific beha data in .xls file for tranfer to SPSS
        feval('xlswrite',cheese,mx,bx)
        
        %save study specific output in .mat file for MRI analyis
        save(num2str(file), 'ONSETS');
        %save study specific behavioural data in .mat file for backup in matlab
        save(stilton,'BehData');
        
        
        %% QUANTILE METHOD
        % gebruik de ranked Go RT, zoek nth RT waarvoor geldt
        % pfailedStop* # sucGORT.
        % bereken SSRT volgens nth RT - mean SSD
        
        pfailgo=(BehData(1,x).numbFailGo/BehData(1,x).numbGo);
        %
        pfailstop=(BehData(1,x).numbAccFailStop/BehData(1,x).numbStop);
        
        
        nth_GORT_place=round(pfailstop*BehData(1,x).numbSucGo);
        nth_GORT=BehData(x).SucGORT_ranked(nth_GORT_place);
        nth_GORT_detrend=BehData(x).dtSucGoRTlist(nth_GORT_place);
        nth_GORT_detrend_v2=BehData(x).dtSucGoRTlist_v2(nth_GORT_place);
        
        SSRT_quantile=nth_GORT-BehData(1,x).mSSD;
        SSRT_quantile_detrend=nth_GORT_detrend-BehData(1,x).mSSD;
        SSRT_quantile_detrend_v2=nth_GORT_detrend_v2-BehData(1,x).mSSD;
        
        % p(respond | signal) corrigeren voor Go omission conform Ye et al.
        corrpfailstop = pfailstop/(1-pfailgo);
        nth_GORT_place_corr=round(corrpfailstop*BehData(1,x).numbSucGo);
        nth_GORT_corr=BehData(x).SucGORT_ranked(nth_GORT_place_corr);
        SSRT_quantile_corr=nth_GORT_corr-BehData(1,x).mSSD;
        
        
        
        BehData(x).SSRT_quantile=SSRT_quantile;
        BehData(x).SSRT_quantile_detrend=SSRT_quantile_detrend;
        BehData(x).SSRT_quantile_detrend_v2=SSRT_quantile_detrend_v2;
        BehData(x).nth_GORT=nth_GORT;
        BehData(x).nth_GORT_detrend=nth_GORT_detrend;
        BehData(x).nth_GORT_detrend_v2=nth_GORT_detrend_v2;
        
        BehData(x).nth_GORT_corr=nth_GORT_corr;
        BehData(x).SSRT_quantile_corr=SSRT_quantile_corr;
        
        
        fx=[x nth_GORT SSRT_quantile nth_GORT_detrend SSRT_quantile_detrend nth_GORT_detrend_v2 SSRT_quantile_detrend_v2 nth_GORT_corr SSRT_quantile_corr ];
        headx=transpose(cellstr(char('PPN', 'nth_GORT', 'SSRT_quantile', 'nth_GORT_detred', 'SSRT_quantile_detrend', 'nth_GORT_dentrend_v2', 'SSRT_quantile_detrend_v2', 'nth_GORT_corr_Ye', 'SSRT_quantile_corr_YE')));
        
        
        Alphabet=char('a'+(1:26)-1)';
        [I,J]=ndgrid(1:26,1:26);
        I=I'; J=J';
        al=[Alphabet(I(:)), Alphabet(J(:))];
        al=cellstr(upper(al));
        alfa=cellstr(upper(Alphabet));
        al=vertcat(alfa,al);
        %  al={upper(strvcat(Alphabet,al(1:16,:)))};
        lastcolumn=al{length(headx)};
        firstcelhead='A1';
        lastcelhead=strcat(lastcolumn,'1');
        c=strcat(firstcelhead,':',lastcelhead);
        
        filename_quantile=strcat('SSRT_quantile_may14_',st,'.xls');
        
        feval('xlswrite',strcat(outputdir,filename_quantile),headx,c)
        
        
        firstcel = strcat('A',num2str(p));
        lastcel = strcat('I',num2str(p));
        bx=strcat(firstcel,':',lastcel);
        feval('xlswrite',strcat(outputdir,filename_quantile),fx,bx)
        
        %% Blocks per 12 stop trials method May '14
        
        %block 12
        
        nth_GORT_place12=round(BehData(x).pfailstop12*BehData(x).numbsucgo12);
        if length(BehData(x).SucGORT12list)>nth_GORT_place12
            
            nth_GORT12=BehData(x).SucGORT12list(nth_GORT_place12);
            SSRT_integr12=nth_GORT12-BehData(1,x).mSSD12;
        else
            nth_GORT12=NaN;
            SSRT_integr12=NaN;
        end
        
        meansucgoRT12=mean(BehData(x).SucGORT12list);
        meanfailstopRT12=mean(BehData(x).failedstopRT12list);
        
        
        
        
        % p(respond | signal) corrigeren voor Go omission conform Ye et al.
        corrpfailstop12 = BehData(x).pfailstop12/(1-BehData(x).pfailgo12);
        nth_GORT_place_corr12=round(corrpfailstop12*BehData(1,x).numbsucgo12);
        if length(BehData(x).SucGORT12list)>nth_GORT_place_corr12
            
            nth_GORT12_YE=BehData(x).SucGORT12list(nth_GORT_place_corr12);
            SSRT_integr12_YE=nth_GORT12_YE-BehData(1,x).mSSD12;
            
        else
            nth_GORT12_YE=NaN;
            SSRT_integr12_YE=NaN;
        end
        
        
        %
        if BehData(x).pfailstop12 >= 0.25 && BehData(x).pfailstop12 <= 0.75
            accSSRT_integr12_YE=SSRT_integr12_YE
            acccorrpfailstop12=corrpfailstop12
        else
            accSSRT_integr12_YE=NaN
            acccorrpfailstop12=NaN
        end
        
        
        %block 24
        
        nth_GORT_place24=round(BehData(x).pfailstop24*BehData(x).numbsucgo24);
        if length(BehData(x).SucGORT24list)>nth_GORT_place24
            
            nth_GORT24=BehData(x).SucGORT24list(nth_GORT_place24);
            SSRT_integr24=nth_GORT24-BehData(1,x).mSSD24;
        else
            nth_GORT24=NaN;
            SSRT_integr24=NaN;
        end
        
        meansucgoRT24=mean(BehData(x).SucGORT24list);
        meanfailstopRT24=mean(BehData(x).failedstopRT24list)
        
        % p(respond | signal) corrigeren voor Go omission conform Ye et al.
        corrpfailstop24 = BehData(x).pfailstop24/(1-BehData(x).pfailgo24);
        nth_GORT_place_corr24=round(corrpfailstop24*BehData(1,x).numbsucgo24);
        if length(BehData(x).SucGORT24list)>nth_GORT_place_corr24
            
            nth_GORT24_YE=BehData(x).SucGORT24list(nth_GORT_place_corr24);
            SSRT_integr24_YE=nth_GORT24_YE-BehData(1,x).mSSD24;
            
        else
            nth_GORT24_YE=NaN;
            SSRT_integr24_YE=NaN;
        end
        
        if BehData(x).pfailstop24 >= 0.25 && BehData(x).pfailstop24 <= 0.75
            accSSRT_integr24_YE=SSRT_integr24_YE;
            acccorrpfailstop24=corrpfailstop24
            
        else
            accSSRT_integr24_YE=NaN
            acccorrpfailstop24=NaN
        end
        
        
        %          block 36
        
        nth_GORT_place36=round(BehData(x).pfailstop36*BehData(x).numbsucgo36);
        if length(BehData(x).SucGORT36list)>nth_GORT_place36
            
            nth_GORT36=BehData(x).SucGORT36list(nth_GORT_place36);
            SSRT_integr36=nth_GORT36-BehData(1,x).mSSD36;
        else
            nth_GORT36=NaN;
            SSRT_integr36=NaN;
        end
        
        meansucgoRT36=mean(BehData(x).SucGORT36list);
        meanfailstopRT36=mean(BehData(x).failedstopRT36list);
        
        %         p(respond | signal) corrigeren voor Go omission conform Ye et al.
        corrpfailstop36 = BehData(x).pfailstop36/(1-BehData(x).pfailgo36);
        nth_GORT_place_corr36=round(corrpfailstop36*BehData(1,x).numbsucgo36);
        if length(BehData(x).SucGORT36list)>nth_GORT_place_corr36
            
            nth_GORT36_YE=BehData(x).SucGORT36list(nth_GORT_place_corr36);
            SSRT_integr36_YE=nth_GORT36_YE-BehData(1,x).mSSD36;
            
        else
            nth_GORT36_YE=NaN;
            SSRT_integr36_YE=NaN;
        end
        
        if BehData(x).pfailstop36 >= 0.25 && BehData(x).pfailstop36 <= 0.75
            accSSRT_integr36_YE=SSRT_integr36_YE
            acccorrpfailstop36=corrpfailstop36
        else
            accSSRT_integr36_YE=NaN
            acccorrpfailstop24=NaN
        end
        %block 48
        
        nth_GORT_place48=round(BehData(x).pfailstop48*BehData(x).numbsucgo48);
        if length(BehData(x).SucGORT48list)>nth_GORT_place48
            
            nth_GORT48=BehData(x).SucGORT48list(nth_GORT_place48);
            SSRT_integr48=nth_GORT48-BehData(1,x).mSSD48;
        else
            nth_GORT48=NaN;
            SSRT_integr48=NaN;
        end
        
        meansucgoRT48=mean(BehData(x).SucGORT48list);
        meanfailstopRT48=mean(BehData(x).failedstopRT48list)
        
        % p(respond | signal) corrigeren voor Go omission conform Ye et al.
        corrpfailstop48 = BehData(x).pfailstop48/(1-BehData(x).pfailgo48);
        nth_GORT_place_corr48=round(corrpfailstop48*BehData(1,x).numbsucgo48);
        if length(BehData(x).SucGORT48list)>nth_GORT_place_corr48
            
            nth_GORT48_YE=BehData(x).SucGORT48list(nth_GORT_place_corr48);
            SSRT_integr48_YE=nth_GORT48_YE-BehData(1,x).mSSD48;
            
        else
            nth_GORT48_YE=NaN;
            SSRT_integr48_YE=NaN;
        end
        
        if BehData(x).pfailstop48 >= 0.25 && BehData(x).pfailstop48 <= 0.75
            accSSRT_integr48_YE=SSRT_integr48_YE
            acccorrpfailstop48=corrpfailstop48
        else
            accSSRT_integr48_YE=NaN
            acccorrpfailstop48=NaN
        end
        
        average_accSSRT_integr_YE=nanmean([accSSRT_integr12_YE accSSRT_integr24_YE accSSRT_integr36_YE accSSRT_integr48_YE]);
        average_acccorrpfailstop=nanmean([acccorrpfailstop12 acccorrpfailstop24 acccorrpfailstop36 acccorrpfailstop48]);
        
        %--------------------------------------------------------------------
        
        
        fx=[x nth_GORT12 nth_GORT12_YE SSRT_integr12 SSRT_integr12_YE BehData(x).pfailstop12 meanfailstopRT12 meansucgoRT12...
            nth_GORT24 nth_GORT24_YE SSRT_integr24 SSRT_integr24_YE BehData(x).pfailstop24 meanfailstopRT24 meansucgoRT24...
            nth_GORT36 nth_GORT36_YE SSRT_integr36 SSRT_integr36_YE BehData(x).pfailstop36 meanfailstopRT36 meansucgoRT36...
            nth_GORT48 nth_GORT48_YE SSRT_integr48 SSRT_integr48_YE BehData(x).pfailstop48 meanfailstopRT48 meansucgoRT48 ...
            accSSRT_integr12_YE accSSRT_integr24_YE accSSRT_integr36_YE accSSRT_integr48_YE,average_accSSRT_integr_YE average_acccorrpfailstop pfailgo];
        
        descx= [x str2double(st) group numbGo numbStop numbSucGo numbFailGo numbFailGoResp numbSucStop numbFailStop ...
            mSucGoRT medSucGoRT mSSD medSSD average_accSSRT_integr_YE average_acccorrpfailstop pfailgo ];
        
        
        headx=transpose(cellstr(char('PPN', 'nth_GORT12', 'nthGORT12_YE', 'SSRT_integr12', 'SSSRT_integr12_YE', 'pfailstop12', 'meanfailstopRT12', 'meansucgoRT12', ...
            'nth_GORT24', 'nthGORT24_YE', 'SSRT_integr24', 'SSSRT_integr24_YE', 'pfailstop24', 'meanfailstopRT24', 'meansucgoRT24',...
            'nth_GORT36', 'nthGORT36_YE', 'SSRT_integr36', 'SSSRT_integr36_YE', 'pfailstop36', 'meanfailstopRT36', 'meansucgoRT36',  ...
            'nth_GORT48', 'nthGORT48_YE', 'SSRT_integr48', 'SSSRT_integr48_YE', 'pfailstop48', 'meanfailstopRT48', 'meansucgoRT48', ...
            'acc_SSRT_block12', 'acc_SSRT_block24', 'acc_SSRT_block36', 'acc_SSRT_block48', 'average_SSRT_YE', 'average_percFailStop', 'percentageFailGO')));
        headdesc=transpose(cellstr(char('PPN', 'study','Group', 'numbGo', 'numbStop', 'numbSucGo', 'numbFailGo', 'numbFailGoResp', 'numbSucStop', 'numbFailstop', ...
            'mSucGoRT', 'medSucGORT', 'mSSD', 'medSSD', 'average_SSRT_YE', 'average_percFailStop', 'percentageFailGO')));
        
        
        filename_integration=strcat('SSRT_integration_may14_block4_',st,'.xls');
        filename_summary=strcat('summary_behavior_',st,'.xls');
        
        
        Alphabet=char('a'+(1:26)-1)';
        [I,J]=ndgrid(1:26,1:26);
        I=I'; J=J';
        al=[Alphabet(I(:)), Alphabet(J(:))];
        al=cellstr(upper(al));
        alfa=cellstr(upper(Alphabet));
        al=vertcat(alfa,al);
        %  al={upper(strvcat(Alphabet,al(1:16,:)))};
        lastcolumn=al{length(headx)};
        lastcolumn2=al{length(headdesc)};
        firstcelhead='A1';
        lastcelhead=strcat(lastcolumn,'1');
        lastcelhead2=strcat(lastcolumn2,'1');
        c=strcat(firstcelhead,':',lastcelhead);
        d=strcat(firstcelhead,':',lastcelhead2);
        
        feval('xlswrite',strcat(outputdir,filename_integration),headx,c)
        feval('xlswrite',strcat(outputdir,filename_summary),headdesc,d)
        
        firstcel = strcat('A',num2str(p));
        lastcel = strcat(lastcolumn,num2str(p));
        lastcel2= strcat(lastcolumn2,num2str(p));
        bx=strcat(firstcel,':',lastcel);
        dx=strcat(firstcel,':',lastcel2);
        feval('xlswrite',strcat(outputdir,filename_integration),fx,bx)
        feval('xlswrite',strcat(outputdir,filename_summary),descx,dx)
        
        
        
        
        %%
        clearvars -except inputdir outputdir st x subjects S
        
        
        
    end
    
end



