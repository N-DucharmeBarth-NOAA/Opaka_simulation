#V3.30
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2026-03-09 11:02:36.734558
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
3 #_N_platoons_Within_GrowthPattern
0.7 #_Morph_between/within_stdev_ratio
0.15 0.7 0.15 # vector_Morphdist_(-1_in_first_val_gives_normal_approx)
4 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	1	1	0	#_recr_dist_pattern1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
0 #_Nblock_Patterns
#_Cond 0 #_blocks_per_pattern
# begin and end years of blocks
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
0 0 0 0 0 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=Maunder_M;_6=Age-range_Lorenzen
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
 0.01	     1.8	   0.135	  0	  0	0	 -3	0	0	0	0	0	0	0	#_NatM_p_1_Fem_GP_1  
    1	      60	       6	  0	  0	0	 -4	0	0	0	0	0	0	0	#_L_at_Amin_Fem_GP_1 
   50	     100	    67.5	  0	  0	0	 -4	0	0	0	0	0	0	0	#_L_at_Amax_Fem_GP_1 
 0.05	     0.5	   0.242	  0	  0	0	 -3	0	0	0	0	0	0	0	#_VonBert_K_Fem_GP_1 
 0.05	    0.25	   0.085	  0	  0	0	 -3	0	0	0	0	0	0	0	#_CV_young_Fem_GP_1  
 0.05	    0.25	   0.085	  0	  0	0	 -3	0	0	0	0	0	0	0	#_CV_old_Fem_GP_1    
   -1	       3	1.75e-05	  0	  0	0	 -3	0	0	0	0	0	0	0	#_Wtlen_1_Fem_GP_1   
   -1	       4	    2.99	  0	  0	0	 -3	0	0	0	0	0	0	0	#_Wtlen_2_Fem_GP_1   
   35	      60	    40.7	  0	  0	0	 -3	0	0	0	0	0	0	0	#_Mat50%_Fem_GP_1    
   -4	       3	   -2.26	  0	  0	0	 -3	0	0	0	0	0	0	0	#_Mat_slope_Fem_GP_1 
   -3	       3	       1	  0	  0	0	 -3	0	0	0	0	0	0	0	#_Eggs_alpha_Fem_GP_1
   -3	       3	       0	  0	  0	0	 -3	0	0	0	0	0	0	0	#_Eggs_beta_Fem_GP_1 
  0.1	      10	       1	  1	  1	0	 -1	0	0	0	0	0	0	0	#_CohortGrowDev      
1e-06	0.999999	     0.5	0.5	0.5	0	-99	0	0	0	0	0	0	0	#_FracFemale_GP_1    
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; 2=Ricker; 3=std_B-H; 4=SCAA;5=Hockey; 6=B-H_flattop; 7=survival_3Parm;8=Shepard_3Parm
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
  3	7	5.66274	0	0	0	  1	0	0	0	0	0	0	0	#_SR_LN(R0)  
0.2	1	   0.76	0	0	0	 -2	0	0	0	0	0	0	0	#_SR_BH_steep
  0	2	   0.52	0	0	0	 -4	0	0	0	0	0	0	0	#_SR_sigmaR  
 -5	5	      0	0	0	0	 -4	0	0	0	0	0	0	0	#_SR_regime  
  0	0	      0	0	0	0	-99	0	0	0	0	0	0	0	#_SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1996 # first year of main recr_devs; early devs can preceed this era
