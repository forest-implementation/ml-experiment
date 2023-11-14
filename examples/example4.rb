# frozen_string_literal: true

require "bundler/setup"

require "ml/experiment/preprocessor"
require "ml/forest"
require "ml/service/isolation/outlier"
require "ml/service/isolation/novelty"
require "stats/statistics"
require "plotting/gnuplotter"
require "plotting/preprocessor"
require "ruby-graphviz"

include Plotting::Gnuplotter
include Plotting::Preprocessor
include Stats::Statistics

input = [
  204.37834694137254, 80.44511997651682, "a",
  181.41498212709297, 61.68981864567371, "a",
  178.75720904480573, 52.00468703958586, "a",
  215.82780078640866, 6.953847930927282, "a",
  177.6228962422697, 37.15308328519245, "a",
  213.91187707810434, 70.28989886167778, "a",
  211.25710704323578, 58.48702652312886, "a",
  204.36592648652447, 40.00795674966827, "a",
  174.84840946933488, 85.70320038687044, "a",
  170.05771964026314, 58.381117183342326, "a",
  160.9466823455541, 29.529631219079533, "a",
  210.95880210750647, 79.14239397485841, "a",
  178.11612471508732, 79.05076300170794, "a",
  201.56225875097834, 52.82331670884787, "a",
  205.61313499038556, 70.74627711924927, "a",
  203.68346698609744, 59.40578664145079, "a",
  202.97128184966056, 25.97460949817946, "a",
  237.66395406846053, 70.65713890254233, "a",
  238.6203925603514, 54.23894516897036, "a",
  212.74029327283873, 35.10457507433796, "a",
  189.07595262984876, 102.05007088502941, "a",
  225.75784588727484, 52.94485579016873, "a",
  188.36288796539623, 84.44059250249467, "a",
  206.05742272196443, 66.21562144123021, "a",
  222.33750412007487, 87.16741743277532, "a",
  153.37791018802298, 89.23683332362765, "a",
  165.95816638172403, 31.592933301727044, "a",
  192.58943621599232, 41.32273127065673, "a",
  202.637314460625, 24.1746697176427, "a",
  172.41398799362244, 64.61742016017939, "a",
  158.1028969119084, 110.37871387829875, "a",
  195.93376310250756, 97.30142405799, "a",
  173.04328121099556, 79.53624381359481, "a",
  223.60352607403016, 88.49009972127476, "a",
  176.16213477342723, 51.55721178686622, "a",
  188.71188534311608, 42.25411458735243, "a",
  179.70871577423387, 71.1087143509314, "a",
  216.27767353622124, 63.65034694457398, "a",
  157.65025283502433, 25.712187626240848, "a",
  208.9518780996771, 77.03311345196033, "a",
  186.17557949577454, 23.600521143692788, "a",
  145.27979817628523, 51.362709589066355, "a",
  215.96136439766207, 79.99258175717449, "a",
  189.90745220073399, 72.4779687668248, "a",
  211.15644091042387, 66.303644058126, "a",
  209.02365838914278, 76.1821085010206, "a",
  206.60699309354757, 5.8912003427558375, "a",
  185.77840804097204, 51.22637381535969, "a",
  222.78939445964738, 20.748565616550025, "a",
  160.38562979600607, 89.37969977846194, "a",
  207.64973324169694, 74.9440774149308, "a",
  199.69978353952166, 89.2872081886785, "a",
  225.62116539499382, 65.024734931056, "a",
  191.75612075334814, 55.871596484478175, "a",
  180.87587357245306, 90.6950025226958, "a",
  222.93473062579346, 68.81137797711943, "a",
  255.50777324982403, 55.9466585765926, "a",
  220.8982062403337, 48.49792609614127, "a",
  231.99113645459605, 41.90613500736737, "a",
  233.11895156367683, 67.45569762485366, "a",
  217.69531165799157, 65.32232541051212, "a",
  196.33710544393128, 50.34571494520617, "a",
  226.68297695667223, 72.35544900361282, "a",
  180.26004996815698, 84.4113658131069, "a",
  202.81292703954605, 87.57028353387335, "a",
  215.80895371386688, 106.52774095512899, "a",
  201.83396432549054, 99.9911687034803, "a",
  203.05303746335468, 38.60572646100462, "a",
  216.11800294550815, 79.10525794513512, "a",
  214.5121396551372, 36.43076390812308, "a",
  206.27023825596618, 76.49311231146777, "a",
  216.4198079794053, 62.22447081443369, "a",
  188.26991056135827, 85.77291833422152, "a",
  184.89192303634653, 68.0278983799609, "a",
  225.3611999176165, 110.49042623029845, "a",
  198.38365005310695, 71.8621062012246, "a",
  165.7055894532111, 90.52490450698156, "a",
  198.44797326090097, 71.00556292235967, "a",
  218.19121227700043, 39.25218790103122, "a",
  198.87820532665873, 36.294848982486826, "a",
  178.49362622937235, 98.64004828263899, "a",
  236.0262582411399, 27.735231902681107, "a",
  203.71407458262553, 56.59016492430118, "a",
  226.3787869867833, -0.33344274457880374, "a",
  182.5645799607299, 57.26478330530642, "a",
  194.05545995317786, 53.40594821605589, "a",
  165.36154472848008, 24.63074230462547, "a",
  230.88462050683376, 99.41275907505616, "a",
  184.05178251639472, 45.88840075355546, "a",
  155.6159214491511, 53.1141886866688, "a",
  180.7880149930575, 3.4086673605476676, "a",
  209.51648874916444, 26.773250805166697, "a",
  196.1944799452997, 67.83819142931492, "a",
  244.86121591145493, 89.19631824283664, "a",
  172.27185359619037, 71.20889147593323, "a",
  198.5254513699631, 66.94138211532982, "a",
  168.59625789847718, 18.46267138599859, "a",
  167.18606271494795, 6.8828439936309, "a",
  214.17338708617513, 34.2398042319565, "a",
  173.29579434248504, -6.9057751034159764, "a",
  213.56341614762374, -18.777287944190334, "a",
  206.797962379223, 26.150815214094052, "a",
  223.5555047159446, 48.37010386534013, "a",
  139.14705900721026, 62.49990086292553, "a",
  158.3297655737999, 98.85590292074045, "a",
  216.79590822978014, 92.31203604262197, "a",
  181.8232286711449, 43.71336535884484, "a",
  166.66957936987515, 86.90138763863507, "a",
  141.50429211736295, 82.93118523212377, "a",
  213.9052660869167, 62.01429616020812, "a",
  194.7796966931797, -28.898540626856743, "a",
  171.8614204222955, 22.00921896969635, "a",
  211.7741733220181, 71.3043840922133, "a",
  202.1166200559578, 52.310645490284855, "a",
  187.97350342099088, 72.46540373945231, "a",
  203.99654319781632, -6.293972280013577, "a",
  187.2427413753561, 49.80983641039893, "a",
  174.61663933389008, 110.99278644214513, "a",
  168.97250793528005, 39.408111893216415, "a",
  211.26912684985874, 78.63788535369753, "a",
  220.2486299767638, 46.91165319481257, "a",
  239.32277671372395, 28.058357260830405, "a",
  223.6964742006939, 41.39674227009607, "a",
  201.2644523978371, 6.4085565120714705, "a",
  193.24189870138107, 52.97011730989652, "a",
  161.1947610370068, 71.47747304164454, "a",
  158.40188090279793, 83.63143787904505, "a",
  190.24767014652448, 117.32742620044479, "a",
  195.85836619442358, 92.56790829530195, "a",
  197.14447987312684, 44.09642845645158, "a",
  261.35935099025994, 32.44927360524446, "a",
  234.2658162353064, 60.313257731534975, "a",
  139.8652772170882, 1.5323878977262666, "a",
  194.69151699364278, 25.497831789074553, "a",
  245.704717497457, 56.893976921967294, "a",
  229.25102063844767, 66.9511490744726, "a",
  234.34793304179743, 41.8871237047137, "a",
  220.69781664228984, 29.650738617753007, "a",
  213.24666315468286, 50.43993106792783, "a",
  231.32359702362876, 73.46216030394413, "a",
  187.650354073765, 52.46526245800584, "a",
  150.10390859650028, 62.345526549652675, "a",
  152.23425135265612, 28.142191120738914, "a",
  198.21479493637125, -5.76512703443899, "a",
  221.87322439860534, 18.392970282876945, "a",
  181.81518448689582, 64.49783267390558, "a",
  212.71153805229716, 52.359881863296096, "a",
  219.52766420628075, 44.1376832316451, "a",
  227.72465897173024, 87.50847848955777, "a",
  176.63552075641047, 80.6400063802289, "a",
  232.35255157197972, 124.97468572262733, "a",
  200.88650291821645, 99.46273238927341, "a",
  208.68572058418874, 45.07343752015089, "a",
  204.92262911821504, 60.748132782721825, "a",
  194.68562155324338, -7.736939060112661, "a",
  235.9296125396008, 33.18862396565635, "a",
  190.7983545655302, 55.880584583155894, "a",
  230.9572416937311, 22.670964065556916, "a",
  232.59294449880252, 65.416063941569, "a",
  177.63468334786907, 65.10088359433024, "a",
  227.79617094973116, 62.225320034644994, "a",
  240.25333227392656, 35.41223845739603, "a",
  221.68468201720896, 71.61672581296517, "a",
  194.4355134361841, 74.4892061026211, "a",
  237.22543335964716, 62.76045237023652, "a",
  152.6131277424718, 41.471264891713304, "a",
  266.16862328380023, 60.13450528557587, "a",
  259.9625648596934, 28.470484098526413, "a",
  215.52607515901042, 50.71782398363678, "a",
  221.13175792877738, 45.58300885064597, "a",
  201.35471241150577, 78.81989031975274, "a",
  176.22155505518467, 45.09921882014635, "a",
  211.17506295295254, 70.02344553743916, "a",
  217.99029418817483, 15.328648914748783, "a",
  207.62078652188865, 60.9317301466852, "a",
  210.13831649354267, 114.1942034234965, "a",
  183.03048900090525, 72.1278824122196, "a",
  119.38472728653106, 84.06985658212278, "a",
  211.10204317123353, 16.843607075487398, "a",
  184.19198748212247, -15.68265663449995, "a",
  123.60815587643657, 29.088442971633185, "a",
  202.8187560775923, -0.7594025473891293, "a",
  179.62470409310149, 61.85637224607308, "a",
  153.94988196846447, 39.772608068546276, "a",
  110.1893730863163, 75.88023512034687, "a",
  180.71958785040368, 119.48651415177517, "a",
  171.1308830193936, 52.38467650043697, "a",
  200.04476814845071, 61.51217578408813, "a",
  182.17502012503343, 34.5980761835051, "a",
  142.5774605635826, 22.7585841655756, "a",
  175.52138032769614, 23.30159835159907, "a",
  161.76148034083602, 29.288479938448233, "a",
  158.30890747908364, 29.03471136428948, "a",
  113.23914761995488, 33.66686411268614, "a",
  178.44373065407592, 28.97766786631928, "a",
  198.25383176265697, 28.600140572889302, "a",
  147.12094803283142, 46.27635155468636, "a",
  148.3118930065689, 64.45373375080226, "a",
  167.31087678982075, 45.19821021982165, "a",
  155.99923947802424, 66.22141398744623, "a",
  161.73740178995615, 63.15674205946959, "a",
  161.28513794064588, 60.11831652703438, "a",
  151.36358721522586, -12.83691578121136, "a",
  85.92686761385727, 16.62236927200837, "a",
  127.52236051343465, -21.31996594664315, "a",
  171.14284824449345, 52.481878609721605, "a",
  129.52197376607626, 12.58744235083708, "a",
  113.777305257265, 33.870447390218544, "a",
  130.76571245348842, 47.90309215628952, "a",
  167.4909927855353, 127.33404539010797, "a",
  185.37122490236035, 48.214430488942185, "a",
  128.66430928757558, 90.11909261646719, "a",
  139.90652451080743, 75.87979442782608, "a",
  175.54299233781674, 34.8953698654816, "a",
  163.78465617683148, 19.540027962902002, "a",
  102.6901540297627, -20.000844227868924, "a",
  106.90735106418815, -48.79882561651516, "a",
  143.42198885864318, 62.3593170146122, "a",
  132.55269547447054, 17.426468563594995, "a",
  140.8761379472495, 41.207634644043424, "a",
  105.54334269259171, 97.97551516227838, "a",
  170.65800337053224, 103.56014411311872, "a",
  150.78618857667462, 128.10814857969723, "a",
  99.80795580666351, 122.68391424816184, "a",
  119.23717688677942, 108.22557231899225, "a",
  143.5047387408875, 91.17118900556903, "a",
  113.0039796025973, 127.0710634870257, "a",
  150.61663921634874, 46.56364260114793, "a",
  118.27625292080742, -6.568440307052299, "a",
  124.04915649767212, 36.108890718363114, "a",
  70.13322011082819, 8.63940130547951, "a",
  124.79275403375532, 39.43875493141394, "a",
  161.73961188122436, 56.935034341611015, "a",
  116.36202853683378, 43.24637816826197, "a",
  136.63395964523576, 89.15977622105709, "a",
  144.8648024022318, 134.075363041929, "a",
  100.94286343817679, 147.1612613042015, "a",
  142.23869600745226, 72.58872059066186, "a",
  96.11937376011197, 62.6533510198297, "a",
  84.39430819026227, 21.973609089101785, "a",
  121.38383539050734, -23.2175771603861, "a",
  116.47615056938116, -12.66427915362658, "a",
  87.3876090443649, 7.78086999136832, "a",
  128.3934387511573, 24.798454773600383, "a",
  68.46982825004238, 53.80178638238425, "a",
  91.86559755412017, 94.85745015456376, "a",
  55.70658872892726, 58.7556694320881, "a",
  53.04398747741987, 90.4710429109964, "a",
  103.03305221488279, 27.042038144924902, "a",
  71.33962865861345, 80.31578475235659, "a",
  75.20390527323369, 37.94087249993805, "a",
  57.633146021001906, 12.912065354215542, "a",
  118.29333753200416, -16.523760270495472, "a",
  84.76021160700935, 34.42582451659416, "a",
  77.2149966202343, 16.97824932055579, "a",
  92.83770189084939, 3.4207514754905333, "a",
  75.10574934258828, -6.053662281118875, "a",
  74.18716694688996, 55.09541303608819, "a",
  128.03294958946566, 120.33229556615532, "a",
  104.16217723091694, 91.40451400666376, "a",
  83.14726326587217, 143.537355771325, "a",
  66.19243341181067, 136.6771669801018, "a",
  83.80202915565825, 92.25471535998099, "a",
  67.05238998470054, 67.33455996045552, "a",
  86.51033999115938, 21.21749448877938, "a",
  120.29786659893709, 18.408093564866135, "a",
  128.04703328211312, 37.32276773004929, "a",
  94.1955085490752, 37.818457228398074, "a",
  42.01263445916849, 23.98224544948863, "a",
  51.00979900598654, 59.07214698981505, "a",
  102.95923356695958, 83.25080176597965, "a",
  136.41106141173407, 142.2862487573101, "a",
  98.08057241449394, 97.61318427165929, "a",
  58.4335931045666, 115.0260767551357, "a",
  84.30477174497673, 85.10587775745847, "a",
  119.11028338207261, 49.1043516090013, "a",
  48.01861921872731, 22.66907650245753, "a",
  108.47625957195844, 49.306427258976726, "a",
  101.49872239919578, 5.712591053165681, "a",
  53.676666404566134, 43.89196763486865, "a",
  81.34824670987076, 58.899582564198624, "a",
  97.69977709976033, 33.71064981760139, "a",
  110.69400055086838, 75.02440564671656, "a",
  97.42094196271563, 146.98879416638079, "a",
  35.616092801187406, 67.16629269372135, "a",
  75.53167966120844, 85.04060823070233, "a",
  129.823128027451, 66.1357153199342, "a",
  108.70536496712404, 46.830929727141495, "a",
  149.22620402019515, 37.24647602379184, "a",
  80.22790699477314, 66.5607728001105, "a",
  56.60438531857909, 72.38862380019549, "a",
  73.85369792248774, 96.63202729389553, "a",
  64.99102117535621, 36.328197918209526, "a",
  72.8315692141679, 54.00020574407125, "a",
  102.99085067764409, 52.055612027040695, "a",
  39.76138438676328, 111.36310457711807, "a",
  31.214299876283963, 42.329992442746175, "a",
  77.98035781850872, -21.09777395068204, "a",
  70.62050401013242, -21.719120387422095, "a",
  55.46239750498927, 4.479063523535842, "a",
  36.049906671263585, -27.357463329176653, "a",
  32.44441879233151, 37.83609588681247, "a",
  17.48740764696204, 62.30879041125081, "a",
  72.4350160479146, 80.12740821500392, "a",
  11.139712554953698, 69.0011629349085, "a",
  19.567041583541794, 90.89426667849648, "a",
  41.48244711892862, 124.86506899341498, "a",
  -9.53649418943845, 94.35913430297933, "a",
  -2.3844081037527616, 48.51465453505983, "a",
  44.727602906610954, 10.294535653193293, "a",
  8.507479139206456, 52.0472056830871, "a",
  21.12909461608347, 41.36914312122917, "a",
  14.214067955996168, 50.60674294453128, "a",
  29.614288053414075, 44.99783953151422, "a",
  14.383655171792839, 134.9447188824089, "a",
  -43.62029781627395, 39.411868465160865, "a",
  13.121046755995454, 30.966063521763772, "a",
  77.02080774376816, 26.73742781018234, "a",
  21.0801728684589, 44.88653208604461, "a",
  -12.046910829629894, 50.650258479467595, "a",
  512.140294114076, 129.24761749740128, "a",
  514.2928879123075, 118.8916865012161, "a",
  448.93814309213815, 67.2696543163022, "a",
  499.571264333044, 87.28365112718592, "a",
  490.61446005316714, 85.33961219438896, "a",
  526.3289763406609, 67.77991042215075, "a",
  477.0961796671821, 66.28351794641213, "a",
  471.20806818184013, 18.503959738909145, "a",
  512.4707223323545, 56.39426275281102, "a",
  483.9063580419068, 130.90508706637826, "a",
  511.518837936414, 88.4885793970708, "a",
  515.377754186918, 90.70236407478154, "a",
  552.5941296582575, 76.07829410890332, "a",
  526.3147496071774, 41.646337122712225, "a",
  574.1180831452431, 32.570903024724885, "a",
  528.5540408869837, 76.65688461851227, "a",
  506.58117393209847, 62.444434746802074, "a",
  511.935808786296, -4.98380921599653, "a",
  501.62125050836244, 68.81515813372033, "a",
  532.6348886491459, 53.98077078866811, "a",
  534.8135489965939, 41.8360023826213, "a",
  506.03143354754354, 43.19508511436521, "a",
  509.4044966850806, 72.40193155314182, "a",
  529.6955673557301, 61.7832808057517, "a",
  500.5031894827659, 100.86952054955327, "a",
  515.8833877421746, 54.38227240772869, "a",
  524.4590806797906, 107.48779999768357, "a",
  492.6244636156093, 77.6115064189861, "a",
  501.6537257590424, 52.25822311118782, "a",
  554.2236788811033, 19.705674016786645, "a",
  504.4119380648525, 22.890861240368736, "a",
  506.93865709795574, 63.89818566236124, "a",
  557.7436149742911, 51.87943877752684, "a",
  512.2859918889669, 39.82035169975512, "a",
  485.68567594146623, 68.34520611282892, "a",
  522.6977224613349, 66.0658231613105, "a",
  525.3899474053277, 89.44098081360585, "a",
  539.486775201698, 83.82141205382504, "a",
  519.1981258077924, 106.46135455799134, "a",
  605.4467450407835, 72.97947979547058, "a",
  545.4395087497386, 72.56937284392507, "a",
  528.4714524823876, 40.213811922608784, "a",
  538.9128592015263, 27.97221893530923, "a",
  520.7108153335759, 13.625353084406697, "a",
  571.1228666349464, 26.288279817465877, "a",
  551.6513183449517, 53.15340849627785, "a",
  560.5768627697444, 68.09660365014975, "a",
  550.100017908567, 64.71330637887502, "a",
  538.2917837445054, 92.02377324094294, "a",
  513.8545641955951, 83.8261806927386, "a",
  567.9158836226827, 134.3388538013864, "a",
  521.1430139596272, 77.96944039568098, "a",
  547.4404365017933, 52.83137985192053, "a",
  578.2330528184395, 30.471948380741367, "a",
  516.6698020331911, 66.2868608565617, "a",
  527.9246075133358, 3.8203965460243126, "a",
  574.6332519988152, -22.539736400766515, "a",
  568.532430464391, 30.485988300712336, "a",
  537.279758622138, -9.3968356352363, "a",
  616.5817476410137, -37.84964703971207, "a",
  523.1503361318885, 66.56877001220198, "a",
  574.6001733119531, 27.05704804099946, "a",
  554.2963305740989, 124.37449444312449, "a",
  565.6925434580273, 71.97916906210412, "a",
  552.7721796700217, 88.20849699375054, "a",
  580.3960215734386, 79.51839907604756, "a",
  566.0155856387764, 5.8825139716613535, "a",
  528.6953306791539, 54.613519326200844, "a",
  537.4115965598571, 24.380695336165502, "a",
  529.8100589571625, 53.88942620975524, "a",
  561.7976410553788, 47.307611375869556, "a",
  591.2315518375877, 40.030052144635306, "a",
  553.5316392263966, 20.513744971953997, "a",
  572.5967111562472, 104.88200481125011, "a",
  568.3793764812303, 94.10511629014303, "a",
  579.8090357474463, 51.84045555599022, "a",
  533.9345668417546, 115.89989706608532, "a",
  562.4553038653943, 22.64675849847106, "a",
  570.2640982217064, 62.042022950234184, "a",
  574.4783252061006, 90.7547544625699, "a",
  600.3567257579134, 21.253110453355532, "a",
  560.5085233878223, 42.39944671523017, "a",
  590.6172009805551, 41.11937549703674, "a",
  568.7179424521225, 78.59445930471207, "a",
  567.7930110607618, 67.12806786802031, "a",
  576.0606837478493, 44.62800242712035, "a",
  561.0457573486998, 74.3225775850288, "a",
  618.2060738644942, 74.82490068758284, "a",
  557.7792779762992, 138.65137768495072, "a",
  546.9385736838627, 94.53291542857642, "a",
  540.2037636013852, 75.58918477442694, "a",
  597.2500036455267, 82.33431290226594, "a",
  595.6524322100621, 51.18352529469803, "a",
  620.7441062087115, 39.47967589355295, "a",
  592.4233265538767, 39.48469703258621, "a",
  585.7826811229951, 103.98622580028427, "a",
  635.2638421815958, 52.758359204777264, "a",
  558.6516405882965, 70.20348608087005, "a",
  563.6148763378495, 169.9708874523265, "a",
  598.6448801020966, 73.80886832998442, "a",
  565.3385668002954, 100.4238022394976, "a",
  607.4260278218889, 79.79799371649017, "a",
  575.983872166009, 1.5019906037653072, "a",
  588.8022684868612, 21.50835374197669, "a",
  581.0065809245897, 44.30358708246246, "a",
  625.9204412644204, 52.47911970213619, "a",
  573.1951994569047, 52.580407997340444, "a",
  605.9338469467342, 38.85062948714926, "a",
  601.9768405116698, 58.591554094862715, "a",
  591.3333205890262, 30.670032821841232, "a",
  621.9091058818921, 81.76300073771489, "a",
  573.4069477033013, 47.477315354651125, "a",
  652.2236323417702, 87.28655777672657, "a",
  637.9474220728861, 56.89736950942324, "a",
  635.878527009282, -3.987343037377002, "a",
  585.5362768035532, 35.3803763042273, "a",
  578.1253433838025, 46.21917798883874, "a",
  616.670553787134, -19.242043493356164, "a",
  628.341607746859, 77.5149090657373, "a",
  610.2256042222849, 29.839657817183706, "a",
  625.8894251086732, 39.50013007560972, "a",
  615.3931382875046, 131.54025526668124, "a",
  669.1471869886848, 107.04952356046834, "a",
  678.2347744712881, 131.67914667168554, "a",
  652.5556303017013, 84.66316756121188, "a",
  669.02964001774, 80.10982357012892, "a",
  573.2385739663506, 65.9258096957949, "a",
  631.505689723751, 43.03204960102863, "a",
  605.1948878660419, 64.81918044720055, "a",
  613.8345036283436, 14.46638650555684, "a",
  625.6758506020132, 17.625733229289835, "a",
  577.7883622827561, -23.72668810642631, "a",
  626.4144342073033, 23.426585346373827, "a",
  641.0202511349008, 79.19173154484537, "a",
  610.7563487792726, 43.664078896496505, "a",
  585.7009640759043, 101.87245140328315, "a",
  564.077528450578, 117.56479831652643, "a",
  591.1023299866906, 100.25508954231617, "a",
  627.8878847927392, 127.21739006456079, "a",
  588.9343325910178, 76.7132985426365, "a",
  578.9477948179012, 19.39315178955769, "a",
  575.2771146394135, 13.061563887610419, "a",
  576.1500683034363, 56.94915445860482, "a",
  544.2604279852795, 49.945237801918495, "a",
  532.2386580901521, 46.939034096082764, "a",
  546.0007916430199, 111.53257289156528, "a",
  577.2012208273327, 84.16036076032873, "a",
  569.0228416462475, 94.75663427379777, "a",
  544.1092208655966, 84.8943410454545, "a",
  552.4867684036202, 132.26356965555368, "a",
  581.70661180872, 100.29931785363095, "a",
  539.362071709824, 79.05495107359894, "a",
  574.3128452191465, 49.84948552054169, "a",
  506.78238209283785, 60.58093999274968, "a",
  542.2869904215057, 39.20384136453936, "a",
  568.4120940573794, 6.132835245632521, "a",
  552.055890194672, 0.8890380591295752, "a",
  535.3605023764833, 2.1116828761641386, "a",
  502.1532682393764, 60.17819316362454, "a",
  526.9378711639316, 128.22409250913256, "a",
  517.8427111716823, 127.06359680265456, "a",
  519.5076237975221, 121.18875894147618, "a",
  505.8584563555844, 62.02306766851905, "a",
  512.5582424982636, 113.41913069371833, "a",
  515.0195542969834, 91.18899671234027, "a",
  546.2343774421302, 71.84364116514155, "a",
  565.0639140470765, 13.545433775007382, "a",
  531.465994878864, -18.313443677216696, "a",
  484.30710711106144, 42.00416047759251, "a",
  519.9511424736384, 4.24231088798274, "a",
  482.9021713039033, 29.92565582269134, "a",
  505.06853669960753, 75.07247098348978, "a",
  519.2992552427761, 107.33195417988111, "a",
  473.7615944303712, 86.28633903256787, "a",
  515.6730084291418, 99.88239603675754, "a",
  577.0581476234098, 139.90999573575323, "a",
  515.6956970726678, 88.64307343450486, "a",
  518.022166556446, 77.26287941275905, "a",
  519.6301083753507, 41.59795569243727, "a",
  492.53018350448224, 9.696252938439159, "a",
  530.3386936032673, 9.106977324671334, "a",
  506.1816490314189, 42.45484423670871, "a",
  517.9880860262958, 10.30904535422502, "a",
  536.3371096106753, 17.986901873473755, "a",
  522.5057168447285, 48.207222808934546, "a",
  547.8454678270683, 54.299778951417295, "a",
  507.9136696409634, 51.89208955745187, "a",
  513.913372561979, 140.81344353512958, "a",
  510.86485767589727, 142.9862287255678, "a",
  498.9198884097965, 69.39314717727757, "a",
  496.4915144412999, 79.89766895797294, "a",
  530.8486203533939, 81.0646885644565, "a",
  474.5730721046536, 31.457149273753146, "a",
  459.42295450451445, 43.53907926079415, "a",
  472.57727229169916, 59.410012816995845, "a",
  447.48029894406545, 0.9227881620428775, "a",
  495.67927080562924, -11.312832980388578, "a",
  489.84987332988413, 51.55532677649512, "a",
  484.77068254658906, 51.741724546127614, "a",
  530.0571345631411, 99.83905442419916, "a",
  473.7768116742866, 49.81510228262414, "a",
  454.3772612138215, 55.489949876536116, "a",
  472.3090933990085, 29.223850020862926, "a",
  528.4739976954197, 81.71945727860185, "a",
  503.92582902422134, 15.791677372714616, "a",
  484.8431676306173, -36.45154063119048, "a",
  525.4810190895731, -19.962455130126614, "a",
  492.700453525686, 39.48143135652572, "a",
  505.7976825898339, 10.821653737051236, "a",
  498.1973729459462, 51.900042154922744, "a",
  495.7494135060992, 40.48640250906311, "a",
  527.1250243598444, 36.86911644798607, "a",
  494.18892649803684, 79.33460386315517, "a",
  531.0430523620637, 83.36348604374933, "a",
  485.68212410023557, 106.52418788065017, "a",
  547.7699689568557, 83.1291760601822, "a",
  547.7435706800477, 62.2353744512269, "a",
  554.0669942978694, 86.02233994753385, "a",
  502.8191831811939, 24.209653046541348, "a",
  506.46516981174534, 8.270974940095755, "a",
  486.1491803524337, 3.059401955373062, "a",
  493.33371216711305, -16.455021000765782, "a",
  538.9699482170923, -10.177807689836527, "a",
  541.1027979088965, 21.950877075828657, "a",
  538.373851496006, 73.65748130971497, "a",
  523.2227509001208, 123.72599243046358, "a",
  559.3695736861193, 91.1586022860073, "a",
  547.3360733977488, 139.01584856238128, "a",
  551.8943147206151, 111.03316497508928, "a",
  562.1539390258787, 115.10172689699436, "a",
  521.6769592743768, 99.92418353037823, "a",
  543.4423094687754, 32.96050423869286, "a",
  582.2396545815935, 25.32508193914174, "a",
  554.3914689368032, 42.95315458258119, "a",
  567.6294798874325, 42.97141162428062, "a",
  562.5192610588424, 135.9334574142864, "a",
  578.7398576103811, 92.6439694949849, "a",
  572.3655505832957, 132.85460946094253, "a",
  642.8736524609861, 100.95828080192842, "a",
  568.8051227117842, 139.45697099124123, "a",
  570.5224531687234, 100.55475941472423, "a",
  562.0395086094809, 87.02350462120353, "a",
  591.173078375888, 52.98036918977499, "a",
  554.7876307589169, 57.383462603470036, "a",
  581.6718475611367, 63.624404985043554, "a",
  601.266952435606, 56.70039049129224, "a",
  530.7159328063112, 0.37922840747364717, "a",
  614.1162231265494, 47.37821381876995, "a",
  630.57996777968, 73.12107424117761, "a",
  614.8644356229399, 62.89478301168646, "a",
  615.035896125105, 63.33377378468987, "a",
  597.242508486555, 121.83746364182298, "a",
  616.9702438895923, 62.10690703281199, "a",
  670.7092043240011, 111.532962088815, "a",
  655.4780893365848, 74.98433294354163, "a",
  629.7488831628295, 27.710432976638856, "a",
  596.2505531864607, 16.85684752693362, "a",
  615.9067696857768, 63.26555419661855, "a",
  636.7453827010203, -21.12455701819829, "a",
  559.9729485908156, 23.159008098390757, "a",
  652.0002738510119, 43.75759585188757, "a",
  643.219270769133, 103.78200762910654, "a",
  604.1337043595388, 107.7418022466008, "a",
  687.0956872175301, 121.11919349606109, "a",
  680.2971078421208, 119.5235117573597, "a",
  674.0245743838901, 90.63345103871967, "a",
  657.0958714200591, 120.20571526142533, "a",
  671.2902721324526, 23.25212234516016, "a",
  674.5750989057177, 25.660654602169018, "a",
  650.8916018386328, 28.271752980631675, "a",
  642.880917346955, 17.57794489637149, "a",
  681.2478941618768, -1.047853886979226, "a",
  660.6210843879784, 49.23726015732865, "a",
  673.6234168991614, 49.207278182409254, "a",
  648.1569563525578, 30.40872061884238, "a",
  642.6444372952773, 102.06150315632834, "a",
  697.8917078398813, 97.82230668791732, "a",
  682.4235840008574, 86.68274483412762, "a",
  702.7662521158749, 85.21322016166704, "a",
  654.89141661988, 86.85610015615214, "a",
  715.6453711224777, -13.248811627950545, "a",
  649.9599190371466, 28.86513426990956, "a",
  649.4180309139244, -11.051068728717041, "a",
  699.758594315669, 16.718792070467487, "a",
  631.0853369898889, 13.477856667103367, "a",
  689.4721970199586, -8.655702081208062, "a",
  690.7238581463971, 66.69005725560277, "a",
  662.3952762824235, 27.306702242172378, "a",
  638.8863188633593, 50.78577815552228, "a",
  734.6246734155446, 62.68134907592599, "a",
  725.4229888341416, 105.54562895800007, "a",
  676.6453383524272, 113.91719092747496, "a",
  688.9047051428239, 63.48835849497834, "a",
  712.4984440021743, 50.76615039492498, "a",
  695.9009142350366, 63.415999914889085, "a",
  681.145721554013, 29.014053527748388, "a",
  669.0847827361488, 68.34096329967491, "a",
  677.747385840001, 31.93770109928971, "a",
  687.5735714721073, 73.39281448439624, "a",
  763.1835113603041, 40.93309785969279, "a",
  693.7727484438234, 74.90626511929565, "a",
  711.5137791655895, 52.957548519289844, "a",
  733.5169950109164, 85.78836931715318, "a",
  710.3945094343104, 87.46719329958569, "a",
  680.7140931775713, 29.374115653302454, "a",
  731.172285117789, 6.84989924626791, "a",
  710.3663089233044, 43.942584680587856, "a",
  742.7148475870154, 70.41868360030821, "a",
  668.7561301065524, 35.47360574386863, "a",
  682.3541512192921, 50.56548145730903, "a",
  706.4377176331892, 103.90820472072966, "a",
  753.5338465524006, 81.1920857694584, "a",
  714.7396884859252, 132.5498546729621, "a",
  735.420213896397, 96.96386846179257, "a",
  718.0264914126396, 121.6203004071358, "a",
  725.2523600993987, 81.28148294012033, "a",
  676.2099108705494, 87.9374487021471, "a",
  659.4648289655448, 32.557779450575765, "a",
  660.3295732576295, -6.906949908302806, "a",
  626.5989203651577, 52.03683614198661, "a",
  691.9367812197916, 23.27238538672634, "a",
  578.496678485938, 20.36430725030101, "a",
  659.883539616757, 71.28933455631295, "a",
  741.7484700019287, 135.4342973929464, "a",
  689.2214117391911, 111.1433684732682, "a",
  669.305149637928, 93.23121477913492, "a",
  711.6522758494029, 71.14107622760628, "a",
  642.5568599986298, 126.64007323735058, "a",
  680.518548567473, 66.748825270888, "a",
  674.5755514123232, 43.15995052678693, "a",
  635.3553932543352, 45.214360352564995, "a",
  616.4836554262699, 111.43071554651334, "a",
  650.9460690162487, 115.08978616856507, "a",
  662.2005543700716, 144.78617345256697, "a",
  660.0316718744998, 111.83628343186388, "a",
  666.7215477381347, 116.99299697405729, "a",
  664.621532867331, 135.76554247745992, "a",
  681.269787236978, 131.92832123041205, "a",
  662.8437005964817, 139.69190432394396, "a",
  644.4547326460055, 158.685995232651, "a",
  630.3967542650046, 111.3980774238824, "a",
  643.6271324098343, 57.014083653109935, "a",
  659.7555847881656, 109.66263419960728, "a",
  654.1568674532654, 65.04584295982107, "a",
  667.9042356812557, 154.63942435060795, "a",
  657.7390212255684, 126.08509021891189, "a",
  652.7669660260968, 110.60722119615366, "a",
  690.3343570915936, 30.757919244446157, "a",
  668.781167133429, 90.85516489793832, "a",
  666.8139460427384, 140.03529780776654, "a",
  572.0847230123471, 118.34609556639299, "a",
  614.3887822273251, 94.64541206786282, "a",
  566.4295806142076, 57.808998723657396, "a",
  556.1156255637586, 135.0355393729916, "a",
  599.061029206549, 113.92003292681397, "a",
  564.1093851944486, 71.71056785086262, "a",
  593.0724684206278, 121.44006131997986, "a",
  596.2966261289555, 127.48365012111151, "a",
  578.3059175785157, 106.17006189947409, "a",
  675.8638336376672, 123.27377961095237, "a",
  643.5223872155568, 111.50274783112775, "a",
  632.2625817661361, 142.2580510304233, "a",
  583.9114799475065, 83.41027861772534, "a",
  632.1886466017563, 48.323960410999746, "a",
  573.7937040609318, 111.76869849018021, "a",
  666.6745873991202, 73.07582033409756, "a",
  585.0681961592012, 126.22235469709778, "a",
  576.5494738941998, 81.1184903728003, "a",
  614.9028983062962, 60.084352370513216, "a",
  577.0347984873055, 99.89731608592575, "a",
  612.7814357000499, 135.61553078246237, "a",
  611.2169141051617, 167.63371484323636, "a",
  626.8943189191199, 139.33054392209647, "a",
  531.7648495208259, 106.90897990451975, "a",
  567.2963116722461, 112.64333967383607, "a",
  596.1547875390362, 115.67389498301497, "a",
  597.5245781999149, 98.46115194073616, "a",
  632.222258625311, 132.27035620859488, "a",
  600.3220872464071, 101.32723317241778, "a",
  561.2653742499025, 107.89355390293252, "a",
  583.7309659110925, 122.0963072984535, "a",
  580.0247576051261, 160.9265717584841, "a",
  549.1754725585121, 81.92448691012987, "a",
  585.7445340833631, 105.60714178452031, "a",
  578.1976978183757, 126.02160969046787, "a",
  572.808308394738, 94.36383261170505, "a",
  544.0413168065995, 131.910981340871, "a",
  542.8778952182894, 109.84296822067279, "a",
  377.2414279836732, 155.77308336647053, "b",
  368.0310520508527, 89.152582548684, "b",
  358.09541122895945, 118.404886437188, "b",
  321.1174251499526, 67.30817723755024, "b",
  383.3612631764752, 54.582216477476095, "b",
  369.476109956462, 65.36858385714271, "b",
  338.01561172378894, 81.6482928551286, "b",
  384.8077814583488, 119.04546841852738, "b",
  345.34089953682815, 48.55601407277027, "b"
]

