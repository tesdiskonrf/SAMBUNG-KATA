--[[
    ╔══════════════════════════════════════════════╗
    ║      SAMBUNG KATA YURXZ  v4.0  FIXED        ║
    ║   Database • AI • Auto Type • Real UI       ║
    ╚══════════════════════════════════════════════╝
]]

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")

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
    SPEED_MIN    = 0.05,
    SPEED_MAX    = 0.12,
    NATURAL_TYPE = true,
    BEST_ENDINGS = {k=true, h=true, r=true, n=true, l=true, m=true, g=true},
    BAD_ENDINGS  = {a=true, i=true, u=true, e=true, o=true},
    AUTO_SUBMIT  = true,
}

-- ══════════════════════════════════════════
--  DATABASE LOKAL
-- ══════════════════════════════════════════
local WORDS = {
a={"abadi","abah","abai","abdi","abstrak","acak","acara","acuh","adab","adegan","adik","agenda","agung","ahli","ajak","ajal","ajar","akad","akar","akhir","akhlak","akibat","akrab","aksi","aktif","alam","alami","alat","alih","alim","alir","alis","alun","alur","amal","aman","ambil","amuk","anak","ancam","andai","aneh","angkat","anjak","anjur","antar","antik","apik","arab","arak","aroma","arung","arus","arwah","asah","asam","asih","asik","asin","aspal","asuh","atas","atau","atlet","atom","atur","awal","awam","awan","awas","awet","ayah","ayam","ayat","ayun","adat","adem","agen","ahad","akbar","akun","akur","akut","album","apek","api","apung","apus","arca","argumen","arik","arta","asai","asak","asis","asta","astral"},
b={"babi","babu","baca","bagai","bahan","baik","baju","bakar","baki","bakti","baku","balai","balik","balok","balon","bambu","banda","banjir","banyak","barat","baris","basah","basi","batas","batu","bawa","bayar","bayi","bebas","beda","bedah","bekal","bekas","beku","belah","belas","belok","belut","benak","benar","benci","benda","benih","bening","bentuk","berani","beras","beres","besar","beton","biak","biaya","bibit","bidang","bijak","biji","bikin","bilah","bilang","bimbing","bina","bintang","biru","bisa","bising","bisul","bisu","bocah","bocor","bola","bolos","boros","botol","buah","buat","bubuk","budak","budi","buka","bukit","buku","bumi","bungkus","buruk","busuk","butir","buyar","badai","badak","badan","bahak","balik","balun","bantai","baper","barak","baret","barit","baron","basah","basal","basis"},
c={"cabai","cabang","cacat","cacing","cahaya","cair","cakap","cakram","cakup","calon","campur","cangkir","cantik","capai","capek","carik","cedera","celah","celaka","cemas","cepat","cerah","cermat","cicak","cinta","ciprat","ciri","corak","cubit","cucuk","cuci","cukup","cukur","cupang","curam","curang","curi","curiga","cabik","cabul","cagar","cakah","cakar","candu","cangkok","cangkul","carak","caram","caran","carap","caras","carat","caruk","carun","carut"},
d={"dada","dagang","daging","damai","dampak","dandan","dapat","dapur","darah","dasar","data","daya","debat","dedak","deras","deret","desak","diam","didik","dikit","dinas","dinding","dingin","diri","dominan","dunia","durasi","dusta","duyung","debar","debur","dekat","debu","delta","depan","detik","dialog","digital","dilema","dimensi","diskon","distrik","dokter","domain","donasi","dompet","donat","drama","drastis","dukun","daftar","dahar","dahak","dahsyat","dakar","dakon","dalan","dalim","damar","daman","danat","danau","dangau","darat","darau","darik","daring","darung","dasar","dasih"},
e={"edan","efek","efisien","ekor","eksis","elastis","elegan","elemen","emak","emas","emosi","empat","empuk","energi","erosi","esok","etika","etnis","evaluasi","evolusi","edisi","ekologi","ekonomi","ekspor","ekspres","emban","empang","empas","empati","endap","endus","entah","epik","era","eror","esai","etanol","etis"},
f={"fajar","fakta","falak","famili","fanatik","fantasi","fasih","favorit","festival","fikir","filosofi","fisik","fondasi","formal","forum","fosil","foto","fungsi","faedah","fahim","fakih","falah","falsafah","fana","fatwa","fauna","fiksi","filsafat","fitnah","fitrah","fokus","fraksi","frasa","faham","faidah","fasik","fatah","fatin","fikrah","fikih","fobia","folio","fonetik","fonologi","formulir","fortuna","fosfor","frekuensi","frustasi","furqan"},
g={"gading","gagal","gagah","gajah","galak","ganas","ganda","ganggu","ganjil","garang","garis","garpu","gaya","gelar","gerak","gerobak","gigih","gitar","global","gosip","gratis","guna","gunung","gusar","gadai","gagap","gaib","galau","gambut","gampang","garam","gaun","gaung","gelap","gema","gempa","gendang","gertak","gigit","ginjal","golek","goreng","gosok","gotong","guru","guyub","gabah","gabung","gadang","gadih","gadis","gaduh","gaet","gagak","gagas","galah","galar","galur","gambar","gambir","gampil","ganas","gasal","gasak","gasal"},
h={"habis","hadap","hadir","hafal","halal","halus","hambat","hangat","harap","harga","harum","hasil","hemat","hidup","hijau","hilang","hormat","humor","huruf","hadiah","hafalan","hampa","hancur","handuk","harmoni","harta","hati","hayal","hewan","hikmat","himpun","histori","hitam","hobi","hukum","habuk","hadam","hadan","hadar","hadas","hadik","hadim","hadis","hajar","hajas","hajat","hakim","hakin","hakis","hakit","hakul","haluan","haluk","hambar","hambur","hantam","hantu","hapus","haraf","haram","harak","haran","harat","harau","haria","harik","haris","harit","harkat","harub","haruk","harun","harung","harut"},
i={"ibu","ikan","ikat","iklim","ilmu","imaji","imun","indah","induk","informasi","ingat","ingin","inovasi","insaf","intan","inti","izin","ibarat","iblis","ikatan","ikhlas","ikrar","imbang","imbas","impas","impian","inap","indeks","injak","insiden","insting","iradat","irama","iris","isap","isyarat","itikad","ibuk","ibun","icak","ical","idan","idar","idas","idik","idim","idin","idip","idir","idis","idul","idup","idur","ihwal","ijab","ijin","ikad","ikah","ikal","ikam","ikan","ikap","ikar","ikis","ikit","ikus","ilai","ilam","ilan","ilar","ilas","ilat","ilau","ilik","ilir","ilis","ilit","iluh","iluk","ilun","ilur"},
j={"jabat","jaga","jalan","janji","jarang","jari","jauh","jelas","jenis","jinak","juara","judul","jujur","juta","jagat","jagoan","jambul","jamur","jarak","jatuh","jawab","jenaka","jenius","jernih","joget","joging","jubah","jurang","justru","jabak","jabun","jabur","jabut","jacak","jacar","jadah","jadam","jadan","jadar","jadas","jadat","jadau","jadek","jaden","jadep","jader","jades","jadet","jadik","jadim","jadin","jadip","jadir","jadis","jadit","jadoh","jadok","jadon","jador","jadot","jaduk","jadul","jadun","jadup","jadur","jadut","jagah","jagai","jagak","jagal","jagam","jagan","jagar","jagas","jagat","jagau","jagek","jagen"},
k={"kabar","kaget","kaki","kalah","kalem","kamus","karya","kasih","kawan","keras","kerja","kira","kuat","kuliah","kunci","kadang","kadar","kagum","kajian","kakak","kalbu","kampung","karakter","karisma","kawasan","kebal","kejam","kejutan","kekal","kelola","kembar","kendali","kepala","kesal","ketua","khusus","kilat","klasik","kolam","kompak","kontak","kotak","kreatif","kritis","kronis","krusial","kultur","kumuh","kurang","kabah","kabal","kabam","kaban","kabas","kabat","kabeh","kabek","kaben","kabep","kaber","kabes","kabet","kabik","kabim","kabin","kabip","kabir","kabis","kabit","kaboh","kabok","kabon","kabor","kabot","kabuk","kabul","kabun","kabup","kabur","kabut","kacah","kacai","kacak","kacal","kacam","kacan","kacar","kacas","kacat","kacau","kaceh","kacek"},
l={"labuh","lapar","lapang","laris","latih","layak","lebih","lembut","lempar","lengkap","lepas","liar","lihat","liku","lincah","lingkar","lisan","logis","lokal","longgar","lunak","luput","labrak","lahir","lahan","laknat","laksana","lambang","langkah","langsung","lantas","lapor","larang","lasak","laskar","lawak","lawan","layan","legenda","lembaga","letak","liberal","lirik","logika","lomba","luang","luhur","lulus","lunas","labah","labai","labak","labal","labam","laban","labar","labas","labat","labau","labeh","labek","laben","labep","laber","labes","labet","labik","labim","labin","labip","labir","labis","labit","laboh","labok","labon","labor","labot","labuk","labul","labun","labup","labur","labut","lacah","lacai","lacak","lacal","lacam","lacan","lacar","lacas","lacat","lacau"},
m={"mabuk","mahal","mahir","makan","makar","makna","malam","malang","mampir","manfaat","manis","marak","masak","masuk","mati","mekar","melati","merah","merdu","minat","minta","misal","misi","mitos","modal","mogok","momen","mulia","mulut","murni","musuh","mahasiswa","mainan","makhluk","malaikat","manusia","masyarakat","media","megah","memang","menang","menarik","mendalam","mengerti","merdeka","metode","mewah","moral","mudah","mujur","mulus","mundur","mabah","mabai","mabak","mabal","mabam","maban","mabar","mabas","mabat","mabau","mabeh","mabek","maben","mabep","maber","mabes","mabet","mabik","mabim","mabin","mabip","mabir","mabis","mabit","maboh","mabok","mabon","mabor","mabot","mabul","mabun","mabup","mabur","mabut","macah","macai","macak","macal","macam","macan","macar","macas","macat","macau"},
n={"naik","nama","nasib","nilai","norma","nyata","nyaman","nyaring","nada","nagari","nakal","nasional","natural","naungan","nazar","nekat","netral","nikmat","niscaya","nista","nomor","normatif","nostalgia","nurani","nusantara","nabah","nabai","nabak","nabal","nabam","naban","nabar","nabas","nabat","nabau","nabeh","nabek","naben","nabep","naber","nabes","nabet","nabik","nabim","nabin","nabip","nabir","nabis","nabit","naboh","nabok","nabon","nabor","nabot","nabuk","nabul","nabun","nabup","nabur","nabut","nacah","nacai","nacak","nacal","nacam","nacan","nacar","nacas","nacat","nacau"},
o={"obat","objek","olahraga","opini","optimal","orang","organisasi","orientasi","oval","olahan","olimpiade","ombak","omong","operasi","opsi","orbit","orde","otak","otomatis","otoritas","obah","obai","obak","obal","obam","oban","obar","obas","obau","obeh","obek","oben","obep","ober","obes","obet","obik","obim","obin","obip","obir","obis","obit","oboh","obok","obon","obor","obot","obuk","obul","obun","obup","obur","obut","ocah","ocai","ocak","ocal","ocam","ocan","ocar","ocas","ocat","ocau"},
p={"padat","pagi","pahit","pakai","panas","panjang","parah","pasti","peduli","pelan","penuh","perlu","pikir","pintar","pokok","prima","proses","publik","puncak","pusing","pahlawan","paksa","palsu","pandai","panduan","panggil","pantas","pelajar","peluh","penat","pendek","pengaruh","penting","perahu","percaya","pilihan","pindah","planet","potensi","prestasi","prinsip","produktif","profesional","progres","proyek","purna","pabah","pabai","pabak","pabal","pabam","paban","pabar","pabas","pabat","pabau","pabeh","pabek","paben","pabep","paber","pabes","pabet","pabik","pabim","pabin","pabip","pabir","pabis","pabit","paboh","pabok","pabon","pabor","pabot","pabuk","pabul","pabun","pabup","pabur","pabut","pacah","pacai","pacak","pacal","pacam","pacan","pacar","pacas","pacat","pacau"},
r={"raba","raih","rakit","ramai","rambut","rancang","rangka","rapih","rasio","ratusan","reaksi","rela","rendah","resmi","rileks","rindu","risiko","rohani","ruang","rumus","rancah","rapat","rasul","rawan","rebut","refleksi","reka","relasi","rendam","rencana","resah","resolusi","restu","rinci","ringkasan","ritual","roboh","rombak","rugi","rukun","rabah","rabai","rabak","rabal","rabam","raban","rabar","rabas","rabat","rabau","rabeh","rabek","raben","rabep","raber","rabes","rabet","rabik","rabim","rabin","rabip","rabir","rabis","rabit","raboh","rabok","rabon","rabor","rabot","rabuk","rabul","rabun","rabup","rabur","rabut","racah","racai","racak","racal","racam","racan","racar","racas","racat","racau"},
s={"sabar","sakit","salah","sampai","sanak","sangat","sayang","sebab","sedia","segala","sehat","selalu","semua","sendi","serius","sifat","sikap","simpul","siswa","solusi","stabil","sukses","sungguh","syukur","sabun","sahaja","sahabat","sajak","samar","sampel","sanggup","santai","santun","sarjana","sasaran","satuan","seimbang","sejarah","sekolah","selesai","semangat","sendiri","sepadan","sepi","setara","setia","sigap","simulasi","sistem","situasi","sosial","spesial","strategi","struktur","sumber","sabah","sabai","sabak","sabal","sabam","saban","sabas","sabat","sabau","sabeh","sabek","saben","sabep","saber","sabes","sabet","sabik","sabim","sabin","sabip","sabir","sabis","sabit","saboh","sabok","sabon","sabor","sabot","sabuk","sabul","sabup","sabur","sabut"},
t={"taati","tahan","tahu","tajam","tamat","tampil","tanah","tantang","tapak","tarik","tegas","tekad","tekan","teman","tenang","tengah","teori","terima","tinggi","tokoh","total","tubuh","tulus","tuntas","tabah","tajuk","takdir","taktik","tanda","tanggap","tanggung","tanya","target","tegar","teknis","teladan","tempat","tentu","tepat","terbuka","terdepan","terjun","tindak","tindakan","tingkah","tipis","titik","toleransi","tradisi","transparan","tujuan","tulisan","tunggal","turun","tabah","tabai","tabak","tabal","tabam","taban","tabar","tabas","tabat","tabau","tabeh","tabek","taben","tabep","taber","tabes","tabet","tabik","tabim","tabin","tabip","tabir","tabis","tabit","taboh","tabok","tabon","tabor","tabot","tabuk","tabul","tabun","tabup","tabur","tabut"},
u={"ubah","ukur","ulang","ulet","ulur","unik","upaya","usaha","utama","uji","ujian","ujung","ulama","unggul","ungkap","unjuk","unsur","urutan","usul","utuh","ubai","ubak","ubal","ubam","uban","ubar","ubas","ubat","ubau","ubeh","ubek","uben","ubep","uber","ubes","ubet","ubik","ubim","ubin","ubip","ubir","ubis","ubit","uboh","ubok","ubon","ubor","ubot","ubuk","ubul","ubun","ubup","ubur","ubut","ucah","ucai","ucak","ucal","ucam","ucan","ucar","ucas","ucat","ucau","uceh","ucek","ucen","ucep","ucer","uces","ucet","ucik","ucim","ucin","ucip","ucir","ucis","ucit","ucoh","ucok","ucon","ucor","ucot","ucuk","ucul","ucun","ucup","ucur","ucut"},
v={"valid","variasi","visi","vokal","volume","vaksin","validasi","varian","veteran","visual","vital","vulkan"},
w={"wajah","wakil","waktu","warga","warna","watak","wawasan","wibawa","wirausaha","wisata","wujud","wahyu","walau","wali","wanita","warisan","waspada","wirid","wirya","wabah","wabai","wabak","wabal","wabam","waban","wabar","wabas","wabat","wabau","wabeh","wabek","waben","wabep","waber","wabes","wabet","wabik","wabim","wabin","wabip","wabir","wabis","wabit","waboh","wabok","wabon","wabor","wabot","wabuk","wabul","wabun","wabup","wabur","wabut"},
x={"xenon","xilem"},
y={"yakin","yang","yakni","yayasan","yuridis","yahudi","yatim","yoga","yuran","yantra"},
z={"zakat","zaman","zona","zuhud","zalim","zat","ziarah","zakar","zaki","zina","zirah","zoologi","zuhur"},
}

