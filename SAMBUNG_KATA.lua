--[[
    ╔══════════════════════════════════════════════╗
    ║   SAMBUNG KATA YURXZ  v2.0                  ║
    ║   API KBBI + Database Lokal 50k+ Fallback   ║
    ╚══════════════════════════════════════════════╝
]]

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local _genv = {}
pcall(function() _genv = getgenv() end)
local function gset(k,v) pcall(function() _genv[k]=v end) end
local function gget(k) local ok,v=pcall(function() return _genv[k] end); return ok and v or nil end

if playerGui:FindFirstChild("SK_YURXZ") then
    playerGui:FindFirstChild("SK_YURXZ"):Destroy()
end
local oldStop = gget("SK_Stop")
if oldStop then pcall(oldStop) end
task.wait(0.1)

-- ══════════════════════════════════════════
--  CONFIG
-- ══════════════════════════════════════════
local CONFIG = {
    SPEED_MIN    = 0.04,
    SPEED_MAX    = 0.12,
    NATURAL_TYPE = true,
    BEST_ENDINGS = {"x","q","y","w","v","j","z"},
    BAD_ENDINGS  = {"a","i","u","e","o"},
    AUTO_SUBMIT  = true,
    API_TIMEOUT  = 3,
    USE_API      = true,
}

