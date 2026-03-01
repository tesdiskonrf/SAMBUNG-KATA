-- SAMBUNG KATA YURXZ v9.0
-- Deteksi UI langsung (Word + Enter) | KBBI valid | Anti-spam | AUTO + MANUAL
-- Natural Type | Hide KB | Custom Akhiran | Speed Preset | Rekomendasi 5 kata

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local VIM          = game:GetService("VirtualInputManager")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local _genv = {}
pcall(function() _genv = getgenv() end)
local function gset(k,v) pcall(function() _genv[k]=v end) end
local function gget(k) local ok,v=pcall(function() return _genv[k] end); return ok and v or nil end

if playerGui:FindFirstChild("SK_YURXZ") then playerGui:FindFirstChild("SK_YURXZ"):Destroy() end
local oldStop = gget("SK_Stop")
if type(oldStop)=="function" then pcall(oldStop) end
task.wait(0.15)

-- ==========================================
-- CONFIG
-- ==========================================
local CONFIG = {
    SPEED_MIN    = 0.04,
    SPEED_MAX    = 0.10,
    NATURAL_TYPE = true,
    AUTO_SUBMIT  = true,
    HIDE_KB      = true,
    SUBMIT_COOLDOWN = 1.8,
    BEST_ENDINGS = {k=true,h=true,r=true,n=true,l=true,m=true,g=true,p=true,t=true},
    BAD_ENDINGS  = {a=true,i=true,u=true,e=true,o=true},
}

-- ==========================================
-- DATABASE KATA KBBI (valid, bersih)
-- ==========================================
local _WD = {}

-- Format: pipe-separated per huruf awal
_WD["a"] = "abadi|abad|abai|abang|acar|acara|adat|adik|adil|aduh|aduk|agak|agar|agama|agen|agung|ahli|air|ajar|ajak|ajal|ajang|akal|akad|akibat|akrab|aksi|aktif|aku|alam|alang|alat|alih|alim|alir|alis|alun|alur|aman|amal|ambil|amuk|anak|ancam|andai|aneh|angin|anjak|anjur|antar|antik|apik|arah|arang|arit|aroma|atur|awam|awan|awas|awet|ayah|ayam|ayat|ayun|abstrak|adegan|agenda|akhlak|alamat|album|ambisi|amfibi|analis|analisa|anggap|anggur|angkat|angkuh|angkasa|anjing|antara|antena|aparat|artikel|aspirasi|asuransi|aturan|audisi|azab|akurat|adaptasi|adiktif|adrenalin|agresif|akademi|akselerasi|akumulasi|aliansi|alokasi|alternatif|analisis|anarkis|animasi|anomali|antologi|aplikasi|apresiasi|argumen|arsip|aset|asimilasi|asisten|astronomi|atmosfer|audit|autentik|otonom"

_WD["b"] = "babu|baca|badan|bagus|bahas|bahasa|bahaya|baik|baju|bakar|bakat|balik|bambu|bangga|bangku|bangun|banjir|bantah|banyak|barang|batas|batu|bawa|bawah|bayar|bayam|bebas|becak|beda|bedah|beku|belah|belajar|belanja|belas|benci|benih|benar|bentuk|berat|bersih|besar|beton|bijak|bisa|bisu|bolos|bubur|budak|bulan|bulu|bunga|bunuh|busuk|biaya|bimbang|binasa|bingung|birahi|bisnis|bocah|borong|brutal|budaya|bukti|buron|buruan|bagan|bagian|bahkan|balasan|bangkit|bantuan|batasan|batuk|beban|bedakan|berhenti|berkembang|berlanjut|bermain|bertahan|berbagi|berhasil|berisik|berlari|bermakna|bernyawa|bertemu|bersatu|besaran|birokrasi|bocoran|bongkar|boikot|bonus|boros|brilian|buram|buruk"

_WD["c"] = "cabe|cabut|cacing|cahaya|cakap|calon|campur|cantik|capek|catat|cedera|cemas|cepat|cerah|cerai|cermat|cerita|cinta|cita|coblos|cocok|contoh|cuaca|cubit|cucian|curang|cabai|candu|canggih|capung|catur|cendol|cerdas|ceria|cikal|cindai|ciptaan|coklat|congkak|cukong|culas|curiga|cadangan|cagar|capai|catatan|cekatan|cemerlang|cerdik|ciri|cita-cita|cobaan|corak|cukup|curhat|cekam|cergas|ceruk|cibiran|cipta|cita|citra|colong|coreng|cukong|curang|curup"

_WD["d"] = "dagang|daging|dahaga|damai|dampak|danau|dapat|darah|dasar|data|daun|debat|dalam|dahan|deras|debu|dengar|dengan|dekat|desa|desak|desir|dewan|dilema|diskusi|dongeng|dompet|dunia|durasi|dusta|daya|dayung|debar|dendam|derek|desah|dewa|dinamis|duduk|dukun|dukungan|dakwah|dan|dapur|darang|daya|debat|dedikasi|definisi|degradasi|dekrit|demokratis|deskripsi|destruktif|devisa|dialog|diktator|dimensi|dinamika|diplomasi|disiplin|distribusi|diversifikasi|dogma|dominan|dorongan|drastis|dua|dugaan|dukungan|duplikasi|durasi"

_WD["e"] = "ekor|ekonomi|ekspor|ekstra|emosi|empuk|endap|energi|engkau|entah|enak|emas|elang|elastis|ekskul|ekspres|elektrik|elite|elok|embun|empati|enggak|evaluasi|evolusi|efektif|efisien|eksekusi|eksistensi|eksperimen|eksploitasi|eksplorasi|ekspresi|eliminasi|emansipasi|embargo|emigrasi|emosi|empiris|endemik|epidemi|era|esai|eskalasi|estetika|etika|etnis|evaluasi|evolusi|ekologi|ekonomi|ekuitas"

_WD["f"] = "faham|fajar|fakir|fakta|faktor|fanatik|fatal|fauna|fenomena|fikir|fiksi|filsafat|final|fisik|fitrah|fokus|formal|forum|foto|fungsi|frekuensi|frustasi|fasih|fasilitas|favorit|federal|feminisme|filosofi|finansial|fleksibel|fondasi|formulasi|fragmentasi|fundamental"

_WD["g"] = "gairah|gaji|galon|gambar|ganas|ganggu|gantung|garang|garpu|gelar|gelap|gempa|gemuk|gerak|getah|golong|gosip|gula|gulat|gunung|galak|gambut|ganggang|gapai|garap|garuda|geliat|gelora|gemilang|genggam|getir|gigih|girang|gotong|gratis|gusar|guyub|gabungan|gagal|gagasan|galang|ganas|gaung|gejolak|gelisah|gelombang|gempa|gerak|geriap|gerindra|getaran|gigih|golongan|gonjang|gontai|guncang|guyuran"