-- ══════════════════════════════════════════
--  WORD AI SELECTOR
-- ══════════════════════════════════════════
local usedWords = {}

local function scoreWord(word)
    local score = 0
    local last = word:sub(-1):lower()
    if CONFIG.BEST_ENDINGS[last] then score = score + 100 end
    if CONFIG.BAD_ENDINGS[last] then score = score - 50 end
    score = score + #word * 2
    return score
end

local function findBestWord(letter)
    letter = letter:lower()
    local pool = {}
    local seen = {}
    local localWords = WORDS[letter]
    if localWords then
        for _, w in ipairs(localWords) do
            if type(w)=="string" and #w>=3 and not seen[w] and not usedWords[w] then
                seen[w]=true; table.insert(pool, w)
            end
        end
    end
    if #pool == 0 then
        for w in pairs(usedWords) do
            if type(w)=="string" and w:sub(1,1)==letter then usedWords[w]=nil end
        end
        pool={}; seen={}
        if localWords then
            for _,w in ipairs(localWords) do
                if type(w)=="string" and #w>=3 and not seen[w] then seen[w]=true; table.insert(pool,w) end
            end
        end
    end
    if #pool == 0 then return nil end
    local scored = {}
    for _,w in ipairs(pool) do table.insert(scored, {word=w, score=scoreWord(w)+math.random(1,10)}) end
    table.sort(scored, function(a,b) return a.score > b.score end)
    local topN = math.min(5, #scored)
    local chosen = scored[math.random(1,topN)].word
    usedWords[chosen] = true
    return chosen
end

-- ══════════════════════════════════════════
--  GAME UI FINDER  (berdasarkan scan hasil)
-- ══════════════════════════════════════════

-- Cari huruf saat ini dari CurrentWordIndex label
local function getCurrentLetter()
    for _, gui in ipairs(playerGui:GetChildren()) do
        -- Cari di semua GUI
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Name == "CurrentWordIndex" then
                local t = obj.Text:gsub("%s","")
                if #t == 1 and t:match("[a-zA-Z]") then
                    return t:lower()
                end
            end
        end
    end
    -- Fallback: cari label yang berisi 1 huruf
    for _, gui in ipairs(playerGui:GetChildren()) do
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Visible then
                local t = obj.Text:gsub("%s","")
                if #t == 1 and t:match("[a-zA-Z]") then
                    return t:lower()
                end
            end
        end
    end
    return nil
end

-- Cari tombol huruf: nama [huruf]Button, atau Text = huruf
local function findLetterBtn(char)
    local upper = char:upper()
    local lower = char:lower()
    -- Cari berdasarkan Name dulu (contoh: AButton, BButton)
    for _, gui in ipairs(playerGui:GetChildren()) do
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextButton") then
                if obj.Name == upper.."Button" or obj.Name == lower.."Button" then
                    return obj
                end
                if obj.Text == upper then
                    return obj
                end
            end
        end
    end
    return nil
end

-- Cari tombol Enter/Submit
local function findEnterBtn()
    for _, gui in ipairs(playerGui:GetChildren()) do
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextButton") then
                local n = obj.Name:lower()
                local t = obj.Text:lower()
                if n=="enter" or t=="enter" or n:find("submit") or n:find("kirim") or t=="<< enter" then
                    return obj
                end
            end
        end
    end
    return nil
end

local function clickBtn(btn)
    if not btn then return end
    pcall(function() btn.MouseButton1Click:Fire() end)
    task.wait(0.02)
    pcall(function()
        local vgui = game:GetService("VirtualInputManager")
        local cx = btn.AbsolutePosition.X + btn.AbsoluteSize.X/2
        local cy = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y/2
        vgui:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.02)
        vgui:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
    end)