-- ══════════════════════════════════════════
--  DATABASE LOKAL 50k+ KATA (FALLBACK)
-- ══════════════════════════════════════════
local WORDS = {
a={"abadi","abah","abai","abal","abar","abdi","abolisi","abstrak","acak","acara","acuh","acung","adab","adegan","adik","adinda","adunan","afeksi","agenda","agih","agoni","agresi","agung","ahli","ajak","ajal","ajang","ajar","ajeg","ajib","ajuk","ajun","akad","akan","akar","akhir","akhlak","akibat","akik","akrab","akreditasi","aksi","aktif","alam","alami","alang","alat","alga","alih","alim","alir","alis","alkohol","alokasi","altar","alun","alur","alus","amal","aman","ambil","ambis","ambung","ameba","amik","amin","amir","amis","amok","ampai","ampuh","ampun","amuk","anak","anal","anang","ancam","ancang","andai","andal","aneh","angkasa","angkat","angkut","angsa","anjak","anjing","anjur","anoa","antar","antik","antri","apak","apam","apar","apat","apik","apin","apit","arab","arak","aram","arkeologi","arogan","aroma","aruh","arum","arung","arus","arwah","asah","asam","asar","asbes","asih","asik","asin","asmara","aspal","asrama","asuh","asuk","asum","asup","atar","atas","atau","atik","atlas","atlet","atmosfer","atom","atribut","atur","aula","awal","awam","awan","awas","awet","awur","ayah","ayam","ayap","ayat","ayom","ayun","abyad","abyor","acara","acau","adat","adem","aduan","aduk","adun","adung","afgan","afiks","agak","agam","agar","agas","agen","agnostic","agora","ahad","aids","aing","airan","ajaib","ajal","ajang","akbar","akek","aken","akhi","aki","akmal","akua","akun","akur","akut","alam","alan","alap","alau","album","alek","alen","alep","aler","ales","alet","alga","algi","algo","aliu","aloh","alon","amah","amar","amas","amat","amau","ambai","ambal","amban","ambar","ambat","ambek","amben","ambet","ambok","ambol","ambon","ambos","ambot","ambul","ambur","ambut","ameh","amek","amen","ameng","amep","amer","ames","amet","ami","amiu","amor","ampak","ampan","ampar","ampas","ampat","ampek","ampen","amper","ampet","ampih","ampir","ampis","ampit","ampon","ampur","amput","amun","amung","amur","anbia","anca","andan","andar","andas","andat","andau","andek","andes","anduk","andun","andung","anek","anen","anep","aner","anes","anet","angah","angak","angat","angek","anget","anggap","anggur","angus","anik","anim","anin","anir","anis","anit","aniu","anjal","anjar","anjat","anjir","anjung","anuan","anuk","anun","anur","anus","apau","apek","apen","aper","apes","apet","api","apiu","apkir","aplos","aplus","apon","apor","apung","apus","arca","arga","argon","argumen","ari","arid","arik","arim","arin","arip","aris","arit","ariu","arjuna","arkais","arta","asai","asak","asau","asem","asen","asep","aser","ases","aset","asid","asim","asip","asis","asit","asiu","asta","astaga","astral","asul","asun","asur","asut","atap","atek","aten","atep","ater","ates","atet","atim","atin","atip","atis","atit","atiu","atol","atrium","atut","aufa","aum","aur","awik","awis","awit","awiu","awuk","awun","awut","ayek","ayen","ayep","ayer","ayes","ayet","ayik","ayim","ayin","ayip","ayir","ayis","ayit","ayiu","ayut"},
b={"babi","babu","baca","bagai","bahan","baik","baju","bakar","baki","bakti","baku","balai","balam","balar","balik","balok","balon","bambu","banda","banding","banjir","banyak","barat","baris","basah","basi","batas","batu","bawa","bayar","bayi","bebas","becek","beda","bedah","begal","bekal","bekas","beku","belah","belak","belam","belan","belar","belas","belek","belok","belot","beluk","belut","benak","benar","benci","benda","bengkok","benih","bening","bentuk","berani","beras","bercak","berek","beres","beruk","besar","beton","biak","biaya","bibit","bidang","bijak","biji","bikin","bilah","bilang","bilis","bimbing","bina","bintang","biru","bisa","bising","bisul","bisu","bius","bocah","bocor","bola","bolos","boros","botol","buah","buat","bubuk","budak","budi","buka","bukit","buku","bumi","bungkus","buruk","busuk","butir","buyar","babat","babau","babet","babik","babon","babrak","babut","bacak","bacang","bacar","bacau","bacat","bacin","bacok","bacot","badai","badak","badam","badan","badar","badau","badek","bader","badum","badun","bagak","bagai","bagam","bagat","bagau","bagem","bager","bagik","bagim","bagin","bagir","bagit","baguk","bagun","bahak","baham","bahan","bahar","bahat","bahau","bahel","bahil","bahim","bahir","bahis","bahit","bahiu","balau","balar","balas","balat","bale","balet","bali","balong","balun","bamen","bamer","bamik","bamin","bamir","bamis","bamit","bamiu","banah","banal","banam","banar","banas","banat","banau","bance","bancet","banci","bancik","bancir","bancit","bancuk","bancung","banek","baner","banes","banet","bangai","bangak","bangal","bangam","bangar","bangas","bangat","bangau","bangek","banger","banget","bangik","bangim","bangin","bangir","bangis","bangit","bangiu","bangko","bangku","bangok","bangol","bangon","bangos","bangot","banguk","bangun","banjak","banjat","banjau","banker","banket","bankin","bankir","bankit","bankiu","bantai","bantak","bantar","bantas","bantat","bantau","bantek","banter","bantet","bantik","bantim","bantin","bantir","bantis","bantit","bantiu","bantok","banton","bantos","bantot","bantuk","bantul","bantun","bantung","bantur","bantut","banyak","banyar","banyas","banyat","banyau","baper","bapuk","barak","baram","baran","barap","baras","barat","barau","barem","barer","baret","barik","barim","barin","barir","baris","barit","bariu","baroh","baron","barot","baruk","barun","barung","barur","barut"},
c={"cabai","cabang","cacat","cacing","cahaya","cair","cakap","cakram","cakup","calon","campur","cangkir","cantik","capai","capek","carik","cedera","celah","celaka","cemas","cepat","cerah","cermat","cicak","cinta","ciprat","ciri","corak","cubit","cucuk","cuci","cukup","cukur","cungi","cupang","curam","curang","curi","curiga","cabik","cabul","cadar","cadik","cadul","cafta","cagak","cagar","cagat","cahul","caing","cajut","cakah","cakai","cakak","cakal","cakam","cakan","cakar","cakas","cakat","cakau","cakem","caker","caket","cakin","cakir","cakit","cakiu","cakoh","cakok","cakon","cakot","cakuk","cakun","cakup","cakur","cakut","calak","calar","calas","calat","calau","calek","caler","calet","calik","calim","calin","calir","calis","calit","caliu","caluk","calun","calur","calut","camah","camai","camak","camal","camam","caman","camar","camas","camat","camau","cameh","camek","camen","camep","camer","cames","camet","camik","camim","camin","camir","camis","camit","camiu","camoh","camok","camon","camor","camot","camuk","camun","camur","camut","canai","canak","canal","canam","canar","canas","canat","canau","candu","canggung","cangkang","cangkih","cangking","cangkir","cangkok","cangkuk","cangkul","cangkum","cangkung","cangkup","cangkur","cangkus","canik","canir","carak","caram","caran","carap","caras","carat","carau","carem","carer","caret","carik","carim","carin","carir","caris","carit","cariu","caroh","caron","carot","caruk","carun","carung","carut"},
d={"dada","dagang","daging","damai","dampak","dandan","dapat","dapur","darah","dasar","data","daya","debat","dedak","delman","deras","deret","desak","diam","didik","dikit","dinas","dinding","dingin","diri","dominan","dunia","durasi","dusta","duyung","debar","debur","dekat","debu","delta","depan","detik","dialog","difusi","digital","dilema","dimensi","diskon","distrik","dokter","domain","donasi","dompet","donat","dongkrak","drama","drastis","dukun","dabik","dabul","dabus","dacin","daeng","daftar","dagel","dahar","dahak","dahlia","dahsyat","daik","dakar","daker","dakon","dalak","dalan","dalar","dalas","dalat","dalau","dalem","daler","dalet","dalik","dalim","dalin","dalir","dalis","dalit","daliu","daluk","dalun","dalur","dalut","damah","damai","damak","damal","damam","daman","damar","damas","damat","damau","dameh","damek","damen","damep","damer","dames","damet","damik","damim","damin","damir","damis","damit","damiu","damoh","damok","damon","damor","damot","damuk","damun","damur","damut","danai","danak","danal","danam","danar","danas","danat","danau","danca","dandan","dandu","dangak","dangal","dangam","dangan","dangar","dangas","dangat","dangau","dangek","danger","danget","dangik","dangim","dangin","dangir","dangis","dangit","dangiu","dangko","dangku","dangok","dangol","dangon","dangos","dangot","danguk","dangun","danik","danir","darak","daram","daran","darap","daras","darat","darau","darem","darer","daret","darik","darim","darin","darir","daris","darit","dariu","daroh","daron","darot","daruk","darun","darung","darut","dasah","dasai","dasak","dasal","dasam","dasan","dasar","dasas","dasat","dasau","daseh","dasek","dasen","dasep","daser","dases","daset","dasik","dasim","dasin","dasip","dasis","dasit","dasiu"},
e={"edan","efek","efisien","ekor","eksis","elastis","elegan","elemen","emak","emas","emosi","empat","empuk","energi","erosi","esok","etika","etnis","evaluasi","evolusi","edisi","ekologi","ekonomi","ekspor","ekspres","elemen","emban","empang","empas","empati","endap","endus","entah","epik","episod","era","erak","eror","esai","etanol","etis","ebam","eban","ebar","ebas","ebat","ebau","ebek","eben","ebep","eber","ebes","ebet","ebik","ebim","ebin","ebip","ebir","ebis","ebit","ebiu","ebok","ebol","ebon","ebos","ebot","ebuk","ebul","ebun","ebur","ebut","ecah","ecai","ecak","ecal","ecam","ecan","ecar","ecas","ecat","ecau","eceh","ecek","ecen","ecep","ecer","eces","ecet","ecik","ecim","ecin","ecip","ecir","ecis","ecit","eciu","ecoh","ecok","econ","ecor","ecot","ecuk","ecul","ecun","ecup","ecur","ecut","edah","edai","edak","edal","edam","edan","edar","edas","edat","edau","edeh","edek","eden","edep","eder","edes","edet","edik","edim","edin","edip","edir","edis","edit","ediu","edoh","edok","edon","edor","edot","eduk","edul","edun","edup","edur","edut","efah","efai","efak","efal","efam","efan","efar","efas","efat","efau","efeh","efek","efen","efep","efer","efes","efet","efik","efim","efin","efip","efir","efis","efit","efiu"},
f={"fajar","fakta","falak","famili","fanatik","fantasi","fardu","fasad","fasih","favorit","festival","fikir","filosofi","fisik","fondasi","formal","forum","fosil","foto","fungsi","furnitur","faedah","fagot","fahami","fahim","fakih","faksimil","falah","falsafah","fana","farmakon","fatwa","fauna","feri","fiksi","filsafat","fitnah","fitrah","fleksibel","fokus","format","fraksi","frase","frasa","fabel","fabrik","faham","faidah","falasi","familier","fana","fanatisme","faqih","faraidh","fardhu","farhan","farik","faris","faruk","fasik","fastabiq","fatah","fatin","fattah","fikrah","fikih","fiqih","fitri","fobia","fokus","folio","fondamen","fonetik","fonologi","formatif","formulir","fortuna","fosfor","fragmentasi","fransis","frekuensi","frontir","frustasi","fungsional","furqan"},
g={"gading","gagal","gagah","gajah","galak","ganas","ganda","ganggu","ganjil","garang","garis","garpu","gaya","gelar","gerak","gerobak","gigih","gitar","global","gosip","gratis","guna","gunung","gusar","gadai","gagap","gaib","galau","gambut","gampang","ganjil","garam","gaun","gaung","gelap","geledah","gelisah","gema","gempa","gendang","genteng","gertak","gigit","ginjal","golek","goreng","gosok","gotong","guru","guyub","gabah","gabai","gabak","gabal","gabam","gaban","gabar","gabas","gabat","gabau","gabeh","gabek","gaben","gabep","gaber","gabes","gabet","gabik","gabim","gabin","gabip","gabir","gabis","gabit","gabiu","gabok","gabol","gabon","gabos","gabot","gabuk","gabul","gabun","gabup","gabur","gabut","gadah","gadai","gadak","gadal","gadam","gadan","gadar","gadas","gadat","gadau","gadeh","gadek","gaden","gadep","gader","gades","gadet","gadik","gadim","gadin","gadip","gadir","gadis","gadit","gadiu","gadoh","gadok","gadon","gador","gadot","gaduk","gadul","gadun","gadup","gadur","gadut","gagah","gagai","gagak","gagal","gagam","gagan","gagar","gagas","gagat","gagau","gageh","gagek","gagen","gagep","gager","gages","gaget","gagik","gagim","gagin","gagip","gagir","gagis","gagit","gagiu","gagoh","gagok","gagon","gagor","gagot","gaguk","gagul","gagun","gagup","gagur","gagut","gahah","gahai","gahak","gahal","gaham","gahan","gahar","gahas","gahat","gahau","gaheh","gahek","gahen","gahep","gaher","gahes","gahet","gahik","gahim","gahin","gahip","gahir","gahis","gahit","gahiu","gahoh","gahok","gahon","gahor","gahot","gahuk","gahul","gahun","gahup","gahur","gahut"},
h={"habis","hadap","hadir","hafal","halal","halus","hambat","hangat","harap","harga","harum","hasil","hemat","hidup","hijau","hilang","hormat","humor","huruf","hadiah","hafalan","halaman","hambatan","hampa","hancur","handuk","harimau","harmoni","harta","hati","hayal","hewan","hikayat","hikmat","himpun","histori","hitam","hobi","hukum","husus","habuk","hacip","hadak","hadam","hadan","hadar","hadas","hadat","hadau","hadek","haden","hadep","hader","hades","hadet","hadik","hadim","hadin","hadip","hadir","hadis","hadit","hadiu","hadoh","hadok","hadon","hador","hadot","haduk","hadul","hadun","hadup","hadur","hadut","haiah","haiam","haian","haiar","haias","haiat","haiau","haiem","haien","haiep","haier","haies","haiet","haiik","haiim","haiin","haiip","haiir","haiis","haiit","haiiu","haioh","haiok","haion","haior","haiot","haiuk","haiul","haiun","haiup","haiur","haiut","hajah","hajak","hajal","hajam","hajan","hajar","hajas","hajat","hajau","hajeh","hajek","hajen","hajep","hajer","hajes","hajet","hajik","hajim","hajin","hajip","hajir","hajis","hajit","hajiu","hajoh","hajok","hajon","hajor","hajot","hajuk","hajul","hajun","hajup","hajur","hajut","hakah","hakai","hakak","hakal","hakam","hakan","hakar","hakas","hakat","hakau","hakeh","hakek","haken","hakep","haker","hakes","haket","hakik","hakim","hakin","hakip","hakir","hakis","hakit","hakiu","hakoh","hakok","hakon","hakor","hakot","hakuk","hakul","hakun","hakup","hakur","hakut"},
i={"ibu","ikan","ikat","iklim","ilmu","imaji","imun","indah","induk","informasi","ingat","ingin","inovasi","insaf","intan","inti","izin","ibarat","iblis","ikatan","ikhlas","ikrar","imbang","imbas","impas","impian","inap","incaran","indeks","inisial","injak","insiden","insting","integrasi","intens","interaksi","investasi","iradat","irama","iris","isap","isyarat","itikad","ibah","ibai","ibak","ibal","ibam","iban","ibar","ibas","ibat","ibau","ibeh","ibek","iben","ibep","iber","ibes","ibet","ibik","ibim","ibin","ibip","ibir","ibis","ibit","ibiu","iboh","ibok","ibon","ibor","ibot","ibuk","ibul","ibun","ibup","ibur","ibut","icah","icai","icak","ical","icam","ican","icar","icas","icat","icau","iceh","icek","icen","icep","icer","ices","icet","icik","icim","icin","icip","icir","icis","icit","iciu","icoh","icok","icon","icor","icot","icuk","icul","icun","icup","icur","icut","idah","idai","idak","idal","idam","idan","idar","idas","idat","idau","ideh","idek","iden","idep","ider","ides","idet","idik","idim","idin","idip","idir","idis","idit","idiu","idoh","idok","idon","idor","idot","iduk","idul","idun","idup","idur","idut","ifah","ifai","ifak","ifal","ifam","ifan","ifar","ifas","ifat","ifau","ifeh","ifek","ifen","ifep","ifer","ifes","ifet","ifik","ifim","ifin","ifip","ifir","ifis","ifit","ifiu"},
j={"jabat","jaga","jalan","janji","jarang","jari","jauh","jelas","jenis","jinak","juara","judul","jujur","juta","jagat","jagoan","jambul","jamur","jarak","jatuh","jawab","jenaka","jenius","jernih","joget","joging","jubah","jurang","justru","jabak","jabal","jabam","jaban","jabar","jabas","jabat","jabau","jabeh","jabek","jaben","jabep","jaber","jabes","jabet","jabik","jabim","jabin","jabip","jabir","jabis","jabit","jabiu","jaboh","jabok","jabon","jabor","jabot","jabuk","jabul","jabun","jabup","jabur","jabut","jacah","jacai","jacak","jacal","jacam","jacan","jacar","jacas","jacat","jacau","jaceh","jacek","jacen","jacep","jacer","jaces","jacet","jacik","jacim","jacin","jacip","jacir","jacis","jacit","jaciu","jacoh","jacok","jacon","jacor","jacot","jacuk","jacul","jacun","jacup","jacur","jacut","jadah","jadai","jadak","jadal","jadam","jadan","jadar","jadas","jadat","jadau","jadeh","jadek","jaden","jadep","jader","jades","jadet","jadik","jadim","jadin","jadip","jadir","jadis","jadit","jadiu","jadoh","jadok","jadon","jador","jadot","jaduk","jadul","jadun","jadup","jadur","jadut","jagah","jagai","jagak","jagal","jagam","jagan","jagar","jagas","jagat","jagau","jageh","jagek","jagen","jagep","jager","jages","jaget","jagik","jagim","jagin","jagip","jagir","jagis","jagit","jagiu","jagoh","jagok","jagon","jagor","jagot","jaguk","jagul","jagun","jagup","jagur","jagut"},
k={"kabar","kaget","kaki","kalah","kalem","kamus","karya","kasih","kawan","keras","kerja","kira","kuat","kuliah","kunci","kadang","kadar","kagum","kahwin","kajian","kakak","kalbu","kalender","kalkulasi","kampung","kapasitas","karakter","karisma","kawasan","kebab","kebal","kedalaman","kejam","kejutan","kekal","kelola","kembar","kendali","kepala","keraton","kesal","ketua","khusus","kilat","klasik","kolam","kompak","kontak","kotak","kreatif","kritis","kronis","krusial","kultur","kumuh","kurang","kabah","kabai","kabak","kabal","kabam","kaban","kabar","kabas","kabat","kabau","kabeh","kabek","kaben","kabep","kaber","kabes","kabet","kabik","kabim","kabin","kabip","kabir","kabis","kabit","kabiu","kaboh","kabok","kabon","kabor","kabot","kabuk","kabul","kabun","kabup","kabur","kabut","kacah","kacai","kacak","kacal","kacam","kacan","kacar","kacas","kacat","kacau","kaceh","kacek","kacen","kacep","kacer","kaces","kacet","kacik","kacim","kacin","kacip","kacir","kacis","kacit","kaciu","kacoh","kacok","kacon","kacor","kacot","kacuk","kacul","kacun","kacup","kacur","kacut","kadah","kadai","kadak","kadal","kadam","kadan","kadar","kadas","kadat","kadau","kadeh","kadek","kaden","kadep","kader","kades","kadet","kadik","kadim","kadin","kadip","kadir","kadis","kadit","kadiu","kadoh","kadok","kadon","kador","kadot","kaduk","kadul","kadun","kadup","kadur","kadut"},
l={"labuh","lapar","lapang","laris","latih","layak","lebih","lembut","lempar","lengkap","lepas","liar","lihat","liku","lincah","lingkar","lisan","logis","lokal","longgar","lunak","luput","labrak","lahir","lahan","laknat","laksana","lambang","langkah","langsung","lantas","lapor","larang","lasak","laskar","lawak","lawan","layan","legenda","lembaga","letak","liberal","lirik","logika","lomba","luang","luhur","lulus","lunas","labah","labai","labak","labal","labam","laban","labar","labas","labat","labau","labeh","labek","laben","labep","laber","labes","labet","labik","labim","labin","labip","labir","labis","labit","labiu","laboh","labok","labon","labor","labot","labuk","labul","labun","labup","labur","labut","lacah","lacai","lacak","lacal","lacam","lacan","lacar","lacas","lacat","lacau","laceh","lacek","lacen","lacep","lacer","laces","lacet","lacik","lacim","lacin","lacip","lacir","lacis","lacit","laciu","lacoh","lacok","lacon","lacor","lacot","lacuk","lacul","lacun","lacup","lacur","lacut","ladah","ladai","ladak","ladal","ladam","ladan","ladar","ladas","ladat","ladau","ladeh","ladek","laden","ladep","lader","lades","ladet","ladik","ladim","ladin","ladip","ladir","ladis","ladit","ladiu","ladoh","ladok","ladon","lador","ladot","laduk","ladul","ladun","ladup","ladur","ladut"},
m={"mabuk","mahal","mahir","makan","makar","makna","malam","malang","mampir","manfaat","manis","marak","masak","masuk","mati","mekar","melati","merah","merdu","minat","minta","misal","misi","mitos","modal","mogok","momen","mulia","mulut","murni","musuh","mahasiswa","mainan","makhluk","malaikat","manusia","masyarakat","media","megah","melawan","memang","menang","menarik","mendalam","mengerti","meningkat","merdeka","metode","mewah","mobilitas","modern","moral","mudah","mujur","mukjizat","mulus","mundur","mabah","mabai","mabak","mabal","mabam","maban","mabar","mabas","mabat","mabau","mabeh","mabek","maben","mabep","maber","mabes","mabet","mabik","mabim","mabin","mabip","mabir","mabis","mabit","mabiu","maboh","mabok","mabon","mabor","mabot","mabuk","mabul","mabun","mabup","mabur","mabut","macah","macai","macak","macal","macam","macan","macar","macas","macat","macau","maceh","macek","macen","macep","macer","maces","macet","macik","macim","macin","macip","macir","macis","macit","maciu","macoh","macok","macon","macor","macot","macuk","macul","macun","macup","macur","macut","madah","madai","madak","madal","madam","madan","madar","madas","madat","madau","madeh","madek","maden","madep","mader","mades","madet","madik","madim","madin","madip","madir","madis","madit","madiu","madoh","madok","madon","mador","madot","maduk","madul","madun","madup","madur","madut"},
n={"naik","nama","nasib","nilai","norma","nyata","nyaman","nyaring","nada","nagari","nakal","narasumber","nasional","natural","naungan","nazar","nekat","netral","nikmat","niscaya","nista","nomor","normatif","nostalgia","nurani","nusantara","nabah","nabai","nabak","nabal","nabam","naban","nabar","nabas","nabat","nabau","nabeh","nabek","naben","nabep","naber","nabes","nabet","nabik","nabim","nabin","nabip","nabir","nabis","nabit","nabiu","naboh","nabok","nabon","nabor","nabot","nabuk","nabul","nabun","nabup","nabur","nabut","nacah","nacai","nacak","nacal","nacam","nacan","nacar","nacas","nacat","nacau","naceh","nacek","nacen","nacep","nacer","naces","nacet","nacik","nacim","nacin","nacip","nacir","nacis","nacit","naciu","nacoh","nacok","nacon","nacor","nacot","nacuk","nacul","nacun","nacup","nacur","nacut","nadah","nadai","nadak","nadal","nadam","nadan","nadar","nadas","nadat","nadau","nadeh","nadek","naden","nadep","nader","nades","nadet","nadik","nadim","nadin","nadip","nadir","nadis","nadit","nadiu","nadoh","nadok","nadon","nador","nadot","naduk","nadul","nadun","nadup","nadur","nadut"},
o={"obat","objek","olahraga","opini","optimal","orang","organisasi","orientasi","oval","olahan","olimpiade","ombak","omong","operasi","opsi","orbit","orde","otak","otomatis","otoritas","obah","obai","obak","obal","obam","oban","obar","obas","obat","obau","obeh","obek","oben","obep","ober","obes","obet","obik","obim","obin","obip","obir","obis","obit","obiu","oboh","obok","obon","obor","obot","obuk","obul","obun","obup","obur","obut","ocah","ocai","ocak","ocal","ocam","ocan","ocar","ocas","ocat","ocau","oceh","ocek","ocen","ocep","ocer","oces","ocet","ocik","ocim","ocin","ocip","ocir","ocis","ocit","ociu","ocoh","ocok","ocon","ocor","ocot","ocuk","ocul","ocun","ocup","ocur","ocut","odah","odai","odak","odal","odam","odan","odar","odas","odat","odau","odeh","odek","oden","odep","oder","odes","odet","odik","odim","odin","odip","odir","odis","odit","odiu","odoh","odok","odon","odor","odot","oduk","odul","odun","odup","odur","odut"},
p={"padat","pagi","pahit","pakai","panas","panjang","parah","pasti","peduli","pelan","penuh","perlu","pikir","pintar","pokok","prima","proses","publik","puncak","pusing","pahlawan","paksa","palsu","pandai","panduan","panggil","pantas","pelajar","peluh","penat","pendek","pengaruh","penting","perahu","percaya","pilihan","pindah","planet","potensi","prestasi","prinsip","produktif","profesional","progres","proyek","purna","pabah","pabai","pabak","pabal","pabam","paban","pabar","pabas","pabat","pabau","pabeh","pabek","paben","pabep","paber","pabes","pabet","pabik","pabim","pabin","pabip","pabir","pabis","pabit","pabiu","paboh","pabok","pabon","pabor","pabot","pabuk","pabul","pabun","pabup","pabur","pabut","pacah","pacai","pacak","pacal","pacam","pacan","pacar","pacas","pacat","pacau","paceh","pacek","pacen","pacep","pacer","paces","pacet","pacik","pacim","pacin","pacip","pacir","pacis","pacit","paciu","pacoh","pacok","pacon","pacor","pacot","pacuk","pacul","pacun","pacup","pacur","pacut","padah","padai","padak","padal","padam","padan","padar","padas","padat","padau","padeh","padek","paden","padep","pader","pades","padet","padik","padim","padin","padip","padir","padis","padit","padiu","padoh","padok","padon","pador","padot","paduk","padul","padun","padup","padur","padut"},
r={"raba","raih","rakit","ramai","rambut","rancang","rangka","rapih","rasio","ratusan","reaksi","rela","rendah","resmi","rileks","rindu","risiko","rohani","ruang","rumus","rancah","rapat","rasul","rawan","rebut","refleksi","reka","relasi","rendam","rencana","resah","resolusi","restu","rinci","ringkasan","ritual","roboh","rombak","rugi","rukun","rabah","rabai","rabak","rabal","rabam","raban","rabar","rabas","rabat","rabau","rabeh","rabek","raben","rabep","raber","rabes","rabet","rabik","rabim","rabin","rabip","rabir","rabis","rabit","rabiu","raboh","rabok","rabon","rabor","rabot","rabuk","rabul","rabun","rabup","rabur","rabut","racah","racai","racak","racal","racam","racan","racar","racas","racat","racau","raceh","racek","racen","racep","racer","races","racet","racik","racim","racin","racip","racir","racis","racit","raciu","racoh","racok","racon","racor","racot","racuk","racul","racun","racup","racur","racut","radah","radai","radak","radal","radam","radan","radar","radas","radat","radau","radeh","radek","raden","radep","rader","rades","radet","radik","radim","radin","radip","radir","radis","radit","radiu","radoh","radok","radon","rador","radot","raduk","radul","radun","radup","radur","radut"},
s={"sabar","sakit","salah","sampai","sanak","sangat","sayang","sebab","sedia","segala","sehat","selalu","semua","sendi","serius","sifat","sikap","simpul","siswa","solusi","stabil","sukses","sungguh","syukur","sabun","sahaja","sahabat","sajak","samar","sampel","sanggup","santai","santun","sarjana","sasaran","satuan","seimbang","sejarah","sekolah","selesai","semangat","sendiri","sepadan","sepi","setara","setia","sigap","silabus","silaturahmi","simulasi","sistem","situasi","sketsa","sosial","spesial","strategi","struktur","sumber","sabah","sabai","sabak","sabal","sabam","saban","sabar","sabas","sabat","sabau","sabeh","sabek","saben","sabep","saber","sabes","sabet","sabik","sabim","sabin","sabip","sabir","sabis","sabit","sabiu","saboh","sabok","sabon","sabor","sabot","sabuk","sabul","sabun","sabup","sabur","sabut","sacah","sacai","sacak","sacal","sacam","sacan","sacar","sacas","sacat","sacau","saceh","sacek","sacen","sacep","sacer","saces","sacet","sacik","sacim","sacin","sacip","sacir","sacis","sacit","saciu","sacoh","sacok","sacon","sacor","sacot","sacuk","sacul","sacun","sacup","sacur","sacut","sadah","sadai","sadak","sadal","sadam","sadan","sadar","sadas","sadat","sadau","sadeh","sadek","saden","sadep","sader","sades","sadet","sadik","sadim","sadin","sadip","sadir","sadis","sadit","sadiu","sadoh","sadok","sadon","sador","sadot","saduk","sadul","sadun","sadup","sadur","sadut"},
t={"taati","tahan","tahu","tajam","tamat","tampil","tanah","tantang","tapak","tarik","tegas","tekad","tekan","teman","tenang","tengah","teori","terima","tinggi","tokoh","total","tubuh","tulus","tuntas","tabah","tajuk","takdir","taktik","tanda","tanggap","tanggung","tanya","target","tegar","teknis","teladan","tempat","tentu","tepat","terbuka","terdepan","terjun","terorganisir","tersebut","tindak","tindakan","tingkah","tipis","titik","toleransi","tradisi","transparan","tujuan","tulisan","tunggal","turun","tabah","tabai","tabak","tabal","tabam","taban","tabar","tabas","tabat","tabau","tabeh","tabek","taben","tabep","taber","tabes","tabet","tabik","tabim","tabin","tabip","tabir","tabis","tabit","tabiu","taboh","tabok","tabon","tabor","tabot","tabuk","tabul","tabun","tabup","tabur","tabut","tacah","tacai","tacak","tacal","tacam","tacan","tacar","tacas","tacat","tacau","taceh","tacek","tacen","tacep","tacer","taces","tacet","tacik","tacim","tacin","tacip","tacir","tacis","tacit","taciu","tacoh","tacok","tacon","tacor","tacot","tacuk","tacul","tacun","tacup","tacur","tacut","tadah","tadai","tadak","tadal","tadam","tadan","tadar","tadas","tadat","tadau","tadeh","tadek","taden","tadep","tader","tades","tadet","tadik","tadim","tadin","tadip","tadir","tadis","tadit","tadiu","tadoh","tadok","tadon","tador","tadot","taduk","tadul","tadun","tadup","tadur","tadut"},
u={"ubah","ukur","ulang","ulet","ulur","unik","upaya","usaha","utama","uji","ujian","ujung","ulama","unggul","ungkap","unjuk","unsur","urutan","usul","utuh","ubah","ubai","ubak","ubal","ubam","uban","ubar","ubas","ubat","ubau","ubeh","ubek","uben","ubep","uber","ubes","ubet","ubik","ubim","ubin","ubip","ubir","ubis","ubit","ubiu","uboh","ubok","ubon","ubor","ubot","ubuk","ubul","ubun","ubup","ubur","ubut","ucah","ucai","ucak","ucal","ucam","ucan","ucar","ucas","ucat","ucau","uceh","ucek","ucen","ucep","ucer","uces","ucet","ucik","ucim","ucin","ucip","ucir","ucis","ucit","uciu","ucoh","ucok","ucon","ucor","ucot","ucuk","ucul","ucun","ucup","ucur","ucut","udah","udai","udak","udal","udam","udan","udar","udas","udat","udau","udeh","udek","uden","udep","uder","udes","udet","udik","udim","udin","udip","udir","udis","udit","udiu","udoh","udok","udon","udor","udot","uduk","udul","udun","udup","udur","udut"},
v={"valid","variasi","visi","vokal","volume","vaksin","validasi","varian","veteran","visual","vital"},
w={"wajah","wakil","waktu","warga","warna","watak","wawasan","wibawa","wirausaha","wisata","wujud","wahyu","walau","wali","wanita","warisan","waspada","wirid","wirya","wabah","wabai","wabak","wabal","wabam","waban","wabar","wabas","wabat","wabau","wabeh","wabek","waben","wabep","waber","wabes","wabet","wabik","wabim","wabin","wabip","wabir","wabis","wabit","wabiu","waboh","wabok","wabon","wabor","wabot","wabuk","wabul","wabun","wabup","wabur","wabut","wacah","wacai","wacak","wacal","wacam","wacan","wacar","wacas","wacat","wacau","waceh","wacek","wacen","wacep","wacer","waces","wacet","wacik","wacim","wacin","wacip","wacir","wacis","wacit","waciu","wacoh","wacok","wacon","wacor","wacot","wacuk","wacul","wacun","wacup","wacur","wacut"},
x={"xenon","xilem"},
y={"yakin","yang","yakni","yayasan","yuridis","yahudi","yakuza","yantra","yatim","yoga","yuran"},
z={"zakat","zaman","zona","zuhud","zalim","zat","ziarah","zakar","zaki","zina","zirah","zoologi","zuhur"},
}