_WD["h"] = "habis|harga|harap|hari|hasil|hati|harum|haus|hebat|hemat|hidup|hijau|hikmat|hikmah|hormat|hujan|hukum|huruf|halus|hambat|handal|hangat|harkat|harmoni|hasrat|heboh|heran|hijrah|hilang|hisab|hitam|horor|hubung|hujat|hukuman|hadap|hadiah|hadir|harapan|harmonis|hasil|hasrat|hebat|hiruk|hubungan|hukum|humanis|huni|hustle"

_WD["i"] = "ibarat|ikhlas|ikat|iklim|ikut|ilmu|iman|impian|inovasi|insan|inspirasi|instansi|integrasi|intelijen|irama|ironi|isi|isyarat|ideal|identitas|ideologi|ilmiah|imajinasi|implikasi|industri|informasi|inisiasi|inklusif|instruksi|investasi|isolasi|isu|idealis|ikhlas|ikhtiar|implementasi|impor|indikasi|induksi|inferensi|infrastruktur|inherent|inisiatif|inkonsistensi|inovasi|institusi|interaksi|internalisasi|interpretasi|intervensi|investigasi|isolasi"

_WD["j"] = "jabat|jahat|jalan|jangka|jauh|jawab|jelas|jelita|jembatan|jimat|jujur|jumpa|jurus|jasa|jasad|jaya|jeda|jejak|jenuh|jiwa|joget|jual|juang|junjung|jurnal|juta|jabatan|jagoan|jalur|jamak|jantan|jarang|jaring|jasad|jemput|jenaka|jenis|jernih|jitu|jugul|julukan|jalinan|janji|jaminan|jangkauan|jasad|jaya|jejaring|jelas|jemput|jendela|jernih|jiwa|jual|juang|jumpa|junjung|jurang"

_WD["k"] = "kabar|kaget|kaku|kalah|kampus|kandas|karya|kasih|kawan|kebun|kejar|keras|kira|kode|kolam|kotor|kuat|kubah|kudeta|kulit|kunci|kurang|kabur|kagum|kajian|kalbu|kalimat|kapas|kapur|karang|kasta|kebal|kebijakan|kebudayaan|kecewa|kecut|kehendak|kekuatan|keluhan|kemampuan|kepala|keputusan|kerajaan|kesal|kidal|kisah|kitab|klien|koboi|koleksi|konsep|konten|konteks|korek|korban|korupsi|kosong|kritis|kronis|krusial|kuliah|kultural|kumpul|kusut|kalangan|kampanye|karakter|karena|kartografi|kategorisasi|keadilan|keamanan|keberhasilan|kebetulan|kebijakan|kebijaksanaan|kebutuhan|kedalaman|kegagalan|kegiatan|keinginan|kekacauan|kekuasaan|keluarga|kemajuan|kemampuan|kemandirian|kemanusiaan|kemerdekaan|kepercayaan|keperluan|kesadaran|kesatuan|kesehatan|kesempatan|ketegasan|keterlibatan|keteladanan|ketepatan|ketulusan|kewajiban"

_WD["l"] = "labuh|lacak|ladang|lahir|laju|langit|lapang|latih|lawan|layak|lebar|lemah|lempar|lengkap|lepas|lihat|lirik|lolos|lowong|luang|lubang|lucu|lukis|lulus|lunas|luntur|lurus|larang|lasak|laskar|latah|lekat|lelah|lembar|lentur|lesung|liberal|lihai|lingkar|lingkup|listrik|logis|logam|lompat|longsor|loyal|lumpur|luput|lusuh|laju|langkah|larangan|latihan|lebih|legasi|legitimasi|lemah|lembaga|lestari|lingkungan|lokal|logika|loyalitas|lugas|luwes"

_WD["m"] = "mabuk|macam|maju|makar|makin|malam|mampu|manajer|marah|massa|masuk|mati|mawar|mayor|media|megah|mekar|menang|mendaki|merah|mesra|modal|mogok|momen|muda|mudah|mulia|munafik|muncul|murni|mahir|makna|maksud|malang|manfaat|mantan|mapan|martabat|masalah|matang|mawas|melarat|melawan|melodi|membara|mencari|mendung|mengaku|menikah|mentah|merana|merapi|merata|merdeka|meriah|minat|minyak|mirip|miskin|mobil|modifikasi|momentum|moral|motivasi|mujarab|mukjizat|musim|mustahil|madani|mahkamah|maklumat|manajerial|mandat|manipulasi|manifestasi|masyarakat|mekanisme|memori|merambat|merebak|merekam|meresap|merespon|merintis|merumuskan|mewujudkan|migrasi|militer|misi|mobilisasi|modernisasi|monopoli|moralitas"

_WD["n"] = "naik|nilai|nikmat|niat|normal|nyaman|nyawa|nakal|naluri|nama|napas|narasi|nasib|nasional|nekat|netral|nihil|nirwana|nista|nonton|nurani|nusantara|naturalisasi|negosiasi|netralitas|norma|nyata"

_WD["o"] = "obat|objek|obrolan|olah|omong|opini|orang|otak|otomatis|ombak|omset|operasi|optimal|orbit|organisasi|orientasi|observasi|oposisi|orisinal|otoritas|otonomi"

_WD["p"] = "panas|pandai|panjang|pasang|pecah|peduli|pejuang|pekat|pelan|pemuda|perang|perlu|pertama|perut|pikir|pintar|pokok|prestasi|prinsip|proses|punya|pusat|pabrik|padu|paham|paksa|pamer|panik|pantau|paraf|paras|paruh|patuh|pecinta|pendapat|pengaruh|percaya|perdana|performa|permata|persatu|persepsi|persis|pertemuan|pertolongan|pesona|petani|petunjuk|pilihan|positif|potensial|praktis|produktif|profil|progresif|proyek|publik|puncak|punggung|pelajaran|pelaksanaan|pelayanan|pemerintah|pendidikan|pengalaman|pengetahuan|penjabaran|penyusunan|pepaya|perceraian|perlindungan|perkembangan|perjuangan|perilaku|perjalanan|persatuan|persyaratan|pertahanan|pertumbuhan|pilar|platform|polarisasi|prioritas|produktivitas|profesi|program|prospek|proteksi"

_WD["r"] = "raba|ragam|raih|rajin|rakus|rakyat|ramah|rancang|rapuh|rasio|ratus|ribut|rinci|ringan|risau|risiko|rohani|ruang|rubah|rugikan|rujuk|rumah|runding|runtuh|rasa|rata|rawat|rela|rendah|respek|retak|riuh|roboh|royong|rumus|rakyat|ratifikasi|realitas|reformasi|regulasi|rehabilitasi|rekonsiliasi|relevan|representasi|resolusi|respons|restrukturisasi|revolusi|rivalitas|ruang"

