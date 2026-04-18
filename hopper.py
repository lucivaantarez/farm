#!/usr/bin/env python3
# ================================================
# THE FOOL
# UNIVERSAL ROBLOX HOPPER | @lanavienrose
# ================================================

import os, sys, time, json, subprocess, threading, queue, urllib.request, urllib.error, traceback
from datetime import datetime, timedelta, timezone

VERSION = "4.4"

# ── TIMEZONE (WIB / UTC+7) ────────────────────────
WIB = timezone(timedelta(hours=7))

def wib_now():
    return datetime.now(WIB)

def wib_from_ts(ts):
    return datetime.fromtimestamp(ts, tz=WIB)

# ── ANSI ──────────────────────────────────────────
R   = "\033[0m"
W   = "\033[97m"
G   = "\033[92m"
Y   = "\033[93m"
RD  = "\033[91m"
C   = "\033[96m"
M   = "\033[95m"
GR  = "\033[90m"
DIM = "\033[2m"

# ── PATHS ─────────────────────────────────────────
HOME        = os.path.expanduser("~")
BASE        = os.path.join(HOME, "saturnity")
CONFIG_FILE = os.path.join(BASE, "hopper_config.json")
LOG_FILE    = os.path.join(BASE, "hopper.log")

try:
    os.makedirs(BASE, exist_ok=True)
except: pass

def _find_ps_file():
    candidates = [
        "/sdcard/saturnity/private_servers.txt",
        "/storage/emulated/0/saturnity/private_servers.txt",
        "/sdcard/private_servers.txt",
        "/storage/emulated/0/private_servers.txt",
    ]
    for path in candidates:
        if os.path.exists(path): return path
    return candidates[0]

PS_FILE = _find_ps_file()

# ── LOGGING ───────────────────────────────────────
def log_file(msg):
    try:
        with open(LOG_FILE, "a") as f:
            f.write(f"[{wib_now().strftime('%Y-%m-%d %H:%M:%S')}] {msg}\n")
    except: pass

def log_error(context, e):
    tb = traceback.format_exc()
    try:
        with open(LOG_FILE, "a") as f:
            f.write(f"[{wib_now().strftime('%Y-%m-%d %H:%M:%S')}] [ERROR] {context}: {e}\n{tb}\n")
    except: pass

# ── CONFIGURATION ─────────────────────────────────
DEFAULT_CONFIG = {
    "launch_delay": 5,
    "hop_delay": 2700,
    "heartbeat_delay": 300,
    "launch_detector": 15,
    "cooldown_hop": 600,
    "fail_limit": 5,
    "webhook_url": "",
    "roblox_package": "com.roblox.client",
    "servers": []
}

def load_config():
    try:
        if os.path.exists(CONFIG_FILE):
            with open(CONFIG_FILE) as f:
                cfg = json.load(f)
            for k, v in DEFAULT_CONFIG.items():
                if k not in cfg: cfg[k] = v
            return cfg
    except: pass
    return DEFAULT_CONFIG.copy()

def save_config(cfg):
    try:
        with open(CONFIG_FILE, "w") as f:
            json.dump(cfg, f, indent=2)
    except: pass

# ── ADB ENGINE ────────────────────────────────────
def adb(cmd):
    try:
        r = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=10)
        return r.stdout.strip()
    except: return ""

def kill_roblox(cfg):
    pkg = cfg.get("roblox_package", "com.roblox.client")
    adb(f"am force-stop {pkg}")

def launch_roblox(link, cfg):
    pkg = cfg.get("roblox_package", "com.roblox.client")
    # Universal code parsing to bypass Chrome intent
    if "privateServerLinkCode=" in link:
        code = link.split("privateServerLinkCode=")[-1].split("&")[0]
    else:
        code = link.split("/")[-1]
    
    deeplink = f"roblox://navigation/share_links?code={code}&type=Server"
    
    adb(f"monkey -p {pkg} -c android.intent.category.LAUNCHER 1")
    time.sleep(3)
    adb(f'am start --user 0 -a android.intent.action.VIEW -d "{deeplink}" {pkg}')

# ── UI ENGINE ─────────────────────────────────────
def get_term_width():
    try: return os.get_terminal_size().columns
    except: return 80

def fmt_time(seconds):
    if seconds is None or seconds < 0: return "--:--"
    m, s = divmod(int(seconds), 60)
    h, m = divmod(m, 60)
    if h > 0: return f"{h:02d}:{m:02d}:{s:02d}"
    return f"{m:02d}:{s:02d}"