2048 # last year of main recr_devs; forecast devs start in following year
1 #_recdev phase
1 # (0/1) to read 13 advanced options
-31 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
2 #_recdev_early_phase
-4 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1901.9 #_last_yr_nobias_adj_in_MPD; begin of ramp
1983 #_first_yr_fullbias_adj_in_MPD; begin of plateau
2019.9 #_last_yr_fullbias_adj_in_MPD
2023.8 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
0.9375 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
0 #_period of cycles in recruitment (N parms read below)
-5 #min rec_dev
5 #max rec_dev
100 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
#_Year	recdev
1949	    -1.1426	#_recdev_input1  
1950	   -1.06887	#_recdev_input2  
1951	  -0.344241	#_recdev_input3  
1952	  -0.280362	#_recdev_input4  
1953	  0.0954153	#_recdev_input5  
1954	    0.40333	#_recdev_input6  
1955	    0.44147	#_recdev_input7  
1956	  -0.357159	#_recdev_input8  
1957	  -0.180408	#_recdev_input9  
1958	  -0.645911	#_recdev_input10 
1959	  -0.363312	#_recdev_input11 
1960	    0.23278	#_recdev_input12 
1961	  -0.642665	#_recdev_input13 
1962	-0.00651183	#_recdev_input14 
1963	  -0.245536	#_recdev_input15 
1964	  -0.683863	#_recdev_input16 
1965	  -0.742749	#_recdev_input17 
1966	 -0.0150919	#_recdev_input18 
1967	   0.693968	#_recdev_input19 
1968	  -0.503054	#_recdev_input20 
1969	   0.634987	#_recdev_input21 
1970	   0.507799	#_recdev_input22 
1971	  -0.144458	#_recdev_input23 
1972	  -0.607171	#_recdev_input24 
1973	   0.343857	#_recdev_input25 
1974	   0.596766	#_recdev_input26 
1975	   -0.96698	#_recdev_input27 
1976	   0.397633	#_recdev_input28 
1977	  -0.152728	#_recdev_input29 
1978	 -0.0186559	#_recdev_input30 
1979	   -0.31967	#_recdev_input31 
1980	  -0.262758	#_recdev_input32 
1981	    0.32837	#_recdev_input33 
1982	  -0.561836	#_recdev_input34 
1983	   -1.23682	#_recdev_input35 
1984	  -0.473634	#_recdev_input36 
1985	   -1.16106	#_recdev_input37 
1986	  -0.154701	#_recdev_input38 
1987	   -1.24766	#_recdev_input39 
1988	   0.597268	#_recdev_input40 
1989	 -0.0563729	#_recdev_input41 
1990	  -0.706922	#_recdev_input42 
1991	  -0.155513	#_recdev_input43 
1992	   0.256126	#_recdev_input44 
1993	   0.541557	#_recdev_input45 
1994	  -0.229955	#_recdev_input46 
1995	   0.349147	#_recdev_input47 
1996	    0.62433	#_recdev_input48 
1997	 -0.0449721	#_recdev_input49 
1998	   -0.51702	#_recdev_input50 
1999	 -0.0913042	#_recdev_input51 
2000	  -0.761823	#_recdev_input52 
2001	 -0.0198111	#_recdev_input53 
2002	 -0.0250792	#_recdev_input54 
2003	  -0.190827	#_recdev_input55 
2004	   0.301998	#_recdev_input56 
2005	   0.366658	#_recdev_input57 
2006	   0.507894	#_recdev_input58 
2007	   0.599994	#_recdev_input59 
2008	   0.379347	#_recdev_input60 
2009	   0.130925	#_recdev_input61 
2010	  0.0460105	#_recdev_input62 
2011	   -0.58077	#_recdev_input63 
2012	  -0.780872	#_recdev_input64 
2013	  0.0149231	#_recdev_input65 
2014	   -1.23067	#_recdev_input66 
2015	  -0.180995	#_recdev_input67 
2016	     1.0352	#_recdev_input68 
2017	   0.133465	#_recdev_input69 
2018	  -0.336306	#_recdev_input70 
2019	   -1.15722	#_recdev_input71 
2020	  0.0749624	#_recdev_input72 
2021	   0.824785	#_recdev_input73 
2022	   -1.06262	#_recdev_input74 
2023	   0.905858	#_recdev_input75 
2024	   0.573876	#_recdev_input76 
2025	   0.760027	#_recdev_input77 
2026	  -0.133763	#_recdev_input78 
2027	  -0.570502	#_recdev_input79 
2028	  -0.226925	#_recdev_input80 
2029	  -0.156502	#_recdev_input81 
2030	   0.115256	#_recdev_input82 
2031	  -0.200117	#_recdev_input83 
2032	 -0.0884275	#_recdev_input84 
2033	   -0.25786	#_recdev_input85 
2034	-0.00914416	#_recdev_input86 
2035	   0.254918	#_recdev_input87 
2036	   0.246001	#_recdev_input88 
2037	  -0.731487	#_recdev_input89 
2038	   0.527516	#_recdev_input90 
2039	    0.39691	#_recdev_input91 
2040	  0.0205478	#_recdev_input92 
2041	   0.129202	#_recdev_input93 
2042	  -0.129006	#_recdev_input94 
2043	  -0.355773	#_recdev_input95 
2044	  -0.936963	#_recdev_input96 
2045	   0.312591	#_recdev_input97 
2046	  -0.712454	#_recdev_input98 
2047	   0.338623	#_recdev_input99 
2048	    0.61751	#_recdev_input100
#
#Fishing Mortality info
0.3 # F ballpark
-2000 # F ballpark year (neg value to disable)
2 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
#_overall start F value; overall phase; N detailed inputs to read
0 1 200 #_F_setup
#_Fleet	Yr	Seas	F_value	se	phase
1	1949	1	 0.0118064	0.005	1	#_1  
1	1950	1	 0.0105801	0.005	1	#_2  
1	1951	1	0.00921453	0.005	1	#_3  
1	1952	1	0.00907302	0.005	1	#_4  
1	1953	1	0.00737786	0.005	1	#_5  
1	1954	1	0.00738682	0.005	1	#_6  
1	1955	1	0.00755357	0.005	1	#_7  
1	1956	1	0.00872881	0.005	1	#_8  
1	1957	1	0.00800456	0.005	1	#_9  
1	1958	1	0.00886222	0.005	1	#_10 
1	1959	1	0.00878066	0.005	1	#_11 
1	1960	1	 0.0109662	0.005	1	#_12 
1	1961	1	0.00989867	0.005	1	#_13 
1	1962	1	 0.0101357	0.005	1	#_14 
1	1963	1	 0.0107463	0.005	1	#_15 
1	1964	1	 0.0113223	0.005	1	#_16 
1	1965	1	 0.0119067	0.005	1	#_17 
1	1966	1	 0.0136057	0.005	1	#_18 
1	1967	1	 0.0124639	0.005	1	#_19 
1	1968	1	 0.0123549	0.005	1	#_20 
1	1969	1	 0.0137134	0.005	1	#_21 
1	1970	1	 0.0134326	0.005	1	#_22 
1	1971	1	  0.015797	0.005	1	#_23 
1	1972	1	 0.0179042	0.005	1	#_24 
1	1973	1	 0.0210223	0.005	1	#_25 
1	1974	1	 0.0216518	0.005	1	#_26 
1	1975	1	 0.0257336	0.005	1	#_27 
1	1976	1	 0.0287693	0.005	1	#_28 
1	1977	1	  0.030248	0.005	1	#_29 
1	1978	1	 0.0310346	0.005	1	#_30 
1	1979	1	 0.0338117	0.005	1	#_31 
1	1980	1	 0.0368465	0.005	1	#_32 
1	1981	1	 0.0381651	0.005	1	#_33 
1	1982	1	 0.0366044	0.005	1	#_34 
1	1983	1	 0.0344678	0.005	1	#_35 
1	1984	1	 0.0357882	0.005	1	#_36 
1	1985	1	 0.0354865	0.005	1	#_37 
1	1986	1	 0.0350356	0.005	1	#_38 
1	1987	1	 0.0334588	0.005	1	#_39 
1	1988	1	 0.0319365	0.005	1	#_40 
1	1989	1	 0.0316155	0.005	1	#_41 
1	1990	1	 0.0327843	0.005	1	#_42 
1	1991	1	 0.0315669	0.005	1	#_43 
1	1992	1	 0.0341312	0.005	1	#_44 
1	1993	1	 0.0360082	0.005	1	#_45 
1	1994	1	 0.0360198	0.005	1	#_46 
1	1995	1	 0.0343763	0.005	1	#_47 
1	1996	1	 0.0337194	0.005	1	#_48 
1	1997	1	 0.0344472	0.005	1	#_49 
1	1998	1	 0.0340413	0.005	1	#_50 
1	1999	1	 0.0353752	0.005	1	#_51 
1	2000	1	 0.0342152	0.005	1	#_52 
1	2001	1	 0.0351346	0.005	1	#_53 
1	2002	1	 0.0329241	0.005	1	#_54 
1	2003	1	 0.0321216	0.005	1	#_55 
1	2004	1	 0.0304352	0.005	1	#_56 
1	2005	1	 0.0284282	0.005	1	#_57 
1	2006	1	 0.0261085	0.005	1	#_58 
1	2007	1	 0.0244405	0.005	1	#_59 
1	2008	1	 0.0226856	0.005	1	#_60 
1	2009	1	   0.02149	0.005	1	#_61 
1	2010	1	 0.0184457	0.005	1	#_62 
1	2011	1	 0.0166911	0.005	1	#_63 
1	2012	1	 0.0128505	0.005	1	#_64 
1	2013	1	 0.0129711	0.005	1	#_65 
1	2014	1	 0.0135724	0.005	1	#_66 
1	2015	1	 0.0131714	0.005	1	#_67 
1	2016	1	 0.0149525	0.005	1	#_68 
1	2017	1	  0.016097	0.005	1	#_69 
1	2018	1	 0.0135668	0.005	1	#_70 
1	2019	1	 0.0167326	0.005	1	#_71 
1	2020	1	 0.0171202	0.005	1	#_72 
1	2021	1	 0.0162311	0.005	1	#_73 
1	2022	1	 0.0167435	0.005	1	#_74 
1	2023	1	 0.0161707	0.005	1	#_75 
1	2024	1	 0.0164467	0.005	1	#_76 
1	2025	1	  0.017965	0.005	1	#_77 
1	2026	1	 0.0171622	0.005	1	#_78 
1	2027	1	  0.019299	0.005	1	#_79 
1	2028	1	 0.0183793	0.005	1	#_80 
1	2029	1	 0.0160501	0.005	1	#_81 
1	2030	1	 0.0156313	0.005	1	#_82 
1	2031	1	 0.0152679	0.005	1	#_83 
1	2032	1	 0.0154976	0.005	1	#_84 
1	2033	1	 0.0140234	0.005	1	#_85 
1	2034	1	 0.0123747	0.005	1	#_86 
1	2035	1	 0.0125652	0.005	1	#_87 
1	2036	1	 0.0149181	0.005	1	#_88 
1	2037	1	 0.0131965	0.005	1	#_89 
1	2038	1	 0.0165562	0.005	1	#_90 
1	2039	1	 0.0147086	0.005	1	#_91 
1	2040	1	 0.0152785	0.005	1	#_92 
1	2041	1	 0.0151404	0.005	1	#_93 
1	2042	1	  0.015795	0.005	1	#_94 
1	2043	1	 0.0182646	0.005	1	#_95 
1	2044	1	 0.0184366	0.005	1	#_96 
1	2045	1	 0.0182167	0.005	1	#_97 
1	2046	1	 0.0159381	0.005	1	#_98 
1	2047	1	 0.0141668	0.005	1	#_99 
1	2048	1	 0.0163508	0.005	1	#_100
2	1949	1	 0.0246288	0.005	1	#_101
2	1950	1	 0.0236754	0.005	1	#_102
2	1951	1	 0.0199116	0.005	1	#_103
2	1952	1	  0.021016	0.005	1	#_104
2	1953	1	 0.0232683	0.005	1	#_105
2	1954	1	 0.0231715	0.005	1	#_106
2	1955	1	 0.0235692	0.005	1	#_107
2	1956	1	 0.0246779	0.005	1	#_108
2	1957	1	 0.0253709	0.005	1	#_109
2	1958	1	 0.0226204	0.005	1	#_110
2	1959	1	 0.0226644	0.005	1	#_111
2	1960	1	  0.022975	0.005	1	#_112
2	1961	1	 0.0217922	0.005	1	#_113
2	1962	1	 0.0229169	0.005	1	#_114
2	1963	1	 0.0224405	0.005	1	#_115
2	1964	1	 0.0257962	0.005	1	#_116
2	1965	1	 0.0227801	0.005	1	#_117
2	1966	1	 0.0234931	0.005	1	#_118
2	1967	1	 0.0216327	0.005	1	#_119
2	1968	1	 0.0224318	0.005	1	#_120
2	1969	1	  0.022922	0.005	1	#_121
2	1970	1	 0.0223171	0.005	1	#_122
2	1971	1	 0.0269996	0.005	1	#_123
2	1972	1	 0.0297927	0.005	1	#_124
2	1973	1	 0.0317582	0.005	1	#_125
2	1974	1	 0.0323524	0.005	1	#_126
2	1975	1	  0.038504	0.005	1	#_127
2	1976	1	  0.043136	0.005	1	#_128
2	1977	1	 0.0445158	0.005	1	#_129
2	1978	1	 0.0433157	0.005	1	#_130
2	1979	1	 0.0474277	0.005	1	#_131
2	1980	1	 0.0521278	0.005	1	#_132
2	1981	1	 0.0532574	0.005	1	#_133
2	1982	1	 0.0524051	0.005	1	#_134
2	1983	1	 0.0519414	0.005	1	#_135
2	1984	1	 0.0506046	0.005	1	#_136
2	1985	1	 0.0529212	0.005	1	#_137
2	1986	1	 0.0521743	0.005	1	#_138
2	1987	1	 0.0519858	0.005	1	#_139
2	1988	1	 0.0515597	0.005	1	#_140
2	1989	1	 0.0530329	0.005	1	#_141
2	1990	1	 0.0554928	0.005	1	#_142
2	1991	1	 0.0539867	0.005	1	#_143
2	1992	1	 0.0557255	0.005	1	#_144
2	1993	1	 0.0555067	0.005	1	#_145
2	1994	1	 0.0559813	0.005	1	#_146
2	1995	1	  0.054907	0.005	1	#_147
2	1996	1	 0.0531147	0.005	1	#_148
2	1997	1	 0.0509812	0.005	1	#_149
2	1998	1	 0.0516995	0.005	1	#_150
2	1999	1	 0.0512736	0.005	1	#_151
2	2000	1	  0.051259	0.005	1	#_152
2	2001	1	 0.0382015	0.005	1	#_153
2	2002	1	 0.0292861	0.005	1	#_154
2	2003	1	 0.0264676	0.005	1	#_155
2	2004	1	 0.0313482	0.005	1	#_156
2	2005	1	 0.0292811	0.005	1	#_157
2	2006	1	 0.0268918	0.005	1	#_158
2	2007	1	 0.0251737	0.005	1	#_159
2	2008	1	 0.0233662	0.005	1	#_160
2	2009	1	 0.0221347	0.005	1	#_161
2	2010	1	 0.0189991	0.005	1	#_162
2	2011	1	 0.0171918	0.005	1	#_163
2	2012	1	 0.0132361	0.005	1	#_164
2	2013	1	 0.0133602	0.005	1	#_165
2	2014	1	 0.0139795	0.005	1	#_166
2	2015	1	 0.0135665	0.005	1	#_167
2	2016	1	 0.0154011	0.005	1	#_168
2	2017	1	 0.0165799	0.005	1	#_169
2	2018	1	 0.0139738	0.005	1	#_170
2	2019	1	 0.0172346	0.005	1	#_171
2	2020	1	 0.0176338	0.005	1	#_172
2	2021	1	  0.016718	0.005	1	#_173
2	2022	1	 0.0172458	0.005	1	#_174
2	2023	1	 0.0166558	0.005	1	#_175
2	2024	1	 0.0169401	0.005	1	#_176
2	2025	1	  0.018504	0.005	1	#_177
2	2026	1	 0.0176771	0.005	1	#_178
2	2027	1	  0.019878	0.005	1	#_179
2	2028	1	 0.0189307	0.005	1	#_180
2	2029	1	 0.0165316	0.005	1	#_181
2	2030	1	 0.0161002	0.005	1	#_182
2	2031	1	 0.0157259	0.005	1	#_183
2	2032	1	 0.0159625	0.005	1	#_184
2	2033	1	 0.0144441	0.005	1	#_185
2	2034	1	 0.0127459	0.005	1	#_186
2	2035	1	 0.0129421	0.005	1	#_187
2	2036	1	 0.0153656	0.005	1	#_188
2	2037	1	 0.0135924	0.005	1	#_189
2	2038	1	 0.0170529	0.005	1	#_190
2	2039	1	 0.0151498	0.005	1	#_191
2	2040	1	 0.0157368	0.005	1	#_192
2	2041	1	 0.0155947	0.005	1	#_193
2	2042	1	 0.0162688	0.005	1	#_194
2	2043	1	 0.0188126	0.005	1	#_195
2	2044	1	 0.0189897	0.005	1	#_196
2	2045	1	 0.0187632	0.005	1	#_197
2	2046	1	 0.0164163	0.005	1	#_198
2	2047	1	 0.0145918	0.005	1	#_199
2	2048	1	 0.0168413	0.005	1	#_200
#
#_initial_F_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
0	0.2	0.0119122	0	0	0	1	#_InitF_seas_1_flt_1Comm
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    1	1	0	0	0	0	#_Comm      
    3	1	0	0	0	0	#_ResFish   
