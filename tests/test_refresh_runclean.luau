--!nocheck
-- Unit test (luau CLI) untuk logika v3.3.0 BloxHubUILibs:
--   1. CLEAN-THREAD DISPATCHER (RunClean) — pola resume/yield sinkron
--   2. Refresh dua gaya panggilan (dot & colon)
-- Kode dispatcher & Refresh disalin PERSIS dari source.lua v3.3.0.

local pass, fail = 0, 0
local function check(name, cond)
	if cond then
		pass = pass + 1
		print("[PASS] " .. name)
	else
		fail = fail + 1
		print("[FAIL] " .. name)
	end
end

-- ═══════════════════════════════════════════════════════════
-- 1. DISPATCHER — disalin persis dari source.lua
-- ═══════════════════════════════════════════════════════════
local __cleanThread = coroutine.create(function(fn, ...)
	local args = table.pack(fn, ...)
	while true do
		if type(args[1]) ~= "function" then
			args = table.pack(function()
				error("RunClean: job bukan fungsi", 0)
			end)
		end
		local results = table.pack(pcall(table.unpack(args, 1, args.n)))
		args = table.pack(coroutine.yield(table.unpack(results, 1, results.n)))
	end
end)

local function RunClean(fn, ...)
	local results = table.pack(coroutine.resume(__cleanThread, fn, ...))
	if not results[1] then
		-- dispatcher mati → jalur lama (perilaku legacy)
		return fn(...)
	end
	if not results[2] then
		-- fn error di dalam: re-raise PESAN ASLI tanpa menambah prefix posisi
		-- baru (level 0) supaya pesan yang ditangkap pcall pemanggil identik
		-- dengan perilaku legacy saat error langsung dari thread pemanggil.
		error(results[3], 0)
	end
	return table.unpack(results, 3, results.n)
end

-- Test: return tunggal
check("dispatcher: return tunggal", RunClean(function() return 42 end) == 42)

-- Test: multi-return
local a, b, c = RunClean(function() return "x", 2, true end)
check("dispatcher: multi-return", a == "x" and b == 2 and c == true)

-- Test: job beruntun (state coroutine bertahan antar resume)
local counter = 0
RunClean(function() counter = counter + 1 end)
RunClean(function(v) counter = counter + v end, 10)
RunClean(function(v) counter = counter + v end, 100)
check("dispatcher: job beruntun (counter=111)", counter == 111)

-- Test: argumen diteruskan
check("dispatcher: argumen diteruskan", RunClean(function(x, y) return x + y end, 3, 4) == 7)

-- Test: error di dalam job → re-raise (pcall pemanggil menangkap)
local ok, err = pcall(function()
	RunClean(function() error("kapten kita karam") end)
end)
check("dispatcher: error re-raise tertangkap", ok == false and tostring(err):find("kapten kita karam") ~= nil)

-- Test: dispatcher MASIH hidup setelah job error (job berikutnya jalan lagi)
local ok2 = RunClean(function() return "hidup" end)
check("dispatcher: tetap hidup setelah error", ok2 == "hidup")

-- Test: error tanpa pesan posisi (level 0)
local ok3, err3 = pcall(function()
	RunClean(function() error("pesan-bersih", 0) end)
end)
check("dispatcher: error level 0 utuh", ok3 == false and err3 == "pesan-bersih")

-- Test: closure over upvalue
local up = { n = 0 }
RunClean(function() up.n = 5 end)
check("dispatcher: mutasi upvalue", up.n == 5)

-- ═══════════════════════════════════════════════════════════
-- 2. REFRESH — body persis dari source.lua (options & createOptions mock)
-- ═══════════════════════════════════════════════════════════
local function makeRow(initialOptions)
	local state = { options = initialOptions, built = 0 }
	local createOptions = function() state.built = state.built + 1 end
	local row = {
		Container = {}, -- row object selalu punya .Container
		GetValue = function() return nil end,
		SetValue = function() end,
		Destroy = function() end,
	}
	-- === Body Refresh persis dari source.lua v3.3.0 ===
	row.Refresh = function(a, b)
		local newOptions = a
		if type(a) == "table" and a.Container ~= nil then
			newOptions = b
		end
		state.options = newOptions or state.options
		RunClean(createOptions)
	end
	return row, state
end

-- Gaya LAMA (dot) — wajib tidak berubah
local r1, s1 = makeRow({ "satu", "dua" })
r1.Refresh({ "x", "y", "z" })
check("refresh dot: opsi diganti", s1.options[1] == "x" and s1.options[3] == "z" and #s1.options == 3)
check("refresh dot: createOptions terpanggil", s1.built == 1)

local r2, s2 = makeRow({ "satu" })
r2.Refresh()
check("refresh dot tanpa arg: opsi tidak berubah", s2.options[1] == "satu" and #s2.options == 1)

local r3, s3 = makeRow({ "satu" })
r3.Refresh({})
check("refresh dot {} (kosong): opsi dikosongkan (semantik lama)", #s3.options == 0)

-- Gaya BARU (colon) — perbaikan bug #1 (RBX-W09)
local r4, s4 = makeRow({ "satu", "dua" })
r4:Refresh({ "alpha", "beta", "gamma" })
check("refresh colon: opsi diganti (BUG FIX)", s4.options[1] == "alpha" and #s4.options == 3)
check("refresh colon: createOptions terpanggil", s4.built == 1)

local r5, s5 = makeRow({ "satu" })
r5:Refresh()
check("refresh colon tanpa arg: opsi tidak berubah (tanpa regresi)", s5.options[1] == "satu" and #s5.options == 1)

local r6, s6 = makeRow({ "satu" })
r6:Refresh({})
check("refresh colon {} (kosong): opsi dikosongkan", #s6.options == 0)

-- Gaya colon dengan daftar panjang (skenario auto-farm: 12 opsi)
local r7, s7 = makeRow({ "lama" })
local big = {}
for i = 1, 12 do big[i] = "opsi" .. i end
r7:Refresh(big)
check("refresh colon: 12 opsi (skenario auto-farm)", #s7.options == 12 and s7.options[12] == "opsi12")

print(string.format("\nHasil: %d pass, %d fail", pass, fail))
if fail > 0 then error("ADA TEST GAGAL") end
print("SEMUA TEST LULUS")