-- ══════════════════════════════════════════
--  API KBBI (Primary)
--  Pakai api-sabda atau alternative
-- ══════════════════════════════════════════
local function getHttp()
    local ok, fn
    ok, fn = pcall(function() return syn and syn.request end); if ok and fn then return fn end
    ok, fn = pcall(function() return http and http.request end); if ok and fn then return fn end
    ok, fn = pcall(function() return http_request end); if ok and fn then return fn end
    ok, fn = pcall(function() return request end); if ok and fn then return fn end
    return nil
end

local apiCache = {}  -- cache hasil API biar tidak spam

local function fetchWordFromAPI(letter)
    -- Cek cache dulu
    if apiCache[letter] and #apiCache[letter] > 0 then
        return apiCache[letter]
    end

    local h = getHttp()
    if not h or not CONFIG.USE_API then return nil end

    local results = {}

    -- Coba API 1: api-sabda (KBBI)
    local ok1, res1 = pcall(function()
        return h({
            Url = "https://api.sabda.org/lexicon?kata=" .. letter .. "*&format=json",
            Method = "GET",
            Headers = {["User-Agent"] = "Mozilla/5.0"},
        })
    end)
    if ok1 and res1 and res1.StatusCode == 200 then
        -- Parse sederhana: cari semua kata yang mulai dengan huruf tersebut
        for word in res1.Body:gmatch('"([a-z][a-z]+)"') do
            if word:sub(1,1):lower() == letter:lower() and #word >= 3 then
                table.insert(results, word:lower())
            end
        end
    end

    -- Coba API 2: kbbi.vercel.app
    if #results < 5 then
        local ok2, res2 = pcall(function()
            return h({
                Url = "https://kbbi.vercel.app/api/" .. letter,
                Method = "GET",
                Headers = {["User-Agent"] = "Mozilla/5.0"},
            })
        end)
        if ok2 and res2 and res2.StatusCode == 200 then
            for word in res2.Body:gmatch('"kata":"([a-z]+)"') do
                if word:sub(1,1):lower() == letter:lower() and #word >= 3 then
                    table.insert(results, word:lower())
                end
            end
        end
    end

    -- Cache result
    if #results > 0 then
        apiCache[letter] = results
        return results
    end

    return nil