_WD["s"] = "sabar|sadar|sakti|salah|sama|sambil|santai|santun|sayang|sebab|sehat|selamat|semangat|sendiri|sepakat|serius|siap|sikap|simpan|singkat|sinis|sistem|sobat|solusi|sopan|sosial|strategis|sukses|sungguh|surga|susah|swasta|syukur|sahabat|sahaja|saksi|sampai|saran|satuan|segar|sejati|sekat|selama|selalu|semua|sengat|senjata|sentuh|sepatu|serasi|serba|serta|setia|sigap|silih|simpati|skala|slogan|soal|sorot|struktur|studi|suara|subur|sulit|sumber|sunyi|syarat|sabotase|sanksi|sentralisasi|signifikan|simulasi|sistematik|situasi|solidaritas|soverign|spekulasi|stabilitas|standar|stategi|stimulasi|substansi|sulitnya|sumber|supremasi|sustainable"

_WD["t"] = "tabah|tahan|tajam|takdir|tanah|tantang|tatap|teguh|tekad|tekun|teladan|tenang|terima|tindak|tujuan|tugas|tuntas|turut|tabung|takluk|takwa|tanam|tanduk|tanya|tapak|tarik|tarung|teliti|telusur|tempuh|tenun|tepat|terasa|terbang|terjal|tetap|tindas|tipu|tobat|tokoh|toleran|topang|total|tradisi|transparan|tulus|tunai|turun|tata|tatanan|teknis|terdepan|terlibat|terlaksana|terorganisir|terpadu|terpenuhi|tersedia|terwujud|transformasi|transparansi|tren|tribun|tumpuan"

_WD["u"] = "ubah|uji|ulang|ulung|umum|undang|ungkap|unik|upaya|urus|usaha|usul|utama|ucap|ukur|ulet|unggulan|unit|universal|urgen|utuh|ujian|ukuran|umpan|undangan|unggul|unggulan|urgensi"

_WD["v"] = "valid|variasi|visi|vital|vokal|volume|vulgar|validasi|verifikasi"

_WD["w"] = "wajah|wajar|waktu|wanita|warga|warna|wasiat|waspada|wujud|watak|wawasan|wirausaha|wisata|wacana|wajib|waspadai|wewenang"

_WD["y"] = "yakin|yang"

_WD["z"] = "zaman|zalim|zikir|zona|zakat|zarurat"

-- Build lookup: huruf awal -> list kata
local WORD_LIST = {}
for ch, raw in pairs(_WD) do
    WORD_LIST[ch] = {}
    for w in raw:gmatch("[^|]+") do
        table.insert(WORD_LIST[ch], w)
    end
end

-- ==========================================
-- STATE
-- ==========================================
local usedWords        = {}
local lastDetectedWord = ""
local isRunning        = false
local isAutoMode       = true
local lastPrefix       = nil
local autoThread       = nil
local lastSubmitTime   = 0
local speedMode        = 2
local SPEEDS = {
    {min=0.12, max=0.20, label="Lambat"},
    {min=0.04, max=0.10, label="Normal"},
    {min=0.02, max=0.05, label="Cepat"},
    {min=0.008,max=0.02, label="Turbo"},
}

-- ==========================================
-- CARI KATA
-- ==========================================
local function scoreWord(w)
    local score = 0
    local last = w:sub(-1):lower()
    if CONFIG.BEST_ENDINGS[last] then score = score + 100 end
    if CONFIG.BAD_ENDINGS[last]  then score = score - 60  end
    score = score + #w * 3  -- kata panjang = lebih susah dijawab lawan
    return score
end

