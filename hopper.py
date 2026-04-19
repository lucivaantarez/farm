#!/usr/bin/env python3
# ================================================
# THE FOOL
# UNIVERSAL ROBLOX HOPPER | @lanavienrose
# ================================================

import os, sys, time, json, subprocess, threading, queue, urllib.request, traceback
from datetime import datetime, timedelta, timezone

VERSION = "5.1"

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
GR  = "\033[90m"
DIM = "\033[2m"

# ── PATHS ─────────────────────────────────────────
HOME        = os.path.expanduser("~")
BASE        = os.path.join(HOME, "saturnity")
CONFIG_FILE = os.path.join(BASE, "hopper_config.json")
LOG_FILE    = os.path.join(BASE, "hopper.log")
GITHUB_URL  = "https://raw.githubusercontent.com/lucivaantarez/farm/main/servers.txt"

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

# ── LOGGING & WEBHOOKS ────────────────────────────
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

def send_webhook(cfg, title, desc, color_hex=5131855):
    url = cfg.get("webhook_url", "").strip()
    if not url: return
    embed = {
        "title": title,
        "description": desc,
        "color": color_hex,
        "footer": {"text": f"THE FOOL • {wib_now().strftime('%H:%M:%S')}"}
    }
    def _send():
        try:
            req = urllib.request.Request(url, data=json.dumps({"embeds": [embed]}).encode(),
                                         headers={"Content-Type": "application/json", "User-Agent": "Mozilla/5.0"}, method="POST")
            urllib.request.urlopen(req, timeout=5)
        except: pass
    threading.Thread(target=_send, daemon=True).start()