input = input.each_slice(3)
pp input.to_a
points_to_predict = input.filter { |x| x[2] == "b" }.map { |x| [x[0], x[1]] }.take(5)
input = input.filter { |x| x[2] == "a" }.map { |x| [x[0], x[1]] }.take(20)

pp points_to_predict.size
pp input.size
pp ranges = input[0].length.times.map { |dim| adjusted_box(input, dim) }
ranges = [-100.0..800, 0.0..150]
novelty_service = Ml::Service::Isolation::Novelty.new(
  batch_size: 20,
  max_depth: 5,
  ranges: ranges
)

# points_to_predict = [[29, 5]]
# input += points_to_predict
# FILTER OUT inputs out of range!

input = input.filter { |input| ranges[0].include?(input[0]) && ranges[1].include?(input[1]) }
points_to_predict = points_to_predict.filter { |input| ranges[0].include?(input[0]) && ranges[1].include?(input[1]) }

# cerny kdyz ucis s nim
# muzes zakomentovat a bude modry

# points_to_predict = [[10, 5]]
forest = Ml::Forest::Tree.new(input, trees_count: 1, forest_helper: novelty_service)

input += points_to_predict

pred_input = input.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }
# pred_to_predict = points_to_predict.map { |point| forest.fit_predict(point, forest_helper: novelty_service) }