local function findTopWords(prefix, count)
    if not prefix or #prefix == 0 then return {} end
    local firstChar = prefix:sub(1,1):lower()
    local list = WORD_LIST[firstChar]
    if not list then return {} end

    local candidates = {}
    for _, w in ipairs(list) do
        local wl = w:lower()
        if wl:sub(1, #prefix) == prefix and not usedWords[w] then
            table.insert(candidates, {w=w, s=scoreWord(w)})
        end
    end
    table.sort(candidates, function(a,b) return a.s > b.s end)

    local result = {}
    for i = 1, math.min(count, #candidates) do
        table.insert(result, candidates[i].w)
    end
    return result
end

local function findBestWord(prefix)
    local tops = findTopWords(prefix, 1)
    if tops[1] then
        usedWords[tops[1]] = true
        return tops[1]
    end
    return nil
end

-- ==========================================
-- DETEKSI UI GAME (dari hasil riset console)
-- Confirmed: TextLabel "Word" berisi prefix (1-3 huruf)
--            TextLabel "WordServer" = "Hurufnya adalah:" saat giliran kita
--            TextLabel "UsedWordWarn" tidak kosong = kata sudah dipakai
--            TextLabel "Warning" berisi "DELAY" = kena spam penalty
-- ==========================================
local function getDescendants()
    local res = {}
    pcall(function()
        for _, v in ipairs(playerGui:GetDescendants()) do
            res[#res+1] = v
        end
    end)
    return res
end

local function findByName(name, class)
    class = class or "TextLabel"
    for _, v in ipairs(getDescendants()) do
        if v:IsA(class) and v.Name == name then
            return v
        end
    end
    return nil
end

-- Ambil prefix dari TextLabel "Word" (CONFIRMED dari console)
local function getCurrentPrefix()
    -- Metode 1: TextLabel bernama "Word" (CONFIRMED)
    local wordLabel = findByName("Word", "TextLabel")
    if wordLabel then
        local txt = wordLabel.Text:match("^%s*(.-)%s*$")
        if txt and #txt >= 1 and #txt <= 5 and txt:match("^[A-Za-z]+$") then
            return txt:lower()
        end
    end

    -- Metode 2: Fallback - cari pola "Hurufnya adalah: X" dari WordServer
    local wsLabel = findByName("WordServer", "TextLabel")
    if wsLabel then
        local found = wsLabel.Text:match("[Hh]urufnya%s+adalah%s*:%s*([A-Za-z]+)")
        if found then return found:lower() end
    end

    -- Metode 3: Fallback - TextLabel 1-3 huruf besar yang visible
    for _, obj in ipairs(getDescendants()) do
        if obj:IsA("TextLabel") and obj.Visible then
            local t = obj.Text:gsub("%s+","")
            if #t >= 1 and #t <= 3 and t:match("^[A-Za-z]+$")
            and obj.AbsoluteSize.X > 20 then
                return t:lower()
            end
        end
    end

    return nil
end

-- Cek apakah giliran kita
local function isOurTurn()
    local ws = findByName("WordServer", "TextLabel")
    if ws then
        local t = ws.Text:lower()
        return t:find("hurufnya") ~= nil or t:find("huruf") ~= nil
    end
    return false
end

-- Cek kata sudah dipakai
local function isWordRejected()
    local uw = findByName("UsedWordWarn", "TextLabel")
    if uw and #uw.Text > 0 then return true end
    return false
end

-- Cek kena delay alert
local function hasDelayAlert()
    local w = findByName("Warning", "TextLabel")
    if w and (w.Text:find("DELAY") or w.Text:find("delay")) then return true end
    return false
end

-- ==========================================
-- CARI TEXTBOX & TOMBOL ENTER
-- ==========================================
local function findInputBox()
    -- Cari TextBox yang visible (game punya input box saat giliran)
    local best, bestScore = nil, -1
    for _, v in ipairs(getDescendants()) do
        if v:IsA("TextBox") and v.Visible then
            local score = 0
            local n = v.Name:lower()
            if n:find("input") or n:find("answer") or n:find("kata") or n:find("word") then
                score = score + 10
            end
            if v.Text == "" then score = score + 3 end
            if score > bestScore then best = v; bestScore = score end
        end
    end
    return best
end

local function findSubmitBtn()
    -- CONFIRMED: TextButton bernama "Enter"
    local enter = findByName("Enter", "TextButton")
    if enter and enter.Visible then return enter end

    -- Fallback
    for _, v in ipairs(getDescendants()) do
        if v:IsA("TextButton") and v.Visible then
            local n = v.Name:lower()
            local t = v.Text:lower():gsub("%s+","")
            if n=="enter" or n:find("submit") or n:find("kirim")
            or t=="enter" or t=="kirim" or t=="submit" then
                return v
            end
        end
    end
    return nil
end

-- ==========================================
-- HIDE KEYBOARD (mobile)
-- ==========================================
local function hideKeyboard()
    if not CONFIG.HIDE_KB then return end
    pcall(function()
        local dummy = Instance.new("TextBox")
        dummy.Size = UDim2.new(0,1,0,1)
        dummy.Position = UDim2.new(0,-200,0,-200)
        dummy.BackgroundTransparency = 1
        dummy.TextTransparency = 1
        dummy.Parent = playerGui
        dummy:CaptureFocus()
        task.wait(0.05)
        dummy:ReleaseFocus()
        dummy:Destroy()
    end)
end

-- ==========================================
-- SUBMIT KATA
-- ==========================================
local function submitWord(word)
    if not word or #word == 0 then return false end

    -- Cooldown anti-spam
    local now = tick()
    if now - lastSubmitTime < CONFIG.SUBMIT_COOLDOWN then
        task.wait(CONFIG.SUBMIT_COOLDOWN - (now - lastSubmitTime))
    end

    local inputBox = findInputBox()

    if inputBox then
        pcall(function() inputBox:CaptureFocus() end)
        task.wait(0.04)
        inputBox.Text = ""
        task.wait(0.02)

        if CONFIG.NATURAL_TYPE then
            for i = 1, #word do
                inputBox.Text = word:sub(1,i)
                local d = CONFIG.SPEED_MIN + math.random()*(CONFIG.SPEED_MAX-CONFIG.SPEED_MIN)
                task.wait(d)
            end
        else
            inputBox.Text = word
            task.wait(0.05)
        end

        task.wait(0.1)

        if CONFIG.AUTO_SUBMIT then
            local sb = findSubmitBtn()
            if sb then
                -- Klik via event
                pcall(function() sb.MouseButton1Click:Fire() end)
                task.wait(0.03)
                -- Klik via VIM (lebih andal di mobile)
                pcall(function()
                    local cx = sb.AbsolutePosition.X + sb.AbsoluteSize.X/2
                    local cy = sb.AbsolutePosition.Y + sb.AbsoluteSize.Y/2
                    VIM:SendMouseButtonEvent(cx,cy,0,true,game,1)
                    task.wait(0.03)
                    VIM:SendMouseButtonEvent(cx,cy,0,false,game,1)
                end)
            else
                -- Fallback: tekan Enter
                pcall(function()
                    VIM:SendKeyEvent(true,Enum.KeyCode.Return,false,game)
                    task.wait(0.04)
                    VIM:SendKeyEvent(false,Enum.KeyCode.Return,false,game)
                end)
                pcall(function() inputBox.FocusLost:Fire(true) end)
            end
        end

        lastSubmitTime = tick()
        task.delay(0.2, hideKeyboard)
        return true
    else
        -- Fallback keyboard fisik
        pcall(function()
            for i = 1, #word do
                local c = word:sub(i,i):upper()
                local kc = Enum.KeyCode[c]
                if kc then
                    VIM:SendKeyEvent(true,kc,false,game)
                    task.wait(0.02)
                    VIM:SendKeyEvent(false,kc,false,game)
                    task.wait(CONFIG.SPEED_MIN + math.random()*(CONFIG.SPEED_MAX-CONFIG.SPEED_MIN))
                end
            end
            task.wait(0.1)
            VIM:SendKeyEvent(true,Enum.KeyCode.Return,false,game)
            task.wait(0.04)
            VIM:SendKeyEvent(false,Enum.KeyCode.Return,false,game)
        end)
        lastSubmitTime = tick()
        task.delay(0.2, hideKeyboard)
        return true
    end
end

-- ==========================================
-- WARNA GUI
-- ==========================================
local C = {
    bg     = Color3.fromRGB(7,  10,  26),
    panel  = Color3.fromRGB(13, 19,  48),
    card   = Color3.fromRGB(20, 30,  72),
    cardHi = Color3.fromRGB(28, 42,  95),
    accent = Color3.fromRGB(88, 166, 255),
    accent2= Color3.fromRGB(140,210, 255),
    green  = Color3.fromRGB(52, 224, 140),
    red    = Color3.fromRGB(255, 72,  72),
    yellow = Color3.fromRGB(255,208,  48),
    purple = Color3.fromRGB(190,110, 255),
    orange = Color3.fromRGB(255,155,  55),
    text   = Color3.fromRGB(228,242, 255),
    muted  = Color3.fromRGB(95, 135, 205),
    border = Color3.fromRGB(40,  70, 165),
    dark   = Color3.fromRGB(4,   7,  20),
}

-- ==========================================
-- BUILD GUI
-- ==========================================
task.wait(0.2)
if not playerGui or not playerGui.Parent then warn("[SK] playerGui null"); return end

local Gui = Instance.new("ScreenGui", playerGui)
Gui.Name = "SK_YURXZ"; Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true; Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 260, 0, 0)
Main.Position = UDim2.new(0.5,-130,0.5,-200)
Main.BackgroundColor3 = C.bg; Main.BorderSizePixel = 0
Main.AutomaticSize = Enum.AutomaticSize.Y
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = C.accent; mainStroke.Thickness = 1.2; mainStroke.Transparency = 0.2

-- Top gradient bar
local topBar = Instance.new("Frame", Main)
topBar.Size = UDim2.new(1,0,0,3); topBar.BackgroundColor3 = C.accent; topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 2)
local tbarG = Instance.new("UIGradient", topBar)
tbarG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(88, 166,255)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(190,110,255)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(52, 224,140)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,208, 48)),
})

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-14,0,0); Content.Position = UDim2.new(0,7,0,7)
Content.BackgroundTransparency = 1; Content.AutomaticSize = Enum.AutomaticSize.Y
local cL = Instance.new("UIListLayout", Content)
cL.Padding = UDim.new(0,5); cL.SortOrder = Enum.SortOrder.LayoutOrder