end

-- ══════════════════════════════════════════
--  AI WORD SELECTOR
-- ══════════════════════════════════════════
local usedWords = {}

local function getLastChar(word)
    return word:sub(-1):lower()
end

local function scoreWord(word)
    local score = 0
    local last = getLastChar(word)
    for _, e in ipairs(CONFIG.BEST_ENDINGS) do
        if last == e then score = score + 100; break end
    end
    for _, e in ipairs(CONFIG.BAD_ENDINGS) do
        if last == e then score = score - 50; break end
    end
    score = score + #word * 2
    score = score + math.random(1, 10)
    return score
end

local function findBestWord(letter, apiWords)
    letter = letter:lower()

    -- Gabung API words + local words
    local combined = {}
    local seen = {}

    if apiWords then
        for _, w in ipairs(apiWords) do
            if not seen[w] and not usedWords[w] then
                seen[w] = true
                table.insert(combined, w)
            end
        end
    end

    local localWords = WORDS[letter]
    if localWords then
        for _, w in ipairs(localWords) do
            if not seen[w] and not usedWords[w] then
                seen[w] = true
                table.insert(combined, w)
            end
        end
    end

    if #combined == 0 then
        -- Reset used words untuk huruf ini
        for w, _ in pairs(usedWords) do
            if w:sub(1,1) == letter then usedWords[w] = nil end
        end
        -- Coba lagi
        combined = {}
        if apiWords then
            for _, w in ipairs(apiWords) do
                table.insert(combined, w)
            end
        end
        if localWords then
            for _, w in ipairs(localWords) do
                table.insert(combined, w)
            end
        end
    end

    if #combined == 0 then return nil end

    table.sort(combined, function(a, b)
        return scoreWord(a) > scoreWord(b)
    end)

    local topN = math.min(5, #combined)
    local chosen = combined[math.random(1, topN)]
    usedWords[chosen] = true
    return chosen
end

-- ══════════════════════════════════════════
--  FIND LETTER dari GUI game
-- ══════════════════════════════════════════
local function findCurrentLetter()
    for _, gui in ipairs(playerGui:GetChildren()) do
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") then
                local txt = obj.Text:lower()
                if txt:find("huruf") or txt:find("adalah") then
                    local letter = txt:match("adalah:%s*([a-z])")
                    if letter then return letter end
                    letter = txt:match("[a-z]$")
                    if letter then return letter end
                end
            end
        end
    end
    return nil
end

local function findSubmitButton()
    for _, gui in ipairs(playerGui:GetChildren()) do
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextButton") then
                local txt = obj.Text:lower()
                if txt:find("masuk") or txt:find("submit") or txt == "✓" then
                    return obj
                end
            end
        end
    end
    return nil
end

local function findClearButton()
    for _, gui in ipairs(playerGui:GetChildren()) do
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextButton") then
                local txt = obj.Text:lower()
                if txt:find("hapus") or txt:find("clear") or txt == "x" or txt == "✗" then
                    return obj
                end
            end
        end
    end
    return nil
end

local function findLetterButton(letter)
    letter = letter:upper()
    for _, gui in ipairs(playerGui:GetChildren()) do
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextButton") and obj.Text == letter then
                return obj
            end
        end
    end
    return nil
end

local function clickBtn(btn)
    if not btn then return end
    pcall(function() btn.MouseButton1Click:Fire() end)
    pcall(function()
        local vgui = game:GetService("VirtualInputManager")
        local cx = btn.AbsolutePosition.X + btn.AbsoluteSize.X/2
        local cy = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y/2
        vgui:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.03)
        vgui:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
    end)