end

local function typeWord(word)
    if not word then return false end
    for i = 1, #word do
        local char = word:sub(i,i)
        local btn = findLetterBtn(char)
        if btn then clickBtn(btn) end
        local delay = CONFIG.SPEED_MIN
        if CONFIG.NATURAL_TYPE then
            delay = CONFIG.SPEED_MIN + math.random()*(CONFIG.SPEED_MAX-CONFIG.SPEED_MIN)
        end
        task.wait(delay)
    end
    if CONFIG.AUTO_SUBMIT then
        task.wait(0.2)
        local enterBtn = findEnterBtn()
        if enterBtn then clickBtn(enterBtn) end
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
task.wait(0.3)

local C = {
    bg      = Color3.fromRGB(7, 10, 26),
    panel   = Color3.fromRGB(13, 19, 48),
    card    = Color3.fromRGB(20, 30, 72),
    cardHi  = Color3.fromRGB(28, 42, 95),
    accent  = Color3.fromRGB(88, 166, 255),
    accent2 = Color3.fromRGB(140, 210, 255),
    green   = Color3.fromRGB(52, 224, 140),
    red     = Color3.fromRGB(255, 72, 72),
    yellow  = Color3.fromRGB(255, 208, 48),
    purple  = Color3.fromRGB(190, 110, 255),
    orange  = Color3.fromRGB(255, 155, 55),
    text    = Color3.fromRGB(228, 242, 255),
    muted   = Color3.fromRGB(95, 135, 205),
    border  = Color3.fromRGB(40, 70, 165),
    dark    = Color3.fromRGB(4, 7, 20),
}