def banner(cfg=None, ts=None):
    w = get_term_width()
    line = "━" * w
    print(f"{DIM}{line}{R}")
    print(f"{W}")
    print(r"   ████████ ██  ██ ██████   ██████ ██████ ██████ ██     ")
    print(r"      ██    ██  ██ ██       ██     ██  ██ ██  ██ ██     ")
    print(r"      ██    ██████ █████    █████  ██  ██ ██  ██ ██     ")
    print(r"      ██    ██  ██ ██       ██     ██  ██ ██  ██ ██     ")
    print(r"      ██    ██  ██ ██████   ██     ██████ ██████ ██████ ")
    print(f"")
    header = f"   UNIVERSAL ROBLOX HOPPER | @lanavienrose"
    if ts:
        print(f"{GR}{header} | last refresh: {ts}{R}")
    else:
        print(f"{GR}{header}{R}")
    print(f"{DIM}{line}{R}")

def print_status(s_num, total, hop_rem, fails, f_limit, cycle, s_label, refresh_mode):
    ts = wib_now().strftime("%H:%M:%S")
    os.system("clear")
    banner(None, ts)
    
    h_str = fmt_time(hop_rem)
    f_clr = RD if fails > 0 else G
    
    cmds = ["[1] SKIP", "[2] +5MIN", "[3] STOP"]
    if refresh_mode == 3: cmds.insert(0, "[0] STATUS")
    while len(cmds) < 5: cmds.append("")

    col_w = 20
    print(f"\n   ENDPOINT  ::  {W}{str(s_label)[:col_w]:<{col_w}}{R} ┃   {GR}{cmds[0]}{R}")
    print(f"   SEQUENCE  ::  {W}{f'{s_num} / {total}':<{col_w}}{R} ┃   {GR}{cmds[1]}{R}")
    print(f"   PHASE     ::  {W}{str(cycle):<{col_w}}{R} ┃   {GR}{cmds[2]}{R}")
    print(f"   FAULTS    ::  {f_clr}{f'{fails} / {f_limit}':<{col_w}}{R} ┃   {GR}{cmds[3]}{R}")
    print(f"   UPLINK    ::  {W}{h_str:<{col_w}}{R} ┃   {GR}{cmds[4]}{R}")
    print(f"                                ┃")
    print(f"   command > ", end="", flush=True)

def print_cooldown(cycle, rem, resume_time, refresh_mode):
    ts = wib_now().strftime("%H:%M:%S")
    os.system("clear")
    banner(None, ts)
    
    cmds = ["[1] SKIP COOLDOWN", "[2] STOP"]
    if refresh_mode == 3: cmds.insert(0, "[0] STATUS")
    while len(cmds) < 3: cmds.append("")

    col_w = 20
    print(f"\n   STATUS    ::  {W}{f'PHASE {cycle} DONE':<{col_w}}{R} ┃   {GR}{cmds[0]}{R}")
    print(f"   COOLDOWN  ::  {Y}{fmt_time(rem):<{col_w}}{R} ┃   {GR}{cmds[1]}{R}")
    print(f"   RESUME    ::  {W}{resume_time:<{col_w}}{R} ┃   {GR}{cmds[2]}{R}")
    print(f"                                ┃")
    print(f"   command > ", end="", flush=True)

def settings_menu(cfg):
    while True:
        ts = wib_now().strftime("%H:%M:%S")
        os.system("clear")
        banner(None, ts)
        
        col_l = 25
        # Pre-formatting values for alignment
        v1 = f"{cfg['launch_delay']}s"
        v2 = fmt_time(cfg['hop_delay'])
        v3 = f"{cfg['heartbeat_delay']}s"
        v4 = f"{cfg['launch_detector']}s"
        v5 = fmt_time(cfg['cooldown_hop'])
        v6 = str(cfg['fail_limit'])
        
        v7 = "active" if cfg['webhook_url'] else "not set"
        v8 = f"{len(cfg['servers'])} links"
        v9 = "auto"
        vP = cfg['roblox_package']

        print(f"   [ PARAMETERS ]                      ┃   [ MENUS & ACTIONS ]")
        print(f"                                       ┃")
        print(f"   [1] KILL->RELAUNCH GAP :: {v1:<10}┃   [7] SET WEBHOOK        :: {v7}")
        print(f"   [2] TIME PER SERVER    :: {v2:<10}┃   [8] MANAGE SERVERS     :: {v8}")
        print(f"   [3] SERVER JOIN WAIT   :: {v3:<10}┃   [9] ADJUST LAYOUT      :: {v9}")
        print(f"   [4] LOBBY LOAD WAIT    :: {v4:<10}┃   [P] SET ROBLOX PACKAGE :: {vP}")
        print(f"   [5] CYCLE COOLDOWN     :: {v5:<10}┃   [Q] TEST START         ")
        print(f"   [6] ERROR RETRY LIMIT  :: {v6:<10}┃   [T] TEST WEBHOOK       ")
        print(f"                                       ┃   [L] VIEW LOG           ")
        print(f"                                       ┃")
        print(f"                                       ┃   [0] BACK               ")
        print(f"                                       ┃")
        
        try:
            c = input(f"   command > ").strip().lower()
        except: break

        if c == "0": break
        elif c == "1":
            v = input("   Launch Gap (s): "); cfg['launch_delay'] = int(v) if v.isdigit() else cfg['launch_delay']
        elif c == "2":
            v = input("   Time per Server (min): "); cfg['hop_delay'] = int(v)*60 if v.isdigit() else cfg['hop_delay']
        elif c == "5":
            v = input("   Cooldown (min): "); cfg['cooldown_hop'] = int(v)*60 if v.isdigit() else cfg['cooldown_hop']
        elif c == "l": view_log()
        save_config(cfg)