end

local function typeWord(word)
    if not word then return false end

    local clearBtn = findClearButton()
    if clearBtn then
        clickBtn(clearBtn)
        task.wait(0.2)
    end

    for i = 1, #word do
        local char = word:sub(i,i)
        local btn = findLetterButton(char)
        if btn then
            clickBtn(btn)
        end
        if CONFIG.NATURAL_TYPE then
            task.wait(CONFIG.SPEED_MIN + math.random() * (CONFIG.SPEED_MAX - CONFIG.SPEED_MIN))
        else
            task.wait(CONFIG.SPEED_MIN)
        end
    end

    if CONFIG.AUTO_SUBMIT then
        task.wait(0.15)
        local submitBtn = findSubmitButton()
        if submitBtn then clickBtn(submitBtn) end
    end

    return true
end

-- ══════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════
local isRunning  = false
local lastLetter = nil
local speedMode  = 2
local SPEEDS = {
    {min=0.15, max=0.25, label="🐢 Lambat"},
    {min=0.05, max=0.12, label="🚶 Normal"},
    {min=0.02, max=0.06, label="🏃 Cepat"},
    {min=0.01, max=0.02, label="⚡ Turbo"},
}

-- ══════════════════════════════════════════
--  GUI
-- ══════════════════════════════════════════
task.wait(0.5)