-- Header
local hdr = Instance.new("Frame", Content)
hdr.Size = UDim2.new(1,0,0,26); hdr.BackgroundTransparency = 1; hdr.LayoutOrder = 1

local dot = Instance.new("Frame", hdr)
dot.Size = UDim2.new(0,8,0,8); dot.Position = UDim2.new(0,2,0.5,-4)
dot.BackgroundColor3 = C.muted; dot.BorderSizePixel = 0
Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

local hTitle = Instance.new("TextLabel", hdr)
hTitle.Size = UDim2.new(0.6,-14,1,0); hTitle.Position = UDim2.new(0,14,0,0)
hTitle.BackgroundTransparency = 1; hTitle.Text = "SAMBUNG KATA  v9.0"
hTitle.TextColor3 = C.text; hTitle.TextSize = 11; hTitle.Font = Enum.Font.GothamBold
hTitle.TextXAlignment = Enum.TextXAlignment.Left

local hInfo = Instance.new("TextLabel", hdr)
hInfo.Size = UDim2.new(0.4,0,1,0); hInfo.Position = UDim2.new(0.6,0,0,0)
hInfo.BackgroundTransparency = 1; hInfo.Text = "KBBI Valid"
hInfo.TextColor3 = C.purple; hInfo.TextSize = 8; hInfo.Font = Enum.Font.GothamBold
hInfo.TextXAlignment = Enum.TextXAlignment.Right

-- Divider
local div0 = Instance.new("Frame", Content)
div0.Size = UDim2.new(1,0,0,1); div0.BackgroundColor3 = C.border
div0.BackgroundTransparency = 0.5; div0.BorderSizePixel = 0; div0.LayoutOrder = 2

-- Mode Toggle (AUTO / MANUAL)
local modeCard = Instance.new("Frame", Content)
modeCard.Size = UDim2.new(1,0,0,32); modeCard.BackgroundColor3 = C.panel
modeCard.BorderSizePixel = 0; modeCard.LayoutOrder = 3
Instance.new("UICorner", modeCard).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", modeCard).Color = C.border
local modePad = Instance.new("UIPadding", modeCard)
modePad.PaddingLeft = UDim.new(0,6); modePad.PaddingRight = UDim.new(0,6)
modePad.PaddingTop = UDim.new(0,5); modePad.PaddingBottom = UDim.new(0,5)

local modeRow = Instance.new("Frame", modeCard)
modeRow.Size = UDim2.new(1,0,1,0); modeRow.BackgroundTransparency = 1
local modeRL = Instance.new("UIListLayout", modeRow)
modeRL.FillDirection = Enum.FillDirection.Horizontal; modeRL.Padding = UDim.new(0,4)

local modeAutoBtn = Instance.new("TextButton", modeRow)
modeAutoBtn.Size = UDim2.new(0.5,-2,1,0)
modeAutoBtn.BackgroundColor3 = C.accent
modeAutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
modeAutoBtn.Text = "AUTO"; modeAutoBtn.TextSize = 10; modeAutoBtn.Font = Enum.Font.GothamBold
modeAutoBtn.AutoButtonColor = false; modeAutoBtn.BorderSizePixel = 0
Instance.new("UICorner", modeAutoBtn).CornerRadius = UDim.new(0,7)

local modeManBtn = Instance.new("TextButton", modeRow)
modeManBtn.Size = UDim2.new(0.5,-2,1,0)
modeManBtn.BackgroundColor3 = C.cardHi
modeManBtn.TextColor3 = C.muted
modeManBtn.Text = "MANUAL"; modeManBtn.TextSize = 10; modeManBtn.Font = Enum.Font.GothamBold
modeManBtn.AutoButtonColor = false; modeManBtn.BorderSizePixel = 0
Instance.new("UICorner", modeManBtn).CornerRadius = UDim.new(0,7)

-- Info Card (prefix + kata)
local infoCard = Instance.new("Frame", Content)
infoCard.Size = UDim2.new(1,0,0,0); infoCard.BackgroundColor3 = C.panel
infoCard.BorderSizePixel = 0; infoCard.AutomaticSize = Enum.AutomaticSize.Y
infoCard.LayoutOrder = 4
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0,10)
local icStroke = Instance.new("UIStroke", infoCard)
icStroke.Color = C.border; icStroke.Thickness = 1; icStroke.Transparency = 0.3
local icPad = Instance.new("UIPadding", infoCard)
icPad.PaddingLeft = UDim.new(0,10); icPad.PaddingRight = UDim.new(0,10)
icPad.PaddingTop = UDim.new(0,8); icPad.PaddingBottom = UDim.new(0,8)
local icL = Instance.new("UIListLayout", infoCard)
icL.Padding = UDim.new(0,5)

-- Row prefix + kata
local rowHK = Instance.new("Frame", infoCard)
rowHK.Size = UDim2.new(1,0,0,40); rowHK.BackgroundTransparency = 1

local prefixBox = Instance.new("Frame", rowHK)
prefixBox.Size = UDim2.new(0.32,-4,1,0)
prefixBox.BackgroundColor3 = C.card; prefixBox.BorderSizePixel = 0
Instance.new("UICorner", prefixBox).CornerRadius = UDim.new(0,8)
local hbStroke = Instance.new("UIStroke", prefixBox)
hbStroke.Color = C.accent; hbStroke.Thickness = 1; hbStroke.Transparency = 0.5

local prefixLbl = Instance.new("TextLabel", prefixBox)
prefixLbl.Size = UDim2.new(1,0,1,0); prefixLbl.BackgroundTransparency = 1
prefixLbl.Text = "?"; prefixLbl.TextColor3 = C.accent2
prefixLbl.TextSize = 20; prefixLbl.Font = Enum.Font.GothamBold