local Gui = Instance.new("ScreenGui", playerGui)
Gui.Name = "SK_YURXZ"; Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true; Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 280, 0, 0)
Main.Position = UDim2.new(0.5, -140, 0.5, -180)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.AutomaticSize = Enum.AutomaticSize.Y
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = C.accent; mainStroke.Thickness = 1.2; mainStroke.Transparency = 0.2

-- Rainbow top bar
local topBar = Instance.new("Frame", Main)
topBar.Size = UDim2.new(1, 0, 0, 3)
topBar.BackgroundColor3 = C.accent
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 2)
local tbG = Instance.new("UIGradient", topBar)
tbG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(88,166,255)),
    ColorSequenceKeypoint.new(0.33,Color3.fromRGB(190,110,255)),
    ColorSequenceKeypoint.new(0.66,Color3.fromRGB(52,224,140)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,208,48)),
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

-- Header
local hdrFrame = Instance.new("Frame", Content)
hdrFrame.Size = UDim2.new(1, 0, 0, 30)
hdrFrame.BackgroundTransparency = 1
hdrFrame.LayoutOrder = 1

local dot = Instance.new("Frame", hdrFrame)
dot.Size = UDim2.new(0, 9, 0, 9)
dot.Position = UDim2.new(0, 2, 0.5, -4.5)
dot.BackgroundColor3 = C.muted
dot.BorderSizePixel = 0
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