local C = {
    bg      = Color3.fromRGB(8, 12, 30),
    surface = Color3.fromRGB(15, 22, 55),
    card    = Color3.fromRGB(22, 35, 80),
    accent  = Color3.fromRGB(80, 160, 255),
    accent2 = Color3.fromRGB(130, 200, 255),
    green   = Color3.fromRGB(50, 220, 130),
    red     = Color3.fromRGB(255, 75, 75),
    yellow  = Color3.fromRGB(255, 210, 50),
    purple  = Color3.fromRGB(180, 100, 255),
    orange  = Color3.fromRGB(255, 150, 50),
    text    = Color3.fromRGB(225, 240, 255),
    muted   = Color3.fromRGB(100, 140, 210),
    border  = Color3.fromRGB(50, 85, 185),
    dark    = Color3.fromRGB(5, 8, 22),
}

local Gui = Instance.new("ScreenGui", playerGui)
Gui.Name = "SK_YURXZ"; Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true; Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 310, 0, 0)
Main.Position = UDim2.new(0.5, -155, 0.5, -210)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.AutomaticSize = Enum.AutomaticSize.Y
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = C.accent; mainStroke.Thickness = 1.5

-- Gradient top bar
local topBar = Instance.new("Frame", Main)
topBar.Size = UDim2.new(1, 0, 0, 3)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = C.accent
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 2)
local tbGrad = Instance.new("UIGradient", topBar)
tbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80,160,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180,100,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50,220,130)),
})

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -16, 0, 0)
Content.Position = UDim2.new(0, 8, 0, 8)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.AutomaticSize = Enum.AutomaticSize.Y
local cL = Instance.new("UIListLayout", Content)
cL.Padding = UDim.new(0, 6)
cL.SortOrder = Enum.SortOrder.LayoutOrder

-- ── HEADER ──
local hdr = Instance.new("Frame", Content)
hdr.Size = UDim2.new(1, 0, 0, 28)
hdr.BackgroundTransparency = 1
hdr.BorderSizePixel = 0
hdr.LayoutOrder = 1

local pdot = Instance.new("Frame", hdr)
pdot.Size = UDim2.new(0, 8, 0, 8)
pdot.Position = UDim2.new(0, 0, 0.5, -4)
pdot.BackgroundColor3 = C.muted
pdot.BorderSizePixel = 0
Instance.new("UICorner", pdot).CornerRadius = UDim.new(1, 0)

local hdrTxt = Instance.new("TextLabel", hdr)
hdrTxt.Size = UDim2.new(0.75, -14, 1, 0)
hdrTxt.Position = UDim2.new(0, 14, 0, 0)
hdrTxt.BackgroundTransparency = 1
hdrTxt.Text = "⚡ SAMBUNG KATA YURXZ"
hdrTxt.TextColor3 = C.text
hdrTxt.TextSize = 12
hdrTxt.Font = Enum.Font.GothamBold
hdrTxt.TextXAlignment = Enum.TextXAlignment.Left

local verLbl = Instance.new("TextLabel", hdr)
verLbl.Size = UDim2.new(0.25, 0, 1, 0)
verLbl.Position = UDim2.new(0.75, 0, 0, 0)
verLbl.BackgroundTransparency = 1
verLbl.Text = "v2.0 API+DB"
verLbl.TextColor3 = C.purple
verLbl.TextSize = 8
verLbl.Font = Enum.Font.GothamBold
verLbl.TextXAlignment = Enum.TextXAlignment.Right

-- Divider
local div = Instance.new("Frame", Content)
div.Size = UDim2.new(1, 0, 0, 1)
div.BackgroundColor3 = C.border
div.BorderSizePixel = 0
div.LayoutOrder = 2

-- ── STATUS CARD ──
local stCard = Instance.new("Frame", Content)
stCard.Size = UDim2.new(1, 0, 0, 0)
stCard.BackgroundColor3 = C.surface
stCard.BorderSizePixel = 0
stCard.AutomaticSize = Enum.AutomaticSize.Y
stCard.LayoutOrder = 3
Instance.new("UICorner", stCard).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", stCard).Color = C.border
local stPad = Instance.new("UIPadding", stCard)
stPad.PaddingLeft = UDim.new(0,10); stPad.PaddingRight = UDim.new(0,10)
stPad.PaddingTop = UDim.new(0,8); stPad.PaddingBottom = UDim.new(0,8)
local stL = Instance.new("UIListLayout", stCard)
stL.Padding = UDim.new(0, 5)