-9999	0	0	0	0	0	#_terminator
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
 -5	0	 -3.8203	0	0	0	1	0	0	0	0	0	0	0	#_LnQ_base_Comm(1)   
-10	0	-6.30407	0	0	0	1	0	0	0	0	0	0	0	#_LnQ_base_ResFish(3)
#_no timevary Q parameters
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
 1	0	0	0	#_1 Comm    
 1	0	0	0	#_2 Non_comm
24	0	0	0	#_3 ResFish 
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
10	0	0	0	#_1 Comm    
10	0	0	0	#_2 Non_comm
10	0	0	0	#_3 ResFish 
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
  30	40	  36.1238	   0	0	0	  2	0	0	0	0	0	0	0	#_SizeSel_P_1_Comm(1)    
 0.1	 7	  3.91735	   0	0	0	  2	0	0	0	0	0	0	0	#_SizeSel_P_2_Comm(1)    
   0	60	       40	   0	0	0	 -2	0	0	0	0	0	0	0	#_SizeSel_P_1_Non_comm(2)
   0	40	       11	   0	0	0	 -2	0	0	0	0	0	0	0	#_SizeSel_P_2_Non_comm(2)
  18	26	  20.4862	  36	5	0	  2	0	0	0	0	0	0	0	#_SizeSel_P_1_ResFish(3) 
  -7	 7	 -1.05702	-0.5	2	0	 -3	0	0	0	0	0	0	0	#_SizeSel_P_2_ResFish(3) 
  -5	10	-0.338084	1.75	5	0	 -3	0	0	0	0	0	0	0	#_SizeSel_P_3_ResFish(3) 
   0	 8	  4.17264	 0.1	2	0	  4	0	0	0	0	0	0	0	#_SizeSel_P_4_ResFish(3) 
-999	15	     -999	  -1	5	0	-99	0	0	0	0	0	0	0	#_SizeSel_P_5_ResFish(3) 
  -3	 5	 -1.52892	   1	5	0	  4	0	0	0	0	0	0	0	#_SizeSel_P_6_ResFish(3) 
#_AgeSelex
#_No age_selex_parm
#_no timevary selex parameters
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0 # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# Input variance adjustments factors: 
#_Factor Fleet Value
-9999 1 0 # terminator
#
4 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
-9999 0 0 0 0 # terminator
#
0 # 0/1 read specs for more stddev reporting
#
999