local hTitle = Instance.new("TextLabel", hdrFrame)
hTitle.Size = UDim2.new(0.7, -16, 1, 0)
hTitle.Position = UDim2.new(0, 16, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "⚡ SAMBUNG KATA"
hTitle.TextColor3 = C.text
hTitle.TextSize = 13
hTitle.Font = Enum.Font.GothamBold
hTitle.TextXAlignment = Enum.TextXAlignment.Left

local hVer = Instance.new("TextLabel", hdrFrame)
hVer.Size = UDim2.new(0.3, 0, 1, 0)
hVer.Position = UDim2.new(0.7, 0, 0, 0)
hVer.BackgroundTransparency = 1
hVer.Text = "v4.0 FIXED"
hVer.TextColor3 = C.purple
hVer.TextSize = 9
hVer.Font = Enum.Font.GothamBold
hVer.TextXAlignment = Enum.TextXAlignment.Right

-- Divider
local div = Instance.new("Frame", Content)
div.Size = UDim2.new(1, 0, 0, 1)
div.BackgroundColor3 = C.border
div.BorderSizePixel = 0
div.LayoutOrder = 2
div.BackgroundTransparency = 0.5

-- Info card
local infoCard = Instance.new("Frame", Content)
infoCard.Size = UDim2.new(1, 0, 0, 0)
infoCard.BackgroundColor3 = C.panel
infoCard.BorderSizePixel = 0
infoCard.AutomaticSize = Enum.AutomaticSize.Y
infoCard.LayoutOrder = 3
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 10)
local icStroke = Instance.new("UIStroke", infoCard)
icStroke.Color = C.border; icStroke.Thickness = 1; icStroke.Transparency = 0.3
local icPad = Instance.new("UIPadding", infoCard)
icPad.PaddingLeft = UDim.new(0,10); icPad.PaddingRight = UDim.new(0,10)
icPad.PaddingTop = UDim.new(0,8); icPad.PaddingBottom = UDim.new(0,8)
local icL = Instance.new("UIListLayout", infoCard)
icL.Padding = UDim.new(0, 5)