local kataBox = Instance.new("Frame", rowHK)
kataBox.Size = UDim2.new(0.68,-4,1,0); kataBox.Position = UDim2.new(0.32,4,0,0)
kataBox.BackgroundColor3 = C.card; kataBox.BorderSizePixel = 0
Instance.new("UICorner", kataBox).CornerRadius = UDim.new(0,8)
local kbStroke = Instance.new("UIStroke", kataBox)
kbStroke.Color = C.green; kbStroke.Thickness = 1; kbStroke.Transparency = 0.5

local kataLbl = Instance.new("TextLabel", kataBox)
kataLbl.Size = UDim2.new(1,-10,1,0); kataLbl.Position = UDim2.new(0,8,0,0)
kataLbl.BackgroundTransparency = 1; kataLbl.Text = "..."
kataLbl.TextColor3 = C.green; kataLbl.TextSize = 13; kataLbl.Font = Enum.Font.GothamBold
kataLbl.TextXAlignment = Enum.TextXAlignment.Left
kataLbl.TextTruncate = Enum.TextTruncate.AtEnd

local statusLbl = Instance.new("TextLabel", infoCard)
statusLbl.Size = UDim2.new(1,0,0,12); statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Menunggu..."; statusLbl.TextColor3 = C.muted
statusLbl.TextSize = 9; statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Rekomendasi Card (mode manual)
local rekomCard = Instance.new("Frame", Content)
rekomCard.Size = UDim2.new(1,0,0,0); rekomCard.BackgroundColor3 = C.panel
rekomCard.BorderSizePixel = 0; rekomCard.AutomaticSize = Enum.AutomaticSize.Y
rekomCard.LayoutOrder = 5; rekomCard.Visible = false
Instance.new("UICorner", rekomCard).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", rekomCard).Color = C.border
local rkPad = Instance.new("UIPadding", rekomCard)
rkPad.PaddingLeft = UDim.new(0,8); rkPad.PaddingRight = UDim.new(0,8)
rkPad.PaddingTop = UDim.new(0,8); rkPad.PaddingBottom = UDim.new(0,8)
local rkL = Instance.new("UIListLayout", rekomCard)
rkL.Padding = UDim.new(0,4)

local rkTitle = Instance.new("TextLabel", rekomCard)
rkTitle.Size = UDim2.new(1,0,0,12); rkTitle.BackgroundTransparency = 1
rkTitle.Text = "Pilih kata (klik untuk submit):"; rkTitle.TextColor3 = C.accent2
rkTitle.TextSize = 9; rkTitle.Font = Enum.Font.GothamBold
rkTitle.TextXAlignment = Enum.TextXAlignment.Left

local rkBtnFrame = Instance.new("Frame", rekomCard)
rkBtnFrame.Size = UDim2.new(1,0,0,0); rkBtnFrame.BackgroundTransparency = 1
rkBtnFrame.AutomaticSize = Enum.AutomaticSize.Y
local rkBL = Instance.new("UIListLayout", rkBtnFrame)
rkBL.Padding = UDim.new(0,3)

local rekomBtns = {}
for i = 1, 5 do
    local btn = Instance.new("TextButton", rkBtnFrame)
    btn.Size = UDim2.new(1,0,0,26)
    btn.BackgroundColor3 = C.card
    btn.TextColor3 = C.text
    btn.Text = "-"; btn.TextSize = 10; btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false; btn.BorderSizePixel = 0
    btn.Visible = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", btn).Color = C.border
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.cardHi}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play()
    end)
    rekomBtns[i] = btn
end

-- Custom Akhiran Card
local endingCard = Instance.new("Frame", Content)
endingCard.Size = UDim2.new(1,0,0,0); endingCard.BackgroundColor3 = C.panel
endingCard.BorderSizePixel = 0; endingCard.AutomaticSize = Enum.AutomaticSize.Y
endingCard.LayoutOrder = 6
Instance.new("UICorner", endingCard).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", endingCard).Color = C.border
local epPad = Instance.new("UIPadding", endingCard)
epPad.PaddingLeft = UDim.new(0,10); epPad.PaddingRight = UDim.new(0,10)
epPad.PaddingTop = UDim.new(0,8); epPad.PaddingBottom = UDim.new(0,8)
local epL = Instance.new("UIListLayout", endingCard)
epL.Padding = UDim.new(0,4)

local epTitle = Instance.new("TextLabel", endingCard)
epTitle.Size = UDim2.new(1,0,0,12); epTitle.BackgroundTransparency = 1
epTitle.Text = "Custom Akhiran Terbaik:"; epTitle.TextColor3 = C.accent2
epTitle.TextSize = 9; epTitle.Font = Enum.Font.GothamBold
epTitle.TextXAlignment = Enum.TextXAlignment.Left

local ltFrame = Instance.new("Frame", endingCard)
ltFrame.Size = UDim2.new(1,0,0,0); ltFrame.BackgroundTransparency = 1
ltFrame.AutomaticSize = Enum.AutomaticSize.Y
local ltGrid = Instance.new("UIGridLayout", ltFrame)
ltGrid.CellSize = UDim2.new(0,24,0,20)
ltGrid.CellPadding = UDim2.new(0,3,0,3)

local letterToggles = {}
for i = 1, 26 do
    local ch = string.char(96+i)  -- a=97
    local btn = Instance.new("TextButton", ltFrame)
    btn.BackgroundColor3 = CONFIG.BEST_ENDINGS[ch] and C.green or C.cardHi
    btn.TextColor3 = CONFIG.BEST_ENDINGS[ch] and C.dark or C.muted
    btn.Text = ch:upper(); btn.TextSize = 8; btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)
    letterToggles[ch] = btn
    btn.MouseButton1Click:Connect(function()
        if CONFIG.BEST_ENDINGS[ch] then
            CONFIG.BEST_ENDINGS[ch] = nil
            TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=C.cardHi,TextColor3=C.muted}):Play()
        else
            CONFIG.BEST_ENDINGS[ch] = true
            TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=C.green,TextColor3=C.dark}):Play()
        end
    end)
end

-- Speed + Settings Card
local setCard = Instance.new("Frame", Content)
setCard.Size = UDim2.new(1,0,0,0); setCard.BackgroundColor3 = C.panel
setCard.BorderSizePixel = 0; setCard.AutomaticSize = Enum.AutomaticSize.Y
setCard.LayoutOrder = 7
Instance.new("UICorner", setCard).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", setCard).Color = C.border
local setPad = Instance.new("UIPadding", setCard)
setPad.PaddingLeft = UDim.new(0,10); setPad.PaddingRight = UDim.new(0,10)
setPad.PaddingTop = UDim.new(0,8); setPad.PaddingBottom = UDim.new(0,8)
local setL = Instance.new("UIListLayout", setCard)
setL.Padding = UDim.new(0,5)