# ── CONFIGURATION & SERVER RESOLUTION ─────────────
DEFAULT_CONFIG = {
    "launch_delay": 5,
    "hop_delay": 2700,
    "heartbeat_delay": 300,
    "launch_detector": 15,
    "cooldown_hop": 600,
    "fail_limit": 5,
    "term_width": 0,
    "webhook_url": "",
    "roblox_package": "com.roblox.client",
    "server_source": "local",
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

def resolve_servers(cfg):
    source = cfg.get("server_source", "local")
    
    if source == "github":
        try:
            req = urllib.request.Request(GITHUB_URL, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=10) as resp:
                lines = resp.read().decode('utf-8').splitlines()
            links = [line.split("|")[0].strip() for line in lines if "http" in line]
            if links: return links
        except Exception as e:
            log_error("github_fetch", e)
            return [] 
            
    if source == "local":
        path = _find_ps_file()
        file_servers = []
        try:
            if os.path.exists(path):
                with open(path, "r") as f:
                    for line in f:
                        if "http" in line:
                            file_servers.append(line.split("|")[0].strip())
        except Exception as e: log_error("local_fetch", e)
        if file_servers: return file_servers

    return cfg.get("servers", [])

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
    
    # Universal URL Parser Engine
    if "privateServerLinkCode=" in link:
        try:
            place_id = link.split("/games/")[1].split("/")[0]
            code = link.split("privateServerLinkCode=")[-1].split("&")[0]
            deeplink = f"roblox://placeId={place_id}&linkCode={code}"
        except:
            deeplink = link 
    elif "share?code=" in link:
        try:
            code = link.split("share?code=")[-1].split("&")[0]
            deeplink = f"roblox://navigation/share_links?code={code}&type=Server"
        except:
            deeplink = link
    else:
        deeplink = link
        
    adb(f"monkey -p {pkg} -c android.intent.category.LAUNCHER 1")
    time.sleep(3)
    adb(f'am start --user 0 -a android.intent.action.VIEW -d "{deeplink}" {pkg}')

# ── UI ENGINE ─────────────────────────────────────
def get_term_width(cfg=None):
    w = 80
    if cfg and cfg.get("term_width", 0) > 0:
        w = cfg["term_width"]
    else:
        try: w = os.get_terminal_size().columns
        except: pass
    # Enforce minimum width of 64 so the lines never break the ASCII logo
    return max(64, w)

def fmt_time(seconds):
    if seconds is None or seconds < 0: return "--:--"
    m, s = divmod(int(seconds), 60)
    h, m = divmod(m, 60)
    if h > 0: return f"{h:02d}:{m:02d}:{s:02d}"
    return f"{m:02d}:{s:02d}"

def banner(cfg=None, ts=None):
    w = get_term_width(cfg) - 1
    line = "━" * w
    print(f"{DIM}{line}{R}")
    print(f"{G}") 
    print(r"   ████████ ██  ██ ██████   ██████ ██████ ██████ ██     ")
    print(r"      ██    ██  ██ ██       ██     ██  ██ ██  ██ ██     ")
    print(r"      ██    ██████ █████    █████  ██  ██ ██  ██ ██     ")
    print(r"      ██    ██  ██ ██       ██     ██  ██ ██  ██ ██     ")
    print(r"      ██    ██  ██ ██████   ██     ██████ ██████ ██████ ")
    print(f"")
    header = f"   UNIVERSAL ROBLOX HOPPER | @lanavienrose"
    if ts: print(f"{GR}{header} | refresh: {ts}{R}")
    else: print(f"{GR}{header}{R}")
    print(f"{DIM}{line}{R}")

def print_status(cfg, s_num, total, hop_rem, fails, f_limit, cycle, s_label, refresh_mode):
    ts = wib_now().strftime("%H:%M:%S")
    os.system("clear")
    banner(cfg, ts)
    
    h_str = fmt_time(hop_rem)
    f_clr = RD if fails > 0 else G
    
    cmds = ["[1] SKIP", "[2] +5MIN", "[3] STOP"]
    if refresh_mode == 3: cmds.insert(0, "[0] STATUS")
    while len(cmds) < 5: cmds.append("")

    col_w = 16 
    print(f"\n   ENDPOINT :: {W}{str(s_label)[:col_w]:<{col_w}}{R} ┃ {GR}{cmds[0]}{R}")
    print(f"   SEQUENCE :: {W}{f'{s_num}/{total}':<{col_w}}{R} ┃ {GR}{cmds[1]}{R}")
    print(f"   PHASE    :: {W}{str(cycle):<{col_w}}{R} ┃ {GR}{cmds[2]}{R}")
    print(f"   FAULTS   :: {f_clr}{f'{fails}/{f_limit}':<{col_w}}{R} ┃ {GR}{cmds[3]}{R}")
    print(f"   UPLINK   :: {W}{h_str:<{col_w}}{R} ┃ {GR}{cmds[4]}{R}")
    print(f"                                ┃")
    print(f"   command > ", end="", flush=True)

def print_cooldown(cfg, cycle, rem, resume_time, refresh_mode):
    ts = wib_now().strftime("%H:%M:%S")
    os.system("clear")
    banner(cfg, ts)
    
    cmds = ["[1] SKIP COOLDOWN", "[2] STOP"]
    if refresh_mode == 3: cmds.insert(0, "[0] STATUS")
    while len(cmds) < 3: cmds.append("")

    col_w = 16
    print(f"\n   STATUS   :: {W}{f'PHASE {cycle} DONE':<{col_w}}{R} ┃ {GR}{cmds[0]}{R}")
    print(f"   COOLDOWN :: {Y}{fmt_time(rem):<{col_w}}{R} ┃ {GR}{cmds[1]}{R}")
    print(f"   RESUME   :: {W}{resume_time:<{col_w}}{R} ┃ {GR}{cmds[2]}{R}")
    print(f"                                ┃")
    print(f"   command > ", end="", flush=True)

# ── SUB-MENUS ─────────────────────────────────────
def server_manager_menu(cfg):
    while True:
        os.system("clear")
        banner(cfg, wib_now().strftime("%H:%M:%S"))
        servers = resolve_servers(cfg)
        
        src_mode = cfg.get("server_source", "local")
        if src_mode == "github": display_src = f"GitHub ({GITHUB_URL.split('/')[-1]})"
        elif src_mode == "local": display_src = f"Local ({PS_FILE if os.path.exists(PS_FILE) else 'Not Found'})"
        else: display_src = "Internal Config"

        print(f"\n   [ ENDPOINT MANAGER ]")
        print(f"   Loaded: {len(servers)} links")
        print(f"   Source: {display_src}\n")
        
        print(f"   [1] ADD SINGLE LINK")
        print(f"   [2] SWITCH SOURCE")
        if src_mode == "github":
            print(f"   [3] FORCE RE-FETCH")
        print(f"   [0] BACK\n")
        
        try: c = input("   command > ").strip()
        except KeyboardInterrupt: sys.exit(0)
        
        if c == "0": break
        if c == "1":
            link = input("   Paste Server Link: ").strip()
            if link.startswith("http"):
                path = _find_ps_file()
                os.makedirs(os.path.dirname(path), exist_ok=True)
                with open(path, "a") as f: f.write(f"{link}\n")
                print("   [+] Saved to local file."); time.sleep(1)
        if c == "2":
            print("\n   [1] Local File\n   [2] GitHub Repo\n   [3] Internal Config")
            s = input("   select > ").strip()
            if s == "1": cfg["server_source"] = "local"
            elif s == "2": cfg["server_source"] = "github"
            elif s == "3": cfg["server_source"] = "config"
            save_config(cfg)
            print("   [+] Source updated."); time.sleep(1)
        if c == "3" and src_mode == "github":
            print("\n   [~] Re-fetching list from source...")
            resolve_servers(cfg)
            print("   [+] Sync complete."); time.sleep(1)

def view_log():
    os.system("clear")
    if os.path.exists(LOG_FILE):
        with open(LOG_FILE, "r") as f:
            print(f.read())
    try: input("\n   Press enter to back...")
    except KeyboardInterrupt: sys.exit(0)

def settings_menu(cfg):
    while True:
        ts = wib_now().strftime("%H:%M:%S")
        os.system("clear")
        banner(cfg, ts)
        
        actual_servers = resolve_servers(cfg)
        
        v1 = f"{cfg['launch_delay']}s"
        v2 = fmt_time(cfg['hop_delay'])
        v3 = f"{cfg['heartbeat_delay']}s"
        v4 = f"{cfg['launch_detector']}s"
        v5 = fmt_time(cfg['cooldown_hop'])
        v6 = str(cfg['fail_limit'])
        v7 = "active" if cfg['webhook_url'] else "none"
        v8 = f"{len(actual_servers)} links"
        v9 = "auto" if cfg.get('term_width', 0) == 0 else str(cfg['term_width'])
        vP = cfg['roblox_package']

        print(f"   [ PARAMETERS ]              ┃ [ SYSTEM CONTROLS ]")
        print(f"                               ┃")
        print(f"   [1] LAUNCH GAP :: {v1:<9}┃ [7] WEBHOOK :: {v7}")
        print(f"   [2] HOP DELAY  :: {v2:<9}┃ [8] SERVERS :: {v8}")
        print(f"   [3] JOIN WAIT  :: {v3:<9}┃ [9] LAYOUT  :: {v9}")
        print(f"   [4] LOBBY WAIT :: {v4:<9}┃ [P] PACKAGE :: {vP[:12]}")
        print(f"   [5] COOLDOWN   :: {v5:<9}┃ [Q] TEST START")
        print(f"   [6] MAX FAULTS :: {v6:<9}┃ [T] TEST WEBHOOK")
        print(f"                               ┃ [L] VIEW LOG")
        print(f"                               ┃")
        print(f"                               ┃ [0] BACK")
        
        try:
            c = input(f"   command > ").strip().lower()
        except KeyboardInterrupt:
            sys.exit(0)
        except: break

        if c == "0": break
        elif c == "1":
            v = input("   Launch Gap (s): "); cfg['launch_delay'] = int(v) if v.isdigit() else cfg['launch_delay']
        elif c == "2":
            v = input("   Time per Server (min): "); cfg['hop_delay'] = int(v)*60 if v.isdigit() else cfg['hop_delay']
        elif c == "3":
            v = input("   Server Join Wait (s): "); cfg['heartbeat_delay'] = int(v) if v.isdigit() else cfg['heartbeat_delay']
        elif c == "4":
            v = input("   Lobby Load Wait (s): "); cfg['launch_detector'] = int(v) if v.isdigit() else cfg['launch_detector']
        elif c == "5":
            v = input("   Cooldown (min): "); cfg['cooldown_hop'] = int(v)*60 if v.isdigit() else cfg['cooldown_hop']
        elif c == "6":
            v = input("   Error Retry Limit: "); cfg['fail_limit'] = int(v) if v.isdigit() else cfg['fail_limit']
        elif c == "7":
            cfg['webhook_url'] = input("   Webhook URL (leave blank to disable): ").strip()
        elif c == "8":
            server_manager_menu(cfg)
        elif c == "9":
            v = input("   Terminal Width (e.g. 80, 0 for auto): "); cfg['term_width'] = int(v) if v.isdigit() else cfg.get('term_width', 0)
        elif c == "p":
            cfg['roblox_package'] = input("   Roblox Package: ").strip() or cfg['roblox_package']
        elif c == "q":
            print("\n   [~] Testing App Launch...")
            launch_roblox("test", cfg); time.sleep(5); kill_roblox(cfg); print("   [+] Done."); time.sleep(1)
        elif c == "t":
            print("\n   [~] Sending Test Webhook...")
            send_webhook(cfg, "Test Webhook", "THE FOOL Architecture is Online.", 5685178); time.sleep(1)
        elif c == "l":
            view_log()
        
        save_config(cfg)

# ── LOGIC LOOPS ───────────────────────────────────
input_queue = queue.Queue()
def input_worker():
    while True:
        try:
            line = sys.stdin.readline().strip()
            if line: input_queue.put(line)
        except: break

def hop_loop(cfg, refresh_mode):
    threading.Thread(target=input_worker, daemon=True).start()
    
    cycle = 1
    stop_ref = [False]

    while not stop_ref[0]:
        
        servers = resolve_servers(cfg)
        if not servers:
            print("\n   [!] No servers found. Waiting 10s before retry..."); time.sleep(10); continue

        for idx, link in enumerate(servers):
            if stop_ref[0]: break
            s_num = idx + 1
            fails = 0
            s_label = f"Server {s_num}"
            
            while fails < cfg['fail_limit'] and not stop_ref[0]:
                try:
                    print_status(cfg, s_num, len(servers), cfg['hop_delay'], fails, cfg['fail_limit'], cycle, s_label, refresh_mode)
                    
                    kill_roblox(cfg)
                    time.sleep(cfg['launch_delay'])
                    launch_roblox(link, cfg)
                    time.sleep(cfg['launch_detector'])
                    
                    for _ in range(cfg['heartbeat_delay']):
                        time.sleep(1)
                        if not input_queue.empty():
                            ui = input_queue.get()
                            if ui == "1": break 
                            if ui == "3": stop_ref[0] = True; break
                        if stop_ref[0]: break
                    
                    if stop_ref[0]: break

                    send_webhook(cfg, "Endpoint Uplink Established", f"Connected to {s_label} ({s_num}/{len(servers)})", 3720406)

                    hop_end = time.time() + cfg['hop_delay']
                    while time.time() < hop_end and not stop_ref[0]:
                        rem = hop_end - time.time()
                        print_status(cfg, s_num, len(servers), rem, fails, cfg['fail_limit'], cycle, s_label, refresh_mode)
                        
                        time.sleep(1)
                        if not input_queue.empty():
                            ui = input_queue.get()
                            if ui == "1": break 
                            if ui == "2": hop_end += 300 
                            if ui == "3": stop_ref[0] = True; break
                    
                    kill_roblox(cfg)
                    break
                except KeyboardInterrupt:
                    print("\n   [!] Terminated by user."); sys.exit(0)
                except Exception as e:
                    fails += 1
                    log_error("loop", traceback.format_exc())

        if stop_ref[0]: break

        cd_end = time.time() + cfg['cooldown_hop']
        resume = wib_from_ts(cd_end).strftime("%H:%M:%S")
        while time.time() < cd_end and not stop_ref[0]:
            rem = cd_end - time.time()
            print_cooldown(cfg, cycle, rem, resume, refresh_mode)
            time.sleep(1)
            if not input_queue.empty():
                ui = input_queue.get()
                if ui == "1": break 
                if ui == "2": stop_ref[0] = True; break
        
        cycle += 1

def main():
    cfg = load_config()
    while True:
        os.system("clear")
        banner(cfg, wib_now().strftime("%H:%M:%S"))
        print(f"\n   1. Start Hop\n   2. Settings\n   3. Exit\n")
        try: c = input("   command > ").strip()
        except KeyboardInterrupt: sys.exit(0)
        except EOFError: break
            
        if c == "1":
            print(f"\n   Refresh Mode:\n   1. 30s\n   2. 60s\n   3. Manual\n")
            try: rm = input("   mode > ").strip()
            except KeyboardInterrupt: sys.exit(0)
            hop_loop(cfg, int(rm) if rm.isdigit() else 1)
        elif c == "2":
            settings_menu(cfg)
        elif c == "3":
            sys.exit(0)

if __name__ == "__main__":
    try: main()
    except KeyboardInterrupt: sys.exit(0)