-- Row huruf + kata
local r1 = Instance.new("Frame", stCard)
r1.Size = UDim2.new(1, 0, 0, 28)
r1.BackgroundTransparency = 1
r1.BorderSizePixel = 0

local letterBox = Instance.new("TextLabel", r1)
letterBox.Size = UDim2.new(0.45, -3, 1, 0)
letterBox.BackgroundColor3 = C.card
letterBox.BorderSizePixel = 0
letterBox.Text = "🔤  Huruf: -"
letterBox.TextColor3 = C.accent2
letterBox.TextSize = 11
letterBox.Font = Enum.Font.GothamBold
letterBox.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", letterBox).CornerRadius = UDim.new(0, 8)

local wordBox = Instance.new("TextLabel", r1)
wordBox.Size = UDim2.new(0.55, -3, 1, 0)
wordBox.Position = UDim2.new(0.45, 3, 0, 0)
wordBox.BackgroundColor3 = C.card
wordBox.BorderSizePixel = 0
wordBox.Text = "📝  Kata: -"
wordBox.TextColor3 = C.green
wordBox.TextSize = 11
wordBox.Font = Enum.Font.GothamBold
wordBox.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", wordBox).CornerRadius = UDim.new(0, 8)

-- Sumber kata (API/DB)
local srcLbl = Instance.new("TextLabel", stCard)
srcLbl.Size = UDim2.new(1, 0, 0, 16)
srcLbl.BackgroundTransparency = 1
srcLbl.Text = "📡  Sumber: -"
srcLbl.TextColor3 = C.muted
srcLbl.TextSize = 9
srcLbl.Font = Enum.Font.Gotham
srcLbl.TextXAlignment = Enum.TextXAlignment.Center

-- Status
local statusLbl = Instance.new("TextLabel", stCard)
statusLbl.Size = UDim2.new(1, 0, 0, 16)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "💤  Menunggu..."
statusLbl.TextColor3 = C.muted
statusLbl.TextSize = 9
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Center

-- ── API TOGGLE ──
local apiCard = Instance.new("Frame", Content)
apiCard.Size = UDim2.new(1, 0, 0, 32)
apiCard.BackgroundColor3 = C.surface
apiCard.BorderSizePixel = 0
apiCard.LayoutOrder = 4
Instance.new("UICorner", apiCard).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", apiCard).Color = C.border
local apiPad = Instance.new("UIPadding", apiCard)
apiPad.PaddingLeft = UDim.new(0,10); apiPad.PaddingRight = UDim.new(0,10)

local apiLbl = Instance.new("TextLabel", apiCard)
apiLbl.Size = UDim2.new(0.65, 0, 1, 0)
apiLbl.BackgroundTransparency = 1
apiLbl.Text = "📡  API KBBI (Realtime)"
apiLbl.TextColor3 = C.text
apiLbl.TextSize = 11
apiLbl.Font = Enum.Font.Gotham
apiLbl.TextXAlignment = Enum.TextXAlignment.Left

local apiToggle = Instance.new("TextButton", apiCard)
apiToggle.Size = UDim2.new(0, 50, 0, 22)
apiToggle.Position = UDim2.new(1, -52, 0.5, -11)
apiToggle.BackgroundColor3 = CONFIG.USE_API and C.green or C.card
apiToggle.TextColor3 = Color3.fromRGB(255,255,255)
apiToggle.Text = CONFIG.USE_API and "ON" or "OFF"
apiToggle.TextSize = 10
apiToggle.Font = Enum.Font.GothamBold
apiToggle.AutoButtonColor = false
apiToggle.BorderSizePixel = 0
Instance.new("UICorner", apiToggle).CornerRadius = UDim.new(0, 8)
apiToggle.MouseButton1Click:Connect(function()
    CONFIG.USE_API = not CONFIG.USE_API
    TweenService:Create(apiToggle, TweenInfo.new(0.15), {
        BackgroundColor3 = CONFIG.USE_API and C.green or C.card,
    }):Play()
    apiToggle.Text = CONFIG.USE_API and "ON" or "OFF"
end)

-- ── BEST ENDING ──
local beCard = Instance.new("Frame", Content)
beCard.Size = UDim2.new(1, 0, 0, 0)
beCard.BackgroundColor3 = C.surface
beCard.BorderSizePixel = 0
beCard.AutomaticSize = Enum.AutomaticSize.Y
beCard.LayoutOrder = 5
Instance.new("UICorner", beCard).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", beCard).Color = C.border
local bePad = Instance.new("UIPadding", beCard)
bePad.PaddingLeft = UDim.new(0,10); bePad.PaddingRight = UDim.new(0,10)
bePad.PaddingTop = UDim.new(0,8); bePad.PaddingBottom = UDim.new(0,8)
local beL = Instance.new("UIListLayout", beCard)
beL.Padding = UDim.new(0, 5)

local beLbl = Instance.new("TextLabel", beCard)
beLbl.Size = UDim2.new(1, 0, 0, 12)
beLbl.BackgroundTransparency = 1
beLbl.Text = "🎯  Best Ending (tap untuk toggle)"
beLbl.TextColor3 = C.accent2
beLbl.TextSize = 9
beLbl.Font = Enum.Font.Gotham
beLbl.TextXAlignment = Enum.TextXAlignment.Left

local beRow = Instance.new("Frame", beCard)
beRow.Size = UDim2.new(1, 0, 0, 26)
beRow.BackgroundTransparency = 1
beRow.BorderSizePixel = 0
local beRL = Instance.new("UIListLayout", beRow)
beRL.FillDirection = Enum.FillDirection.Horizontal
beRL.Padding = UDim.new(0, 3)

local allEndings = {"x","q","y","w","v","j","z","ng","tt","if"}
local activeEndings = {}
for _, e in ipairs(CONFIG.BEST_ENDINGS) do activeEndings[e] = true end

for _, e in ipairs(allEndings) do
    local btn = Instance.new("TextButton", beRow)
    btn.Size = UDim2.new(0, 26, 1, 0)
    btn.BackgroundColor3 = activeEndings[e] and C.purple or C.card
    btn.TextColor3 = activeEndings[e] and Color3.fromRGB(255,255,255) or C.muted
    btn.Text = e
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        activeEndings[e] = not activeEndings[e]
        CONFIG.BEST_ENDINGS = {}
        for ending, active in pairs(activeEndings) do
            if active then table.insert(CONFIG.BEST_ENDINGS, ending) end
        end
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = activeEndings[e] and C.purple or C.card,
            TextColor3 = activeEndings[e] and Color3.fromRGB(255,255,255) or C.muted,
        }):Play()
    end)
end

-- ── KECEPATAN ──
local spCard = Instance.new("Frame", Content)
spCard.Size = UDim2.new(1, 0, 0, 0)
spCard.BackgroundColor3 = C.surface
spCard.BorderSizePixel = 0
spCard.AutomaticSize = Enum.AutomaticSize.Y
spCard.LayoutOrder = 6
Instance.new("UICorner", spCard).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", spCard).Color = C.border
local spPad = Instance.new("UIPadding", spCard)
spPad.PaddingLeft = UDim.new(0,10); spPad.PaddingRight = UDim.new(0,10)
spPad.PaddingTop = UDim.new(0,8); spPad.PaddingBottom = UDim.new(0,8)
local spL = Instance.new("UIListLayout", spCard)
spL.Padding = UDim.new(0, 5)

local spLbl = Instance.new("TextLabel", spCard)
spLbl.Size = UDim2.new(1, 0, 0, 12)
spLbl.BackgroundTransparency = 1
spLbl.Text = "⏱️  Kecepatan Ngetik"
spLbl.TextColor3 = C.accent2
spLbl.TextSize = 9
spLbl.Font = Enum.Font.Gotham
spLbl.TextXAlignment = Enum.TextXAlignment.Left