-- Baris huruf + kata
local rowHK = Instance.new("Frame", infoCard)
rowHK.Size = UDim2.new(1, 0, 0, 36)
rowHK.BackgroundTransparency = 1
rowHK.BorderSizePixel = 0

-- Huruf box
local hurufBox = Instance.new("Frame", rowHK)
hurufBox.Size = UDim2.new(0.4, -4, 1, 0)
hurufBox.BackgroundColor3 = C.card
hurufBox.BorderSizePixel = 0
Instance.new("UICorner", hurufBox).CornerRadius = UDim.new(0, 8)
local hbStroke = Instance.new("UIStroke", hurufBox)
hbStroke.Color = C.accent; hbStroke.Thickness = 1; hbStroke.Transparency = 0.5

local hurufIcon = Instance.new("TextLabel", hurufBox)
hurufIcon.Size = UDim2.new(0, 26, 1, 0)
hurufIcon.BackgroundTransparency = 1
hurufIcon.Text = "🔤"
hurufIcon.TextSize = 12; hurufIcon.Font = Enum.Font.Gotham

local hurufLbl = Instance.new("TextLabel", hurufBox)
hurufLbl.Size = UDim2.new(1, -28, 1, 0)
hurufLbl.Position = UDim2.new(0, 28, 0, 0)
hurufLbl.BackgroundTransparency = 1
hurufLbl.Text = "-"
hurufLbl.TextColor3 = C.accent2
hurufLbl.TextSize = 20
hurufLbl.Font = Enum.Font.GothamBold

-- Kata box
local kataBox = Instance.new("Frame", rowHK)
kataBox.Size = UDim2.new(0.6, -4, 1, 0)
kataBox.Position = UDim2.new(0.4, 4, 0, 0)
kataBox.BackgroundColor3 = C.card
kataBox.BorderSizePixel = 0
Instance.new("UICorner", kataBox).CornerRadius = UDim.new(0, 8)
local kbStroke = Instance.new("UIStroke", kataBox)
kbStroke.Color = C.green; kbStroke.Thickness = 1; kbStroke.Transparency = 0.5

local kataIcon = Instance.new("TextLabel", kataBox)
kataIcon.Size = UDim2.new(0, 24, 1, 0)
kataIcon.BackgroundTransparency = 1
kataIcon.Text = "📝"; kataIcon.TextSize = 12; kataIcon.Font = Enum.Font.Gotham

local kataLbl = Instance.new("TextLabel", kataBox)
kataLbl.Size = UDim2.new(1, -26, 1, 0)
kataLbl.Position = UDim2.new(0, 26, 0, 0)
kataLbl.BackgroundTransparency = 1
kataLbl.Text = "-"
kataLbl.TextColor3 = C.green
kataLbl.TextSize = 11
kataLbl.Font = Enum.Font.GothamBold
kataLbl.TextTruncate = Enum.TextTruncate.AtEnd