local spLbl = Instance.new("TextLabel", setCard)
spLbl.Size = UDim2.new(1,0,0,12); spLbl.BackgroundTransparency = 1
spLbl.Text = "Kecepatan Ketik:"; spLbl.TextColor3 = C.accent2
spLbl.TextSize = 9; spLbl.Font = Enum.Font.GothamBold
spLbl.TextXAlignment = Enum.TextXAlignment.Left

local spRow = Instance.new("Frame", setCard)
spRow.Size = UDim2.new(1,0,0,24); spRow.BackgroundTransparency = 1
local spRL = Instance.new("UIListLayout", spRow)
spRL.FillDirection = Enum.FillDirection.Horizontal; spRL.Padding = UDim.new(0,3)

local speedBtns = {}
for i = 1, 4 do
    local btn = Instance.new("TextButton", spRow)
    btn.Size = UDim2.new(0.25,-3,1,0)
    btn.BackgroundColor3 = i==speedMode and C.yellow or C.cardHi
    btn.TextColor3 = i==speedMode and C.dark or C.muted
    btn.Text = SPEEDS[i].label; btn.TextSize = 8; btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    speedBtns[i] = btn
    btn.MouseButton1Click:Connect(function()
        speedMode = i
        CONFIG.SPEED_MIN = SPEEDS[i].min
        CONFIG.SPEED_MAX = SPEEDS[i].max
        for j,b in ipairs(speedBtns) do
            TweenService:Create(b,TweenInfo.new(0.12),{
                BackgroundColor3 = j==i and C.yellow or C.cardHi,
                TextColor3       = j==i and C.dark   or C.muted,
            }):Play()
        end
    end)
end

-- Toggle row (Natural / AutoSub / HideKB)
local togRow = Instance.new("Frame", setCard)
togRow.Size = UDim2.new(1,0,0,24); togRow.BackgroundTransparency = 1
local togRL = Instance.new("UIListLayout", togRow)
togRL.FillDirection = Enum.FillDirection.Horizontal; togRL.Padding = UDim.new(0,4)

local function mkToggle(parent, label, initVal, onChange)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1/3,-3,1,0)
    frame.BackgroundColor3 = C.cardHi; frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", frame).Color = C.border
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.55,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = label; lbl.TextColor3 = C.text; lbl.TextSize = 7
    lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UIPadding", lbl).PaddingLeft = UDim.new(0,4)
    local tog = Instance.new("TextButton", frame)
    tog.Size = UDim2.new(0,32,0,13); tog.Position = UDim2.new(1,-36,0.5,-6)
    tog.BackgroundColor3 = initVal and C.green or C.card
    tog.TextColor3 = Color3.fromRGB(255,255,255)
    tog.Text = initVal and "ON" or "OFF"
    tog.TextSize = 6; tog.Font = Enum.Font.GothamBold
    tog.AutoButtonColor = false; tog.BorderSizePixel = 0
    Instance.new("UICorner", tog).CornerRadius = UDim.new(0,5)
    local val = initVal
    tog.MouseButton1Click:Connect(function()
        val = not val; onChange(val)
        TweenService:Create(tog,TweenInfo.new(0.12),{BackgroundColor3=val and C.green or C.card}):Play()
        tog.Text = val and "ON" or "OFF"
    end)
end

mkToggle(togRow,"Natural",CONFIG.NATURAL_TYPE,function(v) CONFIG.NATURAL_TYPE=v end)
mkToggle(togRow,"AutoSub",CONFIG.AUTO_SUBMIT,function(v) CONFIG.AUTO_SUBMIT=v end)
mkToggle(togRow,"HideKB",CONFIG.HIDE_KB,function(v) CONFIG.HIDE_KB=v end)

-- START/STOP Button
local actionBtn = Instance.new("TextButton", Content)
actionBtn.Size = UDim2.new(1,0,0,34); actionBtn.LayoutOrder = 8
actionBtn.BackgroundColor3 = C.accent; actionBtn.AutoButtonColor = false
actionBtn.TextColor3 = Color3.fromRGB(255,255,255)
actionBtn.Text = "START"; actionBtn.TextSize = 13; actionBtn.Font = Enum.Font.GothamBold
actionBtn.BorderSizePixel = 0
Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0,10)
local abG = Instance.new("UIGradient", actionBtn)
abG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70,150,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25,90,230)),
})
abG.Rotation = 135

local botPad = Instance.new("Frame", Content)
botPad.Size = UDim2.new(1,0,0,3); botPad.BackgroundTransparency = 1; botPad.LayoutOrder = 9

-- ==========================================
-- MODE TOGGLE LOGIC
-- ==========================================
isAutoMode = true

local function updateModeUI()
    if isAutoMode then
        TweenService:Create(modeAutoBtn,TweenInfo.new(0.15),{BackgroundColor3=C.accent,TextColor3=Color3.fromRGB(255,255,255)}):Play()
        TweenService:Create(modeManBtn,TweenInfo.new(0.15),{BackgroundColor3=C.cardHi,TextColor3=C.muted}):Play()
        rekomCard.Visible = false
    else
        TweenService:Create(modeAutoBtn,TweenInfo.new(0.15),{BackgroundColor3=C.cardHi,TextColor3=C.muted}):Play()
        TweenService:Create(modeManBtn,TweenInfo.new(0.15),{BackgroundColor3=C.orange,TextColor3=C.dark}):Play()
        rekomCard.Visible = true
    end
end
updateModeUI()

modeAutoBtn.MouseButton1Click:Connect(function()
    isAutoMode = true; updateModeUI()
end)
modeManBtn.MouseButton1Click:Connect(function()
    isAutoMode = false; updateModeUI()
end)

-- ==========================================
-- UPDATE REKOMENDASI (mode manual)
-- ==========================================
local function updateRekoms(prefix)
    local tops = findTopWords(prefix, 5)
    for i, btn in ipairs(rekomBtns) do
        if tops[i] then
            btn.Text = tops[i] .. "  (→" .. tops[i]:sub(-1):upper() .. ")"
            btn.Visible = true
            btn.BackgroundColor3 = C.card
            local last = tops[i]:sub(-1):lower()
            -- Warna sesuai kualitas akhiran
            pcall(function()
                local s = btn:FindFirstChildWhichIsA("UIStroke") or Instance.new("UIStroke", btn)
                s.Color = CONFIG.BEST_ENDINGS[last] and C.green
                         or CONFIG.BAD_ENDINGS[last]  and C.red
                         or C.border
            end)
            -- Disconnect koneksi lama
            local connections = btn:GetAttributeChangedSignal("_conn")
            local word = tops[i]
            btn.MouseButton1Click:Connect(function()
                if not isRunning then return end
                usedWords[word] = true
                kataLbl.Text = word
                statusLbl.Text = "Mengirim: " .. word
                statusLbl.TextColor3 = C.green
                lastDetectedWord = word
                lastPrefix = nil  -- reset supaya bisa pick kata berikutnya
                task.spawn(function()
                    submitWord(word)
                end)
            end)
        else
            btn.Visible = false
        end
    end