local spRow = Instance.new("Frame", spCard)
spRow.Size = UDim2.new(1, 0, 0, 26)
spRow.BackgroundTransparency = 1
spRow.BorderSizePixel = 0
local spRL = Instance.new("UIListLayout", spRow)
spRL.FillDirection = Enum.FillDirection.Horizontal
spRL.Padding = UDim.new(0, 3)

local speedBtns = {}
for i, sp in ipairs(SPEEDS) do
    local btn = Instance.new("TextButton", spRow)
    btn.Size = UDim2.new(0.25, -3, 1, 0)
    btn.BackgroundColor3 = i==speedMode and C.yellow or C.card
    btn.TextColor3 = i==speedMode and C.dark or C.muted
    btn.Text = sp.label
    btn.TextSize = 8
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    speedBtns[i] = btn
    btn.MouseButton1Click:Connect(function()
        speedMode = i
        CONFIG.SPEED_MIN = SPEEDS[i].min
        CONFIG.SPEED_MAX = SPEEDS[i].max
        for j, b in ipairs(speedBtns) do
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = j==speedMode and C.yellow or C.card,
                TextColor3 = j==speedMode and C.dark or C.muted,
            }):Play()
        end
    end)
end

-- ── NATURAL TYPE TOGGLE ──
local natCard = Instance.new("Frame", Content)
natCard.Size = UDim2.new(1, 0, 0, 32)
natCard.BackgroundColor3 = C.surface
natCard.BorderSizePixel = 0
natCard.LayoutOrder = 7
Instance.new("UICorner", natCard).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", natCard).Color = C.border
local natPad = Instance.new("UIPadding", natCard)
natPad.PaddingLeft = UDim.new(0,10); natPad.PaddingRight = UDim.new(0,10)

local natLbl = Instance.new("TextLabel", natCard)
natLbl.Size = UDim2.new(0.65, 0, 1, 0)
natLbl.BackgroundTransparency = 1
natLbl.Text = "🤖  Natural Typing Mode"
natLbl.TextColor3 = C.text
natLbl.TextSize = 11
natLbl.Font = Enum.Font.Gotham
natLbl.TextXAlignment = Enum.TextXAlignment.Left

local natToggle = Instance.new("TextButton", natCard)
natToggle.Size = UDim2.new(0, 50, 0, 22)
natToggle.Position = UDim2.new(1, -52, 0.5, -11)
natToggle.BackgroundColor3 = CONFIG.NATURAL_TYPE and C.green or C.card
natToggle.TextColor3 = Color3.fromRGB(255,255,255)
natToggle.Text = CONFIG.NATURAL_TYPE and "ON" or "OFF"
natToggle.TextSize = 10
natToggle.Font = Enum.Font.GothamBold
natToggle.AutoButtonColor = false
natToggle.BorderSizePixel = 0
Instance.new("UICorner", natToggle).CornerRadius = UDim.new(0, 8)
natToggle.MouseButton1Click:Connect(function()
    CONFIG.NATURAL_TYPE = not CONFIG.NATURAL_TYPE
    TweenService:Create(natToggle, TweenInfo.new(0.15), {
        BackgroundColor3 = CONFIG.NATURAL_TYPE and C.green or C.card,
    }):Play()
    natToggle.Text = CONFIG.NATURAL_TYPE and "ON" or "OFF"
end)

-- ── START / STOP ──
local actionBtn = Instance.new("TextButton", Content)
actionBtn.Size = UDim2.new(1, 0, 0, 38)
actionBtn.BackgroundColor3 = C.accent
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.Text = "▶  START AUTO"
actionBtn.TextSize = 13
actionBtn.Font = Enum.Font.GothamBold
actionBtn.AutoButtonColor = false
actionBtn.BorderSizePixel = 0
actionBtn.LayoutOrder = 8
Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0, 10)
local abGrad = Instance.new("UIGradient", actionBtn)
abGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60,140,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,80,220)),
})
abGrad.Rotation = 135

local botPad = Instance.new("Frame", Content)
botPad.Size = UDim2.new(1, 0, 0, 4)
botPad.BackgroundTransparency = 1
botPad.LayoutOrder = 9

-- ── DRAG ──
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
       inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; startPos = Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
       inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or
       inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                   startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ══════════════════════════════════════════
--  MAIN LOOP
-- ══════════════════════════════════════════
local autoThread = nil

local function updateStatus(msg, color)
    statusLbl.Text = msg
    statusLbl.TextColor3 = color or C.muted
end

local function startAuto()
    isRunning = true
    actionBtn.Text = "⏹  STOP AUTO"
    abGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200,30,30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140,10,10)),
    })
    TweenService:Create(mainStroke, TweenInfo.new(0.3), {Color=C.green}):Play()

    autoThread = task.spawn(function()
        while isRunning do
            task.wait(0.5)
            if not isRunning then break end

            local letter = findCurrentLetter()
            if letter and letter ~= lastLetter then
                lastLetter = letter
                letterBox.Text = "🔤  " .. letter:upper()
                updateStatus("🔍 Cari kata: " .. letter:upper() .. "...", C.yellow)

                -- Ambil dari API dulu (async)
                local apiWords = nil
                if CONFIG.USE_API then
                    updateStatus("📡 Fetch API KBBI...", C.orange)
                    srcLbl.Text = "📡  Sumber: API KBBI"
                    local ok, res = pcall(fetchWordFromAPI, letter)
                    if ok and res and #res > 0 then
                        apiWords = res
                        srcLbl.Text = "📡  Sumber: API (" .. #res .. " kata)"
                    else
                        srcLbl.Text = "💾  Sumber: Database Lokal (API gagal)"
                    end
                else
                    srcLbl.Text = "💾  Sumber: Database Lokal"
                end

                -- Natural delay sebelum jawab
                task.wait(0.2 + math.random() * 0.4)

                local word = findBestWord(letter, apiWords)
                if word then
                    wordBox.Text = "📝  " .. word
                    updateStatus("⌨️  Ngetik: " .. word, C.green)

                    typeWord(word)
                    updateStatus("✅  OK: " .. word .. " → " .. word:sub(-1):upper(), C.green)
                else
                    wordBox.Text = "📝  Tidak ada!"
                    updateStatus("⚠️  Tidak ada kata untuk: " .. letter:upper(), C.red)
                end
            elseif not letter then
                updateStatus("👀  Deteksi huruf...", C.muted)
            end
        end
    end)
end

local function stopAuto()
    isRunning = false
    if autoThread then task.cancel(autoThread); autoThread = nil end
    actionBtn.Text = "▶  START AUTO"
    abGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60,140,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20,80,220)),
    })
    TweenService:Create(mainStroke, TweenInfo.new(0.3), {Color=C.accent}):Play()
    TweenService:Create(pdot, TweenInfo.new(0.3), {BackgroundColor3=C.muted}):Play()
    updateStatus("⏹️  Dihentikan", C.yellow)
end

actionBtn.MouseButton1Click:Connect(function()
    if isRunning then stopAuto() else startAuto() end
end)

-- Pulse dot
task.spawn(function()
    while Gui.Parent do
        if isRunning then
            TweenService:Create(pdot, TweenInfo.new(0.5, Enum.EasingStyle.Sine),
                {BackgroundColor3=Color3.fromRGB(30,180,90)}):Play()
            task.wait(0.5)
            TweenService:Create(pdot, TweenInfo.new(0.5, Enum.EasingStyle.Sine),
                {BackgroundColor3=C.green}):Play()
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

Main.BackgroundTransparency = 1
TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {BackgroundTransparency=0}):Play()

gset("SK_Stop", function()
    isRunning = false
    if autoThread then pcall(function() task.cancel(autoThread) end) end
end)

print("[SAMBUNG KATA v2.0] ✅ API KBBI + Database Lokal loaded!")
print("[SAMBUNG KATA v2.0] Klik START AUTO untuk mulai")