input_novelty = input.zip(pred_input).filter { |_coord, score| score.novelty? }.map { |x| x[0] }

pp input_novelty.size

input_regular = input.zip(pred_input).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }
input_novelty = input.zip(pred_input).filter { |_coord, score| score.novelty? }.map { |x| x[0] }

# to_predict_novelty = points_to_predict.zip(pred_to_predict).filter { |_coord, score| score.novelty? }.map { |x| x[0] }
# to_predict_regular = points_to_predict.zip(pred_to_predict).filter { |_coord, score| !score.novelty? }.map { |x| x[0] }

depths_for_tree = Enumerator.new do |y|
  deep_depths(ranges, forest.trees[0]) { |x| y << x }
end

pp "dasdas"
pp depths_for_tree.to_a

# Create a new graph
g = GraphViz.new(:G, type: :digraph, "rankdir" => "LR")
g.node[:shape] = "polygon"

depths_for_tree.each do |x, y|
  g.add_edges(x, y)
end

# Generate output image
g.output(svg: "figures/hello_world.svg")

Gnuplot.open do |gp|
  s = Enumerator.new do |y|
    split_and_depths(ranges, forest.trees[0]) { |x| y << x }
  end

  labels, label_xs, label_ys = prepare_depth_labels(s).transpose
  line_xs, line_ys = prepare_lines(ranges, forest)

  plot_regular = input_regular
  plot_novelty = input_novelty

  plot(gp, "../../figures/example4_gnu.svg", ranges[0].minmax, ranges[1].minmax) do |plot|
    plot.data << lines_init(prepare_for_lines_plot(line_xs), prepare_for_lines_plot(line_ys))
    set_labels(plot, ["Px"], [points_to_predict[0][0] - 1.5], [points_to_predict[0][1]], "Bold")
    set_labels(plot, labels, label_xs, label_ys)
    plot.data << points_init(*plot_regular.transpose, "regular", "1", "black") # regular
    plot.data << points_init(*plot_novelty.transpose, "novelty", "2", "blue") # novelty
  end
end