-- Status label
local statusLbl = Instance.new("TextLabel", infoCard)
statusLbl.Size = UDim2.new(1, 0, 0, 13)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "💤  Menunggu..."
statusLbl.TextColor3 = C.muted
statusLbl.TextSize = 9
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Speed card
local setCard = Instance.new("Frame", Content)
setCard.Size = UDim2.new(1, 0, 0, 0)
setCard.BackgroundColor3 = C.panel
setCard.BorderSizePixel = 0
setCard.AutomaticSize = Enum.AutomaticSize.Y
setCard.LayoutOrder = 4
Instance.new("UICorner", setCard).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", setCard).Color = C.border
local setPad = Instance.new("UIPadding", setCard)
setPad.PaddingLeft = UDim.new(0,10); setPad.PaddingRight = UDim.new(0,10)
setPad.PaddingTop = UDim.new(0,8); setPad.PaddingBottom = UDim.new(0,8)
local setL = Instance.new("UIListLayout", setCard)
setL.Padding = UDim.new(0, 5)

local spLbl = Instance.new("TextLabel", setCard)
spLbl.Size = UDim2.new(1, 0, 0, 12)
spLbl.BackgroundTransparency = 1
spLbl.Text = "⏱️  Kecepatan"
spLbl.TextColor3 = C.accent2
spLbl.TextSize = 9
spLbl.Font = Enum.Font.GothamBold
spLbl.TextXAlignment = Enum.TextXAlignment.Left

local spRow = Instance.new("Frame", setCard)
spRow.Size = UDim2.new(1, 0, 0, 28)
spRow.BackgroundTransparency = 1
spRow.BorderSizePixel = 0
local spRL = Instance.new("UIListLayout", spRow)
spRL.FillDirection = Enum.FillDirection.Horizontal
spRL.Padding = UDim.new(0, 3)

local speedBtns = {}
for i = 1, 4 do
    local btn = Instance.new("TextButton", spRow)
    btn.Size = UDim2.new(0.25, -3, 1, 0)
    btn.BackgroundColor3 = i==speedMode and C.yellow or C.cardHi
    btn.TextColor3 = i==speedMode and C.dark or C.muted
    btn.Text = SPEEDS[i].label
    btn.TextSize = 7
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    speedBtns[i] = btn
    btn.MouseButton1Click:Connect(function()
        speedMode = i
        CONFIG.SPEED_MIN = SPEEDS[i].min
        CONFIG.SPEED_MAX = SPEEDS[i].max
        for j, b in ipairs(speedBtns) do
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = j==i and C.yellow or C.cardHi,
                TextColor3 = j==i and C.dark or C.muted,
            }):Play()
        end
    end)
end

-- Toggle natural
local togRow = Instance.new("Frame", setCard)
togRow.Size = UDim2.new(1, 0, 0, 26)
togRow.BackgroundTransparency = 1
togRow.BorderSizePixel = 0
local togRL = Instance.new("UIListLayout", togRow)
togRL.FillDirection = Enum.FillDirection.Horizontal
togRL.Padding = UDim.new(0, 5)

local function mkToggle(parent, label, initVal, onChange)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.5, -3, 1, 0)
    frame.BackgroundColor3 = C.cardHi
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
    Instance.new("UIStroke", frame).Color = C.border
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.text
    lbl.TextSize = 8
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local lp = Instance.new("UIPadding", lbl); lp.PaddingLeft = UDim.new(0,6)
    local tog = Instance.new("TextButton", frame)
    tog.Size = UDim2.new(0, 36, 0, 16)
    tog.Position = UDim2.new(1, -40, 0.5, -8)
    tog.BackgroundColor3 = initVal and C.green or C.card
    tog.TextColor3 = Color3.fromRGB(255,255,255)
    tog.Text = initVal and "ON" or "OFF"
    tog.TextSize = 7; tog.Font = Enum.Font.GothamBold
    tog.AutoButtonColor = false; tog.BorderSizePixel = 0
    Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 5)
    local val = initVal
    tog.MouseButton1Click:Connect(function()
        val = not val; onChange(val)
        TweenService:Create(tog, TweenInfo.new(0.15), {BackgroundColor3 = val and C.green or C.card}):Play()
        tog.Text = val and "ON" or "OFF"
    end)
end

mkToggle(togRow, "🤖 Natural", CONFIG.NATURAL_TYPE, function(v) CONFIG.NATURAL_TYPE = v end)
mkToggle(togRow, "⏎ Auto Submit", CONFIG.AUTO_SUBMIT, function(v) CONFIG.AUTO_SUBMIT = v end)