end

-- ==========================================
-- DRAG
-- ==========================================
local dragging, dragStart, dragPos
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
       inp.UserInputType == Enum.UserInputType.Touch then
        dragging=true; dragStart=inp.Position; dragPos=Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
       inp.UserInputType == Enum.UserInputType.Touch then dragging=false end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or
       inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        Main.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset+d.X,
                                   dragPos.Y.Scale, dragPos.Y.Offset+d.Y)
    end
end)

-- ==========================================
-- DOT PULSE
-- ==========================================
task.spawn(function()
    while Gui.Parent do
        if isRunning then
            TweenService:Create(dot,TweenInfo.new(0.5,Enum.EasingStyle.Sine),{BackgroundColor3=C.green}):Play()
            task.wait(0.5)
            TweenService:Create(dot,TweenInfo.new(0.5,Enum.EasingStyle.Sine),{BackgroundColor3=Color3.fromRGB(30,200,100)}):Play()
            task.wait(0.5)
        else task.wait(0.5) end
    end
end)

-- ==========================================
-- MAIN LOGIC
-- ==========================================
local function setStatus(msg, col)
    statusLbl.Text = msg
    statusLbl.TextColor3 = col or C.muted
end

local function stopAuto()
    isRunning = false
    if autoThread then pcall(function() task.cancel(autoThread) end); autoThread = nil end
    actionBtn.Text = "START"
    abG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70,150,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25,90,230)),
    })
    TweenService:Create(actionBtn,TweenInfo.new(0.2),{BackgroundColor3=C.accent}):Play()
    TweenService:Create(mainStroke,TweenInfo.new(0.3),{Color=C.accent}):Play()
    TweenService:Create(icStroke,TweenInfo.new(0.3),{Color=C.border}):Play()
    TweenService:Create(dot,TweenInfo.new(0.3),{BackgroundColor3=C.muted}):Play()
    setStatus("Dihentikan", C.yellow)
end

local function startAuto()
    isRunning = true
    lastPrefix = nil
    lastDetectedWord = ""

    actionBtn.Text = "STOP"
    abG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(210,35,35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150,10,10)),
    })
    TweenService:Create(actionBtn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(180,22,22)}):Play()
    TweenService:Create(mainStroke,TweenInfo.new(0.3),{Color=C.green}):Play()
    TweenService:Create(icStroke,TweenInfo.new(0.3),{Color=C.green}):Play()
    setStatus("Aktif | Menunggu giliran...", C.green)

    autoThread = task.spawn(function()
        while isRunning do
            task.wait(0.3)
            if not isRunning then break end

            -- Cek delay alert (kena spam penalty dari game)
            if hasDelayAlert() then
                setStatus("⚠ DELAY ALERT! Tunggu...", C.red)
                task.wait(3)
                continue
            end

            -- Ambil prefix saat ini
            local prefix = getCurrentPrefix()
            if not prefix then
                setStatus("Nunggu giliran...", C.muted)
                prefixLbl.Text = "?"
                lastPrefix = nil
                continue
            end

            -- Skip kalau prefix sama dan belum ada perubahan (kata belum dipakai)
            if prefix == lastPrefix and not isWordRejected() then
                continue
            end

            lastPrefix = prefix
            prefixLbl.Text = prefix:upper()
            TweenService:Create(hbStroke,TweenInfo.new(0.15),{Color=C.yellow,Transparency=0}):Play()
            setStatus("Prefix: " .. prefix:upper() .. " | Cari kata...", C.yellow)

            task.wait(0.06 + math.random()*0.1)
            if not isRunning then break end

            if isAutoMode then
                -- MODE AUTO: langsung jawab
                local word = findBestWord(prefix)
                if word then
                    kataLbl.Text = word
                    kataLbl.TextColor3 = C.green
                    TweenService:Create(kbStroke,TweenInfo.new(0.15),{Color=C.green,Transparency=0}):Play()
                    setStatus("Mengetik: " .. word, C.green)
                    submitWord(word)
                    local ak = word:sub(-1):upper()
                    setStatus("✓ " .. word .. "  (→" .. ak .. ")", C.green)
                    TweenService:Create(hbStroke,TweenInfo.new(0.5),{Color=C.accent,Transparency=0.5}):Play()
                    lastDetectedWord = word
                    task.wait(1.0)
                    lastPrefix = nil  -- siap untuk putaran berikut
                else
                    kataLbl.Text = "Tidak ada!"
                    kataLbl.TextColor3 = C.red
                    setStatus("❌ Tidak ada kata: " .. prefix:upper(), C.red)
                    task.wait(0.5)
                    lastPrefix = nil
                end
            else
                -- MODE MANUAL: tampilkan rekomendasi
                updateRekoms(prefix)
                kataLbl.Text = "Pilih di bawah ↓"
                kataLbl.TextColor3 = C.orange
                setStatus("Pilih kata untuk: " .. prefix:upper(), C.orange)

                -- Tunggu user pilih (atau prefix berubah)
                local waitCount = 0
                while isRunning and lastPrefix == prefix do
                    task.wait(0.3)
                    waitCount = waitCount + 1
                    if waitCount > 50 then
                        setStatus("⏰ Timeout! Segera pilih...", C.red)
                    end
                end
                kataLbl.TextColor3 = C.green
            end
        end
    end)
end

actionBtn.MouseButton1Click:Connect(function()
    if isRunning then stopAuto() else startAuto() end
end)

-- ==========================================
-- OPEN ANIMATION
-- ==========================================
Main.BackgroundTransparency = 1
Main.Position = Main.Position - UDim2.new(0,0,0,10)
TweenService:Create(Main, TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
    {BackgroundTransparency=0, Position=Main.Position+UDim2.new(0,0,0,10)}):Play()

-- ==========================================
-- CLEANUP HOOK
-- ==========================================
gset("SK_Stop", function()
    isRunning = false
    if autoThread then pcall(function() task.cancel(autoThread) end) end
    gset("SK_Stop", nil)
end)

print("[SAMBUNG KATA v9.0] Loaded!")
print("[SAMBUNG KATA v9.0] Deteksi: TextLabel 'Word' + TextButton 'Enter' (confirmed)")
print("[SAMBUNG KATA v9.0] AUTO = jawab otomatis | MANUAL = pilih dari 5 rekomendasi")
print("[SAMBUNG KATA v9.0] Fitur: Anti-spam | Natural Type | Custom Akhiran | Speed 4x")