# ── LOGIC LOOPS ───────────────────────────────────
input_queue = queue.Queue()
def input_worker():
    while True:
        try:
            line = sys.stdin.readline().strip()
            if line: input_queue.put(line)
        except: break

def view_log():
    os.system("clear")
    if os.path.exists(LOG_FILE):
        with open(LOG_FILE, "r") as f:
            print(f.read())
    input("\n   Press enter to back...")

def hop_loop(cfg, refresh_mode):
    # Setup worker thread for background inputs
    threading.Thread(target=input_worker, daemon=True).start()
    
    servers = cfg['servers']
    if not servers:
        # Check for file
        path = _find_ps_file()
        if os.path.exists(path):
            with open(path, "r") as f:
                for line in f:
                    if "http" in line: servers.append(line.strip())
    
    if not servers:
        print("   No servers found."); time.sleep(2); return

    cycle = 1
    stop_ref = [False]

    while not stop_ref[0]:
        for idx, link in enumerate(servers):
            if stop_ref[0]: break
            
            s_num = idx + 1
            fails = 0
            s_label = f"Server {s_num}"
            
            while fails < cfg['fail_limit'] and not stop_ref[0]:
                try:
                    # Dashboard while launching
                    print_status(s_num, len(servers), cfg['hop_delay'], fails, cfg['fail_limit'], cycle, s_label, refresh_mode)
                    
                    # Hard Kill -> Wait -> Launch
                    kill_roblox(cfg)
                    time.sleep(cfg['launch_delay'])
                    launch_roblox(link, cfg)
                    
                    # Lobby Wait
                    time.sleep(cfg['launch_detector'])
                    
                    # Joining wait with input check
                    for _ in range(cfg['heartbeat_delay']):
                        time.sleep(1)
                        if not input_queue.empty():
                            ui = input_queue.get()
                            if ui == "1": break # Skip
                            if ui == "3": stop_ref[0] = True; break
                        if stop_ref[0]: break
                    
                    if stop_ref[0]: break

                    # Active Timer
                    hop_end = time.time() + cfg['hop_delay']
                    while time.time() < hop_end and not stop_ref[0]:
                        rem = hop_end - time.time()
                        print_status(s_num, len(servers), rem, fails, cfg['fail_limit'], cycle, s_label, refresh_mode)
                        
                        # Process Inputs
                        time.sleep(1)
                        if not input_queue.empty():
                            ui = input_queue.get()
                            if ui == "1": break # Skip
                            if ui == "2": hop_end += 300 # +5min
                            if ui == "3": stop_ref[0] = True; break
                    
                    kill_roblox(cfg)
                    break
                except:
                    fails += 1
                    log_error("loop", traceback.format_exc())

        if stop_ref[0]: break

        # Cooldown Phase
        cd_end = time.time() + cfg['cooldown_hop']
        resume = wib_from_ts(cd_end).strftime("%H:%M:%S")
        while time.time() < cd_end and not stop_ref[0]:
            rem = cd_end - time.time()
            print_cooldown(cycle, rem, resume, refresh_mode)
            time.sleep(1)
            if not input_queue.empty():
                ui = input_queue.get()
                if ui == "1": break # Skip CD
                if ui == "2": stop_ref[0] = True; break
        
        cycle += 1

def main():
    cfg = load_config()
    while True:
        os.system("clear")
        banner(cfg, wib_now().strftime("%H:%M:%S"))
        print(f"\n   1. Start Hop\n   2. Settings\n   3. Exit\n")
        c = input("   command > ").strip()
        
        if c == "1":
            print(f"\n   Refresh Mode:\n   1. 30s\n   2. 60s\n   3. Manual\n")
            rm = input("   mode > ").strip()
            hop_loop(cfg, int(rm) if rm.isdigit() else 1)
        elif c == "2":
            settings_menu(cfg)
        elif c == "3":
            sys.exit(0)

if __name__ == "__main__":
    main()