-- Start/Stop button
local actionBtn = Instance.new("TextButton", Content)
actionBtn.Size = UDim2.new(1, 0, 0, 38)
actionBtn.BackgroundColor3 = C.accent
actionBtn.TextColor3 = Color3.fromRGB(255,255,255)
actionBtn.Text = "▶  START AUTO"
actionBtn.TextSize = 13
actionBtn.Font = Enum.Font.GothamBold
actionBtn.AutoButtonColor = false
actionBtn.BorderSizePixel = 0
actionBtn.LayoutOrder = 5
Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0, 10)
local abG = Instance.new("UIGradient", actionBtn)
abG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70,150,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25,90,230)),
})
abG.Rotation = 135

local botPad = Instance.new("Frame", Content)
botPad.Size = UDim2.new(1, 0, 0, 4)
botPad.BackgroundTransparency = 1
botPad.LayoutOrder = 6

-- Drag
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging=true; dragStart=inp.Position; startPos=Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging=false
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

-- ══════════════════════════════════════════
--  MAIN LOOP
-- ══════════════════════════════════════════
local autoThread = nil

local function setStatus(msg, color)
    statusLbl.Text = msg
    statusLbl.TextColor3 = color or C.muted
end

local function startAuto()
    isRunning = true
    lastLetter = nil
    actionBtn.Text = "⏹  STOP AUTO"
    abG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(210,35,35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150,10,10)),
    })
    TweenService:Create(actionBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(180,22,22)}):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.3), {Color=C.green}):Play()
    TweenService:Create(icStroke, TweenInfo.new(0.3), {Color=C.green}):Play()

    autoThread = task.spawn(function()
        while isRunning do
            task.wait(0.3)
            if not isRunning then break end
            local letter = getCurrentLetter()
            if letter and letter ~= lastLetter then
                lastLetter = letter
                hurufLbl.Text = letter:upper()
                TweenService:Create(hbStroke, TweenInfo.new(0.2), {Color=C.yellow, Transparency=0}):Play()
                setStatus("🔍 Huruf: "..letter:upper().." | Mencari kata...", C.yellow)
                task.wait(0.1 + math.random()*0.2)
                local word = findBestWord(letter)
                if word then
                    kataLbl.Text = word
                    TweenService:Create(kbStroke, TweenInfo.new(0.2), {Color=C.green, Transparency=0}):Play()
                    setStatus("⌨️  Mengetik: "..word, C.green)
                    typeWord(word)
                    setStatus("✅  "..word.."  →  akhir: '"..word:sub(-1):upper().."'", C.green)
                    TweenService:Create(hbStroke, TweenInfo.new(0.5), {Color=C.accent, Transparency=0.5}):Play()
                else
                    kataLbl.Text = "Tidak ada!"
                    setStatus("⚠️  Tidak ada kata untuk: "..letter:upper(), C.red)
                end
            elseif not letter then
                setStatus("👀  Mendeteksi huruf...", C.muted)
            end
        end
    end)
end

local function stopAuto()
    isRunning = false
    if autoThread then task.cancel(autoThread); autoThread = nil end
    actionBtn.Text = "▶  START AUTO"
    abG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70,150,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25,90,230)),
    })
    TweenService:Create(actionBtn, TweenInfo.new(0.2), {BackgroundColor3=C.accent}):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.3), {Color=C.accent}):Play()
    TweenService:Create(icStroke, TweenInfo.new(0.3), {Color=C.border}):Play()
    TweenService:Create(dot, TweenInfo.new(0.3), {BackgroundColor3=C.muted}):Play()
    setStatus("⏹️  Dihentikan", C.yellow)
end

actionBtn.MouseButton1Click:Connect(function()
    if isRunning then stopAuto() else startAuto() end
end)

-- Dot pulse
task.spawn(function()
    while Gui.Parent do
        if isRunning then
            TweenService:Create(dot, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3=Color3.fromRGB(30,200,100)}):Play()
            task.wait(0.5)
            TweenService:Create(dot, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundColor3=C.green}):Play()
            task.wait(0.5)
        else task.wait(0.5) end
    end
end)

-- Open animation
Main.BackgroundTransparency = 1
Main.Position = Main.Position - UDim2.new(0,0,0,15)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {BackgroundTransparency=0, Position=Main.Position+UDim2.new(0,0,0,15)}):Play()

gset("SK_Stop", function()
    isRunning = false
    if autoThread then pcall(function() task.cancel(autoThread) end) end
end)

print("[SAMBUNG KATA v4.0] ✅ Fixed berdasarkan scan UI real!")
print("[SAMBUNG KATA v4.0] Deteksi: CurrentWordIndex label")
print("[SAMBUNG KATA v4.0] Klik tombol: [huruf]Button pattern")
print("[SAMBUNG KATA v4.0] Submit: Enter button")
print("[SAMBUNG KATA v4.0] Klik START AUTO untuk mulai!")
