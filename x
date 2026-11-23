<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<title>ZERØ GAP</title>
<meta name="description" content="Covert-ops task command: ops board, notes, schedule and focus timer. Works offline.">
<meta name="theme-color" content="#0b0e13">
<meta name="color-scheme" content="dark">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" type="image/png" href="icons/icon-192.png">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="ZERØ GAP">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<style>:root{color-scheme:light;box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}html{scroll-padding-top:env(safe-area-inset-top,0px)}body{margin:0;padding:0;font:14px -apple-system,BlinkMacSystemFont,sans-serif;background:#fff;color:#000}img{max-width:100%}[hidden]:not([hidden=until-found i]){display:none!important}</style>
</head>
<body>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Oxanium:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600;700&display=swap">
<style>
/* Layout: covert-ops console. Classification strip + sticky command header, one station at a time
   (HQ / OPS / INFIL / LEDGER), station bar at the bottom on phones, full-screen op window for the timer.
   Deliberately single-theme: a calm night console (muted color, legible type). */
:root{
  color-scheme: dark;
  --ink:#0b0e13; --panel:#11151b; --panel-2:#161b22;
  --line:#232a33; --line-2:#323b46;
  --bone:#e6e8ec; --dim:#9aa3ad; --mute:#6b7480;
  --hud:#4cc9b0; --hud-ink:#04140f; --hud-dim:rgba(76,201,176,.12);
  --t0:#9aa3ad; --t1:#ec6a72; --t2:#e3a857; --t3:#7ea6e6; --t4:#ad94e8;
  --classif:#2a1418; --classif-ink:#e8b9bf;
  --f-display:"Oxanium", "IBM Plex Sans", "Segoe UI", sans-serif;
  --f-ui:"IBM Plex Sans", "Segoe UI", system-ui, sans-serif;
  --f-mono:"IBM Plex Mono", ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
}
*,*::before,*::after{box-sizing:border-box}
html{background:var(--ink);-webkit-text-size-adjust:100%}
body{background:var(--ink);color:var(--bone);font-family:var(--f-ui);font-size:15px;line-height:1.45;-webkit-font-smoothing:antialiased}
body.locked{overflow:hidden}
body::before{content:"";position:fixed;inset:0 0 auto;height:env(safe-area-inset-top,0px);z-index:45;background:var(--classif)}
::selection{background:var(--hud);color:var(--hud-ink)}
:focus-visible{outline:2px solid var(--hud);outline-offset:2px}
button{font:inherit;color:inherit;background:none;border:0;padding:0;cursor:pointer;-webkit-tap-highlight-color:transparent}
button:disabled{cursor:not-allowed;opacity:.42}
input,select,textarea{font:inherit;color:var(--bone)}
h1,h2,h3,p{margin:0}
a{color:var(--hud)}
.sr{position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0 0 0 0);white-space:nowrap}
.dim{color:var(--dim)}
.small{font-size:12px}
.row{display:flex;flex-wrap:wrap;gap:8px;align-items:center}
.row.end{justify-content:flex-end}
.wide{width:100%}
.blink{animation:pulse 1.3s ease-in-out infinite}

/* atmosphere */
.fx-grid{position:fixed;inset:0;z-index:0;pointer-events:none;background:
  radial-gradient(120% 70% at 50% -10%, rgba(76,201,176,.08), transparent 60%),
  radial-gradient(80% 60% at 100% 110%, rgba(236,106,114,.05), transparent 60%),
  linear-gradient(rgba(76,201,176,.032) 1px, transparent 1px) 0 0/28px 28px,
  linear-gradient(90deg, rgba(76,201,176,.032) 1px, transparent 1px) 0 0/28px 28px}
.fx-scan{position:fixed;inset:0;z-index:90;pointer-events:none;background:repeating-linear-gradient(to bottom, rgba(0,0,0,.22) 0 1px, transparent 1px 3px);opacity:.3}

.wrap{width:100%;max-width:1180px;margin-inline:auto;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px))}
#app{position:relative;z-index:1;min-height:100%;overflow-x:clip;padding-bottom:calc(92px + env(safe-area-inset-bottom,0px))}
body.has-mini #app{padding-bottom:calc(156px + env(safe-area-inset-bottom,0px))}

/* command header */
.cmd{position:sticky;top:env(safe-area-inset-top,0px);z-index:30;background:rgba(7,9,12,.9);border-bottom:1px solid var(--line);-webkit-backdrop-filter:blur(10px);backdrop-filter:blur(10px)}
.classif{background:var(--classif);color:var(--classif-ink)}
.classif .wrap{display:flex;justify-content:center;gap:10px;font:600 9.5px/1 var(--f-mono);letter-spacing:.26em;text-transform:uppercase;padding-block:5px;white-space:nowrap;overflow:hidden}
.cmd-row{display:flex;align-items:center;gap:12px;padding-block:9px;min-height:58px}
.brand{display:flex;align-items:center;gap:10px;min-width:0;text-decoration:none;color:inherit}
.brand svg{flex:none}
.brand-name{font-family:var(--f-display);font-size:23px;line-height:1;letter-spacing:.03em;white-space:nowrap;animation:glitch .7s steps(3) both}
.brand-name i{font-style:normal;color:var(--hud)}
.brand-sub{font:500 9px/1 var(--f-mono);letter-spacing:.24em;color:var(--dim);margin-top:4px;white-space:nowrap}
.cmd-right{margin-left:auto;display:flex;align-items:center;gap:6px}
.dtg{font:500 10.5px/1.35 var(--f-mono);letter-spacing:.08em;color:var(--dim);text-align:right;margin-right:6px;font-variant-numeric:tabular-nums}
.dtg b{display:block;color:var(--bone);font-weight:500}
.ibtn{width:40px;height:40px;display:grid;place-items:center;box-shadow:inset 0 0 0 1px var(--line);color:var(--dim);font:700 14px/1 var(--f-mono)}
.ibtn:hover{color:var(--bone);box-shadow:inset 0 0 0 1px var(--line-2)}
.ibtn svg{width:18px;height:18px}
.tabs-top{display:none}
.tab{position:relative;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:5px;min-height:54px;padding:9px 4px 10px;font:600 10px/1 var(--f-mono);letter-spacing:.18em;color:var(--dim);text-decoration:none}
.tab svg{width:20px;height:20px}
.tab:hover{color:var(--bone)}
.tab[aria-current="page"]{color:var(--hud)}
.tab[aria-current="page"]::after{content:"";position:absolute;left:50%;top:0;width:30px;height:2px;margin-left:-15px;background:var(--hud);box-shadow:0 0 12px var(--hud)}
.tab-n{position:absolute;top:6px;left:calc(50% + 6px);min-width:17px;height:17px;padding:0 4px;background:var(--t2);color:#1b1100;font:700 9.5px/17px var(--f-mono);letter-spacing:0;text-align:center}
.tabs-bottom{position:fixed;left:0;right:0;bottom:0;z-index:35;display:grid;grid-template-columns:repeat(4,1fr);background:rgba(7,9,12,.96);border-top:1px solid var(--line);padding-bottom:env(safe-area-inset-bottom,0px);padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px));-webkit-backdrop-filter:blur(10px);backdrop-filter:blur(10px)}
@media (min-width:900px){
  .tabs-top{display:flex;gap:4px;margin-left:24px;align-self:stretch}
  .tabs-top .tab{flex-direction:row;gap:8px;min-height:0;padding:0 14px;font-size:11px}
  .tabs-top .tab[aria-current="page"]::after{top:auto;bottom:-10px;left:0;width:100%;margin:0}
  .tabs-top .tab-n{position:static;margin-left:2px}
  .tabs-bottom{display:none}
  #app{padding-bottom:56px}
  body.has-mini #app{padding-bottom:110px}
}
@media (max-width:540px){.dtg{display:none}.brand-sub{display:none}}

.banner{background:rgba(227,168,87,.07);border-bottom:1px solid rgba(227,168,87,.25);color:var(--t2)}
.banner .wrap{padding-block:8px;font:600 10.5px/1.45 var(--f-mono);letter-spacing:.1em}

/* stations */
main{padding-block:20px 8px}
.view{display:grid;gap:16px}
.vhead{display:flex;flex-wrap:wrap;align-items:flex-end;gap:12px 20px;padding-block:4px 2px}
.vhead-t{min-width:0;flex:1 1 320px}
.eyebrow{font:600 10px/1 var(--f-mono);letter-spacing:.26em;color:var(--hud);text-transform:uppercase}
.vt{font-family:var(--f-display);font-size:clamp(32px,6.5vw,46px);line-height:.95;letter-spacing:.02em;margin-top:8px;text-wrap:balance}
.vsub{color:var(--dim);margin-top:8px;max-width:62ch;text-wrap:pretty}
.vhead-a{display:flex;flex-wrap:wrap;gap:8px}
.hint{color:var(--dim);font-size:13px;margin-top:12px;max-width:62ch}

.panel{position:relative;background:linear-gradient(180deg,rgba(19,25,32,.94),rgba(11,15,20,.94));border:1px solid var(--line);padding:16px;min-width:0}
.panel.frame::before,.panel.frame::after{content:"";position:absolute;width:12px;height:12px;pointer-events:none}
.panel.frame::before{top:-1px;left:-1px;border-top:2px solid var(--hud);border-left:2px solid var(--hud)}
.panel.frame::after{bottom:-1px;right:-1px;border-bottom:2px solid var(--hud);border-right:2px solid var(--hud)}
.ph{display:flex;align-items:center;gap:10px;margin-bottom:12px;min-height:20px}
.ph-t{font:600 10.5px/1.3 var(--f-mono);letter-spacing:.22em;color:var(--dim);text-transform:uppercase;display:flex;align-items:center;gap:8px}
.ph-t::before{content:"";flex:none;width:6px;height:6px;background:var(--hud);box-shadow:0 0 8px var(--hud)}
.ph-m{margin-left:auto;font:500 10.5px/1.25 var(--f-mono);letter-spacing:.08em;color:var(--mute);text-align:right}
.lbl{font:600 9.5px/1 var(--f-mono);letter-spacing:.24em;color:var(--mute);text-transform:uppercase}

/* controls */
.btn{--c:var(--bone);display:inline-flex;align-items:center;justify-content:center;gap:8px;min-height:44px;padding:0 16px;font:600 12.5px/1 var(--f-ui);letter-spacing:.14em;text-transform:uppercase;text-decoration:none;color:var(--c);background:rgba(255,255,255,.025);box-shadow:inset 0 0 0 1px var(--line-2);clip-path:polygon(0 0,calc(100% - 10px) 0,100% 10px,100% 100%,10px 100%,0 calc(100% - 10px));transition:background .15s,box-shadow .15s,color .15s,transform .08s}
.btn:hover{background:rgba(255,255,255,.06);box-shadow:inset 0 0 0 1px var(--c)}
.btn:active{transform:translateY(1px)}
.btn:focus-visible{outline:none;background:rgba(76,201,176,.12);box-shadow:inset 0 0 0 2px var(--hud)}
.btn.amber{--c:var(--t2);box-shadow:inset 0 0 0 1px rgba(227,168,87,.55)}
.btn.hud{--c:var(--hud);box-shadow:inset 0 0 0 1px rgba(76,201,176,.5)}
.btn.solid{background:var(--hud);color:var(--hud-ink);box-shadow:none}
.btn.solid:hover{background:#6fdcc6}
.btn.danger{--c:var(--t1);box-shadow:inset 0 0 0 1px rgba(236,106,114,.55)}
.btn.sm{min-height:36px;padding:0 12px;font-size:11px;letter-spacing:.12em;clip-path:polygon(0 0,calc(100% - 7px) 0,100% 7px,100% 100%,7px 100%,0 calc(100% - 7px))}
.link{display:inline-flex;align-items:center;min-height:36px;font:600 10.5px/1 var(--f-mono);letter-spacing:.16em;color:var(--hud);text-transform:uppercase;text-decoration:none}
.link:hover{text-decoration:underline;text-underline-offset:3px}
.link.danger{color:var(--t1)}
.deploy-btn .dl{min-width:0}
.deploy-btn{position:relative;flex:1 1 auto;min-width:0;width:100%;display:flex;align-items:center;justify-content:space-between;gap:12px;min-height:80px;padding:0 28px 0 22px;background:var(--hud);color:var(--hud-ink);clip-path:polygon(0 0,calc(100% - 16px) 0,100% 16px,100% 100%,16px 100%,0 calc(100% - 16px));overflow:hidden;text-align:left}
.deploy-btn .dl{font-family:var(--f-display);font-size:30px;line-height:1;letter-spacing:.04em}
.deploy-btn .dt{flex:none;font:700 20px/1 var(--f-mono);white-space:nowrap}
.deploy-btn::after{content:"";position:absolute;inset:0;background:linear-gradient(105deg,transparent 35%,rgba(255,255,255,.45) 50%,transparent 65%);transform:translateX(-120%);transition:transform .6s}
.deploy-btn:hover::after{transform:translateX(120%)}
.deploy-btn:focus-visible{outline:none;box-shadow:inset 0 0 0 3px var(--hud-ink);filter:brightness(1.08)}
.deploy-btn:disabled{filter:grayscale(1);opacity:.45}
.seg{display:inline-flex;flex-wrap:wrap;box-shadow:inset 0 0 0 1px var(--line-2)}
.seg button{min-width:46px;min-height:44px;padding:0 12px;font:700 13px/1 var(--f-mono);color:var(--dim)}
.seg button:hover{color:var(--bone)}
.seg button[aria-checked="true"]{background:var(--hud-dim);color:var(--hud);box-shadow:inset 0 0 0 1px var(--hud)}
.seg.v{flex-direction:column;flex:none}
.seg.v button{min-height:40px;min-width:56px}
.inp{width:100%;min-height:46px;padding:0 14px;background:rgba(0,0,0,.35);border:1px solid var(--line-2);border-radius:0;color:var(--bone);font:500 15px/1.2 var(--f-ui);outline:none;-webkit-appearance:none;appearance:none}
.inp:focus{border-color:var(--hud);box-shadow:0 0 0 3px rgba(76,201,176,.12)}
.inp::placeholder{color:var(--mute)}
.inp.big{font:700 22px/1 var(--f-mono);letter-spacing:.08em;text-transform:uppercase;min-height:56px}
textarea.inp{padding:12px 14px;min-height:190px;resize:vertical;line-height:1.55}
select.inp{padding-right:38px;background-image:linear-gradient(45deg,transparent 50%,var(--dim) 50%),linear-gradient(135deg,var(--dim) 50%,transparent 50%);background-position:calc(100% - 20px) 50%,calc(100% - 14px) 50%;background-size:6px 6px;background-repeat:no-repeat}
option,optgroup{background:#0d1116;color:var(--bone)}
.field{display:grid;gap:7px;min-width:0}
.field>span,.field>label{font:600 9.5px/1.2 var(--f-mono);letter-spacing:.22em;color:var(--mute);text-transform:uppercase}
.chips{display:flex;flex-wrap:wrap;gap:6px}
.chipbtn{display:inline-flex;align-items:center;gap:6px;min-height:36px;padding:0 11px;font:700 10.5px/1 var(--f-mono);letter-spacing:.14em;color:var(--tc,var(--dim));box-shadow:inset 0 0 0 1px var(--line-2)}
.chipbtn:hover{box-shadow:inset 0 0 0 1px var(--tc,var(--bone))}
.chipbtn[aria-pressed="true"]{background:var(--tc,var(--hud));color:var(--ink);box-shadow:none}
.chipbtn.num{min-width:40px;justify-content:center;color:var(--bone)}
.chipbtn.num[aria-pressed="true"]{background:var(--hud);color:var(--hud-ink)}

.t0{--tc:var(--t0)}.t1{--tc:var(--t1)}.t2{--tc:var(--t2)}.t3{--tc:var(--t3)}.t4{--tc:var(--t4)}
.chip{display:inline-flex;align-items:center;gap:6px;font:700 10px/1 var(--f-mono);letter-spacing:.16em;color:var(--tc,var(--dim));padding:5px 7px;box-shadow:inset 0 0 0 1px currentColor;white-space:nowrap}
.opcode{font:700 10.5px/1.25 var(--f-mono);letter-spacing:.14em;color:var(--tc,var(--dim));text-transform:uppercase;overflow-wrap:anywhere}
.optitle{font:600 18px/1.28 var(--f-ui);color:var(--bone);overflow-wrap:anywhere;text-wrap:pretty}
.opmeta{display:flex;flex-wrap:wrap;align-items:center;gap:6px 12px;font:500 10.5px/1 var(--f-mono);letter-spacing:.1em;color:var(--dim)}
.opmeta .good{color:var(--hud)}
.res{display:inline-flex;align-items:flex-end;gap:6px}
.res .bars{display:inline-flex;align-items:flex-end;gap:2px}
.res i{display:block;width:4px;background:var(--line-2)}
.res i:nth-child(1){height:5px}.res i:nth-child(2){height:7px}.res i:nth-child(3){height:9px}.res i:nth-child(4){height:11px}.res i:nth-child(5){height:13px}
.res i.on{background:var(--bone)}
.due-hot{color:var(--t1)}.due-warm{color:var(--t2)}

/* HQ */
.hq{display:grid;gap:16px;grid-template-columns:minmax(0,1fr)}
@media (min-width:900px){
  .hq{grid-template-columns:minmax(0,1.12fr) minmax(0,.88fr);grid-template-areas:"agent today" "deploy feed" "deploy intel" "deploy manual";align-items:start}
  .a-agent{grid-area:agent}.a-deploy{grid-area:deploy}.a-today{grid-area:today}.a-feed{grid-area:feed}.a-intel{grid-area:intel}.a-manual{grid-area:manual}
}
.feed-st{display:flex;flex-wrap:wrap;align-items:center;gap:6px 12px;font:600 10.5px/1.4 var(--f-mono);letter-spacing:.1em;color:var(--dim)}
.feed-st .live{color:var(--hud)}
.feed-st .live::before{content:"● "}
.feed-st .warn{color:var(--t2)}
.feed-msg{font-size:13.5px;color:var(--dim);margin-top:8px;max-width:60ch}
.feed-acts{display:flex;flex-wrap:wrap;gap:8px;margin-top:12px}
.dl-list{list-style:none;margin:12px 0 0;padding:0;display:grid;gap:6px}
.dl-list li{display:grid;grid-template-columns:auto minmax(0,1fr);gap:4px 10px;align-items:center;padding:9px 11px;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.dl-when{min-width:86px;font:700 10.5px/1 var(--f-mono);letter-spacing:.1em;color:var(--tc);white-space:nowrap}
.dl-t{min-width:0;font-size:13.5px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.cchip{display:inline-flex;align-items:center;padding:4px 6px;font:700 9.5px/1 var(--f-mono);letter-spacing:.12em;color:var(--bone);background:rgba(255,255,255,.06);box-shadow:inset 0 0 0 1px var(--line-2);white-space:nowrap}
.dl-t .cchip{margin-right:6px}
.courses{display:flex;flex-wrap:wrap;align-items:center;gap:6px;margin-top:12px}
.courses .lbl{margin-right:4px}
.courses button.cchip:hover{box-shadow:inset 0 0 0 1px var(--hud)}
.crs-edit{display:flex;flex-wrap:wrap;gap:6px;margin-top:8px}
.crs-edit .inp{flex:1 1 160px;min-height:40px}
.hz{display:flex;flex-wrap:wrap;align-items:center;gap:8px;margin-top:12px}
.hz .seg button{min-height:36px;min-width:44px;font-size:12px}
.steps{margin:10px 0 0;padding-left:20px;display:grid;gap:4px;color:var(--dim);font-size:13.5px}
.srcnote{font:500 10.5px/1.4 var(--f-mono);letter-spacing:.06em;color:var(--dim)}
.agent{display:grid;grid-template-columns:auto minmax(0,1fr);gap:14px 16px;align-items:start}
.agent-emb{width:76px;height:76px;display:grid;place-items:center;background:rgba(76,201,176,.05);box-shadow:inset 0 0 0 1px var(--line-2)}
.agent-emb svg{width:58px;height:58px}
.agent-main{min-width:0}
.callsign{font-family:var(--f-display);font-size:clamp(30px,7vw,42px);line-height:1;letter-spacing:.03em;margin-top:6px;overflow-wrap:anywhere}
.rankline{display:flex;flex-wrap:wrap;gap:6px 12px;align-items:center;margin-top:8px}
.rank{font:700 13px/1 var(--f-ui);letter-spacing:.16em;color:var(--hud)}
.clr{font:500 10.5px/1.4 var(--f-mono);letter-spacing:.12em;color:var(--dim)}
.xp{grid-column:1/-1}
.xpbar{display:grid;grid-template-columns:repeat(24,1fr);gap:3px;height:10px}
.xpbar i{display:block;background:var(--line)}
.xpbar i.on{background:var(--hud);box-shadow:0 0 6px rgba(76,201,176,.55)}
.xpmeta{display:flex;flex-wrap:wrap;justify-content:space-between;gap:4px 10px;margin-top:8px;font:500 11px/1.25 var(--f-mono);letter-spacing:.06em;color:var(--dim)}
.xpmeta b{color:var(--bone);font-weight:700}
.astats{grid-column:1/-1;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;border-top:1px dashed var(--line-2);padding-top:12px;margin:2px 0 0}
.astats dt{font:600 9px/1 var(--f-mono);letter-spacing:.2em;color:var(--mute)}
.astats dd{margin:6px 0 0;font:700 14px/1 var(--f-mono);color:var(--bone);font-variant-numeric:tabular-nums;white-space:nowrap}
.nextop{display:grid;gap:7px;padding:13px 14px;margin-bottom:14px;background:rgba(0,0,0,.28);box-shadow:inset 0 0 0 1px var(--line)}
.nextop .why{font:500 11px/1.4 var(--f-mono);color:var(--hud);letter-spacing:.04em}
.nextop.empty .btn{margin-top:4px}
.deployrow{display:flex;gap:10px;align-items:stretch}
.deployalt{display:flex;flex-wrap:wrap;gap:8px;margin-top:12px}
.deployalt .btn{flex:1 1 210px}
.routebar{display:flex;flex-wrap:wrap;align-items:center;gap:8px 10px;padding:10px 12px;margin-bottom:12px;box-shadow:inset 0 0 0 1px rgba(227,168,87,.45);background:rgba(227,168,87,.06);color:var(--bone);text-decoration:none}
.routebar .rb-t{flex:1 1 180px;min-width:0;font-size:13.5px}
.routebar .rb-t b{font:700 11px/1 var(--f-mono);letter-spacing:.12em;color:var(--t2);margin-right:6px}
.routebar .rb-go{font:700 10.5px/1 var(--f-mono);letter-spacing:.14em;color:var(--t2)}
.tcount{display:flex;align-items:baseline;flex-wrap:wrap;gap:10px;margin-bottom:12px}
.tcount .big{font-family:var(--f-display);font-size:52px;line-height:.9}
.tcount .of{font:600 20px/1 var(--f-mono);color:var(--dim)}
.tcount .cap{margin-left:auto;font:600 10.5px/1.3 var(--f-mono);letter-spacing:.1em;color:var(--hud)}
.cells{display:flex;flex-wrap:wrap;gap:5px}
.cell{position:relative;display:block;width:22px;height:22px;background:var(--tc);box-shadow:0 0 8px -1px var(--tc)}
.cell.ten::after{content:"";position:absolute;inset:6px;background:rgba(0,0,0,.4)}
.cell.empty{background:transparent;box-shadow:inset 0 0 0 1px var(--line-2);background-image:repeating-linear-gradient(45deg,transparent 0 4px,rgba(255,255,255,.035) 4px 5px)}
.cell.new{animation:cellIn .9s cubic-bezier(.2,.9,.3,1.3) .35s both}
.cells.sm{gap:4px}
.cells.sm .cell{width:14px;height:14px;box-shadow:0 0 5px -1px var(--tc)}
.cells.sm .cell.ten::after{inset:4px}
.intel{display:grid;gap:6px;margin:0;padding:0;list-style:none}
.intel li{display:grid;grid-template-columns:auto minmax(0,1fr) auto;align-items:center;gap:10px;padding:10px 12px;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.intel .n{font:700 18px/1 var(--f-mono);color:var(--tc);font-variant-numeric:tabular-nums}
.intel .note{font-size:13px;color:var(--dim);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.a-intel .btn{margin-top:10px;width:100%}
.manualcta p{color:var(--dim);margin-bottom:12px}

/* OPS */
.quick{display:grid;gap:10px}
.quick-row{display:flex;gap:8px}
.quick-row .inp{flex:1 1 auto;min-width:0}
.intake .intake-list{display:flex;flex-wrap:wrap;gap:6px}
.intk{font-size:13px;padding:7px 10px;box-shadow:inset 0 0 0 1px var(--line-2);max-width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:var(--bone)}
.intk.more{color:var(--dim)}
.board{display:grid;gap:18px;grid-template-columns:minmax(0,1fr)}
@media (min-width:720px){.board{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media (min-width:1140px){.board{grid-template-columns:repeat(4,minmax(0,1fr))}}
.col{display:grid;gap:10px;align-content:start;min-width:0}
.colh{display:flex;align-items:center;gap:10px;padding-bottom:10px;border-bottom:2px solid var(--tc)}
.colh .nm{font-family:var(--f-display);font-size:22px;line-height:1;color:var(--tc);letter-spacing:.03em;white-space:nowrap}
.colh .pl{font:600 10px/1 var(--f-mono);letter-spacing:.2em;color:var(--dim);text-transform:uppercase}
.colh .ct{margin-left:auto;font:700 14px/1 var(--f-mono);color:var(--bone)}
.cold{font-size:13px;color:var(--dim)}
.cards{display:grid;gap:10px}
.colempty{padding:16px;border:1px dashed var(--line-2);color:var(--mute);font:500 12px/1.4 var(--f-mono)}
.op{position:relative;display:grid;gap:8px;padding:12px 12px 10px;min-width:0;background:linear-gradient(180deg,rgba(21,27,35,.96),rgba(14,18,24,.96));box-shadow:inset 0 0 0 1px var(--line)}
.op::before{content:"";position:absolute;top:0;right:0;border-top:16px solid var(--tc);border-left:16px solid transparent}
.op:hover{box-shadow:inset 0 0 0 1px var(--line-2)}
.op.editing{box-shadow:inset 0 0 0 1px var(--tc)}
.op .optitle{font-size:16px}
.op-top{display:flex;gap:10px;align-items:baseline;padding-right:16px}
.optag{margin-left:auto;font:500 9.5px/1 var(--f-mono);letter-spacing:.12em;color:var(--mute);white-space:nowrap}
.opact{display:flex;flex-wrap:wrap;gap:6px;margin-top:2px}
.opedit{display:grid;gap:14px;padding-top:12px;margin-top:4px;border-top:1px dashed var(--line-2)}
.cnrow{display:flex;flex-wrap:wrap;gap:10px;align-items:center}
.archive{display:grid;gap:8px}
.arow{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:6px 12px;padding:10px 12px;box-shadow:inset 0 0 0 1px var(--line);background:rgba(0,0,0,.22)}
.arow .ar-main{display:grid;gap:5px;min-width:0}
.arow .optitle{font-size:14px;color:var(--dim);text-decoration:line-through;text-decoration-color:rgba(255,255,255,.28)}
.arow .ar-side{display:grid;justify-items:end;align-content:center;gap:4px}
.mstamp{font-family:var(--f-display);font-size:13px;letter-spacing:.06em;color:var(--t1);border:2px solid var(--t1);padding:3px 7px 1px;transform:rotate(-6deg);opacity:.85;white-space:nowrap}

/* INFIL */
.infil{max-width:900px}
.posgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:8px}
.pos{display:grid;grid-template-columns:auto minmax(0,1fr);grid-template-rows:auto auto;gap:5px 10px;align-items:center;text-align:left;padding:12px;min-height:66px;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line-2)}
.pos:hover{box-shadow:inset 0 0 0 1px var(--h)}
.pos .sw{grid-row:1/3;width:8px;align-self:stretch;background:var(--h);box-shadow:0 0 10px -2px var(--h)}
.pos .pl{font:600 14px/1.2 var(--f-ui);color:var(--bone)}
.pos .phh{font:700 10.5px/1 var(--f-mono);letter-spacing:.08em;color:var(--h)}
.pos[aria-pressed="true"]{box-shadow:inset 0 0 0 2px var(--hud);background:rgba(76,201,176,.07)}
.thermo{position:relative;height:16px;margin:40px 0 0;box-shadow:0 0 0 1px rgba(255,255,255,.08)}
.thermo .gapband{position:absolute;top:50%;height:0;border-top:2px dashed var(--ink);opacity:.85}
.mk{position:absolute;top:-10px;bottom:-10px;width:2px;margin-left:-1px;background:var(--bone);box-shadow:0 0 8px rgba(255,255,255,.5)}
.mk span{position:absolute;left:50%;transform:translateX(-50%);white-space:nowrap;font:700 10.5px/1 var(--f-mono);letter-spacing:.1em;color:var(--bone)}
.mk.you span{bottom:calc(100% + 6px)}
.mk.tgt span{top:calc(100% + 6px)}
.mk.l span{left:0;transform:none}
.mk.r span{left:auto;right:0;transform:none}
.tscale{display:flex;justify-content:space-between;gap:10px;margin:34px 0 16px;font:600 9.5px/1 var(--f-mono);letter-spacing:.16em;color:var(--mute)}
.gapread{display:grid;grid-template-columns:auto minmax(0,1fr);gap:8px 18px;align-items:center;margin-bottom:16px}
.gapnum{display:flex;align-items:baseline;gap:10px;font-family:var(--f-display);font-size:64px;line-height:.85}
.verdict{justify-self:start;font:700 11.5px/1.3 var(--f-mono);letter-spacing:.16em;padding:7px 10px;box-shadow:inset 0 0 0 1px currentColor}
.verdict.ok{color:var(--hud)}.verdict.warn{color:var(--t2)}.verdict.crit{color:var(--t1)}
.vtext{grid-column:1/-1;color:var(--dim)}
.rchart{width:100%;overflow:hidden;margin:4px 0 2px}
.rchart svg{display:block;width:100%;height:auto}
.rchart .gl{stroke:var(--line);stroke-dasharray:2 4}
.rchart .ax{font:500 10px var(--f-mono);fill:var(--mute)}
.rchart .wl{font:700 10.5px var(--f-mono);fill:var(--bone);letter-spacing:.06em}
.rchart .pt.todo .wl{fill:var(--mute)}
.rchart .direct{stroke:var(--t1);stroke-width:1.5;stroke-dasharray:6 6;opacity:.75}
.rlegend{display:flex;flex-wrap:wrap;gap:6px 18px;margin-top:4px;font:700 10px/1.3 var(--f-mono);letter-spacing:.1em}
.rlegend .lr{display:inline-flex;align-items:center;gap:8px}
.rlegend .lr::before{content:"";flex:none;width:22px;height:0}
.rlegend .route{color:var(--bone)}
.rlegend .route::before{border-top:3px solid var(--t2);border-image:linear-gradient(90deg,rgb(255,180,66),rgb(196,64,152),rgb(92,62,196)) 1}
.rlegend .jump{color:var(--t1)}
.rlegend .jump::before{border-top:2px dashed var(--t1)}
.wps{list-style:none;margin:14px 0 14px;padding:0;display:grid;gap:8px}
.wp{display:grid;grid-template-columns:78px minmax(0,1fr);gap:4px 12px;padding:12px;align-items:start;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.wp .wpc{font:700 11.5px/1 var(--f-mono);letter-spacing:.14em;color:var(--h,var(--dim));padding-top:4px}
.wp .wpt{font:600 15px/1.35 var(--f-ui);overflow-wrap:anywhere}
.wp .wpm{font:500 10.5px/1.3 var(--f-mono);letter-spacing:.08em;color:var(--mute);margin-top:4px}
.wp .wpa{display:flex;flex-wrap:wrap;gap:6px;margin-top:10px}
.wp.done{opacity:.5}
.wp.done .wpt{text-decoration:line-through;text-decoration-color:rgba(255,255,255,.3)}
.wp.cur{box-shadow:inset 0 0 0 2px var(--hud);background:rgba(76,201,176,.05)}
.wp.here .wpc::after{content:" ●";color:var(--hud)}
@media (max-width:400px){.wp{grid-template-columns:minmax(0,1fr)}.wp .wpc{padding-top:0}}

/* LEDGER */
.tiles{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:10px}
.tile{min-width:0;padding:14px;background:rgba(0,0,0,.28);box-shadow:inset 0 0 0 1px var(--line)}
.tile .v{font-family:var(--f-display);font-size:36px;line-height:1;margin-top:9px;white-space:nowrap}
.tile .v small{font:600 14px/1 var(--f-mono);color:var(--dim);margin-left:3px}
.tile .s{font:500 10.5px/1.3 var(--f-mono);letter-spacing:.06em;color:var(--mute);margin-top:7px}
.lgrid{display:grid;gap:16px;grid-template-columns:minmax(0,1fr)}
@media (min-width:900px){.lgrid{grid-template-columns:repeat(2,minmax(0,1fr))}.span2{grid-column:1/-1}}
.week{display:grid;gap:8px}
.wrow{display:grid;grid-template-columns:60px minmax(0,1fr) 26px;gap:10px;align-items:center;min-height:20px}
.wrow .wd{font:600 10.5px/1 var(--f-mono);letter-spacing:.12em;color:var(--dim)}
.wrow.today .wd{color:var(--hud)}
.wrow.fut{opacity:.38}
.wrow .wn{font:700 13px/1 var(--f-mono);text-align:right;font-variant-numeric:tabular-nums}
.legend{display:flex;flex-wrap:wrap;gap:6px 14px;margin-top:14px}
.lg{display:inline-flex;align-items:center;gap:6px;font:600 9.5px/1 var(--f-mono);letter-spacing:.14em;color:var(--dim)}
.lg i{display:block;width:10px;height:10px;background:var(--tc)}
.heat{display:grid;grid-template-rows:repeat(7,auto);grid-auto-flow:column;grid-auto-columns:minmax(0,1fr);gap:4px;max-width:560px}
.hc{display:block;aspect-ratio:1;background:rgba(255,255,255,.045)}
.hc.l1{background:rgba(76,201,176,.24)}.hc.l2{background:rgba(76,201,176,.44)}.hc.l3{background:rgba(76,201,176,.7)}.hc.l4{background:var(--hud);box-shadow:0 0 8px rgba(76,201,176,.5)}
.hc.fut{background:transparent}
.hc.now{outline:1px solid var(--bone);outline-offset:1px}
.ladder{list-style:none;margin:0;padding:0;display:grid;gap:3px}
.ladder li{display:grid;grid-template-columns:30px minmax(0,1fr) auto;gap:10px;align-items:center;padding:8px 10px;font:600 11.5px/1.2 var(--f-mono);letter-spacing:.12em;color:var(--mute)}
.ladder li.got{color:var(--dim)}
.ladder li.cur{color:var(--hud);background:rgba(76,201,176,.06);box-shadow:inset 0 0 0 1px var(--hud)}
.medals{display:grid;grid-template-columns:repeat(auto-fill,minmax(128px,1fr));gap:10px}
.medal{display:grid;justify-items:center;align-content:start;text-align:center;gap:8px;padding:14px 10px;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.hex{width:54px;height:60px;display:grid;place-items:center;background:var(--line);color:var(--mute);clip-path:polygon(50% 0,100% 25%,100% 75%,50% 100%,0 75%,0 25%)}
.medal.got .hex{background:linear-gradient(160deg,var(--hud),#2c7f6f);color:var(--hud-ink)}
.hex svg{width:26px;height:26px}
.medal .mn{font:700 10.5px/1.25 var(--f-mono);letter-spacing:.12em}
.medal .mr{font-size:12px;color:var(--mute);line-height:1.35}
.redact{display:inline-block;height:.95em;vertical-align:middle;background:var(--line-2)}
.logl{list-style:none;margin:0;padding:0;display:grid}
.logl li{display:grid;grid-template-columns:auto minmax(0,1fr) auto;gap:10px;align-items:center;padding:9px 0;border-bottom:1px dashed var(--line)}
.logl li:last-child{border-bottom:0}
.logl .cell{width:10px;height:10px}
.logl .t{font-size:14px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.logl .t .opcode{display:inline;margin-right:6px}
.logl .d{font:500 10.5px/1 var(--f-mono);color:var(--dim);letter-spacing:.06em;white-space:nowrap}
@media (max-width:520px){.logl li{grid-template-columns:auto minmax(0,1fr)}.logl .d{grid-column:2}}

/* full-screen op window */
.ov{position:fixed;inset:0;z-index:60;display:flex;flex-direction:column;align-items:center;overflow:auto;background:var(--ink);background:radial-gradient(90% 60% at 50% 42%, color-mix(in srgb, var(--tc) 15%, transparent), transparent 70%), var(--ink);padding:calc(env(safe-area-inset-top,0px) + 14px) max(16px,env(safe-area-inset-right,0px)) calc(env(safe-area-inset-bottom,0px) + 22px) max(16px,env(safe-area-inset-left,0px))}
.ov.brk{--tc:var(--hud)}
.ov-in{width:100%;max-width:560px;margin:auto 0;display:flex;flex-direction:column;align-items:center;gap:14px}
.ov-top{width:100%;display:flex;align-items:center;gap:10px}
.ov-btns{margin-left:auto;display:flex;flex-wrap:wrap;gap:6px;justify-content:flex-end}
.rec{display:inline-flex;align-items:center;gap:8px;font:700 10.5px/1.3 var(--f-mono);letter-spacing:.2em;color:var(--tc)}
.rec i{flex:none;width:8px;height:8px;border-radius:50%;background:var(--tc);animation:blink 1.2s steps(2) infinite}
.ov-op{display:grid;justify-items:center;gap:7px;text-align:center;max-width:100%}
.ov-op .optitle{font-size:clamp(20px,4.6vw,27px);text-align:center;text-wrap:balance}
.scope{position:relative;width:min(82vw,50vh,380px);max-width:100%;aspect-ratio:1}
.scope svg{display:block;width:100%;height:100%;overflow:visible}
.scope .ring1{fill:none;stroke:var(--line)}
.scope .ring2{fill:none;stroke:var(--line-2);stroke-width:2}
.scope .tk{stroke:var(--line-2);stroke-width:1}
.scope .tk.mj{stroke:var(--bone);stroke-width:2}
.scope .face{fill:#0a0e13;stroke:var(--line)}
.scope .cross line,.scope .cross circle{stroke:rgba(255,255,255,.07);fill:none}
.scope .swl{stroke:rgba(255,255,255,.32);stroke-width:1}
.scope .hub{fill:var(--ink);stroke:var(--tc);stroke-width:1.5}
.scope .dig{font:700 19px var(--f-mono);fill:var(--bone)}
.scope.final #wedge{animation:pulse 1s ease-in-out infinite}
.ov-rule{max-width:44ch;text-align:center;color:var(--dim);font-size:14px}
.ov-rule b{color:var(--bone)}
.hold{position:relative;overflow:hidden;min-height:44px;padding:0 20px;font:600 11px/1 var(--f-mono);letter-spacing:.18em;color:var(--t1);box-shadow:inset 0 0 0 1px rgba(236,106,114,.4);-webkit-user-select:none;user-select:none;-webkit-touch-callout:none;touch-action:none;--p:0}
.hold::before{content:"";position:absolute;inset:0;background:rgba(236,106,114,.28);transform-origin:left;transform:scaleX(var(--p))}
.hold span{position:relative}
.ov-in.sec{gap:16px}
.stamp{font-family:var(--f-display);font-size:clamp(44px,12vw,70px);line-height:1;color:var(--t1);padding:8px 18px 2px;border:5px solid currentColor;letter-spacing:.06em;transform:rotate(-8deg);animation:stampIn .5s cubic-bezier(.2,1.4,.4,1) both}
.stamp.good{color:var(--hud);text-shadow:0 0 18px rgba(76,201,176,.35)}
.xppop{font:700 22px/1 var(--f-mono);color:var(--hud);animation:rise 1.1s ease-out .25s both}
.secbox{width:100%;display:grid;gap:10px;padding:14px;background:rgba(0,0,0,.32);box-shadow:inset 0 0 0 1px var(--line)}
.secbox .ph{margin-bottom:0}
.secact{width:100%;display:grid;gap:8px;justify-items:stretch}
.secact .link{justify-self:center}

/* mini bar */
.mini{position:fixed;left:0;right:0;bottom:calc(66px + env(safe-area-inset-bottom,0px));z-index:34;display:flex;justify-content:center;pointer-events:none;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px))}
@media (min-width:900px){.mini{bottom:calc(20px + env(safe-area-inset-bottom,0px))}}
.mini.brk{--tc:var(--hud)}
.mini{gap:8px}
.mini-main{pointer-events:auto;width:100%;max-width:520px;min-width:0;display:flex;align-items:center;gap:12px;padding:11px 14px;text-align:left;background:#0f141a;box-shadow:inset 0 0 0 1px var(--tc),0 10px 30px rgba(0,0,0,.6)}
.mini-pop{pointer-events:auto;flex:none;width:50px;display:grid;place-items:center;color:var(--hud);background:#0f141a;box-shadow:inset 0 0 0 1px var(--line-2),0 10px 30px rgba(0,0,0,.6)}
.mini-pop svg{width:20px;height:20px}
.mini-pop:hover{box-shadow:inset 0 0 0 1px var(--hud),0 10px 30px rgba(0,0,0,.6)}
.mini-l{font:700 10px/1 var(--f-mono);letter-spacing:.18em;color:var(--tc);white-space:nowrap}
.mini-t{font:700 16px/1 var(--f-mono);font-variant-numeric:tabular-nums}
.mini-o{flex:1 1 auto;min-width:0;font-size:13px;color:var(--dim);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.mini-go{font:700 10px/1 var(--f-mono);letter-spacing:.16em;color:var(--hud)}

/* modals */
.mod{position:fixed;inset:0;z-index:70;display:flex;align-items:center;justify-content:center;background:rgba(3,5,7,.8);-webkit-backdrop-filter:blur(4px);backdrop-filter:blur(4px);padding:calc(env(safe-area-inset-top,0px) + 16px) max(16px,env(safe-area-inset-right,0px)) calc(env(safe-area-inset-bottom,0px) + 16px) max(16px,env(safe-area-inset-left,0px))}
.mcard{position:relative;width:100%;max-width:580px;max-height:100%;overflow:auto;display:grid;gap:16px;padding:22px 20px;background:linear-gradient(180deg,#141a22,#0c1015);box-shadow:inset 0 0 0 1px var(--line-2),0 30px 80px rgba(0,0,0,.6)}
.mcard::before{content:"";position:absolute;top:0;left:0;width:14px;height:14px;border-top:2px solid var(--hud);border-left:2px solid var(--hud)}
.mhead{display:flex;align-items:flex-start;gap:12px}
.mhead>div{min-width:0}
.mtitle{font-family:var(--f-display);font-size:30px;line-height:1;letter-spacing:.03em;margin-top:7px;text-wrap:balance}
.mx{margin-left:auto;flex:none}
.mcard p{color:var(--dim);max-width:60ch}
.enroll{padding-top:30px}
.mstamp2{position:absolute;top:18px;right:16px;font-family:var(--f-display);font-size:15px;color:var(--t1);border:3px solid currentColor;padding:4px 9px 1px;transform:rotate(7deg);opacity:.9}
.tri-op{display:grid;gap:6px;padding:14px;background:rgba(0,0,0,.32);box-shadow:inset 0 0 0 1px var(--line-2)}
.tri-tiers{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:8px}
.tri{display:grid;align-content:start;gap:6px;min-height:104px;padding:14px;text-align:left;background:rgba(0,0,0,.25);box-shadow:inset 0 0 0 1px var(--tc)}
.tri:hover{background:rgba(255,255,255,.05);box-shadow:inset 0 0 0 2px var(--tc)}
.tri .nm{font-family:var(--f-display);font-size:21px;line-height:1;color:var(--tc)}
.tri .pl{font:700 10px/1 var(--f-mono);letter-spacing:.2em;color:var(--bone)}
.tri .ds{font-size:12.5px;line-height:1.35;color:var(--dim)}
.pk-g{display:grid;gap:6px}
.pk-h{margin-top:4px}
.pk{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:5px 10px;align-items:center;padding:11px 12px;text-align:left;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.pk:hover{box-shadow:inset 0 0 0 1px var(--tc)}
.pk .opcode{grid-column:1/-1}
.pk-t{font-weight:600;overflow-wrap:anywhere}
.stepper{display:flex;flex-wrap:wrap;align-items:center;gap:12px}
.stepper b{font:700 22px/1 var(--f-mono);min-width:2ch;text-align:center}
.danger-zone{display:grid;gap:10px;padding-top:14px;border-top:1px dashed var(--line-2)}
.man{display:grid;gap:18px}
.man-s{display:grid;grid-template-columns:auto minmax(0,1fr);gap:6px 14px}
.man-n{grid-row:1/4;font-family:var(--f-display);font-size:30px;line-height:.9;color:var(--hud)}
.man-h{font:700 12px/1.2 var(--f-mono);letter-spacing:.2em}
.man-p{color:var(--bone)!important;font-size:14.5px}
.man-a{font:500 11px/1.4 var(--f-mono);letter-spacing:.04em;color:var(--hud)}
.credit{font-size:13px}
.promo .mcard{justify-items:center;text-align:center}
.promo-ins svg{width:104px;height:104px}
.promo-rank{font-family:var(--f-display);font-size:clamp(30px,8vw,46px);line-height:1;text-wrap:balance}

/* toasts */
.toasts{position:fixed;left:0;right:0;bottom:calc(78px + env(safe-area-inset-bottom,0px));z-index:80;display:grid;justify-items:center;gap:8px;pointer-events:none;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px))}
@media (min-width:900px){.toasts{bottom:calc(24px + env(safe-area-inset-bottom,0px))}}
.toast{pointer-events:auto;width:100%;max-width:440px;display:grid;grid-template-columns:auto minmax(0,1fr);gap:3px 10px;align-items:start;padding:11px 14px;background:#0e1319;box-shadow:inset 0 0 0 1px var(--line-2),0 14px 34px rgba(0,0,0,.55);animation:toastIn .22s ease-out both}
.toast::before{content:"";grid-row:1/3;width:8px;height:8px;margin-top:4px;background:var(--k,var(--hud));box-shadow:0 0 8px var(--k,var(--hud))}
.toast b{font:700 11px/1.35 var(--f-mono);letter-spacing:.14em;text-transform:uppercase}
.toast span{grid-column:2;font-size:13px;color:var(--dim)}
.toast.k-good{--k:var(--hud)}.toast.k-warn{--k:var(--t2)}.toast.k-bad{--k:var(--t1)}.toast.k-info{--k:var(--t3)}.toast.k-medal{--k:var(--t4)}

/* audio + pop-out controls */
.audio-lock{cursor:pointer;color:var(--t2)}
.audio-lock:hover{background:rgba(227,168,87,.1)}
.ibtn.snd-off{color:var(--t1);box-shadow:inset 0 0 0 1px rgba(236,106,114,.45)}
.ibtn.snd-lock{color:var(--t2);box-shadow:inset 0 0 0 1px rgba(227,168,87,.6)}
.ibtn.pip-on{color:var(--hud);box-shadow:inset 0 0 0 1px var(--hud)}
@media (max-width:540px){.ibtn.man{display:none}}
.pipvid{position:fixed;right:0;bottom:0;width:2px;height:2px;opacity:.01;pointer-events:none;z-index:-1}
.audio-sec{display:grid;gap:14px;padding-top:14px;border-top:1px dashed var(--line-2)}
.range{width:100%;min-height:32px;accent-color:var(--hud)}
.ov.ringing,.wdg.ringing{animation:ringing 1s steps(2) infinite}
@media (max-height:560px){.ov-rule{display:none}.ov-in{gap:8px}.ov .scope{width:min(70vw,46vh,380px)}}
/* compact widget for small windows */
#widget{display:none}
body.widget #app,body.widget .tabs-bottom,body.widget #mini,body.widget #ov{display:none}
body.widget #widget{display:block}
.wdg{position:relative;min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:10px;padding-block:14px;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px));text-align:center;background:radial-gradient(80% 60% at 50% 45%,color-mix(in srgb,var(--tc) 14%,transparent),transparent 70%),var(--ink);box-shadow:inset 0 0 0 2px var(--tc)}
.wdg.brk{--tc:var(--hud)}
.wdg .scope{width:min(76vw,50vh,320px)}
.wdg-top{display:flex;flex-wrap:wrap;align-items:center;justify-content:center;gap:6px 10px}
.rec.idle{color:var(--dim)}
.rec.idle i{background:var(--dim);animation:none}
.wdg-op{max-width:40ch;font:600 15px/1.3 var(--f-ui);overflow:hidden;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;text-wrap:balance}
.wdg-l{font-family:var(--f-display);font-size:clamp(26px,9vw,40px);line-height:1;color:var(--tc)}
.wdg-l.good{color:var(--hud)}
.wdg-x{font:700 18px/1 var(--f-mono);color:var(--hud)}
.wdg-act{display:flex;flex-wrap:wrap;justify-content:center;gap:6px;width:100%;max-width:360px}
.wdg-act .btn{flex:1 1 120px}
.wdg .deploy-btn{max-width:360px;min-height:60px}
.wdg .deploy-btn .dl{font-size:24px}
@keyframes ringing{50%{box-shadow:inset 0 0 0 6px var(--hud),inset 0 0 90px rgba(76,201,176,.18)}}
@keyframes blink{50%{opacity:.2}}
@keyframes pulse{50%{opacity:.5}}
@keyframes stampIn{0%{transform:scale(2.6) rotate(-16deg);opacity:0}55%{transform:scale(.92) rotate(-7deg);opacity:1}100%{transform:scale(1) rotate(-8deg);opacity:1}}
@keyframes cellIn{0%{transform:scale(0);opacity:0}55%{transform:scale(1.6);opacity:1}100%{transform:scale(1);opacity:1}}
@keyframes rise{0%{transform:translateY(12px);opacity:0}35%{opacity:1}100%{transform:translateY(0);opacity:1}}
@keyframes toastIn{from{transform:translateY(8px);opacity:0}to{transform:none;opacity:1}}
@keyframes glitch{0%{clip-path:inset(0 0 62% 0);transform:translateX(-3px)}35%{clip-path:inset(42% 0 0 0);transform:translateX(3px)}70%{clip-path:inset(12% 0 28% 0);transform:translateX(-1px)}100%{clip-path:inset(0);transform:none}}
@media (prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;animation-iteration-count:1!important;transition-duration:.01ms!important;scroll-behavior:auto!important}}
/* ===== deadline alerts ===== */
.remset{display:grid;gap:10px;padding-bottom:14px;margin-bottom:6px;border-bottom:1px dashed var(--line-2)}
.remset .seg button{min-height:38px;font-size:11px}
.remtime{display:flex;align-items:center;gap:10px;font:700 11px/1 var(--f-mono);letter-spacing:.12em;color:var(--dim);text-transform:uppercase}
.remtime .inp{width:auto;min-height:40px}
.btn.rem.ok{--c:var(--hud)}
.remtag{display:inline-flex;align-items:center;min-height:36px;padding:0 10px;font:700 10.5px/1 var(--f-mono);letter-spacing:.08em;color:var(--dim);box-shadow:inset 0 0 0 1px var(--line-2)}
.remtag.ok{color:var(--hud)}
/* ===== tasks first, optional window, Claude intel ===== */
.addon{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:8px 12px;margin-top:16px;padding-top:12px;border-top:1px dashed var(--line-2)}
.addon .row{gap:6px}
.sugg{border-color:rgba(173,148,232,.45)}
.sugg .ph-t::before{background:var(--t4);box-shadow:0 0 8px var(--t4)}
.sg-hint{margin:0 0 10px}
.sg-list{list-style:none;margin:0;padding:0;display:grid;gap:6px}
.sg-list li{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:8px 12px;padding:10px 12px;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.sg-t{display:grid;gap:3px;min-width:0;flex:1 1 220px}
.sg-t b{font-weight:600;overflow-wrap:anywhere}
.sg-t span{font-size:12.5px;color:var(--dim)}
.mcard .sugg{margin-top:4px}
/* ===== routines ===== */
.t5{--tc:#4cc9b0}
.rt-box{display:grid;gap:8px;margin-top:14px;padding-top:12px;border-top:1px dashed var(--line-2)}
.rt-hint{margin-top:10px}
.rt-list{list-style:none;margin:0;padding:0;display:grid;gap:6px}
.rt{display:flex;align-items:center;gap:10px;min-height:46px;padding:7px 10px;border-radius:12px;box-shadow:inset 0 0 0 1px var(--line)}
.rt-chk{flex:none;width:32px;height:32px;border-radius:50%;display:grid;place-items:center;font:800 16px/1 var(--f-ui);color:var(--ink);box-shadow:inset 0 0 0 2px var(--tc)}
.rt.done .rt-chk{background:var(--tc)}
.rt-t{flex:1 1 auto;min-width:0;font-weight:600;overflow-wrap:anywhere}
.rt.done .rt-t{text-decoration:line-through;opacity:.6}
.rt-st{flex:none;font:800 10.5px/1 var(--f-mono);letter-spacing:.1em;color:var(--tc)}
.rtn .ph-t::before{background:var(--tc)}
.rt-cards{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:10px}
.rt-tri{width:100%}
/* ===== phone fit: long words wrap, nothing wider than its box ===== */
.mcard{grid-template-columns:minmax(0,1fr)}
.mcard>*,.view>*,.hq>*{min-width:0}
.mtitle,.vt,.callsign,.promo-rank,.tri .nm,.colh .nm,.optitle,.gapnum{overflow-wrap:anywhere}
.tri{min-width:0}
.tri-tiers{grid-template-columns:repeat(2,minmax(0,1fr))}
.verdict{max-width:100%}
.chip,.cchip{max-width:100%;overflow:hidden;text-overflow:ellipsis}
@media (max-width:520px){
  .tri-tiers{grid-template-columns:minmax(0,1fr)}
  .tri{min-height:0}
  .gapread{grid-template-columns:minmax(0,1fr)}
  .mtitle{font-size:clamp(20px,6.6vw,30px)}
  .vt{font-size:clamp(26px,8.4vw,46px)}
  .colh .nm{white-space:normal}
}
/* ===== calm skin: legible type, softer color ===== */
body{font-size:15.5px;line-height:1.5}
.fx-scan{display:none}
.fx-grid{opacity:.5}
.brand-name{animation:none;font-weight:700;letter-spacing:.02em}
.classif .wrap{letter-spacing:.18em}
.lbl,.eyebrow,.field>span,.field>label,.tab,.chip,.opcode,.ph-m,.opmeta,.mini-l,.dtg,.chipbtn,.xpmeta,.clr,.astats dt{letter-spacing:.07em}
.ph-t{letter-spacing:.12em}
.vt,.callsign,.mtitle,.colh .nm,.tri .nm,.tile .v,.tcount .big,.gapnum,.promo-rank,.man-n,.deploy-btn .dl,.wdg-l,.stamp,.mstamp,.mstamp2{font-weight:700;letter-spacing:.01em}
.optitle{font-weight:600}
.panel{border-radius:14px;background:var(--panel);border-color:var(--line)}
.panel.frame::before,.panel.frame::after{display:none}
.ph-t::before{border-radius:50%;box-shadow:none}
.tab[aria-current="page"]::after{box-shadow:none}
.btn,.btn.sm{clip-path:none;border-radius:10px}
.deploy-btn{clip-path:none;border-radius:14px}
.deploy-btn::after{display:none}
.seg{border-radius:10px;overflow:hidden}
.inp{border-radius:10px}
.chip,.chipbtn,.cchip,.verdict{border-radius:999px}
.op{border-radius:12px;overflow:hidden;background:var(--panel-2)}
.nextop,.intel li,.dl-list li,.arow,.pos,.wp,.tile,.medal,.tri-op,.tri,.pk,.secbox,.routebar,.ladder li,.sg-list li,.rt,.colempty,.intk{border-radius:10px}
.cell,.cells.sm .cell{border-radius:5px;box-shadow:none}
.xpbar i{border-radius:2px}
.xpbar i.on,.hc.l4,.pos .sw,.toast::before,.rec i{box-shadow:none}
.mcard{border-radius:18px}
.mcard::before{display:none}
.stamp.good{text-shadow:none}
.toast,.mini-main,.mini-pop{border-radius:12px}
.toast::before{border-radius:50%}
.agent-emb{border-radius:14px}
.hex{clip-path:none;border-radius:50%}
.ibtn{border-radius:10px}
/* ===== notes, debriefs, case files ===== */
.opnote{margin:0;font-size:13.5px;line-height:1.45;color:var(--dim);white-space:pre-line;overflow:hidden;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow-wrap:anywhere}
.case-link{text-align:left;cursor:pointer}
.case-link:hover{color:var(--hud)}
#edit-notes,#db-note{min-height:96px}
.db-custom{display:flex;align-items:center;gap:10px;margin-top:6px;font:600 11px/1 var(--f-mono);letter-spacing:.08em;color:var(--mute);text-transform:uppercase}
.db-custom .inp{width:120px;min-height:40px}
.case-stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(130px,1fr));gap:8px;margin:0}
.case-stats div{padding:10px 12px;border-radius:10px;background:var(--panel-2);box-shadow:inset 0 0 0 1px var(--line);min-width:0}
.case-stats dt{font:600 10px/1.2 var(--f-mono);letter-spacing:.1em;color:var(--mute);text-transform:uppercase}
.case-stats dd{margin:6px 0 0;font:700 16px/1.2 var(--f-mono);color:var(--bone);overflow-wrap:anywhere}
.case-sec{display:grid;gap:6px}
.mcard .case-sec p{color:var(--bone);white-space:pre-line;overflow-wrap:anywhere;max-width:none}
.logl button.t{min-width:0;text-align:left}
.ar-side{gap:2px}
/* ===== day report ===== */
button.hc{cursor:pointer;padding:0;border:0}
button.hc:hover,button.hc:focus-visible{outline:1px solid var(--hud);outline-offset:1px}
.wrow button.wd{text-align:left;cursor:pointer}
.wrow button.wd:hover{color:var(--hud)}
.dr-proof{color:var(--hud)!important;font-weight:600}
.dr-list{list-style:none;margin:0;padding:0;display:grid;gap:8px}
.dr-list li{display:grid;gap:5px;padding:12px 12px 12px 14px;border-radius:10px;background:var(--panel-2);box-shadow:inset 0 0 0 1px var(--line),inset 3px 0 0 var(--tc);min-width:0}
.dr-top{display:flex;flex-wrap:wrap;gap:6px 10px;align-items:center}
.mcard .dr-note{margin:0;font-size:14px;line-height:1.5;color:var(--bone);white-space:pre-line;overflow-wrap:anywhere;max-width:none}
.mcard .dr-note.dim{color:var(--mute)}
.dr-nav{display:flex;justify-content:space-between;gap:8px}
/* ===== Proton schedule ===== */
/* ===== HQ columns, notes, offline ===== */
@media (min-width:900px){
  .hq{grid-template-areas:none}
  .hq-col{display:flex;flex-direction:column;gap:16px;min-width:0}
}
@media (max-width:899px){
  .hq-col{display:contents}
  .hq .a-agent{order:1}.hq .a-deploy{order:2}.hq .a-notes{order:3}.hq .a-today{order:4}.hq .a-sched{order:5}.hq .a-feed{order:6}.hq .a-intel{order:7}.hq .a-manual{order:8}
}
.nt-new{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:8px;align-items:stretch}
textarea.inp#note-new{min-height:64px;padding:10px 12px}
textarea.inp#note-edit{min-height:120px}
.nt-q{margin-top:10px;min-height:40px}
.nt-list{list-style:none;margin:12px 0 0;padding:0;display:grid;gap:6px}
.nt{display:grid;gap:6px;min-width:0;padding:10px 12px;border-radius:10px;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.nt.pin{box-shadow:inset 0 0 0 1px rgba(227,168,87,.4),inset 3px 0 0 var(--t2)}
.nt.editing{box-shadow:inset 0 0 0 1px var(--hud)}
.nt-text{margin:0;font-size:14px;line-height:1.5;white-space:pre-wrap;overflow-wrap:anywhere;display:-webkit-box;-webkit-line-clamp:6;-webkit-box-orient:vertical;overflow:hidden}
.nt-text.open{display:block}
.nt-meta{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:0 10px;font:500 10.5px/1.3 var(--f-mono);letter-spacing:.06em;color:var(--mute)}
.nt-acts{display:flex;flex-wrap:wrap;gap:0 14px}
.nt-acts .link{min-height:32px}
.nt-all{margin-top:6px}
.bn-row{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:2px 12px}
.bn-act{min-height:28px;color:var(--t2)}
.banner.ok{background:rgba(76,201,176,.07);border-bottom-color:rgba(76,201,176,.3);color:var(--hud)}
.banner.ok .bn-act{color:var(--hud)}
.a-sched{transition:box-shadow .15s,background .15s}
.a-sched.drag{border-color:var(--hud);box-shadow:inset 0 0 0 1px var(--hud);background:rgba(76,201,176,.06)}
.ph-m.ag-free{color:var(--hud)}
.ph-m.ag-busy{color:var(--t2)}
.ag-day{margin-top:14px}
.ag-wrap>.ag-day:first-child{margin-top:0}
.ag-earlier{margin-bottom:10px}
.ag{list-style:none;margin:8px 0 0;padding:0;display:grid;gap:6px}
.ag li{display:grid;grid-template-columns:auto minmax(0,1fr) auto;gap:4px 12px;align-items:center;padding:9px 11px;border-radius:10px;background:rgba(0,0,0,.22);box-shadow:inset 0 0 0 1px var(--line)}
.ag li.on{background:rgba(76,201,176,.07);box-shadow:inset 0 0 0 1px var(--hud),inset 3px 0 0 var(--hud)}
.ag-when{min-width:96px;font:700 11px/1.2 var(--f-mono);letter-spacing:.04em;color:var(--t3);white-space:nowrap;font-variant-numeric:tabular-nums}
.ag li.on .ag-when{color:var(--hud)}
.ag-main{display:grid;gap:3px;min-width:0}
.ag-t{font-size:14px;font-weight:600;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ag-l{display:flex;align-items:center;gap:6px;min-width:0;font-size:12.5px;color:var(--dim);white-space:nowrap;overflow:hidden}
.ag-lt{min-width:0;overflow:hidden;text-overflow:ellipsis}
.chip.ag-now{color:var(--hud)}
.chip.ag-soon{color:var(--t2)}
.ag-empty{font-size:13.5px;color:var(--dim);margin-top:6px}
.ag-foot{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:4px 12px;margin-top:14px;padding-top:10px;border-top:1px dashed var(--line-2)}
.srcnote.warn{color:var(--t2)}
.cchip.ag-del{color:var(--t1);box-shadow:inset 0 0 0 1px var(--t1)}
@media (max-width:420px){.ag li{grid-template-columns:minmax(0,1fr) auto}.ag-when{grid-column:1/-1;min-width:0}}
</style>

<div class="fx-grid" aria-hidden="true"></div>
<div id="app">
  <header class="cmd">
    <div class="classif"><div class="wrap"><span>Top secret</span><span>//</span><span>Zerø gap</span><span>//</span><span>Eyes only</span></div></div>
    <div class="wrap cmd-row">
      <a class="brand" href="#hq" aria-label="ZERØ GAP headquarters">
        <svg width="34" height="34" viewBox="0 0 40 40" aria-hidden="true"><circle cx="20" cy="20" r="15" fill="none" style="stroke:var(--hud)" stroke-width="2.2" stroke-dasharray="78 16.25" transform="rotate(-28 20 20)"/><path d="M20 1.5v6M20 32.5v6M1.5 20h6M32.5 20h6" style="stroke:var(--hud)" stroke-width="2"/><path d="M12 28L28 12" style="stroke:var(--bone)" stroke-width="2.6"/><circle cx="20" cy="20" r="2.6" style="fill:var(--t1)"/></svg>
        <div><div class="brand-name">ZER<i>Ø</i> GAP</div><div class="brand-sub">COVERT OPS COMMAND</div></div>
      </a>
      <nav class="tabs-top" id="tabs-top" aria-label="Stations"></nav>
      <div class="cmd-right">
        <div class="dtg" id="dtg" aria-label="Date-time group"></div>
        <button class="ibtn" type="button" id="snd-btn" data-act="sound-toggle" aria-label="Sound on or off" title="Sound"></button>
        <button class="ibtn" type="button" hidden id="pip-btn" data-act="popout" aria-label="Pop out the timer" title="Pop out the timer"></button>
        <button class="ibtn man" type="button" data-act="manual" aria-label="Field manual" title="Field manual"></button>
        <button class="ibtn" type="button" id="fs-btn" data-act="fullscreen" aria-label="Full screen" title="Full screen"></button>
        <button class="ibtn" type="button" data-act="settings" aria-label="Settings" title="Settings"></button>
      </div>
    </div>
  </header>
  <div id="banner"></div>
  <main class="wrap" id="view"></main>
</div>
<nav class="tabs-bottom" id="tabs-bottom" aria-label="Stations"></nav>
<div id="mini"></div>
<div id="widget"></div>
<div id="ov"></div>
<div id="mod"></div>
<div class="toasts" id="toasts" aria-live="polite"></div>
<div class="fx-scan" aria-hidden="true"></div>

<script id="zg-main">
(function () {
'use strict';
/* Captured before anything renders: the offline copy is rebuilt from this. */
const BOOT_BODY = (function () { try { return document.body ? document.body.innerHTML : ''; } catch (e) { return ''; } })();
const SEED = (function () { try { const el = document.getElementById('zg-seed'); const v = el ? JSON.parse(el.textContent) : null; return v && v.kind === 'zerogap-copy' && v.data ? v : null; } catch (e) { return null; } })();

/* ================= CONSTANTS ================= */
const TIERS = {
  0: { key: 't0', name: 'INTAKE', plain: 'Unsorted', desc: 'Not sorted yet. Triage it by how it feels.' },
  1: { key: 't1', name: 'CRITICAL', plain: 'Urgent', desc: 'Has to happen today. Real consequences if it slips.' },
  2: { key: 't2', name: 'COUNTDOWN', plain: 'Deadline', desc: 'A deadline is coming, but there is still buffer.' },
  3: { key: 't3', name: 'GRUNT WORK', plain: 'Admin', desc: 'Boring but usually small: email, forms, chores.' },
  4: { key: 't4', name: 'SANDBOX', plain: 'Fun', desc: 'Stuff you actually want to do. Best warm-up fuel.' },
  5: { key: 't5', name: 'STANDING ORDER', plain: 'Recurring', desc: 'Never closes: run it every day it is scheduled.' }
};
const RANKS = [[0, 'RECRUIT'], [500, 'ANALYST'], [1500, 'FIELD OPERATIVE'], [3500, 'SPECIAL AGENT'], [7000, 'SENIOR SPECIAL AGENT'], [12000, 'SECTION CHIEF'], [20000, 'PHANTOM'], [32000, 'GHOST'], [50000, 'DIRECTOR']];
const NATO = ['ALPHA', 'BRAVO', 'CHARLIE', 'DELTA', 'ECHO', 'FOXTROT', 'GOLF', 'HOTEL'];
const HMIN = -60, HMAX = 320, GAP_OK = 60;
const POSITIONS = [
  { id: 'bed', label: 'Scrolling in bed', heat: 300 },
  { id: 'game', label: 'Gaming', heat: 260 },
  { id: 'video', label: 'Watching videos', heat: 240 },
  { id: 'desk', label: 'Scrolling at my desk', heat: 200 },
  { id: 'chat', label: 'Texting or chatting', heat: 160 },
  { id: 'pc', label: 'Browsing on the PC', heat: 100 },
  { id: 'zoned', label: 'Zoned out, doing nothing', heat: 80 }
];
const ENV = {
  bed: [{ t: 'Move to your desk. Keep scrolling there. That is allowed.', h: 200 }, { t: 'Open the PC. Same app, but in the browser. Clunkier, less pull.', h: 120 }],
  game: [{ t: 'Finish this match. Do not queue another. Exit to desktop.', h: 200 }, { t: 'Stay seated. Music on, skim news or patch notes for two minutes.', h: 120 }],
  video: [{ t: 'Kill autoplay. Finish this one video, then stop.', h: 190 }, { t: 'Switch to audio only: music or a podcast, screen off.', h: 120 }],
  desk: [{ t: 'Put the phone down. Same app on the PC browser instead.', h: 120 }],
  chat: [{ t: 'Send one last message: "brb, locking in." Phone face down.', h: 110 }],
  pc: [],
  zoned: [{ t: 'Stand up. Get water. Sit back down at your desk.', h: 75 }]
};
const ADJ = ['SILENT', 'IRON', 'GLASS', 'BLACK', 'CRIMSON', 'HOLLOW', 'NIGHT', 'STEEL', 'COLD', 'VELVET', 'ASH', 'COBALT', 'ONYX', 'PALE', 'RAPID', 'SILVER', 'STATIC', 'ARCTIC', 'BURNT', 'FROZEN', 'LUNAR', 'NEON', 'OBSIDIAN', 'QUIET', 'SABLE', 'SOLAR', 'VOID', 'WINTER', 'AMBER', 'DEEP', 'DUSK', 'GRANITE', 'HIDDEN', 'IVORY', 'JADE', 'KINETIC', 'LONE', 'MIDNIGHT', 'NORTHERN', 'PRIME', 'RADIANT', 'SCARLET', 'UMBRAL', 'WIRED', 'HUSHED', 'BRASS', 'CARBON', 'GLACIAL'];
const NOUN = ['ANVIL', 'VIPER', 'HARBOR', 'LANTERN', 'FALCON', 'CIPHER', 'MERIDIAN', 'SPARROW', 'BASTION', 'CASCADE', 'ECLIPSE', 'FORGE', 'GAMBIT', 'HALO', 'JACKAL', 'KESTREL', 'LEDGER', 'MONOLITH', 'NEEDLE', 'ORBIT', 'PRISM', 'QUARTZ', 'RAVEN', 'SENTINEL', 'TALON', 'VECTOR', 'WRAITH', 'ZEPHYR', 'ATLAS', 'BEACON', 'COMPASS', 'DRIFT', 'FULCRUM', 'GLACIER', 'HORIZON', 'IRIS', 'JUNCTION', 'KEYSTONE', 'MIRAGE', 'NOMAD', 'OUTPOST', 'PARALLAX', 'QUASAR', 'RAMPART', 'SIGNAL', 'TEMPEST', 'UPLINK', 'VANGUARD', 'WARDEN', 'ZENITH'];
const CALLSIGNS = ['KESTREL', 'NULLBYTE', 'NIGHTJAR', 'HALCYON', 'RAZORBILL', 'BLACKOUT', 'WRAITH', 'OSPREY', 'FERROUS', 'STATIC', 'DRIFTER', 'SABLE', 'NOMAD', 'PARALLAX', 'BASILISK', 'ONYX', 'MERIDIAN', 'HUSH', 'CINDER', 'VOLTAGE', 'GLITCH', 'SPECTRAL', 'CIPHER', 'OBSIDIAN'];
const BADGES = [
  { id: 'first', name: 'FIRST CONTACT', req: 'Close your first op', glyph: 'bolt' },
  { id: 'b2b', name: 'BACK-TO-BACK', req: 'Two op windows in a row, no break between', glyph: 'b2b' },
  { id: 'infil', name: 'CLEAN INFIL', req: 'Finish an infiltration route', glyph: 'route' },
  { id: 'zero', name: 'ZERO GAP', req: 'Infiltrate all the way from scrolling in bed', glyph: 'zero' },
  { id: 'quota', name: 'QUOTA MET', req: 'Close your daily quota of ops', glyph: 'grid' },
  { id: 'red', name: 'RED LINE', req: 'Close a Critical op', glyph: 'alert' },
  { id: 'budget', name: 'UNDER BUDGET', req: 'Close an op in fewer windows than estimated', glyph: 'down' },
  { id: 'sweep', name: 'CLEAN SWEEP', req: 'Close 5 ops in one day', glyph: 'check' },
  { id: 'dawn', name: 'DAWN PATROL', req: 'Close an op between 05:00 and 09:00', glyph: 'sun' },
  { id: 'triage', name: 'TRIAGE OFFICER', req: 'Sort 10 ops by how they feel', glyph: 'sort' },
  { id: 'iron', name: 'IRON WEEK', req: 'Seven days of active duty in a row', glyph: 'shield' },
  { id: 'hours', name: 'FORTY DOWN', req: 'Close 40 ops', glyph: 'clock' }
];
const GLYPH = {
  bolt: '<path d="M13.5 2L5 13.5h6L10 22l9-12h-6.2z" fill="currentColor"/>',
  b2b: '<path d="M4 10.5l8-6 8 6M4 17.5l8-6 8 6" fill="none" stroke="currentColor" stroke-width="2.4"/>',
  route: '<path d="M3 4h5v5h5v5h5v6" fill="none" stroke="currentColor" stroke-width="2.4"/>',
  zero: '<circle cx="12" cy="12" r="7.5" fill="none" stroke="currentColor" stroke-width="2.4"/><path d="M6 18L18 6" stroke="currentColor" stroke-width="2.4"/>',
  grid: '<g fill="currentColor"><rect x="3" y="3" width="8" height="8"/><rect x="13" y="3" width="8" height="8"/><rect x="3" y="13" width="8" height="8"/><rect x="13" y="13" width="8" height="8"/></g>',
  alert: '<path d="M12 2.5L22 20H2z" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linejoin="round"/><path d="M12 9v5" stroke="currentColor" stroke-width="2.4"/><circle cx="12" cy="17" r="1.4" fill="currentColor"/>',
  down: '<path d="M12 3v13M6 10.5l6 6 6-6" fill="none" stroke="currentColor" stroke-width="2.4"/><path d="M5 21h14" stroke="currentColor" stroke-width="2.4"/>',
  check: '<path d="M3.5 12.5l5.5 5.5L20.5 6.5" fill="none" stroke="currentColor" stroke-width="2.8"/>',
  sun: '<path d="M5 17a7 7 0 0 1 14 0" fill="none" stroke="currentColor" stroke-width="2.4"/><path d="M2 20.5h20M12 3v3.5M4.2 8.2l2.4 2.4M19.8 8.2l-2.4 2.4" stroke="currentColor" stroke-width="2.2"/>',
  sort: '<path d="M3 5h18M3 11h13M3 17h8" stroke="currentColor" stroke-width="2.6"/>',
  shield: '<path d="M12 2.5l8 3v6c0 5-3.5 8.5-8 10-4.5-1.5-8-5-8-10v-6z" fill="none" stroke="currentColor" stroke-width="2.2"/><path d="M8.5 12l2.5 2.5 4.5-5" fill="none" stroke="currentColor" stroke-width="2.2"/>',
  clock: '<circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="2.2"/><path d="M12 6.5V12l4 2.5" fill="none" stroke="currentColor" stroke-width="2.2"/>'
};
const ICON = {
  hq: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="7.5" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="12" cy="12" r="2.2" fill="currentColor"/><path d="M12 1.5v5M12 17.5v5M1.5 12h5M17.5 12h5" stroke="currentColor" stroke-width="1.8"/></svg>',
  ops: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2.5 5.5h7l2 2.2h10v12.8h-19z" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="M6.5 12h11M6.5 15.8h7" stroke="currentColor" stroke-width="1.8"/></svg>',
  infil: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2.5 4.5h5v5h5v5h5v4" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="19.5" cy="19.5" r="2.4" fill="currentColor"/></svg>',
  ledger: '<svg viewBox="0 0 24 24" aria-hidden="true"><g fill="currentColor"><rect x="3" y="3" width="5" height="5"/><rect x="9.5" y="3" width="5" height="5"/><rect x="3" y="9.5" width="5" height="5"/></g><g fill="none" stroke="currentColor" stroke-width="1.4"><rect x="16.7" y="3.7" width="3.6" height="3.6"/><rect x="10.2" y="10.2" width="3.6" height="3.6"/><rect x="16.7" y="10.2" width="3.6" height="3.6"/><rect x="3.7" y="16.7" width="3.6" height="3.6"/><rect x="10.2" y="16.7" width="3.6" height="3.6"/><rect x="16.7" y="16.7" width="3.6" height="3.6"/></g></svg>',
  gear: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="3.4" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="M12 2.5v3M12 18.5v3M2.5 12h3M18.5 12h3M5.3 5.3l2.1 2.1M16.6 16.6l2.1 2.1M5.3 18.7l2.1-2.1M16.6 7.4l2.1-2.1" stroke="currentColor" stroke-width="1.8"/></svg>',
  manual: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4.5 3h10.5l4.5 4.5V21h-15z" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="M8 11h8M8 14.5h8M8 18h5" stroke="currentColor" stroke-width="1.8"/></svg>'
};
const MON = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
const DOW = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
const THERMAL = [[-60, [34, 44, 120]], [0, [92, 62, 196]], [80, [196, 64, 152]], [160, [244, 98, 60]], [240, [255, 180, 66]], [320, [255, 242, 204]]];
const THERMAL_CSS = 'linear-gradient(90deg,' + THERMAL.map(function (p) { return 'rgb(' + p[1].join(',') + ') ' + ((p[0] - HMIN) / (HMAX - HMIN) * 100).toFixed(1) + '%'; }).join(',') + ')';
const REDUCED = !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
const BASE_TITLE = 'ZERØ GAP';
const GCAL = 'Google Calendar';
const FEED_EVERY = 3 * 3600000;

/* ================= UTIL ================= */
const $ = function (s) { return document.querySelector(s); };
const esc = function (s) { return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); };
const pad = function (n) { return String(n).padStart(2, '0'); };
const clone = function (o) { return o == null ? o : JSON.parse(JSON.stringify(o)); };
const sleep = function (ms) { return new Promise(function (r) { setTimeout(r, ms); }); };
const rnd = function (a) { return a[Math.floor(Math.random() * a.length)]; };
function clampInt(v, lo, hi, d) { v = parseInt(v, 10); return isNaN(v) ? d : Math.max(lo, Math.min(hi, v)); }
function dayKey(ms) { const d = new Date(ms); return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
function parseDay(k) { const p = String(k).split('-').map(Number); return new Date(p[0], p[1] - 1, p[2], 12); }
function zoneLetter(d) {
  const off = -d.getTimezoneOffset() / 60;
  if (!Number.isInteger(off)) return 'J';
  if (off === 0) return 'Z';
  if (off > 0) return 'ABCDEFGHIKLM'[Math.min(off, 12) - 1];
  return 'NOPQRSTUVWXY'[Math.min(-off, 12) - 1];
}
function dtg(ms) { const d = new Date(ms); return pad(d.getDate()) + pad(d.getHours()) + pad(d.getMinutes()) + zoneLetter(d) + ' ' + MON[d.getMonth()] + ' ' + String(d.getFullYear()).slice(2); }
function zulu(ms) { const d = new Date(ms); return pad(d.getUTCHours()) + pad(d.getUTCMinutes()) + 'Z'; }
function fmtMS(ms) { const s = Math.max(0, Math.ceil(ms / 1000)); return pad(Math.floor(s / 60)) + ':' + pad(s % 60); }
function hm(min) { min = Math.round(min); const h = Math.floor(min / 60), m = min % 60; return h ? (h + 'H' + (m ? ' ' + m + 'M' : '')) : m + 'M'; }
function fmtHeat(h) { return h > 0 ? '+' + h : h < 0 ? '−' + Math.abs(h) : '0'; }
function fmtN(n) { return Number(n).toLocaleString('en-US'); }
function hash(s) { let h = 2166136261; for (let i = 0; i < s.length; i++) { h ^= s.charCodeAt(i); h = Math.imul(h, 16777619); } return h >>> 0; }
function uid(p) { return (p || 'o') + Date.now().toString(36) + Math.random().toString(36).slice(2, 8); }
function codename() { return rnd(ADJ) + ' ' + rnd(NOUN); }
function opTag(id) { return 'OP-' + hash(String(id)).toString(16).toUpperCase().padStart(8, '0').slice(0, 4); }
function isDate(s) { return /^\d{4}-\d{2}-\d{2}$/.test(s || ''); }
function daysUntil(due) { if (!isDate(due)) return null; const n = new Date(); const t0 = new Date(n.getFullYear(), n.getMonth(), n.getDate(), 12).getTime(); return Math.round((parseDay(due).getTime() - t0) / 86400000); }
function tminus(due) { const n = daysUntil(due); if (n === null) return ''; if (n < 0) return 'OVERDUE ' + (-n) + 'D'; if (n === 0) return 'DUE TODAY'; return 'T-' + n + 'D'; }
function heatColor(h) {
  h = Math.max(HMIN, Math.min(HMAX, h));
  for (let i = 1; i < THERMAL.length; i++) {
    if (h <= THERMAL[i][0]) {
      const a = THERMAL[i - 1], b = THERMAL[i], f = (h - a[0]) / (b[0] - a[0]);
      return 'rgb(' + a[1].map(function (v, j) { return Math.round(v + (b[1][j] - v) * f); }).join(',') + ')';
    }
  }
  return 'rgb(255,242,204)';
}
function setPath(o, path, v) { const k = path.split('.'); let t = o; for (let i = 0; i < k.length - 1; i++) { if (t[k[i]] == null) t[k[i]] = {}; t = t[k[i]]; } t[k[k.length - 1]] = v; }
function focusSoon(id) { setTimeout(function () { const el = document.getElementById(id); if (el) { try { el.focus({ preventScroll: true }); } catch (e) { el.focus(); } } }, 60); }
function tabFromHash() { const h = (location.hash || '').replace('#', ''); return ['hq', 'ops', 'infil', 'ledger'].indexOf(h) >= 0 ? h : 'hq'; }
function pickSuggestions() { return CALLSIGNS.slice().sort(function () { return Math.random() - .5; }).slice(0, 4); }

/* ================= STATE ================= */
const S = { mode: 'connecting', why: '', ready: false, hqKnown: false, opsKnown: false, logKnown: false, hq: null, ops: {}, days: {}, dayDocs: new Set(), feed: null, sugg: [], cals: {}, calKnown: false, notes: {}, notesKnown: false };
const ui = {
  tab: tabFromHash(), mins: 15, minimized: false, overlay: null, secured: null, breakOp: null,
  modal: null, away: null, awaySeen: null, promo: 0,
  draft: { quick: '', quickTier: 0, dump: '' },
  edit: null, expanded: null, confirmShred: null, showArchive: false,
  triage: null, infil: { pos: null, target: null },
  enroll: { callsign: '', quota: 4, sugg: pickSuggestions() },
  settings: null, purgeText: '', purgeOpen: false,
  feed: { avail: null, state: 'idle', msg: '', allow: false, perm: false, newCount: 0, didAuto: false },
  courseEdit: null, courseDraft: '', pinned: null, pinWhy: '',
  cal: { busy: false, del: null },
  notes: { draft: '', edit: null, editText: '', del: null, all: false, q: '', open: null }
};
let store = null;
let lastD = null;
let completing = null;
const pageLoadedAt = Date.now();

/* ================= SCORING ================= */
function blockXP(m) { return m === 10 ? 70 : 100; }
function routeXP(n) { return 50 + 10 * (n || 0); }
function closeXP(op) {
  const base = { 0: 60, 1: 200, 2: 150, 3: 100, 4: 60 }[op.tier || 0] || 60;
  let bonus = 0, tag = '';
  if (op.est > 0 && op.used > 0) { if (op.used < op.est) { bonus = 100; tag = 'UNDER BUDGET'; } else if (op.used === op.est) { bonus = 50; tag = 'ON BUDGET'; } }
  return { base: base, bonus: bonus, tag: tag, total: base + bonus };
}
/* Canvas imports ride their due date: due within a day = Critical, otherwise Countdown, until you set a tier yourself. */
function tierOf(op) {
  if (!op) return 0;
  if (op.repeat) return 5;
  if (op.src === 'canvas' && op.autoTier !== false && op.status !== 'closed') { const n = daysUntil(op.due); return n !== null && n <= 1 ? 1 : 2; }
  return op.tier || 0;
}
function courseLabel(code) { const c = S.feed && S.feed.courses; return (c && c[code]) || (code ? 'COURSE ' + code : ''); }
function opLabel(op) { return op.course ? courseLabel(op.course) + ' · ' + op.title : op.title; }
function guessEffort(t) {
  t = String(t || '').toLowerCase();
  if (/exam|capstone|final|midterm|\btest\b/.test(t)) return { res: 4, est: 4 };
  if (/project|plan\b|roadmap|script|letter|paper|essay|assignment/.test(t)) return { res: 3, est: 3 };
  if (/quiz|grader/.test(t)) return { res: 3, est: 2 };
  if (/reply|discussion|topic|profile/.test(t)) return { res: 2, est: 1 };
  if (/ebook|reading|read\b/.test(t)) return { res: 2, est: 2 };
  return { res: 3, est: 2 };
}
function opHeat(op) { if (!op) return 0; const r = op.res || 3, t = tierOf(op); return 60 - 20 * r + (t === 4 ? 20 : 0) + (t === 1 ? 10 : 0); }
const byCreated = function (a, b) { return (a.created || 0) - (b.created || 0); };
const byEase = function (a, b) { return (a.res || 3) - (b.res || 3) || (a.est || 99) - (b.est || 99) || byCreated(a, b); };
function dueSort(a, b) { const x = a.due || '9999', y = b.due || '9999'; return x < y ? -1 : x > y ? 1 : 0; }
function isUrgent(o) { const t = tierOf(o); if (t === 1) return true; const d = daysUntil(o.due); return t === 2 && d !== null && d <= 0; }

function derive() {
  const D = {};
  const hq = S.hq || {};
  D.quota = clampInt(hq.quota, 1, 24, 4);
  const blocks = [], routes = [];
  Object.keys(S.days || {}).forEach(function (date) {
    const day = S.days[date]; if (!day) return;
    const bl = day.blocks || {};
    Object.keys(bl).forEach(function (id) { const b = bl[id]; if (b && typeof b.t === 'number') blocks.push(Object.assign({}, b, { id: id, date: dayKey(b.t) })); });
    const rt = day.routes || {};
    Object.keys(rt).forEach(function (id) { const r = rt[id]; if (r) routes.push(Object.assign({}, r, { id: id })); });
  });
  blocks.sort(function (a, b) { return a.t - b.t; });
  const byDay = {};
  blocks.forEach(function (b) { (byDay[b.date] || (byDay[b.date] = [])).push(b); });
  D.blocks = blocks; D.routes = routes; D.byDay = byDay;
  D.todayK = dayKey(Date.now());
  D.today = byDay[D.todayK] || [];
  D.total = blocks.length;
  D.focusMin = blocks.reduce(function (s, b) { return s + (b.m || 15); }, 0);
  const used = {};
  blocks.forEach(function (b) { if (b.op) used[b.op] = (used[b.op] || 0) + 1; });
  D.used = used;
  const open = { 0: [], 1: [], 2: [], 3: [], 4: [] }, closed = [];
  const routines = [], rdone = [];
  Object.keys(S.ops).forEach(function (id) {
    const op = S.ops[id]; if (!op || !op.title) return;
    if (op.repeat) { routines.push(op); return; }
    if (op.status === 'closed') closed.push(op); else (open[tierOf(op)] || open[0]).push(op);
  });
  routines.sort(byCreated);
  routines.forEach(function (op) { Object.keys(op.doneOn || {}).forEach(function (k) { const t = op.doneOn[k]; if (typeof t === 'number') rdone.push({ id: op.id + '@' + k, closedAt: t, tier: 5, title: op.title, code: op.code, rt: true }); }); });
  D.routines = routines; D.rdone = rdone; D.doneTotal = closed.length + rdone.length;
  D.loggedMin = closed.reduce(function (s, o) { return s + ((o.debrief && o.debrief.mins) || 0); }, 0);
  open[0].sort(byCreated);
  open[1].sort(function (a, b) { return dueSort(a, b) || byCreated(a, b); });
  open[2].sort(function (a, b) { return dueSort(a, b) || byCreated(a, b); });
  open[3].sort(byEase); open[4].sort(byEase);
  closed.sort(function (a, b) { return (b.closedAt || 0) - (a.closedAt || 0); });
  D.open = open; D.closed = closed;
  let xp = 0;
  blocks.forEach(function (b) { xp += blockXP(b.m); });
  routes.forEach(function (r) { xp += routeXP(r.n); });
  closed.forEach(function (o) { xp += closeXP(o).total; });
  xp += rdone.length * 40;
  D.xp = xp;
  let ri = 0; for (let i = 0; i < RANKS.length; i++) if (xp >= RANKS[i][0]) ri = i;
  D.rank = { idx: ri, name: RANKS[ri][1], floor: RANKS[ri][0], next: RANKS[ri + 1] ? { xp: RANKS[ri + 1][0], name: RANKS[ri + 1][1] } : null };
  D.rank.pct = D.rank.next ? (xp - D.rank.floor) / (D.rank.next.xp - D.rank.floor) : 1;
  const act = Object.assign({}, byDay);
  closed.concat(rdone).forEach(function (o) { if (o.closedAt) act[dayKey(o.closedAt)] = [1]; });
  routes.forEach(function (x) { if (x.t) act[dayKey(x.t)] = [1]; });
  D.streak = currentStreak(act);
  D.longest = longestStreak(Object.keys(act));
  const n = new Date(), dow = (n.getDay() + 6) % 7;
  const mon = new Date(n.getFullYear(), n.getMonth(), n.getDate() - dow, 12);
  D.week = [];
  for (let i = 0; i < 7; i++) { const d = new Date(mon.getFullYear(), mon.getMonth(), mon.getDate() + i, 12); const k = dayKey(d.getTime()); D.week.push({ k: k, d: d, blocks: byDay[k] || [] }); }
  D.weekTotal = D.week.reduce(function (s, w) { return s + w.blocks.length; }, 0);
  D.weekFocus = D.week.reduce(function (s, w) { return s + w.blocks.reduce(function (a, b) { return a + (b.m || 15); }, 0); }, 0);
  const closesByDay = {};
  closed.concat(rdone).forEach(function (o) { if (o.closedAt) { const k = dayKey(o.closedAt); closesByDay[k] = (closesByDay[k] || 0) + 1; } });
  D.closesByDay = closesByDay;
  D.week.forEach(function (w) { w.done = closed.concat(rdone).filter(function (o) { return o.closedAt && dayKey(o.closedAt) === w.k; }).sort(function (a, b) { return a.closedAt - b.closedAt; }); });
  D.doneToday = closed.concat(rdone).filter(function (o) { return o.closedAt && dayKey(o.closedAt) === D.todayK; }).sort(function (a, b) { return a.closedAt - b.closedAt; });
  D.weekCloses = closed.filter(function (o) { return o.closedAt && dayKey(o.closedAt) >= D.week[0].k; }).length;
  const withUse = closed.filter(function (o) { return (o.used || 0) > 0; });
  D.avgBlocks = withUse.length ? withUse.reduce(function (s, o) { return s + o.used; }, 0) / withUse.length : null;
  D.badges = computeBadges(D);
  D.rec = recommend(D);
  D.hard = hardTarget(D);
  D.deadlines = [1, 2, 3, 4, 0].reduce(function (a, t) { return a.concat(open[t]); }, []).filter(function (o) { return isDate(o.due); }).sort(function (a, b) { return dueSort(a, b) || tierOf(a) - tierOf(b); });
  D.feedOpen = D.deadlines.filter(function (o) { return o.src === 'canvas'; }).length;
  return D;
}
function currentStreak(byDay) {
  const d = new Date(); d.setHours(12, 0, 0, 0);
  if (!byDay[dayKey(d.getTime())]) d.setDate(d.getDate() - 1);
  let n = 0;
  while (byDay[dayKey(d.getTime())]) { n++; d.setDate(d.getDate() - 1); }
  return n;
}
function longestStreak(keys) {
  if (!keys.length) return 0;
  const ts = keys.map(function (k) { return parseDay(k).getTime(); }).sort(function (a, b) { return a - b; });
  let best = 1, run = 1;
  for (let i = 1; i < ts.length; i++) { const diff = Math.round((ts[i] - ts[i - 1]) / 86400000); if (diff === 1) { run++; if (run > best) best = run; } else if (diff > 1) run = 1; }
  return best;
}
function computeBadges(D) {
  const b = {};
  b.first = D.doneTotal >= 1;
  b.b2b = false;
  for (let i = 1; i < D.blocks.length; i++) { const p = D.blocks[i - 1], c = D.blocks[i]; if (c.s && p.t && c.s >= p.t - 1000 && c.s - p.t <= 180000) { b.b2b = true; break; } }
  b.infil = D.routes.length >= 1;
  b.zero = D.routes.some(function (r) { return r.from === 'bed'; });
  b.quota = Object.keys(D.closesByDay).some(function (k) { return D.closesByDay[k] >= D.quota; });
  b.red = D.closed.some(function (o) { return o.tier === 1; });
  b.budget = D.closed.some(function (o) { return o.est > 0 && o.used > 0 && o.used < o.est; });
  b.sweep = Object.keys(D.closesByDay).some(function (k) { return D.closesByDay[k] >= 5; });
  b.dawn = D.closed.some(function (o) { if (!o.closedAt) return false; const h = new Date(o.closedAt).getHours(); return h >= 5 && h < 9; });
  b.triage = Object.keys(S.ops).filter(function (id) { const o = S.ops[id]; return o && o.src !== 'canvas' && (o.tier || 0) >= 1; }).length >= 10;
  b.iron = D.longest >= 7;
  b.hours = D.doneTotal >= 40;
  return b;
}
function recommend(D) {
  const all = D.open[1].concat(D.open[2], D.open[3], D.open[4]);
  if (!all.length) return null;
  const n = D.doneToday.length;
  if (n < 2) {
    const pool = D.open[4].concat(D.open[3]);
    const pick = (pool.length ? pool : all).slice().sort(byEase)[0];
    return { op: pick, why: n === 0 ? 'Cold start. Warm up on your lowest-friction op.' : 'Warm-up 2 of 2. One more easy op, then the hard stuff.' };
  }
  const last = D.today[D.today.length - 1];
  if (last && last.op) { const o = S.ops[last.op], lt = tierOf(o); if (o && o.status !== 'closed' && (lt === 1 || lt === 2)) return { op: o, why: 'Stay on target. Switching tiers costs momentum.' }; }
  const urgent = all.filter(isUrgent);
  if (urgent.length) return { op: urgent[0], why: 'Momentum built. Engage Critical.' };
  if (D.open[2].length) return { op: D.open[2][0], why: 'Momentum built. Burn down the nearest deadline.' };
  if (D.open[3].length) return { op: D.open[3][0], why: 'No fires. Clear grunt work while you are rolling.' };
  return { op: D.open[4][0], why: 'Board is clear. Sandbox time.' };
}
function hardTarget(D) {
  const all = D.open[1].concat(D.open[2], D.open[3], D.open[4]);
  const urgent = all.filter(isUrgent);
  return urgent[0] || D.open[2][0] || D.open[3].slice().sort(function (a, b) { return (b.res || 3) - (a.res || 3); })[0] || D.open[4][0] || D.open[0][0] || null;
}
function infilTargetId(D) {
  const t = ui.infil.target;
  if (t && S.ops[t] && S.ops[t].status !== 'closed') return t;
  const pool = [1, 2, 3, 4, 0].reduce(function (a, x) { return a.concat(D.open[x]); }, []);
  return D.hard ? D.hard.id : (pool[0] ? pool[0].id : null);
}
function buildRoute(posId, target, D) {
  const pos = POSITIONS.find(function (p) { return p.id === posId; });
  if (!pos || !target) return null;
  const th = opHeat(target);
  const steps = [{ kind: 'here', text: pos.label, heat: pos.heat }];
  let cur = pos.heat, direct = false;
  if (cur - th <= GAP_OK) direct = true;
  else {
    (ENV[posId] || []).forEach(function (e) { if (e.h < cur && cur - th > GAP_OK) { steps.push({ kind: 'env', text: e.t, heat: e.h }); cur = e.h; } });
    if (cur - th > GAP_OK) {
      const pool = D.open[4].concat(D.open[3]).filter(function (o) { return o.id !== target.id && opHeat(o) > th; }).sort(function (a, b) { return opHeat(b) - opHeat(a) || byEase(a, b); }).slice(0, 2);
      if (pool.length) pool.forEach(function (o) { const h = Math.min(opHeat(o), cur - 10); steps.push({ kind: 'op', op: o.id, text: o.title, code: o.code, heat: h }); cur = h; });
      else {
        const g1 = Math.min(cur - 10, th + 70), g2 = Math.min(g1 - 10, th + 35);
        steps.push({ kind: 'gen', text: 'Warm-up: tidy your desk for two minutes.', heat: g1 });
        steps.push({ kind: 'gen', text: 'Open everything the target needs: tabs, files, notes. Do not start it yet.', heat: g2 });
      }
    }
  }
  steps.push({ kind: 'target', op: target.id, text: target.title, code: target.code, heat: th });
  steps.forEach(function (s, i) { s.wp = NATO[i] || ('WP' + (i + 1)); });
  return { steps: steps, direct: direct };
}
function verdict(gap) {
  if (gap <= GAP_OK) return { cls: 'ok', label: 'GAP CLOSABLE', text: 'Direct entry authorized. Deploy straight on the target.' };
  if (gap <= 160) return { cls: 'warn', label: 'GAP WIDE', text: 'Jumping straight in will probably stall. Take a short downshift first.' };
  return { cls: 'crit', label: 'GAP CRITICAL', text: 'A direct jump will fail. Run the full infiltration route.' };
}

/* ================= SOUND ================= */
/* Everything is synthesized in the page: master gain → compressor → speakers. */
const AUDIO_DEF = { vol: .8, amb: 'off', voice: true, uisfx: true, alarm: 30 };
const NUMW = { 10: 'Ten', 15: 'Fifteen' };
const Sfx = {
  ctx: null, out: null, pending: [], sched: null, amb: null, ringing: false, ringT: 0, unlocked: false, last: 0, over: null, _keep: null, _nb: null, _ab: null, hold: null, lastKey: 0,
  enabled: function () { const o = this.over || S.hq; return !o || o.sound !== false; },
  opt: function (k) { const o = this.over || S.hq || {}; return o[k] == null ? AUDIO_DEF[k] : o[k]; },
  level: function () { const v = Number(this.opt('vol')); return this.enabled() ? Math.max(0, Math.min(1, isNaN(v) ? .8 : v)) : 0; },
  setLevel: function () { try { if (this.out) this.out.gain.setTargetAtTime(this.level(), this.ctx.currentTime, .03); } catch (e) {} },
  ensure: function () {
    try {
      if (!this.ctx) {
        const AC = window.AudioContext || window.webkitAudioContext, ua = navigator.userActivation;
        if (!AC || (ua && !ua.hasBeenActive)) return null;
        try { if (navigator.audioSession) navigator.audioSession.type = 'playback'; } catch (e) {}
        const c = new AC(), comp = c.createDynamicsCompressor(), g = c.createGain();
        comp.threshold.value = -18; comp.knee.value = 10; comp.ratio.value = 5; comp.attack.value = .003; comp.release.value = .25;
        g.gain.value = this.level(); g.connect(comp); comp.connect(c.destination);
        this.ctx = c; this.out = g;
        const self = this;
        c.onstatechange = function () { const u = c.state === 'running'; if (u !== self.unlocked) { self.unlocked = u; scheduleRender(); } };
      }
      if (this.ctx.state !== 'running' && this.ctx.state !== 'closed') { const p = this.ctx.resume(); if (p && p.catch) p.catch(function () {}); }
      this.unlocked = this.ctx.state === 'running';
    } catch (e) {}
    return this.ctx;
  },
  /* Only make sound when it will actually play now; a suspended clock would queue it into a burst later. */
  live: function () { const ua = navigator.userActivation; return !!this.ctx && (this.ctx.state === 'running' || !!(ua && ua.isActive)); },
  nb: function () {
    if (!this._nb) { const c = this.ctx, n = c.sampleRate * 2, b = c.createBuffer(1, n, c.sampleRate), d = b.getChannelData(0); for (let i = 0; i < n; i++) d[i] = Math.random() * 2 - 1; this._nb = b; }
    return this._nb;
  },
  filt: function (src, o, t, dur) {
    if (!(o.lp || o.hp || o.bp)) return src;
    const f = this.ctx.createBiquadFilter();
    f.type = o.lp ? 'lowpass' : o.hp ? 'highpass' : 'bandpass';
    f.frequency.setValueAtTime(o.lp || o.hp || o.bp, t);
    if (o.ff) f.frequency.exponentialRampToValueAtTime(o.ff, t + dur);
    if (o.q) f.Q.value = o.q;
    src.connect(f); return f;
  },
  env: function (node, v, t, dur, a) {
    const g = this.ctx.createGain();
    g.gain.setValueAtTime(.0001, t); g.gain.exponentialRampToValueAtTime(Math.max(.0002, v), t + (a || .004)); g.gain.exponentialRampToValueAtTime(.0001, t + dur);
    node.connect(g); g.connect(this.out); return g;
  },
  tone: function (f, t, dur, o) {
    o = o || {};
    const osc = this.ctx.createOscillator();
    osc.type = o.type || 'sine'; osc.frequency.setValueAtTime(f, t);
    if (o.f2) osc.frequency.exponentialRampToValueAtTime(o.f2, t + (o.glide || dur));
    this.env(this.filt(osc, o, t, dur), o.vol == null ? .2 : o.vol, t, dur, o.a);
    osc.start(t); osc.stop(t + dur + .05);
    if (this._keep) this._keep.push(osc);
    return osc;
  },
  noise: function (t, dur, o) {
    o = o || {};
    const s = this.ctx.createBufferSource(); s.buffer = this.nb(); s.loop = true;
    this.env(this.filt(s, o, t, dur), o.vol == null ? .15 : o.vol, t, dur, o.a);
    s.start(t, Math.random() * 1.5); s.stop(t + dur + .05);
    if (this._keep) this._keep.push(s);
    return s;
  },
  play: function (name, x) {
    if (!this.enabled() || !this.fx[name] || !this.ensure() || !this.live()) return;
    this.last = performance.now();
    try { this.fx[name].call(this, this.ctx.currentTime + .015, x); } catch (e) {}
  },
  ui: function (name) { if (this.opt('uisfx')) this.play(name); },
  key: function () { const n = performance.now(); if (n - this.lastKey > 28 && this.opt('uisfx')) { this.lastKey = n; this.play('key'); } },
  fx: {
    tap: function (t) { this.noise(t, .028, { vol: .1, bp: 3400, q: 1.4 }); this.tone(2300, t, .03, { type: 'square', vol: .03, lp: 5200 }); },
    key: function (t) { this.noise(t, .014, { vol: .07, hp: 2600 }); },
    tab: function (t) { this.tone(1500, t, .04, { type: 'square', vol: .05, lp: 4200 }); this.tone(2250, t + .055, .05, { type: 'square', vol: .05, lp: 4200 }); },
    open: function (t) { this.noise(t, .2, { vol: .08, bp: 800, ff: 3200, q: .9 }); this.tone(480, t, .16, { type: 'triangle', f2: 1100, vol: .09 }); },
    close: function (t) { this.noise(t, .16, { vol: .07, bp: 2800, ff: 700, q: .9 }); this.tone(1000, t, .13, { type: 'triangle', f2: 460, vol: .08 }); },
    blip: function (t) { this.tone(1320, t, .07, { type: 'square', vol: .05, lp: 5000 }); },
    info: function (t) { this.tone(1046.5, t, .12, { type: 'triangle', vol: .13 }); },
    good: function (t) { this.tone(880, t, .09, { type: 'triangle', vol: .13 }); this.tone(1318.5, t + .085, .2, { type: 'triangle', vol: .13 }); },
    warn: function (t) { this.tone(740, t, .1, { type: 'triangle', vol: .14 }); this.tone(740, t + .14, .1, { type: 'triangle', vol: .14 }); },
    error: function (t) { this.tone(116, t, .22, { type: 'square', vol: .12, lp: 900 }); this.tone(98, t + .25, .32, { type: 'square', vol: .12, lp: 900 }); },
    lock: function (t) { this.tone(600, t, .05, { type: 'square', vol: .05, lp: 3000 }); this.tone(900, t + .06, .08, { type: 'square', vol: .05, lp: 3000 }); },
    arm: function (t) { this.tone(150, t, .36, { type: 'sawtooth', f2: 1250, vol: .1, lp: 2400 }); this.tone(880, t + .38, .07, { type: 'square', vol: .08, lp: 4200 }); this.tone(1320, t + .47, .14, { type: 'square', vol: .08, lp: 4200 }); this.tone(95, t + .38, .32, { f2: 40, vol: .5 }); },
    count: function (t) { this.tone(1760, t, .07, { type: 'square', vol: .07, lp: 6000 }); },
    cue: function (t) { this.tone(987.77, t, .55, { type: 'triangle', vol: .17 }); this.tone(1318.5, t + .17, .8, { type: 'triangle', vol: .15 }); },
    alarm: function (t) { for (let i = 0; i < 3; i++) this.tone(1568, t + i * .15, .09, { type: 'square', vol: .1, lp: 4200 }); const self = this; [523.25, 659.25, 783.99, 1046.5].forEach(function (f) { self.tone(f, t + .5, .55, { type: 'triangle', vol: .09 }); }); this.tone(110, t + .5, .35, { f2: 45, vol: .45 }); },
    chime: function (t) { this.tone(659.25, t, 1.5, { vol: .2 }); this.tone(1318.5, t, 1, { vol: .06 }); this.tone(987.77, t + .28, 1.5, { vol: .17 }); },
    stamp: function (t) { this.tone(165, t, .24, { f2: 48, vol: .6 }); this.noise(t, .17, { vol: .32, lp: 2600 }); },
    xp: function (t) { this.tone(1318.5, t, .09, { type: 'square', vol: .055, lp: 6500 }); this.tone(1975.5, t + .08, .24, { type: 'square', vol: .055, lp: 6500 }); },
    shred: function (t) { this.noise(t, .6, { vol: .24, bp: 1600, ff: 5200, q: .6 }); this.tone(68, t, .55, { type: 'sawtooth', vol: .09, lp: 320 }); for (let i = 0; i < 6; i++) this.noise(t + .05 + i * .08, .03, { vol: .16, hp: 3000 }); },
    medal: function (t) { const self = this; [1046.5, 1318.5, 1568, 2093].forEach(function (f, i) { self.tone(f, t + i * .075, .4, { vol: .1 }); }); this.noise(t + .2, .5, { vol: .05, hp: 7000 }); },
    promo: function (t) { const self = this; [392, 523.25, 659.25, 783.99].forEach(function (f, i) { self.tone(f, t + i * .12, .5, { type: 'sawtooth', vol: .07, lp: 2800 }); }); [523.25, 659.25, 783.99, 1046.5].forEach(function (f) { self.tone(f, t + .5, 1.4, { type: 'sawtooth', vol: .05, lp: 2400 }); }); this.tone(70, t + .5, .8, { f2: 38, vol: .5 }); },
    abort: function (t) { this.tone(900, t, .7, { type: 'sawtooth', f2: 55, vol: .09, lp: 2200 }); },
    min: function (t) { this.noise(t, .26, { vol: .11, bp: 3200, ff: 420, q: .8 }); },
    max: function (t) { this.noise(t, .26, { vol: .11, bp: 420, ff: 3200, q: .8 }); this.tone(1320, t + .24, .06, { type: 'square', vol: .04, lp: 5000 }); },
    t0: function (t) { this.tone(990, t, .08, { type: 'triangle', vol: .1 }); },
    t1: function (t) { for (let i = 0; i < 3; i++) this.tone(1200, t + i * .085, .06, { type: 'square', vol: .075, lp: 5000 }); },
    t2: function (t) { this.tone(1500, t, .035, { type: 'square', vol: .07, lp: 5000 }); this.tone(1050, t + .14, .035, { type: 'square', vol: .07, lp: 5000 }); },
    t3: function (t) { this.tone(230, t, .14, { type: 'triangle', f2: 115, vol: .3 }); this.noise(t, .08, { vol: .12, lp: 700 }); },
    t4: function (t) { this.tone(1568, t, .14, { vol: .1 }); this.tone(2093, t + .07, .2, { vol: .09 }); },
    scan: function (t, h) { h = Number(h) || 0; this.tone(180, t, .4, { type: 'sawtooth', f2: 260 + (h + 60) * 4.2, vol: .07, lp: 2000 }); const n = Math.max(2, Math.round((h + 60) / 30)); for (let i = 0; i < n; i++) this.noise(t + .03 + Math.random() * .35, .012, { vol: .12, hp: 3200 }); },
    step: function (t, h) { const f = 240 + ((Number(h) || 0) + 60) * 3; this.tone(f * 1.33, t, .11, { type: 'triangle', vol: .14 }); this.tone(f, t + .11, .34, { type: 'triangle', vol: .14 }); },
    route: function (t) { this.noise(t, .09, { vol: .13, bp: 2100, q: 1 }); this.tone(1200, t + .09, .06, { type: 'square', vol: .06, lp: 4500 }); this.tone(1800, t + .16, .09, { type: 'square', vol: .06, lp: 4500 }); this.noise(t + .27, .07, { vol: .1, bp: 2600, q: 1 }); },
    breach: function (t) { this.tone(82, t, .65, { f2: 30, vol: .7 }); this.noise(t, .45, { vol: .36, lp: 1300, ff: 180 }); },
    data: function (t) { for (let i = 0; i < 10; i++) this.tone(700 + Math.random() * 1700, t + i * .045, .03, { type: 'square', vol: .035, lp: 5200 }); },
    incoming: function (t) { const p = [0, .12, .24, .46, .7]; for (let i = 0; i < p.length; i++) this.tone(1000, t + p[i], i === 3 ? .2 : .08, { vol: .14 }); }
  }
};
Object.assign(Sfx, {
  track: function (fn) { const keep = []; this._keep = keep; try { fn.call(this); } catch (e) {} this._keep = null; return keep; },
  reps: function (kind) { const secs = Number(this.opt('alarm')) || 0, per = kind === 'op' ? 2.2 : 3; return secs <= 0 ? 1 : Math.max(1, Math.ceil(secs / per)); },
  /* Pre-schedule cues, the last-10-seconds countdown and the first alarm cycles on the audio clock,
     so they land on time even while the tab sits in the background. */
  schedule: function (a) {
    this.cancel();
    const c = this.ensure(); if (!c || !this.enabled() || !this.live()) return;
    const lead = (a.end - Date.now()) / 1000; if (lead <= .5) return;
    const t0 = c.currentTime + lead, per = a.kind === 'op' ? 2.2 : 3, pre = Math.min(4, this.reps(a.kind));
    this.pending = this.track(function () {
      if (a.kind === 'op') {
        if (lead > 301) this.fx.cue.call(this, t0 - 300);
        if (lead > 61) this.fx.cue.call(this, t0 - 60);
        for (let k = 10; k >= 1; k--) if (lead - k > .3) this.fx.count.call(this, t0 - k);
      }
      for (let r = 0; r < pre; r++) (a.kind === 'op' ? this.fx.alarm : this.fx.chime).call(this, t0 + r * per);
    });
    this.sched = { start: a.start, t0: t0, pre: pre };
  },
  /* A window just ended: keep ringing for the chosen alarm length, or ring now if the clock slept. */
  ring: function (a) {
    const c = this.ensure();
    if (!c || !this.enabled() || c.state !== 'running') { this.sched = null; return; }
    const s = this.sched, now = c.currentTime, per = a.kind === 'op' ? 2.2 : 3, reps = this.reps(a.kind);
    let base = now + .05, first = 0;
    if (s && s.start === a.start && now >= s.t0 - .5 && now < s.t0 + reps * per) { base = s.t0; first = s.pre; }
    else this.cancel();
    const fx = a.kind === 'op' ? this.fx.alarm : this.fx.chime;
    this.pending = this.pending.concat(this.track(function () { for (let r = first; r < reps; r++) { const t = base + r * per; if (t >= now - .05) fx.call(this, t); } }));
    this.sched = null;
    this.ringing = true; clearTimeout(this.ringT);
    const self = this;
    this.ringT = setTimeout(function () { self.ringing = false; scheduleRender(); }, Math.max(.5, base + reps * per - now) * 1000);
  },
  silence: function () { const was = this.ringing; this.cancel(); this.ringing = false; clearTimeout(this.ringT); return was; },
  cancel: function () { this.pending.forEach(function (n) { try { n.stop(0); } catch (e) {} try { n.disconnect(); } catch (e) {} }); this.pending = []; this.sched = null; },
  ambBuf: function (mode) {
    const c = this.ctx, sr = c.sampleRate; this._ab = this._ab || {};
    if (this._ab[mode]) return this._ab[mode];
    let b;
    const click = function (d, off, f, amp) { const n = Math.floor(sr * .045); for (let i = 0; i < n && off + i < d.length; i++) d[off + i] += amp * Math.sin(2 * Math.PI * f * i / sr) * Math.exp(-i / (sr * .006)) + amp * .25 * (Math.random() * 2 - 1) * Math.exp(-i / (sr * .0015)); };
    if (mode === 'tick') { b = c.createBuffer(1, sr * 2, sr); const d = b.getChannelData(0); click(d, 0, 2100, .32); click(d, sr, 1550, .26); }
    else if (mode === 'sonar') {
      b = c.createBuffer(1, sr * 5, sr); const d = b.getChannelData(0), echo = Math.floor(sr * .5);
      for (let i = 0; i < sr * 2.4; i++) { d[i] = .3 * Math.sin(2 * Math.PI * 1150 * i / sr) * Math.exp(-i / (sr * .45)); const j = i - echo; if (j >= 0) d[i] += .1 * Math.sin(2 * Math.PI * 1150 * j / sr) * Math.exp(-j / (sr * .45)); }
    } else {
      const n = sr * 8, m = Math.floor(sr * .5), x = new Float32Array(n + m); let last = 0;
      for (let i = 0; i < n + m; i++) { last = (last + .02 * (Math.random() * 2 - 1)) / 1.02; x[i] = last * 3.2; }
      b = c.createBuffer(1, n, sr); const d = b.getChannelData(0);
      for (let i = 0; i < n; i++) d[i] = i < m ? x[i] * (i / m) + x[n + i] * (1 - i / m) : x[i];
    }
    this._ab[mode] = b; return b;
  },
  /* Background sound for an op window, looped and aligned so ticks land on the second the timer changes. */
  ambientStart: function (a) {
    this.ambientStop();
    const mode = this.opt('amb');
    if (!a || a.kind !== 'op' || mode === 'off' || !this.enabled()) return;
    const c = this.ensure(); if (!c || !this.live()) return;
    const rem = (a.end - Date.now()) / 1000; if (rem <= 1) return;
    try {
      const src = c.createBufferSource(), g = c.createGain();
      src.buffer = this.ambBuf(mode); src.loop = true; g.gain.value = mode === 'noise' ? .55 : .6;
      src.connect(g); g.connect(this.out);
      src.start(c.currentTime + ((a.end - Date.now()) % 1000) / 1000 + .005); src.stop(c.currentTime + rem);
      this.amb = { src: src, start: a.start };
    } catch (e) { this.amb = null; }
  },
  ambientStop: function () { if (this.amb) { try { this.amb.src.stop(0); } catch (e) {} try { this.amb.src.disconnect(); } catch (e) {} this.amb = null; } },
  pickVoice: function () {
    try {
      const vs = (window.speechSynthesis && window.speechSynthesis.getVoices()) || [];
      const en = vs.filter(function (v) { return /^en([-_]|$)/i.test(v.lang || ''); });
      const pref = [/Google UK English Male/i, /Microsoft (Guy|Andrew|Christopher|Eric|Brian|Davis|Ryan|Mark|David)/i, /\bDaniel\b/i, /\bAlex\b/i, /Google US English/i];
      for (let i = 0; i < pref.length; i++) { const v = en.find(function (x) { return pref[i].test(x.name); }); if (v) return v; }
      return en[0] || null;
    } catch (e) { return null; }
  },
  say: function () {
    return;
    try {
      const ss = window.speechSynthesis, ua = navigator.userActivation;
      if (!ss || typeof SpeechSynthesisUtterance === 'undefined' || (ua && !ua.hasBeenActive)) return;
      const u = new SpeechSynthesisUtterance(text), v = this.pickVoice();
      if (v) { u.voice = v; u.lang = v.lang; } else u.lang = 'en-US';
      u.rate = 1.04; u.pitch = .8; u.volume = Math.min(1, this.level() + .15);
      if (ss.speaking || ss.pending) ss.cancel();
      ss.speak(u);
    } catch (e) {}
  },
  sayLater: function (text, ms) { const self = this; setTimeout(function () { self.say(text); }, ms || 0); },
  holdStart: function () {
    this.holdStop(true);
    if (!this.enabled() || !this.ensure() || !this.live()) return;
    try {
      const c = this.ctx, o = c.createOscillator(), f = c.createBiquadFilter(), g = c.createGain(), t = c.currentTime;
      o.type = 'sawtooth'; o.frequency.setValueAtTime(180, t); o.frequency.exponentialRampToValueAtTime(900, t + 1.5);
      f.type = 'lowpass'; f.frequency.value = 1800;
      g.gain.setValueAtTime(.0001, t); g.gain.exponentialRampToValueAtTime(.08, t + .1);
      o.connect(f); f.connect(g); g.connect(this.out); o.start(t);
      this.hold = { o: o, g: g };
    } catch (e) { this.hold = null; }
  },
  holdStop: function (fast) {
    const h = this.hold; this.hold = null; if (!h) return;
    try { const t = this.ctx.currentTime; h.g.gain.cancelScheduledValues(t); h.g.gain.setValueAtTime(Math.max(.0002, h.g.gain.value), t); h.g.gain.exponentialRampToValueAtTime(.0001, t + (fast ? .02 : .12)); h.o.stop(t + .16); } catch (e) {}
  },
  /* First tap after a reload: browsers keep audio locked until then, so re-arm the running window. */
  unlock: function () {
    const was = this.unlocked;
    if (!this.ensure()) return;
    const a = S.hq && S.hq.active;
    if (a && a.end > Date.now() && this.enabled() && (!this.sched || this.sched.start !== a.start)) { this.schedule(a); this.ambientStart(a); }
    if (was !== this.unlocked) scheduleRender();
  },
  test: function (s, light) {
    this.over = Object.assign({}, S.hq || {}, s); this.setLevel();
    if (light) this.play('blip');
    else {
      this.silence();
      const c = this.ensure();
      if (c && this.enabled() && this.live()) this.pending = this.track(function () { this.fx.alarm.call(this, c.currentTime + .05); });
      this.say('Comms check. Audio online.');
    }
    const self = this; clearTimeout(this.testT);
    this.testT = setTimeout(function () { self.over = null; self.setLevel(); }, light ? 600 : 3000);
  }
});
let wake = null;
function holdWake() { try { if ('wakeLock' in navigator && document.visibilityState === 'visible') navigator.wakeLock.request('screen').then(function (w) { wake = w; }).catch(function () { wake = null; }); } catch (e) { wake = null; } }
function releaseWake() { try { if (wake) wake.release(); } catch (e) {} wake = null; }

/* ================= POP-OUT TIMER (Picture-in-Picture) ================= */
/* The widget is a canvas streamed into a hidden video; the browser floats that video above every window. */
Object.assign(ICON, {
  fsOn: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3.5 9V3.5H9M15 3.5h5.5V9M20.5 15v5.5H15M9 20.5H3.5V15" fill="none" stroke="currentColor" stroke-width="1.9"/></svg>',
  fsOff: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 3.5V9H3.5M20.5 9H15V3.5M15 20.5V15h5.5M3.5 15H9v5.5" fill="none" stroke="currentColor" stroke-width="1.9"/></svg>',
  snd: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3.5 9.5h4l5-4v13l-5-4h-4z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/><path d="M16 9a4 4 0 0 1 0 6M18.5 6.5a7.5 7.5 0 0 1 0 11" fill="none" stroke="currentColor" stroke-width="1.8"/></svg>',
  mute: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3.5 9.5h4l5-4v13l-5-4h-4z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/><path d="M16 9.5l5 5M21 9.5l-5 5" stroke="currentColor" stroke-width="1.8"/></svg>',
  pip: '<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="2.5" y="4.5" width="19" height="15" fill="none" stroke="currentColor" stroke-width="1.8"/><rect x="12" y="11.5" width="7" height="5.5" fill="currentColor"/></svg>'
});
const TIERHEX = { 0: '#9aa3ad', 1: '#ec6a72', 2: '#e3a857', 3: '#7ea6e6', 4: '#ad94e8', 5: '#4cc9b0' };
function pipState() {
  const a = S.hq && S.hq.active, D = lastD;
  const st = { kind: 'idle', color: '#4cc9b0', label: 'STANDBY', time: 'READY', frac: 0, title: '', sub: 'OP WINDOW IS OPTIONAL', mins: 15 };
  if (a) {
    const rem = Math.max(0, a.end - Date.now());
    st.kind = a.kind; st.mins = a.mins || 15; st.frac = rem / (st.mins * 60000); st.time = fmtMS(rem);
    if (a.kind === 'op') { st.color = TIERHEX[a.tier || 0]; st.label = 'OP WINDOW · ' + st.mins + ' MIN'; st.title = a.title; st.sub = a.code ? 'OPERATION ' + a.code : 'UNASSIGNED WINDOW'; }
    else { st.label = 'STAND DOWN · BREAK'; st.title = 'Low-stim break. Phone face down.'; st.sub = 'REDEPLOY WHEN IT ENDS'; }
  } else if (ui.overlay === 'secured' && ui.secured) {
    st.kind = 'secured'; st.color = TIERHEX[ui.secured.tier || 0]; st.label = 'WINDOW SECURED'; st.time = '+' + ui.secured.xp + ' XP'; st.title = ui.secured.title; st.sub = 'DEPLOY AGAIN OR STAND DOWN';
  } else if (ui.overlay === 'breakdone') {
    st.kind = 'breakdone'; st.label = 'BREAK OVER'; st.time = 'GO'; st.title = 'Time to redeploy.'; st.sub = '';
  } else { const r = D && D.rec; st.title = r ? opLabel(r.op) : 'No ops on the board.'; }
  st.today = D ? D.doneToday : []; st.quota = D ? D.quota : 4; st.ring = Sfx.ringing;
  return st;
}
function wrapLines(cx, text, maxW, max) {
  const words = String(text || '').split(/\s+/).filter(Boolean), lines = [];
  let cur = '', i = 0;
  for (; i < words.length; i++) {
    const t = cur ? cur + ' ' + words[i] : words[i];
    if (cx.measureText(t).width <= maxW || !cur) cur = t;
    else { lines.push(cur); cur = words[i]; if (lines.length === max) break; }
  }
  if (lines.length < max && cur) { lines.push(cur); cur = ''; i = words.length; }
  if (i < words.length || cur) { let l = lines[max - 1] || ''; while (l && cx.measureText(l + '…').width > maxW) l = l.slice(0, -1); lines[max - 1] = l + '…'; }
  return lines.slice(0, max).map(function (l) { let x = l; while (x.length > 1 && cx.measureText(x).width > maxW) x = x.slice(0, -2) + '…'; return x; });
}
const Pip = {
  v: null, cv: null, cx: null, track: null, active: false, key: '',
  able: function () { try { return !!(document.pictureInPictureEnabled && HTMLVideoElement.prototype.requestPictureInPicture && HTMLCanvasElement.prototype.captureStream); } catch (e) { return false; } },
  prepare: function () {
    if (this.v) return true;
    if (!this.able()) return false;
    try {
      const cv = document.createElement('canvas'); cv.width = 640; cv.height = 360;
      this.cv = cv; this.cx = cv.getContext('2d'); this.draw(true);
      const st = cv.captureStream(12); this.track = st.getVideoTracks()[0] || null;
      const v = document.createElement('video'), self = this;
      v.muted = true; v.playsInline = true; v.autoplay = true; v.setAttribute('playsinline', ''); v.setAttribute('aria-hidden', 'true'); v.tabIndex = -1; v.className = 'pipvid';
      v.srcObject = st;
      v.addEventListener('enterpictureinpicture', function () { self.active = true; self.draw(true); scheduleRender(); });
      v.addEventListener('leavepictureinpicture', function () { self.active = false; scheduleRender(); });
      v.addEventListener('pause', function () { if (self.active) v.play().catch(function () {}); });
      document.body.appendChild(v); this.v = v;
      v.play().catch(function () {});
      try { if (document.fonts && document.fonts.load) Promise.all([document.fonts.load('700 90px "IBM Plex Mono"'), document.fonts.load('600 22px "IBM Plex Sans"')]).then(function () { self.draw(true); }).catch(function () {}); } catch (e) {}
      return true;
    } catch (e) { this.v = null; return false; }
  },
  toggle: function () {
    try { if (document.pictureInPictureElement) { document.exitPictureInPicture().catch(function () {}); Sfx.ui('min'); return; } } catch (e) {}
    if (!this.prepare()) { ui.modal = 'pipfail'; Sfx.play('warn'); render(); return; }
    if (this.v.readyState < 1) { this.v.play().catch(function () {}); toast('Pop-out warming up', 'Tap POP OUT again in a second.', 'info'); return; }
    this.draw(true);
    try { this.v.play().catch(function () {}); } catch (e) {}
    this.v.requestPictureInPicture().then(function () {
      Sfx.play('max');
      toast('Timer popped out', 'Drag it anywhere. It stays on top of every window.', 'good');
    }).catch(function (e) { console.warn('[zerogap] pop-out refused', e && e.name); ui.modal = 'pipfail'; Sfx.play('warn'); render(); });
  },
  draw: function (force) {
    const cx = this.cx; if (!cx) return;
    const s = pipState(), blink = Math.floor(Date.now() / 500) % 2 === 0, flash = s.ring && blink;
    const key = [s.kind, s.time, s.label, s.title, s.color, s.today.length, s.quota, flash, Math.round(s.frac * 720), blink && s.kind === 'op'].join('|');
    if (!force && key === this.key) return;
    this.key = key;
    const W = 640, H = 360, mono = '"IBM Plex Mono", ui-monospace, Menlo, Consolas, monospace', ui1 = '"IBM Plex Sans", "Segoe UI", system-ui, sans-serif';
    cx.fillStyle = '#07090c'; cx.fillRect(0, 0, W, H);
    cx.strokeStyle = 'rgba(76,201,176,0.05)'; cx.lineWidth = 1; cx.beginPath();
    for (let x = 0; x <= W; x += 24) { cx.moveTo(x + .5, 0); cx.lineTo(x + .5, H); }
    for (let y = 0; y <= H; y += 24) { cx.moveTo(0, y + .5); cx.lineTo(W, y + .5); }
    cx.stroke();
    if (flash) { cx.fillStyle = 'rgba(76,201,176,0.12)'; cx.fillRect(0, 0, W, H); }
    const bw = flash ? 12 : 4; cx.strokeStyle = flash ? '#4cc9b0' : s.color; cx.lineWidth = bw; cx.strokeRect(bw / 2, bw / 2, W - bw, H - bw);
    const X = 172, Y = 180, R = 128;
    cx.strokeStyle = '#2f3a47'; cx.lineWidth = 2; cx.beginPath(); cx.arc(X, Y, R + 12, 0, Math.PI * 2); cx.stroke();
    const every = s.mins === 10 ? 6 : 4;
    for (let i = 0; i < 60; i++) {
      const ang = i / 60 * Math.PI * 2 - Math.PI / 2, mj = i % every === 0, r1 = mj ? R + 16 : R + 21, r2 = R + 27;
      cx.strokeStyle = mj ? '#ece7db' : '#2f3a47'; cx.lineWidth = mj ? 3 : 1.5;
      cx.beginPath(); cx.moveTo(X + r1 * Math.cos(ang), Y + r1 * Math.sin(ang)); cx.lineTo(X + r2 * Math.cos(ang), Y + r2 * Math.sin(ang)); cx.stroke();
    }
    cx.fillStyle = '#0a0e13'; cx.beginPath(); cx.arc(X, Y, R, 0, Math.PI * 2); cx.fill();
    if (s.frac > .0005) { cx.fillStyle = s.color; cx.globalAlpha = .92; cx.beginPath(); cx.moveTo(X, Y); cx.arc(X, Y, R - 3, -Math.PI / 2, -Math.PI / 2 + Math.min(1, s.frac) * Math.PI * 2); cx.closePath(); cx.fill(); cx.globalAlpha = 1; }
    cx.strokeStyle = 'rgba(255,255,255,0.08)'; cx.lineWidth = 1; cx.beginPath(); cx.moveTo(X - R, Y); cx.lineTo(X + R, Y); cx.moveTo(X, Y - R); cx.lineTo(X, Y + R); cx.stroke();
    cx.fillStyle = '#07090c'; cx.beginPath(); cx.arc(X, Y, 34, 0, Math.PI * 2); cx.fill(); cx.strokeStyle = s.color; cx.lineWidth = 2.5; cx.stroke();
    const RX = 334, RW = W - RX - 26;
    try { cx.letterSpacing = '2px'; } catch (e) {}
    cx.textAlign = 'left'; cx.textBaseline = 'alphabetic';
    cx.font = '700 16px ' + mono; cx.fillStyle = s.color;
    cx.fillText(((s.kind === 'op' && blink) || s.kind !== 'op' ? '● ' : '  ') + s.label, RX, 66);
    try { cx.letterSpacing = '0px'; } catch (e) {}
    cx.fillStyle = '#ece7db';
    let fs = s.time.length <= 5 ? 96 : 64; cx.font = '700 ' + fs + 'px ' + mono;
    while (cx.measureText(s.time).width > RW && fs > 30) { fs -= 4; cx.font = '700 ' + fs + 'px ' + mono; }
    cx.fillText(s.time, RX - 4, 168);
    cx.font = '600 23px ' + ui1; cx.fillStyle = '#ece7db';
    wrapLines(cx, s.title, RW, 2).forEach(function (l, i) { cx.fillText(l, RX, 212 + i * 28); });
    try { cx.letterSpacing = '1.5px'; } catch (e) {}
    cx.font = '600 12px ' + mono; cx.fillStyle = '#8f98a3';
    if (s.sub) cx.fillText(wrapLines(cx, s.sub, RW, 1)[0] || '', RX, 284);
    try { cx.letterSpacing = '0px'; } catch (e) {}
    const n = Math.max(s.quota, s.today.length), cell = 14, gap = 5, fit = Math.max(1, Math.floor((RW - 70) / (cell + gap))), show = Math.min(n, fit);
    for (let i = 0; i < show; i++) {
      const b = s.today[i], x = RX + i * (cell + gap), y = 304;
      if (b) { cx.fillStyle = TIERHEX[b.tier || 0]; cx.fillRect(x, y, cell, cell); }
      else { cx.strokeStyle = '#2f3a47'; cx.lineWidth = 1.5; cx.strokeRect(x + .75, y + .75, cell - 1.5, cell - 1.5); }
    }
    cx.font = '700 13px ' + mono; cx.fillStyle = '#8f98a3'; cx.fillText(s.today.length + '/' + s.quota, RX + show * (cell + gap) + 6, 316);
    cx.font = '600 11px ' + mono; cx.fillStyle = '#5d6773'; cx.textAlign = 'right'; cx.fillText('ZERØ GAP', W - 18, H - 16);
    try { if (this.track && this.track.requestFrame) this.track.requestFrame(); } catch (e) {}
  }
};

/* ================= STORAGE ================= */
function clean(o) { return JSON.parse(JSON.stringify(o)); }
function saveErr(e) {
  console.warn('[zerogap] save failed', e);
  const code = e && e.code;
  if (code === 'quota_exceeded') toast('Storage full', 'Shred old closed ops in the archive, then try again.', 'bad');
  else if (code === 'resource_exhausted') toast('Too many saves at once', 'Wait a few seconds, then try again.', 'bad');
  else if (code === 'revoked') toast('Access changed', 'Reload the page to reconnect.', 'bad');
  else if (code === 'invalid_argument') toast('Save rejected', 'This terminal is read-only for you.', 'bad');
  else toast('Save failed', 'The connection dropped. Try that again.', 'bad');
}
const pend = { hq: 0, feed: 0, ops: new Map(), days: new Map(), cal: new Map(), notes: new Map() };
function bump(map, key, d) { const n = (map.get(key) || 0) + d; if (n <= 0) map.delete(key); else map.set(key, n); }
const gate = { n: 0, q: [] };
function slot() { if (gate.n < 6) { gate.n++; return Promise.resolve(); } return new Promise(function (r) { gate.q.push(r); }).then(function () { gate.n++; }); }
function unslot() { gate.n--; const w = gate.q.shift(); if (w) w(); }
const pathQ = new Map();
function queue(path, fn) {
  const prev = pathQ.get(path) || Promise.resolve();
  const run = function () { return slot().then(function () { return Promise.resolve().then(fn).finally(unslot); }); };
  const p = prev.then(run, run);
  pathQ.set(path, p.catch(function () {}));
  return p;
}
function retry(fn) { return fn().catch(function (e) { if (e && e.code === 'unavailable') return sleep(500 + Math.random() * 800).then(fn); throw e; }); }

/* Writes that fail for lack of a connection wait in an outbox on this device and replay once it is back. */
const OB_KEY = 'zerogap.outbox.v1';
const OB = { m: {}, warned: false, busy: false };
try { const raw = localStorage.getItem(OB_KEY); if (raw) OB.m = JSON.parse(raw) || {}; } catch (e) { OB.m = {}; }
function obSave() { try { localStorage.setItem(OB_KEY, JSON.stringify(OB.m)); } catch (e) {} }
function obCount() { return Object.keys(OB.m).length; }
function netErr(e) { const c = e && e.code; return !c || c === 'unavailable' || c === 'timeout'; }
function withTimeout(p, ms) { let t = 0; return Promise.race([p, new Promise(function (_, rej) { t = setTimeout(function () { rej({ code: 'timeout', message: 'no answer' }); }, ms); })]).finally(function () { clearTimeout(t); }); }
function offlineNote() { if (OB.warned) return; OB.warned = true; toast('Offline · saved on this device', 'Keep going. Changes sync when you reconnect.', 'warn'); }
function mergeDay(a, b) {
  const r = clone(a) || {};
  if (b && b.date) r.date = b.date;
  ['blocks', 'routes'].forEach(function (f) { if (b && b[f]) r[f] = Object.assign({}, r[f] || {}, b[f]); });
  return r;
}
function DbStore(db) {
  const logCol = db.collection('log'), sgCol = db.collection('suggest');
  const hqRef = db.doc('hq/state'), feedRef = db.doc('feed/state'), opsCol = db.collection('ops'), calCol = db.collection('cal'), noteCol = db.collection('notes');
  const unsubs = {};
  const fail = function (what) {
    return function (e) {
      const code = e && e.code;
      console.warn('[zerogap] listener ended', what, code);
      if (code === 'unavailable') { setTimeout(function () { sub[what](); }, 2000); return; }
      if (!S.ready) { stopAll(); useLocal('offline'); return; }
      toast('Uplink lost', 'Reload the page to reconnect.', 'bad');
    };
  };
  const overlay = function (col, m, withId) {
    Object.keys(OB.m).forEach(function (k) {
      const op = OB.m[k]; if (!op || op.col !== col) return;
      if (op.t === 'del') delete m[op.id];
      else if (col === 'log') m[op.id] = mergeDay(m[op.id], op.body);
      else m[op.id] = withId ? Object.assign(clone(op.body), { id: op.id }) : clone(op.body);
    });
  };
  const single = function (key) { const op = OB.m[key]; return op ? { v: op.t === 'del' ? null : clone(op.body) } : null; };
  const sub = {
    hq: function () {
      unsubs.hq = hqRef.onSnapshot(function (snap) {
        if (!snap.exists && snap.metadata && snap.metadata.fromCache) return;
        const ob = single('hq/state');
        if (ob) S.hq = ob.v; else if (pend.hq <= 0) S.hq = snap.exists ? clone(snap.data()) : null;
        S.hqKnown = true; onData();
      }, fail('hq'));
    },
    feed: function () {
      unsubs.feed = feedRef.onSnapshot(function (snap) {
        if (!snap.exists && snap.metadata && snap.metadata.fromCache) return;
        const ob = single('feed/state');
        if (ob) S.feed = ob.v; else if (pend.feed <= 0) S.feed = snap.exists ? clone(snap.data()) : null;
        onData();
      }, function (e) { console.warn('[zerogap] feed listener ended', e && e.code); });
    },
    ops: function () {
      unsubs.ops = opsCol.onSnapshot(function (qs) {
        const m = {};
        qs.docs.forEach(function (d) { if (d.exists) m[d.id] = Object.assign(clone(d.data()), { id: d.id }); });
        pend.ops.forEach(function (_, id) { if (S.ops[id]) m[id] = S.ops[id]; else delete m[id]; });
        overlay('ops', m, true);
        S.ops = m; S.opsKnown = true; onData();
      }, fail('ops'));
    },
    sugg: function () {
      unsubs.sugg = sgCol.onSnapshot(function (qs) {
        const a = [];
        qs.docs.forEach(function (d) { if (d.exists) a.push(Object.assign(clone(d.data()), { id: d.id })); });
        S.sugg = a; scheduleRender();
      }, function (e) { console.warn('[zerogap] suggestions listener ended', e && e.code); });
    },
    cal: function () {
      unsubs.cal = calCol.onSnapshot(function (qs) {
        const m = {};
        qs.docs.forEach(function (d) { if (d.exists) m[d.id] = clone(d.data()); });
        pend.cal.forEach(function (_, id) { if (S.cals[id]) m[id] = S.cals[id]; else delete m[id]; });
        overlay('cal', m, false);
        S.cals = m; S.calKnown = true; scheduleRender();
      }, function (e) { console.warn('[zerogap] schedule listener ended', e && e.code); S.calKnown = true; scheduleRender(); });
    },
    notes: function () {
      unsubs.notes = noteCol.onSnapshot(function (qs) {
        const m = {};
        qs.docs.forEach(function (d) { if (d.exists) m[d.id] = Object.assign(clone(d.data()), { id: d.id }); });
        pend.notes.forEach(function (_, id) { if (S.notes[id]) m[id] = S.notes[id]; else delete m[id]; });
        overlay('notes', m, true);
        S.notes = m; S.notesKnown = true; scheduleRender();
      }, function (e) { console.warn('[zerogap] notes listener ended', e && e.code); S.notesKnown = true; scheduleRender(); });
    },
    log: function () {
      unsubs.log = logCol.orderBy('date', 'desc').limit(800).onSnapshot(function (qs) {
        const m = {}, docs = new Set();
        qs.docs.forEach(function (d) { if (d.exists) { m[d.id] = clone(d.data()); docs.add(d.id); } });
        pend.days.forEach(function (_, k) { if (S.days[k]) m[k] = S.days[k]; else delete m[k]; });
        overlay('log', m, false);
        S.days = m; S.dayDocs = docs; S.logKnown = true; onData();
      }, fail('log'));
    }
  };
  function stopAll() { Object.keys(unsubs).forEach(function (k) { try { unsubs[k](); } catch (e) {} }); }
  const raw = function (op) {
    const r = db.collection(op.col).doc(op.id);
    if (op.t === 'del') return r.delete();
    if (op.col === 'log') { const body = mergeDay(S.days[op.id], op.body); body.date = op.id; return r.set(clean(body)); }
    return r.set(op.body);
  };
  /* One full-document write (set or delete). A newer write to the same path supersedes anything waiting in the outbox. */
  function write(op, mark, onErr) {
    const key = op.col + '/' + op.id;
    mark(1);
    return queue(key, function () { return withTimeout(retry(function () { return raw(op); }), 15000); })
      .then(function () { if (OB.m[key]) { delete OB.m[key]; obSave(); scheduleRender(); } })
      .catch(function (e) {
        if (netErr(e)) { OB.m[key] = op; obSave(); offlineNote(); scheduleRender(); return; }
        (onErr || saveErr)(e);
      })
      .finally(function () { mark(-1); });
  }
  const mHQ = function (d) { pend.hq += d; }, mFeed = function (d) { pend.feed += d; };
  const mMap = function (map, id) { return function (d) { bump(map, id, d); }; };
  function flush() {
    if (OB.busy || !obCount()) return;
    OB.busy = true;
    let ok = 0;
    Promise.all(Object.keys(OB.m).map(function (key) {
      return queue(key, function () {
        const op = OB.m[key]; if (!op) return null;
        return withTimeout(raw(op), 15000).then(function () { if (OB.m[key] === op) delete OB.m[key]; ok++; });
      }).catch(function (e) { if (!netErr(e)) { delete OB.m[key]; saveErr(e); } });
    })).then(function () {
      OB.busy = false; obSave();
      if (!obCount()) { OB.warned = false; if (ok) toast('Back online', ok + (ok === 1 ? ' change' : ' changes') + ' synced.', 'good'); }
      scheduleRender();
    });
  }
  return {
    kind: 'db',
    flush: flush,
    subscribe: function () { sub.hq(); sub.ops(); sub.log(); sub.feed(); sub.sugg(); sub.cal(); sub.notes(); setTimeout(flush, 1500); },
    setHQ: function (obj) { return write({ t: 'set', col: 'hq', id: 'state', body: clean(obj) }, mHQ); },
    deleteHQ: function () { return write({ t: 'del', col: 'hq', id: 'state' }, mHQ); },
    setFeed: function (obj) { return write({ t: 'set', col: 'feed', id: 'state', body: clean(obj) }, mFeed); },
    deleteFeed: function () { return write({ t: 'del', col: 'feed', id: 'state' }, mFeed); },
    putOp: function (op) { const body = clean(op); delete body.id; return write({ t: 'set', col: 'ops', id: op.id, body: body }, mMap(pend.ops, op.id)); },
    deleteOp: function (id) { return write({ t: 'del', col: 'ops', id: id }, mMap(pend.ops, id)); },
    putNote: function (n) { const body = clean(n); delete body.id; return write({ t: 'set', col: 'notes', id: n.id, body: body }, mMap(pend.notes, n.id)); },
    deleteNote: function (id) { return write({ t: 'del', col: 'notes', id: id }, mMap(pend.notes, id)); },
    putCal: function (id, doc) { return write({ t: 'set', col: 'cal', id: id, body: clean(doc) }, mMap(pend.cal, id), function (e) { if (e && e.code === 'invalid_argument') toast('Calendar too big to save', 'Export a smaller calendar from Proton and try again.', 'bad'); else saveErr(e); }); },
    deleteCal: function (id) { return write({ t: 'del', col: 'cal', id: id }, mMap(pend.cal, id)); },
    addToDay: function (date, field, id, entry) {
      const ref = logCol.doc(date), e2 = clean(entry), key = 'log/' + date;
      bump(pend.days, date, 1);
      return queue(key, function () {
        const viaSet = function () { const base = clone(S.days[date]) || {}; base.date = date; base[field] = Object.assign({}, base[field] || {}, { [id]: e2 }); return retry(function () { return ref.set(base); }); };
        let p;
        if (!S.dayDocs.has(date)) p = viaSet();
        else {
          const patch = {}; patch[field] = {}; patch[field][id] = e2;
          p = retry(function () { return ref.update(patch); }).catch(function (err) { if (err && err.code === 'invalid_argument') return viaSet(); throw err; });
        }
        return withTimeout(p, 15000);
      }).catch(function (e) {
        if (!netErr(e)) { saveErr(e); return; }
        const prev = OB.m[key], body = mergeDay(prev && prev.body, { date: date });
        body[field] = Object.assign({}, body[field] || {}, { [id]: e2 });
        OB.m[key] = { t: 'set', col: 'log', id: date, body: body }; obSave(); offlineNote(); scheduleRender();
      }).finally(function () { bump(pend.days, date, -1); });
    },
    dropSugg: function (id) { S.sugg = S.sugg.filter(function (x) { return x.id !== id; }); return queue('suggest/' + id, function () { return retry(function () { return sgCol.doc(id).delete(); }); }).catch(saveErr); },
    deleteDay: function (date) { return write({ t: 'del', col: 'log', id: date }, mMap(pend.days, date)); }
  };
}
function LocalStore(key, seed) {
  const KEY = key || 'zerogap.v1';
  const norm = function (p) { p = p || {}; return { hq: p.hq || null, ops: p.ops || {}, log: p.log || {}, feed: p.feed || null, cal: p.cal || {}, notes: p.notes || {}, copyId: p.copyId || '' }; };
  let data = norm(null), warned = false;
  try { const raw = localStorage.getItem(KEY); if (raw) { const p = JSON.parse(raw); if (p && typeof p === 'object') data = norm(p); } } catch (e) {}
  const persist = function () {
    try { localStorage.setItem(KEY, JSON.stringify(data)); }
    catch (e) { if (!warned) { warned = true; toast('Browser storage is full', 'Recent changes may not survive a reload. Export changes now.', 'bad'); } }
  };
  if (seed && data.copyId !== seed.copyId) { data = norm(clone(seed.data)); data.copyId = seed.copyId; persist(); }
  const withIds = function (o) { const m = {}; Object.keys(o || {}).forEach(function (id) { m[id] = Object.assign(clone(o[id]), { id: id }); }); return m; };
  const emit = function () {
    S.hq = clone(data.hq);
    S.ops = withIds(data.ops); S.notes = withIds(data.notes);
    S.days = clone(data.log); S.dayDocs = new Set(Object.keys(data.log)); S.feed = clone(data.feed);
    S.cals = clone(data.cal) || {}; S.calKnown = true; S.notesKnown = true;
    S.hqKnown = S.opsKnown = S.logKnown = true; onData();
  };
  const done = function () { persist(); emit(); return Promise.resolve(); };
  const strip = function (o) { const b = clone(o); delete b.id; return b; };
  return {
    kind: 'local',
    subscribe: emit,
    dump: function () { const d = clone(data); delete d.copyId; return d; },
    replaceAll: function (d) { const cid = data.copyId; data = norm(clone(d)); data.copyId = cid; return done(); },
    setHQ: function (obj) { data.hq = clone(obj); return done(); },
    deleteHQ: function () { data.hq = null; return done(); },
    setFeed: function (obj) { data.feed = clone(obj); return done(); },
    deleteFeed: function () { data.feed = null; return done(); },
    putOp: function (op) { data.ops[op.id] = strip(op); return done(); },
    deleteOp: function (id) { delete data.ops[id]; return done(); },
    putNote: function (n) { data.notes[n.id] = strip(n); return done(); },
    deleteNote: function (id) { delete data.notes[id]; return done(); },
    putCal: function (id, doc) { data.cal[id] = clone(doc); return done(); },
    deleteCal: function (id) { delete data.cal[id]; return done(); },
    addToDay: function (date, field, id, entry) { const d = data.log[date] || (data.log[date] = { date: date }); const f = Object.assign({}, d[field] || {}); f[id] = clone(entry); d[field] = f; return done(); },
    deleteDay: function (date) { delete data.log[date]; return done(); },
    dropSugg: function () { return Promise.resolve(); }
  };
}
function useLocal(why) { S.mode = 'local'; S.why = why; store = LocalStore(); store.subscribe(); }
function connect() {
  if (SEED) { S.mode = 'local'; S.why = 'copy'; store = LocalStore('zerogap.copy.v1', SEED); store.subscribe(); return; }
  const host = window.claude && typeof window.claude.use === 'function';
  if (!host) { useLocal('app'); return; }
  Promise.all([
    window.claude.use('db').catch(function () { return null; }),
    window.claude.use('user').catch(function () { return null; })
  ]).then(function (res) {
    const db = res[0], user = res[1];
    if (!db) { useLocal('offline'); return; }
    const ownerCheck = user ? user.isOwner().catch(function () { return true; }) : Promise.resolve(true);
    return ownerCheck.then(function (owner) {
      if (user && owner === false) { useLocal('guest'); return; }
      S.mode = 'db'; store = DbStore(db); store.subscribe();
    });
  }).catch(function () { useLocal('offline'); });
}
function onData() {
  if (!S.ready && S.hqKnown && S.opsKnown && S.logKnown) {
    S.ready = true;
    if (S.hq && S.hq.defMins === 10) ui.mins = 10;
  }
  scheduleAuto(); scheduleRem();
  if (Sfx.amb && Sfx.opt('amb') === 'off') Sfx.ambientStop();
  scheduleRender();
}
let rq = 0;
function scheduleRender() { if (rq) return; rq = requestAnimationFrame(function () { rq = 0; render(); }); }

/* ================= MUTATIONS ================= */
function patchHQ(patch) { const next = Object.assign({}, S.hq || {}, patch); S.hq = next; return store.setHQ(next); }
function saveOp(op) { const m = Object.assign({}, S.ops); m[op.id] = op; S.ops = m; return store.putOp(op); }
function removeOp(id) { const m = Object.assign({}, S.ops); delete m[id]; S.ops = m; return store.deleteOp(id); }
function addLocalDay(k, field, id, entry) {
  const day = Object.assign({ date: k }, clone(S.days[k]) || {});
  const f = Object.assign({}, day[field] || {}); f[id] = entry; day[field] = f;
  const m = Object.assign({}, S.days); m[k] = day; S.days = m;
}
function newOp(title, tier, created) { return { id: uid('o'), title: title, tier: tier || 0, res: 3, est: 0, due: '', code: codename(), status: 'open', created: created || Date.now(), closedAt: null, used: null }; }

function startWindow(opId, mins) {
  const cur = S.hq && S.hq.active;
  if (cur && cur.end > Date.now()) { ui.minimized = false; render(); return; }
  const op = opId ? S.ops[opId] : null;
  const now = Date.now();
  const a = { kind: 'op', opId: op ? op.id : null, mins: mins === 10 ? 10 : 15, start: now, end: now + (mins === 10 ? 10 : 15) * 60000, tier: op ? tierOf(op) : 0, title: op ? opLabel(op) : 'Unassigned window', code: op ? op.code : '' };
  completing = null;
  patchHQ({ active: a });
  ui.overlay = null; ui.secured = null; ui.minimized = false;
  if (ui.modal !== 'promo') ui.modal = null;
  Sfx.ensure(); Sfx.silence(); Sfx.play('arm'); Sfx.schedule(a); Sfx.ambientStart(a);
  Sfx.sayLater('Window armed. ' + NUMW[a.mins] + ' minutes.', 800);
  holdWake();
  render();
}
function startBreak(opId) {
  const now = Date.now();
  const a = { kind: 'break', opId: opId || null, mins: 15, start: now, end: now + 15 * 60000, tier: 0, title: 'Stand down', code: '' };
  completing = null;
  patchHQ({ active: a });
  ui.overlay = null; ui.secured = null; ui.minimized = false;
  Sfx.ensure(); Sfx.silence(); Sfx.ambientStop(); Sfx.play('min'); Sfx.schedule(a);
  Sfx.sayLater('Standing down. Fifteen minutes.', 400);
  releaseWake();
  render();
}
function secureBlock(a, quiet) {
  const entry = { t: a.end, s: a.start, m: a.mins === 10 ? 10 : 15, op: a.opId || null, tier: a.tier || 0, title: a.title || 'Unassigned window', code: a.code || '' };
  const id = 'b' + a.start, k = dayKey(a.end);
  addLocalDay(k, 'blocks', id, entry);
  store.addToDay(k, 'blocks', id, entry);
  if (S.hq && S.hq.active && S.hq.active.start === a.start) patchHQ({ active: null });
  ui.secured = Object.assign({ id: id, xp: blockXP(entry.m) }, entry);
  ui.overlay = 'secured'; ui.minimized = false;
  Sfx.ambientStop();
  if (quiet) { Sfx.cancel(); Sfx.play('stamp'); }
  else {
    Sfx.ring(a);
    const nToday = derive().today.length, q = clampInt(S.hq && S.hq.quota, 1, 24, 4);
    Sfx.sayLater('Window secured. ' + (nToday === q ? 'Daily quota met.' : nToday + ' block' + (nToday === 1 ? '' : 's') + ' today.'), 1100);
  }
  try { if (navigator.vibrate) navigator.vibrate([160, 70, 160]); } catch (e) {}
  releaseWake();
  render();
  afterAction();
}
function finishBreak(a) {
  patchHQ({ active: null });
  ui.overlay = 'breakdone'; ui.breakOp = a.opId || null; ui.minimized = false;
  Sfx.ring(a);
  Sfx.sayLater('Break over. Time to redeploy.', 1200);
  render();
}
function abortWindow() {
  const a = S.hq && S.hq.active; if (!a) return;
  Sfx.silence(); Sfx.ambientStop(); releaseWake(); completing = a.start;
  patchHQ({ active: null });
  ui.minimized = false;
  if (a.kind === 'break') { ui.overlay = 'breakdone'; ui.breakOp = a.opId || null; Sfx.play('chime'); }
  else { Sfx.play('abort'); Sfx.say('Window aborted.'); toast('Window aborted', 'No block logged. Redeploy when you are ready.', 'warn'); }
  render();
}
function closeOp(id, quiet) {
  const op = S.ops[id]; if (!op || op.status === 'closed') return;
  const used = derive().used[id] || 0;
  const upd = Object.assign({}, op, { status: 'closed', closedAt: Date.now(), used: used, tier: tierOf(op), autoTier: false });
  saveOp(upd);
  const x = closeXP(upd);
  if (ui.expanded === id) { ui.expanded = null; ui.edit = null; }
  if (ui.pinned === id) ui.pinned = null;
  Sfx.play('stamp'); setTimeout(function () { Sfx.play('xp'); }, 260);
  Sfx.sayLater('Operation ' + op.code.toLowerCase() + ' closed.', 400);
  toast('Operation ' + op.code + ' closed', '+' + x.total + ' XP' + (x.tag ? ' · ' + x.tag : ''), 'good');
  if (!quiet && !(S.hq && S.hq.debrief === false)) { ui.debrief = { id: id, note: '', mins: null, custom: '' }; ui.modal = 'debrief'; }
  render(); afterAction();
}
function enlist() {
  const cs = (ui.enroll.callsign || ui.enroll.sugg[0] || 'KESTREL').trim().toUpperCase().replace(/\s+/g, ' ').slice(0, 18) || 'KESTREL';
  const hq = { v: 1, callsign: cs, quota: ui.enroll.quota || 4, sound: true, defMins: 15, created: Date.now(), seen: [], rankSeen: 0, active: null, route: null };
  S.hq = hq; store.setHQ(hq);
  ui.mins = 15; ui.modal = 'dump';
  Sfx.play('promo'); Sfx.sayLater('Welcome, Agent ' + cs.charAt(0) + cs.slice(1).toLowerCase() + '.', 700);
  render(); focusSoon('dump-text');
}
function dumpSave() {
  const lines = String(ui.draft.dump || '').split(/\r?\n/).map(function (s) { return s.replace(/^\s*(?:[-*•]+|\d+[.)])\s*/, '').trim(); }).filter(Boolean).slice(0, 80);
  if (!lines.length) { toast('Nothing to upload', 'Type at least one task, one per line.', 'warn'); focusSoon('dump-text'); return; }
  const base = Date.now(), ids = [];
  lines.forEach(function (t, i) { const op = newOp(t.slice(0, 140), 0, base + i); ids.push(op.id); saveOp(op); });
  ui.draft.dump = '';
  Sfx.play('data');
  ui.triage = { queue: ids, i: 0, res: 3, due: '' }; ui.modal = 'triage';
  toast(lines.length + ' intel item' + (lines.length === 1 ? '' : 's') + ' uploaded', 'Now sort each one by how it feels.', 'good');
  render();
}
function openTriage(D) {
  const q = D.open[0].map(function (o) { return o.id; });
  if (!q.length) { toast('Nothing to triage', 'Every op already has a tier.', 'info'); return; }
  ui.triage = { queue: q, i: 0, res: 3, due: '' }; ui.modal = 'triage'; render();
}
function triageAssign(t) {
  const tr = ui.triage; if (!tr) return;
  const op = S.ops[tr.queue[tr.i]];
  if (op) saveOp(Object.assign({}, op, { tier: t, res: tr.res, due: isDate(tr.due) ? tr.due : (op.due || ''), autoTier: false }));
  Sfx.play('t' + t);
  triageNext();
}
function triageNext() {
  const tr = ui.triage; if (!tr) return;
  tr.i++; tr.res = 3; tr.due = '';
  while (tr.i < tr.queue.length) { const o = S.ops[tr.queue[tr.i]]; if (o && (o.tier || 0) === 0 && o.status !== 'closed') break; tr.i++; }
  if (tr.i >= tr.queue.length) {
    ui.triage = null; ui.modal = null;
    toast('Triage complete', 'Board sorted. Your next op is on HQ.', 'good');
    if (ui.tab !== 'hq') location.hash = 'hq';
    afterAction();
  }
  render();
}
function editSave() {
  const e = ui.edit; if (!e) return;
  const title = String(e.title || '').trim();
  if (!title) { toast('Title required', 'Give the op a name before saving.', 'warn'); return; }
  const orig = S.ops[e.id] || {};
  const tier = clampInt(e.tier, 0, 4, 0);
  const op = Object.assign({}, orig, { id: e.id, title: title.slice(0, 140), notes: String(e.notes || '').trim().slice(0, 2000), tier: tier, res: clampInt(e.res, 1, 5, 3), est: clampInt(e.est, 0, 12, 0), due: isDate(e.due) ? e.due : '', code: e.code || codename() });
  op.repeat = e.repeat && e.repeat.days && e.repeat.days.length ? { days: e.repeat.days.slice().sort() } : null;
  if (op.repeat) { op.due = ''; op.status = 'open'; op.closedAt = null; }
  delete op.rtPick;
  if (tier !== tierOf(orig)) op.autoTier = false;
  saveOp(op);
  ui.expanded = null; ui.edit = null; ui.confirmShred = null;
  toast('Op updated', 'Operation ' + op.code, 'info');
  render(); afterAction();
}
function routeStart() {
  const D = derive(), tid = infilTargetId(D), tgt = tid && S.ops[tid];
  const plan = tgt && buildRoute(ui.infil.pos, tgt, D);
  if (!plan || plan.direct) return;
  patchHQ({ route: { from: ui.infil.pos, target: tgt.id, steps: plan.steps, at: 1, started: Date.now() } });
  ui.infil.pos = null;
  Sfx.play('route'); Sfx.sayLater('Route plotted. ' + (plan.steps.length - 1) + ' steps to target.', 450);
  toast('Infiltration started', 'Waypoint ' + plan.steps[1].wp + ' is live.', 'good');
  render();
  try { window.scrollTo({ top: 0, behavior: REDUCED ? 'auto' : 'smooth' }); } catch (e) { window.scrollTo(0, 0); }
}
function routeAdvance(silent) {
  const r = S.hq && S.hq.route; if (!r) return;
  const nextAt = Math.min(r.at + 1, r.steps.length - 1);
  patchHQ({ route: Object.assign({}, r, { at: nextAt }) });
  if (!silent) { Sfx.play('step', r.steps[nextAt].heat); render(); }
}
function routeBreach() {
  const r = S.hq && S.hq.route; if (!r) return;
  const now = Date.now();
  const entry = { t: now, n: r.steps.length - 1, from: r.from, target: r.target || null };
  const id = 'r' + (r.started || now), k = dayKey(now);
  addLocalDay(k, 'routes', id, entry);
  store.addToDay(k, 'routes', id, entry);
  patchHQ({ route: null });
  Sfx.play('breach');
  toast('Infiltration complete', '+' + routeXP(entry.n) + ' XP · target breached', 'good');
  const op = r.target && S.ops[r.target];
  ui.pinned = op && op.status !== 'closed' ? op.id : null;
  ui.pinWhy = 'Infiltration complete. Target acquired: start with the smallest piece.';
  if (ui.tab !== 'hq') location.hash = 'hq'; else render();
  afterAction();
}
function openSettings() {
  const h = S.hq || {};
  ui.settings = { callsign: h.callsign || '', quota: clampInt(h.quota, 1, 24, 4), defMins: h.defMins === 10 ? 10 : 15, sound: h.sound !== false,
    vol: Math.round((h.vol == null ? AUDIO_DEF.vol : Number(h.vol)) * 100), amb: h.amb || AUDIO_DEF.amb, voice: h.voice !== false, uisfx: h.uisfx !== false, alarm: h.alarm == null ? AUDIO_DEF.alarm : Number(h.alarm), debrief: h.debrief !== false };
  ui.purgeOpen = false; ui.purgeText = ''; ui.modal = 'settings'; render();
}
function settingsSave() {
  const s = ui.settings; if (!s) return;
  const cs = String(s.callsign || '').trim().toUpperCase().slice(0, 18) || (S.hq && S.hq.callsign) || 'AGENT';
  patchHQ({ callsign: cs, quota: s.quota, defMins: s.defMins, sound: s.sound, vol: clampInt(s.vol, 0, 100, 80) / 100, amb: s.amb, voice: !!s.voice, uisfx: !!s.uisfx, alarm: Number(s.alarm) || 0, debrief: s.debrief !== false });
  Sfx.setLevel();
  const act = S.hq && S.hq.active;
  if (act && act.kind === 'op' && act.end > Date.now()) { Sfx.unlock(); Sfx.ambientStart(act); }
  if (!s.sound) { Sfx.silence(); Sfx.ambientStop(); }
  ui.mins = s.defMins; ui.modal = null;
  toast('Settings saved', '', 'info');
  render();
}
function purgeAll() {
  const ids = Object.keys(S.ops), days = Object.keys(S.days);
  ui.modal = null; ui.purgeOpen = false; ui.purgeText = '';
  Sfx.cancel(); releaseWake();
  ids.forEach(function (id) { removeOp(id); });
  days.forEach(function (d) { const m = Object.assign({}, S.days); delete m[d]; S.days = m; store.deleteDay(d); });
  S.hq = null; store.deleteHQ();
  S.feed = null; store.deleteFeed();
  Object.keys(S.cals || {}).forEach(function (id) { store.deleteCal(id); }); S.cals = {};
  Object.keys(S.notes || {}).forEach(function (id) { store.deleteNote(id); }); S.notes = {};
  ui.feed.state = 'idle'; ui.feed.msg = ''; ui.feed.didAuto = false;
  ui.overlay = null; ui.secured = null; ui.triage = null;
  toast('All data purged', 'Enroll again to start over.', 'warn');
  render();
}
let unlockT = 0;
function afterAction() { clearTimeout(unlockT); unlockT = setTimeout(checkUnlocks, 500); }
function checkUnlocks() {
  if (!S.hq) return;
  const D = derive();
  const seen = Array.isArray(S.hq.seen) ? S.hq.seen : [];
  const fresh = BADGES.filter(function (b) { return D.badges[b.id] && seen.indexOf(b.id) < 0; });
  const patch = {};
  if (fresh.length) {
    patch.seen = seen.concat(fresh.map(function (b) { return b.id; }));
    fresh.forEach(function (b, i) { setTimeout(function () { toast('Commendation · ' + b.name, b.req, 'medal'); if (i === 0) { Sfx.play('medal'); Sfx.say('Commendation. ' + b.name.toLowerCase() + '.'); } }, 300 + i * 700); });
  }
  const rs = typeof S.hq.rankSeen === 'number' ? S.hq.rankSeen : 0;
  if (D.rank.idx > rs) { patch.rankSeen = D.rank.idx; ui.promo = D.rank.idx; if (ui.modal === 'debrief') ui.promoQueued = true; else ui.modal = 'promo'; Sfx.play('promo'); Sfx.sayLater('Promotion. Clearance granted. ' + D.rank.name.toLowerCase() + '.', 1000); }
  if (Object.keys(patch).length) { patchHQ(patch); render(); }
}

/* ================= CANVAS UPLINK (Google Calendar) ================= */
let MCP = null, PERM = null, feedBusy = false, autoQueued = false;
function initFeed() {
  if (!(window.claude && typeof window.claude.use === 'function')) { ui.feed.avail = false; return; }
  window.claude.use('mcp').then(function (m) { MCP = m || null; ui.feed.avail = !!m; scheduleAuto(); scheduleRender(); }).catch(function () { ui.feed.avail = false; scheduleRender(); });
  window.claude.use('permissions').then(function (p) { PERM = p || null; }).catch(function () {});
}
function scheduleAuto() {
  if (autoQueued || ui.feed.didAuto || !MCP || !S.ready || !S.hq || !S.feed || !S.feed.enabled) return;
  autoQueued = true;
  setTimeout(function () { autoQueued = false; maybeAutoSync(); }, 900);
}
function maybeAutoSync() {
  if (!MCP || !S.ready || !S.hq || !S.feed || !S.feed.enabled || feedBusy) return;
  if (!ui.feed.didAuto || Date.now() - (S.feed.lastSync || 0) > FEED_EVERY) { ui.feed.didAuto = true; syncFeed(false); }
}
function saveFeed(F) { S.feed = F; return store.setFeed(F); }
function feedErr(e) {
  const code = (e && e.code) || 'upstream_error';
  const msg = {
    needs_reauth: 'Reconnect Google Calendar in claude.ai Settings → Connectors, then tap SYNC.',
    server_not_connected: 'Add Google Calendar in claude.ai Settings → Connectors, then tap SYNC.',
    selection_required: 'claude.ai needs you to pick which Google Calendar connector to use. Tap SYNC to get the prompt.',
    not_in_manifest: 'Calendar access is off for this page. Tap ALLOW to turn it on.',
    approval_required: 'Calendar access needs your OK. Tap ALLOW.',
    consent_required: 'Calendar access needs your OK. Tap ALLOW.',
    blocked_by_policy: 'Your organization blocks this connector here.',
    tool_error: 'Google Calendar refused the request. Tap SYNC to try again.',
    not_granted: 'Calendar sync is not available in this view.',
    capability_disabled: 'Calendar sync is not available in this view.',
    capability_removed: 'Calendar sync is not available in this view.'
  }[code] || 'Google Calendar did not answer. Tap SYNC to try again.';
  return { code: code, msg: msg, allow: code === 'not_in_manifest' || code === 'approval_required' || code === 'consent_required' };
}
function gcal(tool, input, manual) {
  const opts = manual ? { cache: { refresh: true } } : undefined;
  return MCP.callTool(GCAL, tool, input, opts).catch(function (e) {
    if (e && e.retryable) return sleep(Math.min(e.retryAfterMs || 1500, 8000) + Math.random() * 600).then(function () { return MCP.callTool(GCAL, tool, input, opts); });
    throw e;
  });
}
function isoLocal(d) { return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + 'T' + pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds()); }
function eventDue(ev) {
  const s = (ev && ev.start) || {};
  if (s.date) return String(s.date).slice(0, 10);
  if (s.dateTime) { const t = new Date(s.dateTime).getTime(); return isNaN(t) ? null : dayKey(t); }
  return null;
}
function parseSummary(sum) {
  const s = String(sum || '').trim(), m = s.match(/^(.*?)\s*\[([^\]]+)\]\s*$/);
  if (!m) return { title: s, course: '' };
  return { title: (m[1] || m[2]).trim(), course: m[2].split('.')[0].replace(/[^A-Za-z0-9_-]/g, '').slice(0, 40) };
}
async function syncFeed(manual) {
  if (feedBusy || !MCP || !store || !S.ready) return;
  feedBusy = true; ui.feed.state = 'syncing'; ui.feed.msg = ''; ui.feed.allow = false; render();
  if (manual) Sfx.play('data');
  const F = Object.assign({ horizon: 10 }, clone(S.feed) || {});
  F.enabled = true; F.seen = F.seen || {}; F.courses = F.courses || {};
  let created = 0, moved = 0;
  try {
    if (!F.calId) {
      const r = await gcal('list_calendars', { pageSize: 100 }, manual);
      const cals = (r && r.payload && r.payload.calendars) || [];
      const cv = cals.find(function (c) { return /canvas/i.test(String(c.summary || '') + ' ' + String(c.description || '')); });
      if (!cv) { ui.feed.state = 'nocal'; saveFeed(F); return; }
      F.calId = cv.id;
    }
    const now = new Date();
    const start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0);
    const end = new Date(now.getFullYear(), now.getMonth(), now.getDate() + (F.horizon || 10), 23, 59, 59);
    let events = [], token = null, pages = 0;
    do {
      const input = { calendarId: F.calId, startTime: isoLocal(start), endTime: isoLocal(end), orderBy: 'startTime', pageSize: 250 };
      if (token) input.pageToken = token;
      const r = await gcal('list_events', input, manual);
      const p = (r && r.payload) || {};
      events = events.concat(Array.isArray(p.events) ? p.events : []);
      token = p.nextPageToken || null; pages++;
    } while (token && pages < 4);
    const todayK = dayKey(Date.now());
    events.forEach(function (ev) {
      const ps = parseSummary(ev && ev.summary);
      if (ps.course && !F.courses[ps.course]) { const m = ps.title.match(/\b([A-Z]{3})\s?(\d{4}[A-Z]?)\b/); if (m) F.courses[ps.course] = m[1] + ' ' + m[2]; }
    });
    events.forEach(function (ev) {
      if (!ev || !ev.id || ev.status === 'cancelled') return;
      const due = eventDue(ev); if (!due || due < todayK) return;
      const ps = parseSummary(ev.summary); if (!ps.title) return;
      const id = 'cv' + String(ev.id).replace(/[^A-Za-z0-9_-]/g, '').slice(0, 180);
      const ex = S.ops[id];
      if (!ex) {
        if (F.seen[ev.id]) return;
        const g = guessEffort(ps.title);
        saveOp({ id: id, title: ps.title.slice(0, 140), tier: 2, res: g.res, est: g.est, due: due, code: codename(), status: 'open', created: Date.now() + created, closedAt: null, used: null, src: 'canvas', ext: String(ev.id), course: ps.course, feedDue: due, link: String(ev.htmlLink || ''), autoTier: true });
        F.seen[ev.id] = due; created++;
      } else if (ex.status !== 'closed' && ex.feedDue && ex.feedDue !== due) {
        const upd = Object.assign({}, ex, { feedDue: due });
        if (ex.due === ex.feedDue) upd.due = due;
        saveOp(upd); moved++;
      }
    });
    const cutoff = dayKey(Date.now() - 45 * 86400000);
    Object.keys(F.seen).forEach(function (k) { if (!isDate(F.seen[k]) || F.seen[k] < cutoff) delete F.seen[k]; });
    F.lastSync = Date.now(); F.lastCount = events.length;
    saveFeed(F);
    ui.feed.state = 'ok'; ui.feed.newCount = created;
    if (created) { Sfx.play('incoming'); Sfx.sayLater(created + ' new deadline' + (created === 1 ? '' : 's') + ' from Canvas.', 900); toast(created + ' new deadline' + (created === 1 ? '' : 's') + ' from Canvas', 'Filed by due date. Anything due within a day goes Critical.', 'good'); }
    else if (moved) toast(moved + ' due date' + (moved === 1 ? '' : 's') + ' moved in Canvas', 'Your board is updated.', 'info');
    else if (manual) toast('Canvas uplink synced', 'No new deadlines.', 'info');
  } catch (e) {
    const fe = feedErr(e);
    ui.feed.state = 'error'; ui.feed.msg = fe.msg; ui.feed.allow = fe.allow; ui.feed.perm = !!PERM && fe.allow;
    if (!S.feed || !S.feed.enabled) saveFeed(F);
    if (manual) Sfx.play('error');
    console.warn('[zerogap] calendar sync failed', fe.code);
  } finally {
    feedBusy = false; render();
    if (created) afterAction();
  }
}
function fmtAgo(ms) {
  if (!ms) return 'NEVER';
  const m = Math.round((Date.now() - ms) / 60000);
  if (m < 1) return 'JUST NOW';
  if (m < 60) return m + ' MIN AGO';
  if (m < 1440) return Math.floor(m / 60) + ' H AGO';
  return dtg(ms);
}
function feedPanelHTML(D) {
  const F = S.feed, f = ui.feed, linked = !!(F && F.enabled);
  let head = '<div class="ph"><span class="ph-t">Calendar uplink</span>' + (linked && MCP ? '<button class="link ph-m" type="button" data-act="feed-sync"' + (f.state === 'syncing' ? ' disabled' : '') + '>' + (f.state === 'syncing' ? 'SYNCING…' : 'SYNC NOW') + '</button>' : '') + '</div>';
  let body = remPanelHTML() + '<div class="lbl" style="margin-top:14px">Canvas feed</div>';
  if (f.avail === false || (f.avail === null && !MCP)) {
    body += '<p class="feed-msg">' + (f.avail === null ? 'Connecting to your calendar…' : (isApp() ? 'Automatic Canvas import needs the claude.ai version. In the app, add due dates as ops, or import your Canvas calendar (.ics) into Schedule.' : 'Calendar sync runs when this page is open inside Claude, on the web or in the app.')) + '</p>';
  } else if (!linked) {
    body += '<p class="feed-msg">Pull every Canvas due date onto your board automatically, from the Canvas calendar in your Google Calendar. Nothing to type each week.</p><div class="feed-acts"><button class="btn hud" type="button" data-act="feed-link">LINK CANVAS</button></div>';
  } else {
    let st;
    if (f.state === 'syncing') st = '<span class="live">SYNCING</span>';
    else if (f.state === 'error') st = '<span class="warn">UPLINK DOWN</span>';
    else if (f.state === 'nocal') st = '<span class="warn">NO CANVAS CALENDAR</span>';
    else st = '<span class="live">LIVE</span><span>LAST SYNC ' + fmtAgo(F.lastSync) + '</span>';
    body += '<div class="feed-st">' + st + '<span>' + D.feedOpen + ' OPEN FROM CANVAS</span></div>';
    if (f.state === 'error') body += '<p class="feed-msg">' + esc(f.msg) + '</p><div class="feed-acts">' + (f.allow ? '<button class="btn hud" type="button" data-act="feed-sync">ALLOW</button>' : '') + (f.perm ? '<button class="btn" type="button" data-act="feed-perm">PERMISSIONS</button>' : '') + '</div>';
    if (f.state === 'nocal') body += '<p class="feed-msg">No calendar with "Canvas" in its name is in your Google Calendar. Add it once:</p><ol class="steps"><li>Canvas → Calendar → Calendar Feed → copy the link.</li><li>Google Calendar → Other calendars → + → From URL → paste it.</li><li>Come back and tap SYNC NOW.</li></ol>';
    const hz = F.horizon || 10;
    body += '<div class="hz"><span class="lbl">Look ahead</span><div class="seg" role="radiogroup" aria-label="Days to look ahead">' + [7, 10, 14].map(function (n) { return '<button type="button" role="radio" aria-checked="' + (hz === n) + '" data-act="feed-hz" data-v="' + n + '">' + n + 'D</button>'; }).join('') + '</div></div>';
    const codes = Object.keys(F.courses || {});
    D.deadlines.forEach(function (o) { if (o.course && codes.indexOf(o.course) < 0) codes.push(o.course); });
    if (codes.length) {
      body += '<div class="courses"><span class="lbl">Courses</span>' + codes.map(function (c) { return '<button type="button" class="cchip" data-act="crs-edit" data-v="' + esc(c) + '" title="Rename">' + esc(courseLabel(c)) + '</button>'; }).join('') + '</div>';
      if (ui.courseEdit) body += '<div class="crs-edit"><label class="sr" for="crs-in">Course name</label><input class="inp" id="crs-in" data-bind="courseDraft" maxlength="24" value="' + esc(ui.courseDraft) + '" autocomplete="off"><button class="btn sm solid" type="button" data-act="crs-save">SAVE</button><button class="btn sm" type="button" data-act="crs-cancel">CANCEL</button></div>';
    }
  }
  const list = D.deadlines.slice(0, 5);
  if (list.length) {
    body += '<ul class="dl-list" aria-label="Next deadlines">' + list.map(function (o) { const t = tierOf(o); return '<li class="' + TIERS[t].key + '"><span class="dl-when">' + tminus(o.due) + '</span><span class="dl-t">' + (o.course ? '<span class="cchip">' + esc(courseLabel(o.course)) + '</span>' : '') + esc(o.title) + '</span></li>'; }).join('') + '</ul>';
  }
  return '<section class="panel a-feed" aria-label="Calendar uplink">' + head + body + '</section>';
}

/* ================= DEADLINE ALERTS (Google Calendar) ================= */
/* With the calendar connector: one alert event per op with a deadline, kept in sync. Without it: a prefilled Google Calendar link per op. */
const RT = {
  head: 'Deadline alerts', whenAria: 'When to alert', at: 'At',
  when: { '0d': 'DAY OF', '1d': '1 DAY BEFORE', '2d': '2 DAYS BEFORE', off: 'OFF' },
  autoOn: 'Armed: every op with a deadline gets its own alert event in your Google Calendar, and your phone pings you at that time. Disarming deletes those alerts.',
  autoOff: 'Arm this and every op with a deadline creates its own alert in your Google Calendar. Your phone gets the notification through the Google Calendar app.',
  turnOn: 'ARM AUTO ALERTS', turnOff: 'DISARM ALERTS',
  manual: 'Each op with a deadline gets an ⏰ ALERT button that opens Google Calendar with the reminder filled in. Tap Save there.',
  add: 'ALERT', added: 'ALERT SET', pending: 'ALERT PENDING', autoTip: 'Auto alert in Google Calendar',
  made: function (n) { return n === 1 ? '1 alert created in Google Calendar' : n + ' alerts created in Google Calendar'; },
  fail: 'An alert could not be created',
  title: function (t, due) { const d = parseDay(due); return '⏰ ' + t + ' (due ' + MON[d.getMonth()] + ' ' + d.getDate() + ')'; },
  desc: function (t, due) { return 'ZERØ GAP alert. Op: ' + t + '. Deadline: ' + due + '.'; }
};
const REM_OPTS = [['0d', 0], ['1d', 1], ['2d', 2], ['off', -1]];
function remCfg() { const h = S.hq || {}; return { when: h.remWhen || '1d', time: /^\d{2}:\d{2}$/.test(h.remTime || '') ? h.remTime : '09:00', auto: h.remAuto === true }; }
function remAt(op) {
  if (!op || !isDate(op.due) || op.status === 'closed') return null;
  const c = remCfg(), o = REM_OPTS.find(function (x) { return x[0] === c.when; }), days = o ? o[1] : 1;
  if (days < 0) return null;
  const d = parseDay(op.due), t = c.time.split(':');
  d.setDate(d.getDate() - days); d.setHours(Number(t[0]), Number(t[1]), 0, 0);
  return d;
}
function remFmt(d) { return DOW[d.getDay()] + ' ' + d.getDate() + ' ' + MON[d.getMonth()] + ' · ' + pad(d.getHours()) + ':' + pad(d.getMinutes()); }
function gcalCompact(d) { return d.getFullYear() + pad(d.getMonth() + 1) + pad(d.getDate()) + 'T' + pad(d.getHours()) + pad(d.getMinutes()) + '00'; }
function gcalLink(op) {
  const a = remAt(op); if (!a) return '';
  const b = new Date(a.getTime() + 15 * 60000);
  return 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=' + encodeURIComponent(RT.title(op.title, op.due)) + '&dates=' + gcalCompact(a) + '/' + gcalCompact(b) + '&details=' + encodeURIComponent(RT.desc(op.title, op.due));
}
function remAutoOn() { return !!(MCP && remCfg().auto); }
function remBtnHTML(op) {
  const a = remAt(op); if (!a || a.getTime() < Date.now()) return '';
  if (remAutoOn()) { const ok = !!(op.rem && op.rem.at === isoLocal(a)); return '<span class="remtag' + (ok ? ' ok' : '') + '" title="' + esc(RT.autoTip) + '">⏰ ' + (ok ? remFmt(a) : RT.pending) + '</span>'; }
  const done = op.remLink === isoLocal(a);
  return '<a class="btn sm rem' + (done ? ' ok' : '') + '" href="' + esc(gcalLink(op)) + '" target="_blank" rel="noopener" data-act="rem-link" data-id="' + op.id + '">⏰ ' + (done ? RT.added : RT.add) + '</a>';
}
function remPanelHTML() {
  const c = remCfg();
  let h = '<div class="remset"><div class="lbl">' + RT.head + '</div><div class="seg" role="radiogroup" aria-label="' + RT.whenAria + '">' +
    REM_OPTS.map(function (o) { return '<button type="button" role="radio" aria-checked="' + (c.when === o[0]) + '" data-act="rem-when" data-v="' + o[0] + '">' + RT.when[o[0]] + '</button>'; }).join('') + '</div>' +
    '<label class="remtime" for="rem-time"><span>' + RT.at + '</span><input class="inp" type="time" id="rem-time" value="' + c.time + '"></label>';
  if (MCP) h += '<p class="feed-msg">' + (c.auto ? RT.autoOn : RT.autoOff) + '</p><div class="feed-acts"><button class="btn' + (c.auto ? '' : ' hud') + '" type="button" data-act="rem-auto">' + (c.auto ? RT.turnOff : RT.turnOn) + '</button></div>';
  else h += '<p class="feed-msg">' + RT.manual + '</p>';
  return h + '</div>';
}
let remBusy = false, remT = 0;
const remFail = new Set();
function scheduleRem() { clearTimeout(remT); remT = setTimeout(syncReminders, 2500); }
async function syncReminders() {
  if (remBusy || !MCP || !S.ready || !S.hq || !store) return;
  const auto = remCfg().auto;
  const want = function (op) { const a = auto ? remAt(op) : null; return a && a.getTime() > Date.now() ? isoLocal(a) : ''; };
  const work = Object.keys(S.ops).map(function (id) { return S.ops[id]; }).filter(function (op) {
    if (!op || remFail.has(op.id)) return false;
    const have = (op.rem && op.rem.at) || '';
    return want(op) !== have;
  }).slice(0, 12);
  if (!work.length) return;
  remBusy = true;
  let made = 0, failed = null;
  for (const op of work) {
    const w = want(op);
    try {
      if (op.rem && op.rem.ev) {
        try { await MCP.callTool(GCAL, 'delete_event', { eventId: op.rem.ev, notificationLevel: 'NONE' }); }
        catch (e) { if (!e || e.code !== 'tool_error') throw e; }
      }
      let rem = null;
      if (w) {
        const a = remAt(op);
        const res = await MCP.callTool(GCAL, 'create_event', { summary: RT.title(op.title, op.due), description: RT.desc(op.title, op.due), startTime: w, endTime: isoLocal(new Date(a.getTime() + 15 * 60000)), overrideReminders: [{ method: 'popup', minutes: 0 }], availability: 'AVAILABILITY_FREE', notificationLevel: 'NONE' });
        const p = (res && res.payload) || {}, ev = p.id || (p.event && p.event.id) || p.eventId || '';
        rem = { at: w, ev: String(ev || '') }; made++;
      }
      const cur = S.ops[op.id]; if (cur) saveOp(Object.assign({}, cur, { rem: rem }));
    } catch (e) {
      remFail.add(op.id); failed = e;
      console.warn('[zerogap] alert sync failed', e && e.code);
      if (e && e.code !== 'tool_error') break;
    }
  }
  remBusy = false;
  if (made) toast(RT.made(made), '', 'good');
  if (failed) toast(RT.fail, feedErr(failed).msg, 'warn');
  render();
}
document.addEventListener('change', function (ev) {
  if (!ev.target || ev.target.id !== 'rem-time' || !S.hq) return;
  patchHQ({ remTime: ev.target.value || '09:00' }); remFail.clear(); scheduleRem(); render();
});

/* ================= PROTON SCHEDULE (.ics import, stays off Google) ================= */
/* Proton Calendar has no API. Export an .ics from Proton and drop it in: the file is parsed in this page and
   saved in its owner-only store. Recurring events expand on the fly, so one import keeps working for weeks. */
const CAL_DAYS = 7, CAL_MAX = 1200, CAL_BYTES = 230000, CAL_STALE = 7 * 86400000, CAL_ROWS = 10;
const WD = { SU: 0, MO: 1, TU: 2, WE: 3, TH: 4, FR: 5, SA: 6 };
const tzFmt = {};
function tzOffset(ms, tz) {
  let f = tzFmt[tz];
  if (!f) f = tzFmt[tz] = new Intl.DateTimeFormat('en-US', { timeZone: tz, hourCycle: 'h23', year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit' });
  const p = {}; f.formatToParts(new Date(ms)).forEach(function (x) { p[x.type] = x.value; });
  return Date.UTC(+p.year, +p.month - 1, +p.day, (+p.hour) % 24, +p.minute, +p.second) - ms;
}
/* Wall-clock time in an IANA zone → epoch ms. Unknown zones fall back to this device's zone. */
function zonedMs(y, mo, d, h, mi, s, tz) {
  if (tz) {
    try {
      const guess = Date.UTC(y, mo - 1, d, h, mi, s), o1 = tzOffset(guess, tz);
      let t = guess - o1; const o2 = tzOffset(t, tz); if (o2 !== o1) t = guess - o2;
      return t;
    } catch (e) {}
  }
  return new Date(y, mo - 1, d, h, mi, s).getTime();
}
/* One ICS date value → { ms } for a moment, or { day, ms } for an all-day date. */
function icsTime(v, p, defTz) {
  const m = String(v || '').trim().match(/^(\d{4})(\d{2})(\d{2})(?:T(\d{2})(\d{2})(\d{2})?(Z)?)?$/);
  if (!m) return null;
  const y = +m[1], mo = +m[2], d = +m[3];
  if (!m[4]) return { day: m[1] + '-' + m[2] + '-' + m[3], ms: new Date(y, mo - 1, d).getTime() };
  const h = +m[4], mi = +m[5], s = +(m[6] || 0);
  if (m[7]) return { ms: Date.UTC(y, mo - 1, d, h, mi, s) };
  const tz = String((p && p.TZID) || defTz || '').replace(/^\//, '');
  return { ms: zonedMs(y, mo, d, h, mi, s, tz) };
}
function icsDur(v) {
  const m = String(v || '').trim().match(/^([+-])?P(?:(\d+)W)?(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$/);
  if (!m) return 0;
  const ms = (((+m[2] || 0) * 7 + (+m[3] || 0)) * 86400 + (+m[4] || 0) * 3600 + (+m[5] || 0) * 60 + (+m[6] || 0)) * 1000;
  return m[1] === '-' ? -ms : ms;
}
function icsProp(line) {
  let i = 0, q = false;
  for (; i < line.length; i++) { const c = line[i]; if (c === '"') q = !q; else if (c === ':' && !q) break; }
  if (i >= line.length) return null;
  const parts = line.slice(0, i).split(';'), p = {};
  parts.slice(1).forEach(function (x) { const k = x.indexOf('='); if (k > 0) p[x.slice(0, k).toUpperCase()] = x.slice(k + 1).replace(/^"|"$/g, ''); });
  return { name: parts[0].toUpperCase(), p: p, v: line.slice(i + 1) };
}
function icsText(v) { return String(v || '').replace(/\\n/gi, ' ').replace(/\\([,;\\])/g, '$1').replace(/\s+/g, ' ').trim(); }
function parseICS(text) {
  const lines = String(text || '').replace(/^﻿/, '').replace(/\r\n?/g, '\n').replace(/\n[ \t]/g, '').split('\n');
  let name = '', calTz = '', cur = null, depth = 0;
  const evs = [];
  lines.forEach(function (line) {
    if (!line) return;
    const pr = icsProp(line); if (!pr) return;
    if (pr.name === 'BEGIN') { const k = pr.v.trim().toUpperCase(); if (!cur && k === 'VEVENT') { cur = { ex: [] }; depth = 0; } else if (cur) depth++; return; }
    if (pr.name === 'END') { if (cur) { if (depth === 0 && pr.v.trim().toUpperCase() === 'VEVENT') { evs.push(cur); cur = null; } else depth = Math.max(0, depth - 1); } return; }
    if (!cur) { if (pr.name === 'X-WR-CALNAME') name = icsText(pr.v); else if (pr.name === 'X-WR-TIMEZONE') calTz = pr.v.trim(); return; }
    if (depth > 0) return;
    switch (pr.name) {
      case 'UID': cur.uid = pr.v.trim(); break;
      case 'SUMMARY': cur.t = icsText(pr.v); break;
      case 'LOCATION': cur.l = icsText(pr.v); break;
      case 'DTSTART': cur.s = icsTime(pr.v, pr.p, calTz); break;
      case 'DTEND': cur.e = icsTime(pr.v, pr.p, calTz); break;
      case 'DURATION': cur.dur = icsDur(pr.v); break;
      case 'RRULE': cur.r = pr.v.trim().slice(0, 300); break;
      case 'EXDATE': pr.v.split(',').forEach(function (x) { const t = icsTime(x, pr.p, calTz); if (t) cur.ex.push(t); }); break;
      case 'RECURRENCE-ID': cur.rid = icsTime(pr.v, pr.p, calTz); break;
      case 'STATUS': cur.st = pr.v.trim().toUpperCase(); break;
    }
  });
  return { name: name, tz: calTz, evs: evs };
}
function addDaysKey(k, n) { const d = parseDay(k); d.setDate(d.getDate() + n); return dayKey(d.getTime()); }
function exKey(t, allDay) { return allDay || t.day ? (t.day || dayKey(t.ms)) : Math.round(t.ms / 60000); }
const ruleCache = {};
function parseRule(str) {
  if (ruleCache[str]) return ruleCache[str];
  const r = { f: '', i: 1, c: 0, u: 0, d: null, md: null, m: null, sp: null, ws: 1 };
  String(str || '').split(';').forEach(function (kv) {
    const eq = kv.indexOf('='); if (eq < 0) return;
    const k = kv.slice(0, eq).trim().toUpperCase(), v = kv.slice(eq + 1).trim().toUpperCase();
    if (k === 'FREQ') r.f = v;
    else if (k === 'INTERVAL') r.i = Math.max(1, parseInt(v, 10) || 1);
    else if (k === 'COUNT') r.c = Math.max(0, parseInt(v, 10) || 0);
    else if (k === 'UNTIL') { const t = icsTime(v, null, ''); if (t) { if (t.day) { const d = parseDay(t.day); d.setHours(23, 59, 59, 999); r.u = d.getTime(); } else r.u = t.ms; } }
    else if (k === 'BYDAY') r.d = v.split(',').map(function (x) { const mm = x.trim().match(/^([+-]?\d{1,2})?(MO|TU|WE|TH|FR|SA|SU)$/); return mm ? { n: mm[1] ? parseInt(mm[1], 10) : 0, w: WD[mm[2]] } : null; }).filter(Boolean);
    else if (k === 'BYMONTHDAY') r.md = v.split(',').map(Number).filter(function (n) { return n && Math.abs(n) <= 31; });
    else if (k === 'BYMONTH') r.m = v.split(',').map(Number).filter(function (n) { return n >= 1 && n <= 12; });
    else if (k === 'BYSETPOS') r.sp = v.split(',').map(Number).filter(Boolean);
    else if (k === 'WKST') r.ws = WD[v] != null ? WD[v] : 1;
  });
  if (r.d && !r.d.length) r.d = null;
  if (r.md && !r.md.length) r.md = null;
  if (r.m && !r.m.length) r.m = null;
  ruleCache[str] = r;
  return r;
}
function ruleUntil(str) { return str ? parseRule(str).u || 0 : 0; }
/* Proton .ics → the compact record kept in the store: only what the agenda shows, nothing from descriptions. */
function compactEv(ev, keepRule) {
  const ad = !!ev.s.day, rec = { t: (ev.t || 'Busy').slice(0, 120) };
  if (ev.l) rec.l = ev.l.slice(0, 80);
  if (ad) {
    rec.a = 1; rec.s = ev.s.day;
    if (ev.e && ev.e.day && ev.e.day > ev.s.day) rec.e = ev.e.day;
    else rec.e = addDaysKey(ev.s.day, ev.dur > 0 ? Math.max(1, Math.round(ev.dur / 86400000)) : 1);
  } else {
    const end = ev.e ? ev.e.ms : ev.dur ? ev.s.ms + ev.dur : ev.s.ms;
    rec.s = ev.s.ms; rec.e = Math.max(ev.s.ms, end);
  }
  if (keepRule && ev.r && /FREQ=/i.test(ev.r)) rec.r = ev.r;
  const ex = (ev.ex || []).map(function (t) { return exKey(t, ad); });
  if (ex.length) rec.x = ex;
  return rec;
}
function dayStart(k) { const d = parseDay(k); d.setHours(0, 0, 0, 0); return d.getTime(); }
function evEnd(rec) { return rec.a ? dayStart(rec.e) : rec.e; }
function evStart(rec) { return rec.a ? dayStart(rec.s) : rec.s; }
function buildCal(parsed, fileName) {
  const keepFrom = Date.now() - 2 * 86400000, masters = {}, singles = [];
  const overrides = [];
  parsed.evs.forEach(function (ev, i) {
    if (!ev.s) return;
    if (ev.rid) { overrides.push(ev); return; }
    if (ev.st === 'CANCELLED') return;
    const rec = compactEv(ev, true);
    if (rec.r) masters[ev.uid || ('u' + i)] = rec; else singles.push(rec);
  });
  overrides.forEach(function (ov) {
    const m = masters[ov.uid];
    if (m) m.x = (m.x || []).concat(exKey(ov.rid, !!m.a));
    if (ov.st !== 'CANCELLED') singles.push(compactEv(ov, false));
  });
  let rec = Object.keys(masters).map(function (k) { return masters[k]; }).filter(function (r) { const u = ruleUntil(r.r); return !u || u >= keepFrom; });
  rec.forEach(function (r) {
    if (!r.x) return;
    const keepDay = dayKey(keepFrom), keepMin = Math.round(keepFrom / 60000);
    r.x = r.x.filter(function (x) { return typeof x === 'number' ? x >= keepMin : x >= keepDay; }).slice(-60);
    if (!r.x.length) delete r.x;
  });
  const one = singles.filter(function (r) { return evEnd(r) >= keepFrom; }).sort(function (a, b) { return evStart(a) - evStart(b); });
  let ev = rec.concat(one);
  const total = ev.length;
  if (ev.length > CAL_MAX) ev = ev.slice(0, CAL_MAX);
  const name = (parsed.name || String(fileName || '').replace(/\.ics$/i, '') || 'Proton calendar').slice(0, 40);
  const doc = { name: name, at: Date.now(), file: String(fileName || '').slice(0, 80), tz: (parsed.tz || '').slice(0, 64), ev: ev };
  while (doc.ev.length && JSON.stringify(doc).length > CAL_BYTES) doc.ev = doc.ev.slice(0, Math.floor(doc.ev.length * .9));
  doc.n = doc.ev.length;
  return { doc: doc, cut: total - doc.ev.length };
}
function dim(y, m) { return new Date(y, m + 1, 0).getDate(); }
function uniqSort(a) { return a.filter(function (x, i) { return a.indexOf(x) === i; }).sort(function (x, y) { return x - y; }); }
function monthWeekdays(y, m, w, nth) {
  const all = [], n = dim(y, m);
  for (let d = 1; d <= n; d++) if (new Date(y, m, d).getDay() === w) all.push(d);
  if (!nth) return all;
  const pick = nth > 0 ? all[nth - 1] : all[all.length + nth];
  return pick ? [pick] : [];
}
/* Occurrences of one stored event that overlap [from, to). Recurrence runs in this device's local time. */
function expandEv(ev, from, to, out) {
  const ad = !!ev.a, s0 = evStart(ev);
  const base = new Date(s0), H = base.getHours(), Mi = base.getMinutes(), Se = base.getSeconds();
  const span = ad ? Math.max(1, Math.round((parseDay(ev.e).getTime() - parseDay(ev.s).getTime()) / 86400000)) : 0, dur = ad ? 0 : Math.max(0, ev.e - ev.s);
  const mk = function (y, m, d) { return ad ? new Date(y, m, d).getTime() : new Date(y, m, d, H, Mi, Se).getTime(); };
  const endOf = function (t) { if (!ad) return t + dur; const d = new Date(t); return new Date(d.getFullYear(), d.getMonth(), d.getDate() + span).getTime(); };
  const push = function (t) { const e = endOf(t); if (e > from && t < to) out.push({ s: t, e: e, a: ad, t: ev.t, l: ev.l || '' }); };
  const r = ev.r ? parseRule(ev.r) : null;
  if (!r || ['DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY'].indexOf(r.f) < 0) { push(s0); return; }
  const ex = new Set(ev.x || []);
  const isEx = function (t) { if (ex.has(dayKey(t))) return true; if (ad) return false; const mn = Math.round(t / 60000); return ex.has(mn) || ex.has(mn - 60) || ex.has(mn + 60); };
  let count = 0, stop = false;
  const take = function (t) {
    if (stop || t < s0) return;
    if ((r.u && t > r.u) || (r.c && count >= r.c) || t >= to) { stop = true; return; }
    count++;
    if (!isEx(t)) push(t);
  };
  const by = base.getFullYear(), bm = base.getMonth(), bd = base.getDate(), LIM = 6000;
  if (r.f === 'DAILY') {
    for (let k = 0; k < LIM && !stop; k++) {
      const d = new Date(by, bm, bd + k * r.i);
      if (d.getTime() >= to) break;
      if (r.d && !r.d.some(function (x) { return x.w === d.getDay(); })) continue;
      if (r.m && r.m.indexOf(d.getMonth() + 1) < 0) continue;
      take(mk(d.getFullYear(), d.getMonth(), d.getDate()));
    }
  } else if (r.f === 'WEEKLY') {
    const order = uniqSort((r.d ? r.d.map(function (x) { return x.w; }) : [base.getDay()]).map(function (w) { return (w - r.ws + 7) % 7; }));
    const off = (base.getDay() - r.ws + 7) % 7;
    for (let k = 0; k < LIM && !stop; k++) {
      const ws = new Date(by, bm, bd - off + k * 7 * r.i);
      if (ws.getTime() >= to) break;
      for (let j = 0; j < order.length && !stop; j++) take(mk(ws.getFullYear(), ws.getMonth(), ws.getDate() + order[j]));
    }
  } else if (r.f === 'MONTHLY') {
    for (let k = 0; k < LIM && !stop; k++) {
      const mi = bm + k * r.i, y = by + Math.floor(mi / 12), m = mi % 12;
      if (new Date(y, m, 1).getTime() >= to) break;
      if (r.m && r.m.indexOf(m + 1) < 0) continue;
      const nd = dim(y, m);
      let c = [];
      if (r.md) r.md.forEach(function (x) { const dd = x > 0 ? x : nd + x + 1; if (dd >= 1 && dd <= nd) c.push(dd); });
      else if (r.d) r.d.forEach(function (x) { c = c.concat(monthWeekdays(y, m, x.w, x.n)); });
      else if (bd <= nd) c.push(bd);
      c = uniqSort(c);
      if (r.sp) c = uniqSort(r.sp.map(function (p) { return p > 0 ? c[p - 1] : c[c.length + p]; }).filter(function (x) { return x != null; }));
      for (let j = 0; j < c.length && !stop; j++) take(mk(y, m, c[j]));
    }
  } else {
    for (let k = 0; k < LIM && !stop; k++) {
      const y = by + k * r.i;
      if (new Date(y, 0, 1).getTime() >= to) break;
      const months = uniqSort(r.m || [bm + 1]);
      for (let j = 0; j < months.length && !stop; j++) {
        const m = months[j] - 1, nd = dim(y, m);
        let c = [];
        if (r.md) r.md.forEach(function (x) { const dd = x > 0 ? x : nd + x + 1; if (dd >= 1 && dd <= nd) c.push(dd); });
        else if (r.d && r.m) r.d.forEach(function (x) { c = c.concat(monthWeekdays(y, m, x.w, x.n)); });
        else if (bd <= nd) c.push(bd);
        c = uniqSort(c);
        for (let q = 0; q < c.length && !stop; q++) take(mk(y, m, c[q]));
      }
    }
  }
}
function calIds() { return Object.keys(S.cals || {}).filter(function (k) { return S.cals[k] && Array.isArray(S.cals[k].ev); }).sort(); }
let agCache = { key: '', list: [] };
function agenda() {
  const n = new Date(), from = new Date(n.getFullYear(), n.getMonth(), n.getDate()).getTime(), to = new Date(n.getFullYear(), n.getMonth(), n.getDate() + CAL_DAYS).getTime();
  const ids = calIds(), key = from + '|' + ids.map(function (k) { return k + ':' + S.cals[k].at + ':' + S.cals[k].ev.length; }).join(',');
  if (agCache.key === key) return agCache.list;
  const out = [];
  ids.forEach(function (id) {
    const c = S.cals[id];
    c.ev.forEach(function (ev) {
      const o = [];
      try { expandEv(ev, from - 86400000, to, o); } catch (e) { return; }
      o.forEach(function (x) { x.cal = c.name || 'Proton'; out.push(x); });
    });
  });
  out.sort(function (a, b) { return a.s - b.s || (b.a ? 1 : 0) - (a.a ? 1 : 0) || (a.t < b.t ? -1 : a.t > b.t ? 1 : 0); });
  agCache = { key: key, list: out.slice(0, 500) };
  return agCache.list;
}
function hhmm(ms) { const d = new Date(ms); return pad(d.getHours()) + ':' + pad(d.getMinutes()); }
function calAgo(ms) {
  const m = Math.round((Date.now() - ms) / 60000);
  if (m < 1) return 'JUST NOW';
  if (m < 60) return m + ' MIN AGO';
  if (m < 1440) return Math.floor(m / 60) + ' H AGO';
  const d = Math.floor(m / 1440); return d + (d === 1 ? ' DAY AGO' : ' DAYS AGO');
}
function schedPanelHTML() {
  const head = function (meta) { return '<div class="ph"><span class="ph-t">Schedule · Proton</span>' + (meta || '') + '</div>'; };
  const pickBtn = function (cls, label) { return '<button class="' + cls + '" type="button" data-act="ics-pick"' + (ui.cal.busy ? ' disabled' : '') + '>' + (ui.cal.busy ? 'READING…' : label) + '</button>'; };
  if (!S.calKnown) return '<section class="panel a-sched" aria-label="Schedule">' + head() + '<p class="ag-empty">Loading your schedule…</p></section>';
  const ids = calIds();
  if (!ids.length) {
    return '<section class="panel a-sched" aria-label="Schedule">' + head() +
      '<p class="feed-msg" style="margin-top:0">See your Proton Calendar right here. Export it once from Proton and drop the file in. It stays in this page\'s private storage and never goes to Google.</p>' +
      '<ol class="steps"><li>On a computer, open calendar.proton.me → Settings → All settings → Import/export.</li><li>Pick your calendar → Download ICS.</li><li>Tap IMPORT .ICS and choose that file, or drag it onto this panel.</li></ol>' +
      '<div class="feed-acts">' + pickBtn('btn hud', 'IMPORT .ICS') + '</div></section>';
  }
  const now = Date.now(), list = agenda(), todayK = dayKey(now), multi = ids.length > 1;
  const live = list.filter(function (x) { return !x.a && x.s <= now && x.e > now; }).sort(function (a, b) { return b.e - a.e; });
  const next = list.find(function (x) { return !x.a && x.s > now; });
  let meta;
  if (live.length) meta = '<span class="ph-m ag-busy">BUSY UNTIL ' + hhmm(live[0].e) + '</span>';
  else if (next && dayKey(next.s) === todayK) meta = '<span class="ph-m ag-free">FREE FOR ' + hm(Math.max(1, (next.s - now) / 60000)) + '</span>';
  else meta = '<span class="ph-m ag-free">CLEAR REST OF TODAY</span>';
  const days = [];
  for (let i = 0; i < CAL_DAYS; i++) { const d = new Date(); d.setHours(12, 0, 0, 0); d.setDate(d.getDate() + i); days.push({ k: dayKey(d.getTime()), mid: new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime(), d: d, items: [] }); }
  let earlier = 0;
  list.forEach(function (x) {
    if (x.e <= now) { if (!x.a && dayKey(x.s) === todayK) earlier++; return; }
    if (x.a) { days.forEach(function (g) { if (g.mid >= x.s && g.mid < x.e) g.items.push(x); }); return; }
    const k = x.s < now ? todayK : dayKey(x.s), g = days.find(function (y) { return y.k === k; });
    if (g) g.items.push(x);
  });
  const row = function (x) {
    const on = !x.a && x.s <= now && x.e > now, soon = !on && !x.a && x.s > now && x.s - now <= 3 * 3600000;
    const when = x.a ? 'ALL DAY' : hhmm(x.s) + (x.e > x.s ? '–' + hhmm(x.e) : '');
    const tag = on ? '<span class="chip ag-now">NOW</span>' : soon ? '<span class="chip ag-soon">IN ' + hm(Math.max(1, (x.s - now) / 60000)) + '</span>' : '';
    const sub = (multi ? '<span class="cchip">' + esc(x.cal) + '</span>' : '') + (x.l ? '<span class="ag-lt">' + esc(x.l) + '</span>' : '');
    return '<li class="' + (on ? 'on' : '') + '"><span class="ag-when">' + when + '</span><span class="ag-main"><span class="ag-t">' + esc(x.t) + '</span>' + (sub ? '<span class="ag-l">' + sub + '</span>' : '') + '</span>' + tag + '</li>';
  };
  let shown = 0, hidden = 0, body = '';
  days.forEach(function (g, i) {
    const label = i === 0 ? 'TODAY · ' : i === 1 ? 'TOMORROW · ' : '';
    const dl = '<div class="lbl ag-day">' + label + DOW[g.d.getDay()] + ' ' + g.d.getDate() + ' ' + MON[g.d.getMonth()] + '</div>';
    if (!g.items.length) { if (i === 0) body += dl + '<p class="ag-empty">' + (earlier ? 'Nothing else today.' : 'Nothing on the calendar today.') + '</p>'; return; }
    const room = Math.max(0, CAL_ROWS - shown), take = i === 0 ? g.items : g.items.slice(0, room);
    hidden += g.items.length - take.length;
    if (!take.length) return;
    shown += take.length;
    body += dl + '<ul class="ag">' + take.map(row).join('') + '</ul>';
  });
  if (earlier) body = '<p class="srcnote ag-earlier">✓ ' + earlier + (earlier === 1 ? ' event' : ' events') + ' earlier today</p>' + body;
  if (hidden) body += '<p class="srcnote" style="margin-top:8px">+ ' + hidden + ' more in the next ' + CAL_DAYS + ' days</p>';
  const oldest = Math.min.apply(null, ids.map(function (k) { return S.cals[k].at || 0; })), stale = now - oldest > CAL_STALE;
  const foot = '<div class="ag-foot"><span class="srcnote' + (stale ? ' warn' : '') + '">IMPORTED ' + calAgo(oldest) + (stale ? ' · RE-IMPORT TO CATCH CHANGES' : ' · PRIVATE, NOT ON GOOGLE') + '</span>' + pickBtn('link', 'RE-IMPORT .ICS') + '</div>' +
    '<div class="courses"><span class="lbl">Calendars</span>' + ids.map(function (k) { const c = S.cals[k], arm = ui.cal.del === k; return '<button type="button" class="cchip' + (arm ? ' ag-del' : '') + '" data-act="cal-del" data-id="' + esc(k) + '" title="Remove this calendar">' + (arm ? 'TAP AGAIN TO REMOVE' : esc(c.name) + ' ✕') + '</button>'; }).join('') + '</div>';
  return '<section class="panel a-sched" aria-label="Schedule">' + head(meta) + '<div class="ag-wrap">' + body + '</div>' + foot + '</section>';
}
function saveCal(id, doc) { const m = Object.assign({}, S.cals); m[id] = doc; S.cals = m; return store.putCal(id, doc); }
function removeCal(id) { const m = Object.assign({}, S.cals); delete m[id]; S.cals = m; return store.deleteCal(id); }
async function importICS(files) {
  const list = Array.prototype.slice.call(files || []).filter(function (f) { return f && (/\.ics$/i.test(f.name || '') || /calendar/i.test(f.type || '')); });
  if (!list.length) { toast('That is not an .ics file', 'In Proton: Settings → All settings → Import/export → Download ICS.', 'warn'); return; }
  if (!S.ready || !store) { toast('Still connecting', 'Try the import again in a few seconds.', 'warn'); return; }
  ui.cal.busy = true; render();
  Sfx.play('data');
  for (const f of list) {
    try {
      if (f.size > 8e6) { toast('File too big', (f.name || 'That file') + ' is over 8 MB.', 'bad'); continue; }
      const parsed = parseICS(await f.text());
      if (!parsed.evs.length) { toast('No events found', (f.name || 'That file') + ' has no calendar events in it.', 'warn'); continue; }
      const b = buildCal(parsed, f.name), id = 'pc' + hash(b.doc.name.toLowerCase()).toString(36);
      saveCal(id, b.doc);
      toast('Imported · ' + b.doc.name, b.doc.n + ' event' + (b.doc.n === 1 ? '' : 's') + ' saved' + (b.cut > 0 ? ', ' + b.cut + ' far-off ones skipped' : '') + '. Private to you.', 'good');
    } catch (e) {
      console.warn('[zerogap] ics import failed', e);
      toast('Could not read that file', 'Use the .ics from Proton: Settings → All settings → Import/export.', 'bad');
    }
  }
  ui.cal.busy = false; render();
}
let calDelT = 0;
function initIcsInput() {
  const inp = document.createElement('input');
  inp.type = 'file'; inp.id = 'ics-in'; inp.accept = '.ics,text/calendar'; inp.multiple = true; inp.tabIndex = -1;
  inp.setAttribute('aria-hidden', 'true');
  inp.style.cssText = 'position:fixed;left:-9999px;top:0;width:1px;height:1px;opacity:0';
  inp.addEventListener('change', function () { const fs = Array.prototype.slice.call(inp.files || []); inp.value = ''; if (fs.length) importICS(fs); });
  document.body.appendChild(inp);
  const hasFiles = function (ev) { const t = ev.dataTransfer && ev.dataTransfer.types; return !!t && Array.prototype.indexOf.call(t, 'Files') >= 0; };
  const mark = function (p) { document.querySelectorAll('.a-sched').forEach(function (el) { el.classList.toggle('drag', el === p); }); };
  document.addEventListener('dragover', function (ev) {
    if (!hasFiles(ev)) return;
    ev.preventDefault();
    const p = ev.target.closest ? ev.target.closest('.a-sched') : null;
    mark(p); try { ev.dataTransfer.dropEffect = p ? 'copy' : 'none'; } catch (e) {}
  });
  document.addEventListener('dragleave', function (ev) { if (!ev.relatedTarget) mark(null); });
  document.addEventListener('drop', function (ev) {
    if (!hasFiles(ev)) return;
    ev.preventDefault();
    const p = ev.target.closest ? ev.target.closest('.a-sched') : null;
    mark(null);
    if (p) importICS(ev.dataTransfer.files);
  });
}

/* ================= NOTES ================= */
/* A scratchpad for anything that is not a task yet. One tap turns a note into an op. */
const NOTE_SHOW = 5, NOTE_MAX = 2000, NOTE_DRAFT = 'zerogap.notedraft';
const COARSE = !!(window.matchMedia && window.matchMedia('(pointer: coarse)').matches);
function draftRead() { try { return localStorage.getItem(NOTE_DRAFT) || ''; } catch (e) { return ''; } }
let draftT = 0;
function draftStore(v) { clearTimeout(draftT); draftT = setTimeout(function () { try { if (v) localStorage.setItem(NOTE_DRAFT, v); else localStorage.removeItem(NOTE_DRAFT); } catch (e) {} }, 300); }
function noteList() {
  return Object.keys(S.notes || {}).map(function (k) { return S.notes[k]; }).filter(function (n) { return n && typeof n.text === 'string'; })
    .sort(function (a, b) { return (b.pin ? 1 : 0) - (a.pin ? 1 : 0) || (b.created || 0) - (a.created || 0); });
}
function noteWhen(ms) {
  if (!ms) return '';
  const d = new Date(ms), k = dayKey(ms), today = dayKey(Date.now()), y = dayKey(Date.now() - 86400000);
  if (k === today) return 'TODAY ' + hhmm(ms);
  if (k === y) return 'YESTERDAY ' + hhmm(ms);
  return DOW[d.getDay()] + ' ' + d.getDate() + ' ' + MON[d.getMonth()] + (d.getFullYear() !== new Date().getFullYear() ? ' ' + d.getFullYear() : '');
}
function saveNote(n) { const m = Object.assign({}, S.notes); m[n.id] = n; S.notes = m; return store.putNote(n); }
function removeNote(id) { const m = Object.assign({}, S.notes); delete m[id]; S.notes = m; return store.deleteNote(id); }
function noteAdd() {
  const text = String(ui.notes.draft || '').trim();
  if (!text) { focusSoon('note-new'); return; }
  if (!store || !S.ready) { toast('Still connecting', 'Your note is still in the box. Try SAVE again in a moment.', 'warn'); return; }
  const now = Date.now();
  saveNote({ id: uid('n'), text: text.slice(0, NOTE_MAX), created: now, updated: now });
  const box = document.getElementById('note-new'); if (box) box.value = '';
  ui.notes.draft = ''; draftStore('');
  Sfx.play('blip');
  render(); focusSoon('note-new');
}
function noteSave(id) {
  const n = S.notes[id]; if (!n) { ui.notes.edit = null; render(); return; }
  const text = String(ui.notes.editText || '').trim();
  ui.notes.edit = null;
  if (!text) { removeNote(id); toast('Empty note deleted', '', 'info'); }
  else if (text !== n.text) { saveNote(Object.assign({}, n, { text: text.slice(0, NOTE_MAX), updated: Date.now() })); toast('Note saved', '', 'info'); }
  render();
}
function noteToOp(id) {
  const n = S.notes[id]; if (!n) return;
  const first = n.text.split(/\n/).map(function (l) { return l.trim(); }).filter(Boolean)[0] || 'Note';
  const op = newOp(first.slice(0, 140), 0);
  if (n.text.trim() !== first) op.notes = n.text.slice(0, 2000);
  saveOp(op); removeNote(id);
  Sfx.play('t0');
  toast('Note filed as an op', 'Operation ' + op.code + ' is in Intake. Triage it on the Ops board.', 'good');
  render();
}
function noteRowHTML(n) {
  const N = ui.notes;
  if (N.edit === n.id) {
    return '<li class="nt editing"><label class="sr" for="note-edit">Edit note</label><textarea class="inp" id="note-edit" data-bind="notes.editText" rows="4" maxlength="' + NOTE_MAX + '">' + esc(N.editText) + '</textarea>' +
      '<div class="row"><button class="btn sm solid" type="button" data-act="note-save" data-id="' + esc(n.id) + '">SAVE</button><button class="btn sm" type="button" data-act="note-cancel">CANCEL</button></div></li>';
  }
  const long = n.text.length > 280 || n.text.split('\n').length > 6, open = N.open === n.id;
  return '<li class="nt' + (n.pin ? ' pin' : '') + '"><p class="nt-text' + (open ? ' open' : '') + '">' + esc(n.text) + '</p>' +
    '<div class="nt-meta"><span>' + (n.pin ? 'PINNED · ' : '') + noteWhen(n.created) + '</span><span class="nt-acts">' +
    (long ? '<button class="link" type="button" data-act="note-more" data-id="' + esc(n.id) + '">' + (open ? 'LESS' : 'MORE') + '</button>' : '') +
    '<button class="link" type="button" data-act="note-edit" data-id="' + esc(n.id) + '">EDIT</button>' +
    '<button class="link" type="button" data-act="note-pin" data-id="' + esc(n.id) + '">' + (n.pin ? 'UNPIN' : 'PIN') + '</button>' +
    '<button class="link" type="button" data-act="note-op" data-id="' + esc(n.id) + '" title="Turn this note into an op">→ OP</button>' +
    '<button class="link danger" type="button" data-act="note-del" data-id="' + esc(n.id) + '">' + (N.del === n.id ? 'TAP AGAIN TO DELETE' : 'DELETE') + '</button>' +
    '</span></div></li>';
}
function notesPanelHTML() {
  const N = ui.notes, all = noteList(), q = String(N.q || '').trim().toLowerCase();
  const list = q ? all.filter(function (n) { return n.text.toLowerCase().indexOf(q) >= 0; }) : all;
  const show = N.all || q ? list : list.slice(0, NOTE_SHOW);
  let h = '<section class="panel a-notes" aria-label="Notes"><div class="ph"><span class="ph-t">Notes</span><span class="ph-m">' + (all.length ? all.length + (all.length === 1 ? ' NOTE' : ' NOTES') : 'SCRATCHPAD') + '</span></div>' +
    '<div class="nt-new"><label class="sr" for="note-new">New note</label><textarea class="inp" id="note-new" data-bind="notes.draft" rows="2" maxlength="' + NOTE_MAX + '" placeholder="' + (COARSE ? 'Jot anything, then tap SAVE.' : 'Jot anything. Enter saves, Shift+Enter adds a line.') + '">' + esc(N.draft) + '</textarea>' +
    '<button class="btn solid" type="button" data-act="note-add">SAVE</button></div>';
  if (all.length > 6) h += '<label class="sr" for="note-q">Search notes</label><input class="inp nt-q" id="note-q" type="search" data-bind="notes.q" data-live="1" placeholder="Search notes" value="' + esc(N.q) + '" autocomplete="off">';
  if (!all.length) h += '<p class="hint">Phone numbers, ideas, links, things to look up later. Anything that turns out to be a task becomes an op with one tap.</p>';
  else if (!list.length) h += '<p class="ag-empty">No notes match that search.</p>';
  else h += '<ul class="nt-list">' + show.map(noteRowHTML).join('') + '</ul>';
  if (!q && list.length > NOTE_SHOW) h += '<button class="link nt-all" type="button" data-act="note-all">' + (N.all ? 'SHOW FEWER' : 'SHOW ALL ' + list.length) + '</button>';
  return h + '</section>';
}
let noteDelT = 0;
document.addEventListener('keydown', function (ev) {
  const t = ev.target; if (!t || ev.isComposing) return;
  if (t.id === 'note-new' && ev.key === 'Enter' && !ev.shiftKey && !COARSE) { ev.preventDefault(); noteAdd(); }
  else if (t.id === 'note-edit' && ev.key === 'Enter' && (ev.ctrlKey || ev.metaKey)) { ev.preventDefault(); noteSave(ui.notes.edit); }
  else if (t.id === 'note-edit' && ev.key === 'Escape') { ev.stopImmediatePropagation(); ui.notes.edit = null; render(); }
});
document.addEventListener('input', function (ev) { if (ev.target && ev.target.id === 'note-new') draftStore(ev.target.value); });

/* ================= OFFLINE ================= */
/* A page on claude.ai needs internet to open. For Wi-Fi-free use: download a self-contained copy with your data inside.
   The copy saves in its browser; EXPORT CHANGES makes a file, and IMPORT OFFLINE CHANGES here merges it back. */
let DL = null;
function initDownloads() { if (window.claude && typeof window.claude.use === 'function' && !SEED) window.claude.use('downloads').then(function (d) { DL = d || null; }).catch(function () { DL = null; }); }
function withoutIds(o) { const m = {}; Object.keys(o || {}).forEach(function (id) { const b = clone(o[id]); delete b.id; m[id] = b; }); return m; }
function snapshotData() { return { hq: clone(S.hq), ops: withoutIds(S.ops), log: clone(S.days) || {}, feed: clone(S.feed), cal: clone(S.cals) || {}, notes: withoutIds(S.notes) }; }
function offlineHTML(snap) {
  const tpl = document.createElement('template');
  tpl.innerHTML = BOOT_BODY;
  Array.prototype.slice.call(tpl.content.querySelectorAll('script')).forEach(function (s) { if (s.id !== 'zg-main') s.parentNode.removeChild(s); });
  const seed = '<script type="application/json" id="zg-seed">' + JSON.stringify(snap).replace(/</g, '\\u003c') + '<\/script>';
  return '<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><title>ZERØ GAP · Offline</title><style>body{margin:0;padding:0}img{max-width:100%}[hidden]{display:none!important}</style></head><body>' + seed + tpl.innerHTML + '</body></html>';
}
async function downloadCopy() {
  if (!S.ready || S.mode !== 'db') return;
  if (!DL) { toast('Downloads are off in this view', 'Open ZERØ GAP on claude.ai in a browser and try again.', 'warn'); return; }
  if (!BOOT_BODY || BOOT_BODY.indexOf('zg-main') < 0) { toast('Could not build the offline copy', 'Reload the page and try again.', 'bad'); return; }
  const snap = { kind: 'zerogap-copy', v: 1, copyId: uid('c'), at: Date.now(), data: snapshotData() };
  try {
    await DL.save({ filename: 'zero-gap-offline-' + dayKey(Date.now()) + '.html', data: new Blob([offlineHTML(snap)], { type: 'text/html' }) });
    toast('Offline copy saved', 'Open it in Chrome or Edge on your computer. It works without Wi-Fi.', 'good');
  } catch (e) {
    const c = e && e.code;
    if (c === 'declined') return;
    toast('Download did not start', c === 'rate_limited' ? 'A save prompt is already open.' : 'Try again from Settings.', 'warn');
  }
}
function exportChanges() {
  if (!(SEED && store && store.dump)) return;
  const pkg = { kind: 'zerogap-sync', v: 1, copyId: SEED.copyId, made: SEED.at, at: Date.now(), base: SEED.data, data: store.dump() };
  const name = 'zero-gap-changes-' + dayKey(Date.now()) + '.json';
  try {
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([JSON.stringify(pkg)], { type: 'application/json' }));
    a.download = name; document.body.appendChild(a); a.click();
    setTimeout(function () { URL.revokeObjectURL(a.href); a.remove(); }, 3000);
    toast('Changes file saved', 'Back online: ZERØ GAP → Settings → IMPORT OFFLINE CHANGES, pick ' + name + '.', 'good');
  } catch (e) { toast('Could not save the file', 'Your changes are still here. Try again.', 'bad'); }
}
function stable(o) { return JSON.stringify(o === undefined ? null : o, function (k, v) { return v && typeof v === 'object' && !Array.isArray(v) ? Object.keys(v).sort().reduce(function (a, x) { a[x] = v[x]; return a; }, {}) : v; }); }
/* Three-way merge: only what changed in the copy since it was made is written here; everything else stays as it is now. */
function mergeSync(base, cur) {
  let n = 0;
  const each = function (b, c, put, del) {
    b = b || {}; c = c || {};
    Object.keys(Object.assign({}, b, c)).forEach(function (id) {
      if (stable(b[id]) === stable(c[id])) return;
      if (c[id] == null) del(id); else put(id, c[id]);
      n++;
    });
  };
  each(base.ops, cur.ops, function (id, v) { saveOp(Object.assign({}, v, { id: id })); }, function (id) { if (S.ops[id]) removeOp(id); });
  each(base.notes, cur.notes, function (id, v) { saveNote(Object.assign({}, v, { id: id })); }, function (id) { if (S.notes[id]) removeNote(id); });
  each(base.cal, cur.cal, function (id, v) { saveCal(id, v); }, function (id) { if (S.cals[id]) removeCal(id); });
  const bl = base.log || {}, cl = cur.log || {};
  Object.keys(cl).forEach(function (date) {
    ['blocks', 'routes'].forEach(function (f) {
      const cf = (cl[date] && cl[date][f]) || {}, bf = (bl[date] && bl[date][f]) || {};
      Object.keys(cf).forEach(function (id) { if (stable(bf[id]) === stable(cf[id])) return; addLocalDay(date, f, id, cf[id]); store.addToDay(date, f, id, cf[id]); n++; });
    });
  });
  if (cur.hq) {
    const bh = base.hq || {}, patch = {};
    Object.keys(Object.assign({}, bh, cur.hq)).forEach(function (k) { if (stable(bh[k]) !== stable(cur.hq[k])) patch[k] = cur.hq[k] === undefined ? null : cur.hq[k]; });
    if (Object.keys(patch).length) { patchHQ(patch); n++; }
  }
  if (cur.feed && stable(base.feed) !== stable(cur.feed)) { saveFeed(Object.assign({}, S.feed || {}, cur.feed)); n++; }
  return n;
}
async function importSync(files) {
  const f = files && files[0]; if (!f) return;
  if (!S.ready || S.mode !== 'db') { toast('Open the main ZERØ GAP to import', 'Changes merge into your synced data, not into a copy.', 'warn'); return; }
  let pkg = null;
  try { pkg = JSON.parse(await f.text()); } catch (e) { pkg = null; }
  if (!pkg || pkg.kind !== 'zerogap-sync' || !pkg.base || !pkg.data) { toast('Not a ZERØ GAP changes file', 'Pick the .json the offline copy saved with EXPORT CHANGES.', 'warn'); return; }
  const n = mergeSync(pkg.base, pkg.data);
  ui.modal = null;
  if (n) { Sfx.play('incoming'); toast('Offline changes merged', n + (n === 1 ? ' change' : ' changes') + ' from the copy made ' + (pkg.made ? dtg(pkg.made) : 'earlier') + '.', 'good'); }
  else toast('Nothing new in that file', 'Everything in it is already here.', 'info');
  render(); afterAction();
}
function initSyncInput() {
  const inp = document.createElement('input');
  inp.type = 'file'; inp.id = 'sync-in'; inp.accept = '.json,application/json'; inp.tabIndex = -1;
  inp.setAttribute('aria-hidden', 'true');
  inp.style.cssText = 'position:fixed;left:-9999px;top:0;width:1px;height:1px;opacity:0';
  inp.addEventListener('change', function () { const fs = Array.prototype.slice.call(inp.files || []); inp.value = ''; if (fs.length) { if (isApp()) pickRestore(fs); else importSync(fs); } });
  document.body.appendChild(inp);
}
function offlineSettingsHTML() {
  if (S.mode === 'local' && S.why === 'copy') {
    return '<div class="audio-sec"><div class="lbl">Offline copy</div><p>This copy runs without Wi-Fi and saves in this browser. Back online, export your changes and import them into ZERØ GAP.</p><div class="row"><button class="btn sm hud" type="button" data-act="off-export">EXPORT CHANGES</button></div></div>';
  }
  if (isApp()) return appSettingsHTML();
  if (S.mode !== 'db') return '';
  return '<div class="audio-sec"><div class="lbl">Offline</div>' +
    '<p>ZERØ GAP now has its own app that works offline on your phone. Move your data: EXPORT BACKUP here, then RESTORE BACKUP in the app.</p><div class="row" style="margin-bottom:6px"><button class="btn sm solid" type="button" data-act="backup-export">EXPORT BACKUP FOR THE APP</button><a class="btn sm hud" href="' + APP_URL + '" target="_blank" rel="noopener">OPEN THE APP ↗</a></div>' +
    '<p>Wi-Fi drops while ZERØ GAP is open? Keep working. Changes wait on this device and sync when you reconnect.</p>' +
    '<p>To open it with no internet at all, download a copy. It runs in Chrome or Edge on a computer, with your ops, notes, schedule, timer and ledger inside.</p>' +
    '<div class="row"><button class="btn sm hud" type="button" data-act="off-copy">DOWNLOAD OFFLINE COPY</button><button class="btn sm" type="button" data-act="off-import">IMPORT OFFLINE CHANGES</button></div></div>';
}

/* ================= STANDALONE APP (installable, offline, data on this device) ================= */
/* The same page runs as a home-screen app from GitHub Pages. There it saves on the device, works with no
   internet (service worker), and picks up new versions when online. Bump APP_VERSION here and VERSION in sw.js together. */
const APP_VERSION = '1.0.0';
const APP_URL = 'https://marinvanastrea.github.io/zero-gap/';
const BACKUP_KEY = 'zerogap.lastbackup';
function inClaude() { return !!(window.claude && typeof window.claude.use === 'function'); }
function isApp() { return S.mode === 'local' && S.why === 'app'; }
function lastBackup() { try { return Number(localStorage.getItem(BACKUP_KEY)) || 0; } catch (e) { return 0; } }
function markBackup() { try { localStorage.setItem(BACKUP_KEY, String(Date.now())); } catch (e) {} scheduleRender(); }
async function exportBackup() {
  if (!S.ready || !S.hq) { toast('Nothing to back up yet', 'Enlist first.', 'info'); return; }
  const pkg = { kind: 'zerogap-backup', v: 1, at: Date.now(), from: S.mode === 'db' ? 'claude' : 'app', data: snapshotData() };
  const name = 'zero-gap-backup-' + dayKey(Date.now()) + '.json', text = JSON.stringify(pkg);
  const after = S.mode === 'db' ? 'In the ZERØ GAP app: Settings → RESTORE BACKUP → pick ' + name + '.' : 'Keep it somewhere safe, like iCloud Drive or Google Drive.';
  if (DL) {
    try { await DL.save({ filename: name, data: text }); markBackup(); toast('Backup saved', after, 'good'); }
    catch (e) { if (!e || e.code !== 'declined') toast('Download did not start', 'Try again from Settings.', 'warn'); }
    return;
  }
  try {
    const file = new File([text], name, { type: 'application/json' });
    if (COARSE && navigator.canShare && navigator.canShare({ files: [file] })) {
      await navigator.share({ files: [file], title: 'ZERØ GAP backup' });
      markBackup(); toast('Backup ready', 'Pick Save to Files (or Drive) in the share sheet.', 'good');
      return;
    }
  } catch (e) { if (e && e.name === 'AbortError') return; }
  try {
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([text], { type: 'application/json' }));
    a.download = name; document.body.appendChild(a); a.click();
    setTimeout(function () { URL.revokeObjectURL(a.href); a.remove(); }, 3000);
    markBackup(); toast('Backup saved', after, 'good');
  } catch (e) { toast('Could not save the backup', 'Try again.', 'bad'); }
}
async function pickRestore(files) {
  const f = files && files[0]; if (!f) return;
  let pkg = null;
  try { pkg = JSON.parse(await f.text()); } catch (e) { pkg = null; }
  const ok = pkg && ['zerogap-backup', 'zerogap-sync', 'zerogap-copy'].indexOf(pkg.kind) >= 0 && pkg.data && typeof pkg.data === 'object';
  if (!ok) { toast('Not a ZERØ GAP backup', 'Pick the .json made with EXPORT BACKUP.', 'warn'); return; }
  ui.restore = { at: pkg.at || 0, data: pkg.data, name: f.name || '' }; ui.modal = 'restore'; render();
}
function applyRestore() {
  const r = ui.restore; if (!r || !store || !store.replaceAll) return;
  store.replaceAll(r.data);
  ui.restore = null; ui.modal = null; agCache = { key: '', list: [] };
  const n = Object.keys(S.ops).length, k = Object.keys(S.notes).length;
  Sfx.play('incoming');
  toast('Backup restored', n + (n === 1 ? ' op, ' : ' ops, ') + k + (k === 1 ? ' note' : ' notes') + ' on this device now.', 'good');
  render(); afterAction();
}
function restoreModalHTML() {
  const r = ui.restore, d = r.data || {}, c = function (o) { return Object.keys(o || {}).length; };
  const has = !!(S.hq || Object.keys(S.ops).length || Object.keys(S.notes).length);
  const stat = function (a, b) { return '<div><dt>' + a + '</dt><dd>' + b + '</dd></div>'; };
  return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="rs-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Backup' + (r.at ? ' · ' + dtg(r.at) : '') + '</div><h2 class="mtitle" id="rs-t">RESTORE BACKUP</h2></div>' + closeX('Cancel') + '</div>' +
    '<dl class="case-stats">' + stat('Agent', esc((d.hq && d.hq.callsign) || '—')) + stat('Ops', c(d.ops)) + stat('Notes', c(d.notes)) + stat('Calendars', c(d.cal)) + '</dl>' +
    '<p>' + (has ? 'This replaces everything on this device with the backup.' : 'This loads the backup onto this device.') + '</p>' +
    '<div class="row"><button class="btn solid" type="button" data-act="restore-ok">' + (has ? 'REPLACE WITH BACKUP' : 'RESTORE') + '</button><button class="btn" type="button" data-act="close-mod">CANCEL</button></div></div></div>';
}
function appSettingsHTML() {
  const lb = lastBackup();
  return '<div class="audio-sec"><div class="lbl">Backup · app v' + APP_VERSION + '</div>' +
    '<p>Everything lives on this device and works with no internet. A backup file keeps it safe if the phone is lost or the app is deleted, and moves it to another device.</p>' +
    '<p class="small">Last backup: ' + (lb ? calAgo(lb).toLowerCase() : 'never') + '.</p>' +
    '<div class="row"><button class="btn sm hud" type="button" data-act="backup-export">EXPORT BACKUP</button><button class="btn sm" type="button" data-act="backup-restore">RESTORE BACKUP</button></div></div>';
}
function appBannerHTML() {
  if (ui.update) return '<div class="banner ok"><div class="wrap bn-row"><span>NEW VERSION OF ZERØ GAP READY</span><button class="link bn-act" type="button" data-act="app-update">UPDATE NOW →</button></div></div>';
  if (!isApp() || !S.hq) return '';
  const lb = lastBackup(), age = Date.now() - (lb || S.hq.created || Date.now());
  if (age < (lb ? 14 : 3) * 86400000) return '';
  return '<div class="banner"><div class="wrap bn-row"><span>' + (lb ? 'LAST BACKUP ' + calAgo(lb) : 'NO BACKUP YET') + ' · Your data lives only on this device</span><button class="link bn-act" type="button" data-act="backup-export">BACK UP NOW →</button></div></div>';
}
function movedBannerHTML() {
  return '<div class="banner ok"><div class="wrap bn-row"><span>ZERØ GAP NOW HAS ITS OWN APP · works offline on your phone</span><span class="row"><button class="link bn-act" type="button" data-act="backup-export">1 · EXPORT BACKUP</button><a class="link bn-act" href="' + APP_URL + '" target="_blank" rel="noopener">2 · OPEN THE APP ↗</a></span></div></div>';
}
function initApp() {
  if (inClaude() || SEED) return;
  try { if (navigator.storage && navigator.storage.persist) navigator.storage.persist().catch(function () {}); } catch (e) {}
  if (!('serviceWorker' in navigator) || !/^https?:$/.test(location.protocol)) return;
  navigator.serviceWorker.register('sw.js').then(function (reg) {
    const ready = function () { if (reg.waiting && navigator.serviceWorker.controller) { ui.update = reg; scheduleRender(); } };
    ready();
    reg.addEventListener('updatefound', function () {
      const w = reg.installing; if (!w) return;
      w.addEventListener('statechange', function () { if (w.state === 'installed') ready(); });
    });
    setInterval(function () { reg.update().catch(function () {}); }, 60 * 60000);
    document.addEventListener('visibilitychange', function () { if (document.visibilityState === 'visible') reg.update().catch(function () {}); });
  }).catch(function (e) { console.warn('[zerogap] offline cache unavailable', e && e.message); });
  let reloaded = false;
  navigator.serviceWorker.addEventListener('controllerchange', function () { if (reloaded) return; reloaded = true; location.reload(); });
}

/* ================= TOASTS ================= */
let toastSeq = 0;
function toast(title, body, kind) {
  const box = document.getElementById('toasts'); if (!box) return;
  const id = ++toastSeq;
  const el = document.createElement('div');
  el.className = 'toast k-' + (kind || 'info'); el.dataset.id = String(id);
  el.innerHTML = '<b>' + esc(title) + '</b>' + (body ? '<span>' + esc(body) + '</span>' : '');
  box.appendChild(el);
  while (box.children.length > 3) box.removeChild(box.firstChild);
  if (kind === 'bad') Sfx.play('error');
  else if (performance.now() - Sfx.last > 220) Sfx.ui(kind === 'medal' ? 'medal' : kind || 'info');
  setTimeout(function () { if (el.parentNode) el.parentNode.removeChild(el); }, 3800);
}

/* ================= RENDER HELPERS ================= */
function setHTML(el, html) {
  if (!el || el.__html === html) return false;
  const ae = document.activeElement;
  let keep = null;
  if (ae && ae.id && el.contains(ae)) { keep = { id: ae.id, s: null, e: null, sc: ae.scrollTop }; try { keep.s = ae.selectionStart; keep.e = ae.selectionEnd; } catch (e) {} }
  el.innerHTML = html; el.__html = html;
  if (keep) {
    const n = document.getElementById(keep.id);
    if (n) { try { n.focus({ preventScroll: true }); } catch (e) { n.focus(); } try { if (keep.s != null) n.setSelectionRange(keep.s, keep.e); } catch (e) {} n.scrollTop = keep.sc || 0; }
  }
  return true;
}
function starPath(cx, cy, r) { let d = ''; for (let i = 0; i < 10; i++) { const rr = i % 2 ? r * .42 : r, a = -Math.PI / 2 + i * Math.PI / 5; d += (i ? 'L' : 'M') + (cx + rr * Math.cos(a)).toFixed(2) + ' ' + (cy + rr * Math.sin(a)).toFixed(2); } return d + 'Z'; }
function insignia(idx) {
  const st = 'style="stroke:var(--hud)"', fl = 'style="fill:var(--hud)"';
  let g = '';
  if (idx === 0) g = '<path d="M28 15L41 28L28 41L15 28Z" fill="none" ' + st + ' stroke-width="3"/><circle cx="28" cy="28" r="3" ' + fl + '/>';
  else if (idx <= 3) { const top = 28 - (idx - 1) * 5; for (let i = 0; i < idx; i++) { const y = top + i * 10; g += '<path d="M14 ' + (y + 6) + 'L28 ' + (y - 4) + 'L42 ' + (y + 6) + '" fill="none" ' + st + ' stroke-width="4.2"/>'; } }
  else if (idx === 4) { for (let i = 0; i < 3; i++) { const y = 15 + i * 9; g += '<path d="M14 ' + (y + 6) + 'L28 ' + (y - 4) + 'L42 ' + (y + 6) + '" fill="none" ' + st + ' stroke-width="3.6"/>'; } g += '<path d="M14 40Q28 48 42 40" fill="none" ' + st + ' stroke-width="3.6"/>'; }
  else {
    const n = idx - 4;
    const pos = n === 1 ? [[28, 28]] : n === 2 ? [[18, 28], [38, 28]] : n === 3 ? [[13, 30], [28, 24], [43, 30]] : [[18, 18], [38, 18], [18, 38], [38, 38]];
    const r = n <= 2 ? 10.5 : 8.5;
    pos.forEach(function (p) { g += '<path d="' + starPath(p[0], p[1], r) + '" ' + fl + '/>'; });
  }
  return '<svg viewBox="0 0 56 56" aria-hidden="true">' + g + '</svg>';
}
function resHTML(r) { let b = ''; for (let i = 1; i <= 5; i++) b += '<i class="' + (i <= r ? 'on' : '') + '"></i>'; return '<span class="res" title="Resistance ' + r + ' of 5"><span>RESIST</span><span class="bars" aria-hidden="true">' + b + '</span></span>'; }
function opMetaHTML(op, D) {
  const used = D.used[op.id] || 0;
  let out = (op.course ? '<span class="cchip">' + esc(courseLabel(op.course)) + '</span>' : '') + resHTML(op.res || 3);
  if (op.est) out += '<span>' + used + '/' + op.est + ' WIN</span>'; else if (used) out += '<span>' + used + ' WIN</span>';
  if (op.due) { const n = daysUntil(op.due); out += '<span class="' + (n !== null && n <= 0 ? 'due-hot' : n !== null && n <= 2 ? 'due-warm' : '') + '">' + tminus(op.due) + '</span>'; }
  return out;
}
function cellsHTML(blocks, quota, newId) {
  let out = blocks.map(function (b) { return '<span class="cell ' + TIERS[b.tier || 0].key + (b.m === 10 ? ' ten' : '') + (b.id === newId ? ' new' : '') + '" title="' + esc(dtg(b.t) + ' · ' + (b.title || '')) + '"></span>'; }).join('');
  for (let i = blocks.length; i < quota; i++) out += '<span class="cell empty"></span>';
  return out;
}
function stepLabel(s, route, i) {
  if (s.kind === 'here') return 'You are here: ' + s.text;
  if (s.kind === 'op') { const k = route.steps.slice(0, i).filter(function (x) { return x.kind === 'op'; }).length; return (k === 0 ? 'Warm-up op: ' : 'Chain op: ') + s.text; }
  if (s.kind === 'target') return 'Target: ' + s.text;
  return s.text;
}
const DAYS_ES = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];
function rtScheduled(op, d) { return !!(op && op.repeat && Array.isArray(op.repeat.days) && op.repeat.days.indexOf(d.getDay()) >= 0); }
function rtDone(op, k) { return !!(op && op.doneOn && op.doneOn[k || dayKey(Date.now())]); }
function rtLabel(op) {
  const d = ((op.repeat && op.repeat.days) || []).slice().sort(), s = d.join('');
  if (d.length === 7) return 'EVERY DAY';
  if (s === '12345') return 'WEEKDAYS';
  if (s === '06') return 'WEEKENDS';
  return d.map(function (x) { return DOW[x]; }).join(' · ');
}
function rtStreak(op) {
  const d = new Date(); d.setHours(12, 0, 0, 0);
  if (!rtDone(op, dayKey(d.getTime()))) d.setDate(d.getDate() - 1);
  let n = 0;
  for (let i = 0; i < 400; i++) {
    if (op.created && d.getTime() < op.created - 86400000) break;
    if (rtScheduled(op, d)) { if (rtDone(op, dayKey(d.getTime()))) n++; else break; }
    d.setDate(d.getDate() - 1);
  }
  return n;
}
function rtToggle(id) {
  const op = S.ops[id]; if (!op || !op.repeat) return;
  const k = dayKey(Date.now()), done = Object.assign({}, op.doneOn || {});
  if (done[k]) { delete done[k]; saveOp(Object.assign({}, op, { doneOn: done })); toast('Standing order unchecked', op.title, 'info'); render(); return; }
  done[k] = Date.now();
  const keys = Object.keys(done).sort(); while (keys.length > 120) delete done[keys.shift()];
  const upd = Object.assign({}, op, { doneOn: done });
  saveOp(upd);
  Sfx.play('stamp'); setTimeout(function () { Sfx.play('xp'); }, 260);
  const st = rtStreak(upd);
  toast('Standing order logged · ' + op.title, '+40 XP' + (st > 1 ? ' · ' + st + '-day streak' : ''), 'good');
  render(); afterAction();
}
function rtTodayHTML(D) {
  if (!D.routines.length) return '<p class="hint rt-hint">Something you do every day, like a workout or prayer? File it as a standing order on the Ops board.</p>';
  const now = new Date(), list = D.routines.filter(function (op) { return rtScheduled(op, now); });
  if (!list.length) return '<div class="rt-box"><div class="lbl">Standing orders today</div><p class="hint" style="margin:0">None scheduled today.</p></div>';
  const done = list.filter(function (op) { return rtDone(op); }).length;
  return '<div class="rt-box"><div class="lbl">Standing orders today · ' + done + '/' + list.length + '</div><ul class="rt-list">' + list.map(function (op) {
    const ok = rtDone(op), st = rtStreak(op);
    return '<li class="rt t5' + (ok ? ' done' : '') + '"><button type="button" class="rt-chk" data-act="rt-done" data-id="' + op.id + '" aria-pressed="' + ok + '" aria-label="' + (ok ? 'Uncheck: ' : 'Mark done today: ') + esc(op.title) + '">' + (ok ? '✓' : '') + '</button><span class="rt-t">' + esc(op.title) + '</span>' + (st ? '<span class="rt-st">' + st + (st === 1 ? ' DAY' : ' DAYS') + '</span>' : '') + '</li>';
  }).join('') + '</ul></div>';
}
function rtCardHTML(op, D) {
  const open = ui.expanded === op.id, today = rtScheduled(op, new Date()), done = rtDone(op), st = rtStreak(op);
  return '<article class="op t5' + (open ? ' editing' : '') + '"><div class="op-top"><span class="opcode">↻ ' + rtLabel(op) + '</span><span class="optag">' + esc(op.code) + '</span></div>' +
    '<h3 class="optitle">' + esc(op.title) + '</h3><div class="opmeta"><span>STREAK ' + st + (st === 1 ? ' DAY' : ' DAYS') + '</span>' + (today ? '<span class="' + (done ? 'good' : '') + '">' + (done ? 'DONE TODAY' : 'DUE TODAY') + '</span>' : '<span>OFF TODAY</span>') + '</div>' +
    '<div class="opact">' + (today ? '<button class="btn sm' + (done ? '' : ' hud') + '" type="button" data-act="rt-done" data-id="' + op.id + '">' + (done ? '↺ UNDO' : 'DONE TODAY ✓') + '</button>' : '') + '<button class="btn sm" type="button" data-act="edit" data-id="' + op.id + '" aria-expanded="' + open + '">' + (open ? 'CANCEL' : 'EDIT') + '</button></div>' +
    (open ? editHTML() : '') + '</article>';
}
function rtPanelHTML(D) {
  if (!D.routines.length) return '';
  return '<section class="panel rtn t5"><div class="ph"><span class="ph-t">Standing orders · ' + D.routines.length + '</span><span class="ph-m">RECURRING · NEVER CLOSES</span></div><div class="rt-cards">' + D.routines.map(function (op) { return rtCardHTML(op, D); }).join('') + '</div></section>';
}
function rtFieldHTML(e) {
  const d = (e.repeat && e.repeat.days) || [], s = d.slice().sort().join('');
  const mode = e.rtPick ? 'pick' : !d.length ? 'no' : d.length === 7 ? 'all' : s === '12345' ? 'wk' : 'pick';
  return '<div class="field"><span>Repeats</span><div class="chips">' + [['no', 'NO'], ['all', 'EVERY DAY'], ['wk', 'WEEKDAYS'], ['pick', 'PICK DAYS']].map(function (o) { return '<button type="button" class="chipbtn t5" data-act="rt-mode" data-v="' + o[0] + '" aria-pressed="' + (mode === o[0]) + '">' + o[1] + '</button>'; }).join('') + '</div>' +
    (mode === 'pick' ? '<div class="chips">' + [1, 2, 3, 4, 5, 6, 0].map(function (x) { return '<button type="button" class="chipbtn num" data-act="rt-day" data-v="' + x + '" aria-pressed="' + (d.indexOf(x) >= 0) + '" aria-label="' + DOW[x] + '">' + DAYS_ES[x] + '</button>'; }).join('') + '</div>' : '') + '</div>';
}
function dayLabel(k) { const d = parseDay(k); return DOW[d.getDay()] + ' ' + d.getDate() + ' ' + MON[d.getMonth()] + ' ' + d.getFullYear(); }
function doneCell(o) { return { id: o.id, t: o.closedAt, tier: o.tier || 0, title: o.title, m: 15 }; }
function suggHTML() {
  const list = (S.sugg || []).filter(function (x) { return x && x.title; }).sort(function (a, b) { return (b.created || 0) - (a.created || 0); });
  if (!list.length) return '';
  return '<section class="panel sugg"><div class="ph"><span class="ph-t">Claude intel · possible gaps</span><span class="ph-m">' + list.length + ' PENDING</span></div><p class="hint sg-hint">Pulled from your chats with Claude. File what is real, shred the rest.</p><ul class="sg-list">' +
    list.slice(0, 8).map(function (x) { return '<li><div class="sg-t"><b>' + esc(x.title) + '</b>' + (x.why ? '<span>' + esc(x.why) + '</span>' : '') + '</div><div class="row"><button class="btn sm hud" type="button" data-act="sg-add" data-id="' + esc(x.id) + '">FILE</button><button class="btn sm" type="button" data-act="sg-drop" data-id="' + esc(x.id) + '" aria-label="Shred suggestion">✕</button></div></li>'; }).join('') +
    '</ul>' + (list.length > 8 ? '<p class="srcnote">+' + (list.length - 8) + ' more queued behind these.</p>' : '') + '</section>';
}
function tabsHTML(D) {
  const n0 = D ? D.open[0].length : 0;
  return [['hq', 'HQ'], ['ops', 'OPS'], ['infil', 'INFIL'], ['ledger', 'LEDGER']].map(function (t) {
    return '<a class="tab" href="#' + t[0] + '"' + (ui.tab === t[0] ? ' aria-current="page"' : '') + '>' + ICON[t[0]] + '<span>' + t[1] + '</span>' + (t[0] === 'ops' && n0 ? '<span class="tab-n" aria-label="' + n0 + ' unsorted">' + n0 + '</span>' : '') + '</a>';
  }).join('');
}

/* ================= VIEWS ================= */
function viewLoading() {
  return '<div class="hq"><section class="panel frame a-agent agent"><div class="agent-emb">' + insignia(0) + '</div><div class="agent-main"><div class="lbl">Secure uplink</div><div class="callsign blink">CONNECTING</div><div class="rankline"><span class="clr">Decrypting your dossier: ops, blocks and rank.</span></div></div></section>' +
    '<section class="panel frame a-deploy"><div class="ph"><span class="ph-t">Next op</span></div><div class="nextop"><div class="optitle dim">Standing by for intel.</div></div><div class="deployrow"><button class="deploy-btn" type="button" disabled><span class="dl">STANDBY</span><span class="dt">--:--</span></button></div></section></div>';
}
function viewHQ(D) {
  if (!S.ready) return viewLoading();
  const hq = S.hq || {}, r = D.rank;
  const on = Math.round(r.pct * 24);
  let bar = ''; for (let i = 0; i < 24; i++) bar += '<i class="' + (i < on ? 'on' : '') + '"></i>';
  const agentNo = 'ZG-' + String(hash(String(hq.callsign || '') + String(hq.created || '')) % 10000).padStart(4, '0');
  const agent = '<section class="panel frame a-agent agent" aria-label="Agent profile"><div class="agent-emb">' + insignia(r.idx) + '</div>' +
    '<div class="agent-main"><div class="lbl">Callsign</div><div class="callsign">' + esc(hq.callsign || 'AGENT') + '</div><div class="rankline"><span class="rank">' + r.name + '</span><span class="clr">CLEARANCE L' + (r.idx + 1) + '</span></div></div>' +
    '<div class="xp"><div class="xpbar" role="progressbar" aria-label="Progress to next rank" aria-valuemin="0" aria-valuemax="100" aria-valuenow="' + Math.round(r.pct * 100) + '">' + bar + '</div>' +
    '<div class="xpmeta"><span><b>' + fmtN(D.xp) + '</b> XP</span><span>' + (r.next ? fmtN(r.next.xp - D.xp) + ' XP TO ' + r.next.name : 'MAXIMUM CLEARANCE') + '</span></div></div>' +
    '<dl class="astats"><div><dt>AGENT NO.</dt><dd>' + agentNo + '</dd></div><div><dt>ACTIVE DUTY</dt><dd>' + D.streak + ' DAY' + (D.streak === 1 ? '' : 'S') + '</dd></div><div><dt>OPS CLOSED</dt><dd>' + fmtN(D.doneTotal) + '</dd></div></dl></section>';

  let rec = D.rec;
  const route = hq.route, pin = ui.pinned && S.ops[ui.pinned], pinned = !!(pin && pin.status !== 'closed');
  if (pinned) rec = { op: pin, why: ui.pinWhy || 'Your call. Start with the smallest piece.' };
  let routeBar = '';
  if (route && route.steps && route.steps[route.at]) { const s = route.steps[route.at]; routeBar = '<a class="routebar" href="#infil"><span class="chip t2">INFIL ACTIVE</span><span class="rb-t"><b>' + s.wp + '</b>' + esc(stepLabel(s, route, route.at)) + '</span><span class="rb-go">CONTINUE →</span></a>'; }
  let next;
  if (rec) {
    const op = rec.op, T = TIERS[tierOf(op)];
    next = '<div class="nextop ' + T.key + '"><div class="why">▸ ' + esc(rec.why) + '</div><div class="opcode">OPERATION ' + esc(op.code) + ' · ' + T.name + '</div><div class="optitle">' + esc(op.title) + '</div>' + (op.notes ? '<p class="opnote">' + esc(op.notes) + '</p>' : '') + '<div class="opmeta">' + opMetaHTML(op, D) + '</div></div>' +
      '<div class="deployrow"><button class="deploy-btn" type="button" data-act="close-op" data-id="' + op.id + '"><span class="dl">MISSION COMPLETE</span><span class="dt">✓</span></button></div>' +
      '<div class="deployalt"><a class="btn amber" href="#infil">STUCK? RUN INFILTRATION</a><button class="btn" type="button" data-act="pick">CHOOSE ANOTHER OP</button>' + remBtnHTML(op) + '</div>' +
      (pinned ? '<div class="row" style="margin-top:8px"><button class="link" type="button" data-act="unpin">BACK TO RECOMMENDED OP</button></div>' : '') +
      '<div class="addon"><span class="lbl">Optional · op window</span><div class="row">' + [10, 15].map(function (m) { return '<button class="btn sm" type="button" data-act="deploy" data-id="' + op.id + '" data-v="' + m + '">' + m + ' MIN</button>'; }).join('') + '</div></div>';
  } else next = '<div class="nextop empty"><div class="optitle">No ops on the board.</div><p class="dim">Get everything out of your head first, one line per task. Sorting comes after.</p><div><button class="btn amber" type="button" data-act="dump">BRAIN DUMP</button></div></div>';
  const deploy = '<section class="panel frame a-deploy" aria-label="Next op"><div class="ph"><span class="ph-t">Next op</span><span class="ph-m">' + (D.doneToday.length < 2 ? 'PHASE 1 · WARM-UP ' + D.doneToday.length + '/2' : 'PHASE 2 · ENGAGE') + '</span></div>' + routeBar + next + '</section>';

  const left = Math.max(0, D.quota - D.doneToday.length), now = new Date();
  const today = '<section class="panel a-today" aria-label="Today\'s ops"><div class="ph"><span class="ph-t">Today\'s ops</span><span class="ph-m">' + DOW[now.getDay()] + ' ' + pad(now.getDate()) + ' ' + MON[now.getMonth()] + '</span></div>' +
    '<div class="tcount"><span class="big">' + D.doneToday.length + '</span><span class="of">/ ' + D.quota + '</span><span class="cap">' + (left ? left + ' MORE TO HIT QUOTA' : 'QUOTA MET') + '</span></div>' +
    '<div class="cells">' + cellsHTML(D.doneToday.map(doneCell), D.quota) + '</div><p class="hint">Every closed op colors one block. Got 15 spare minutes? Close one more.</p>' +
    (D.today.length ? '<p class="srcnote" style="margin-top:8px">+ ' + D.today.length + ' op window' + (D.today.length === 1 ? '' : 's') + ' run today</p>' : '') + rtTodayHTML(D) + '</section>';

  const rows = [1, 2, 3, 4].map(function (t) {
    const list = D.open[t], T = TIERS[t];
    let note = list.length ? esc(list[0].title) : 'Clear';
    if (t === 2 && list.length && list[0].due) note = tminus(list[0].due) + ' · ' + esc(list[0].title);
    return '<li class="' + T.key + '"><span class="chip">' + T.name + '</span><span class="note">' + note + '</span><span class="n">' + list.length + '</span></li>';
  }).join('');
  const ns = (S.sugg || []).length;
  const intel = '<section class="panel a-intel" aria-label="Board status"><div class="ph"><span class="ph-t">Board status</span><a class="link ph-m" href="#ops">OPEN BOARD →</a></div><ul class="intel">' + rows + '</ul>' + (D.open[0].length ? '<button class="btn amber" type="button" data-act="triage">TRIAGE ' + D.open[0].length + ' UNSORTED</button>' : '') +
    (ns ? '<a class="btn hud" href="#ops">REVIEW ' + ns + ' CLAUDE INTEL TIP' + (ns === 1 ? '' : 'S') + '</a>' : '') + '</section>';
  const manual = '<section class="panel a-manual manualcta"><div class="ph"><span class="ph-t">Field manual</span><span class="ph-m">2 MIN READ</span></div><p>Why starting is hard, and which station fixes which part.</p><button class="btn hud" type="button" data-act="manual">OPEN THE MANUAL</button></section>';
  return '<div class="hq"><div class="hq-col">' + agent + deploy + notesPanelHTML() + '</div><div class="hq-col">' + today + schedPanelHTML() + feedPanelHTML(D) + intel + manual + '</div></div>';
}
function opCardHTML(op, D) {
  if (op.repeat) return rtCardHTML(op, D);
  const T = TIERS[tierOf(op)], open = ui.expanded === op.id;
  return '<article class="op ' + T.key + (open ? ' editing' : '') + '"><div class="op-top"><span class="opcode">OPERATION ' + esc(op.code) + '</span><span class="optag">' + opTag(op.id) + '</span></div>' +
    '<h3 class="optitle">' + esc(op.title) + '</h3>' + (op.notes ? '<p class="opnote">' + esc(op.notes) + '</p>' : '') + '<div class="opmeta">' + opMetaHTML(op, D) + '</div>' +
    '<div class="opact"><button class="btn sm hud" type="button" data-act="close-op" data-id="' + op.id + '">CLOSE ✓</button><button class="btn sm" type="button" data-act="pick-op" data-id="' + op.id + '">DO NOW</button>' + remBtnHTML(op) + '<button class="btn sm" type="button" data-act="edit" data-id="' + op.id + '" aria-expanded="' + open + '">' + (open ? 'CANCEL' : 'EDIT') + '</button></div>' +
    (open ? editHTML() : '') + '</article>';
}
function editHTML() {
  const e = ui.edit; if (!e) return '';
  return '<div class="opedit">' +
    '<div class="field"><label for="edit-title">Title</label><input class="inp" id="edit-title" data-bind="edit.title" maxlength="140" value="' + esc(e.title) + '" autocomplete="off"></div>' +
    '<div class="field"><label for="edit-notes">Notes</label><textarea class="inp" id="edit-notes" data-bind="edit.notes" rows="3" maxlength="2000" placeholder="Context, links, what done looks like.">' + esc(e.notes || '') + '</textarea></div>' +
    rtFieldHTML(e) + '<div class="field"><span>How it feels</span><div class="chips">' + [1, 2, 3, 4, 0].map(function (t) { return '<button type="button" class="chipbtn ' + TIERS[t].key + '" data-act="edit-set" data-k="tier" data-v="' + t + '" aria-pressed="' + ((e.tier || 0) === t) + '">' + TIERS[t].name + '</button>'; }).join('') + '</div></div>' +
    '<div class="field"><span>Resistance · 1 easy, 5 brutal</span><div class="chips">' + [1, 2, 3, 4, 5].map(function (r) { return '<button type="button" class="chipbtn num" data-act="edit-set" data-k="res" data-v="' + r + '" aria-pressed="' + ((e.res || 3) === r) + '">' + r + '</button>'; }).join('') + '</div></div>' +
    '<div class="field"><span>Estimated windows</span><div class="chips">' + [0, 1, 2, 3, 4, 6, 8].map(function (n) { return '<button type="button" class="chipbtn num" data-act="edit-set" data-k="est" data-v="' + n + '" aria-pressed="' + ((e.est || 0) === n) + '">' + (n || '—') + '</button>'; }).join('') + '</div></div>' +
    '<div class="field"><label for="edit-due">Deadline (optional)</label><input class="inp" type="date" id="edit-due" data-bind="edit.due" value="' + esc(e.due || '') + '"></div>' +
    '<div class="field"><span>Codename</span><div class="cnrow"><span class="opcode">OPERATION ' + esc(e.code) + '</span><button type="button" class="btn sm" data-act="edit-reroll">REROLL</button></div></div>' +
    (e.src === 'canvas' ? '<div class="field"><span>Source</span><p class="srcnote">Pulled from Canvas' + (e.course ? ' · ' + esc(courseLabel(e.course)) : '') + '. ' + (e.autoTier !== false ? 'Tier follows the due date until you pick one.' : 'Tier is set by you.') + '</p>' + (/^https:\/\//.test(e.link || '') ? '<a class="link" href="' + esc(e.link) + '" target="_blank" rel="noopener">OPEN IN GOOGLE CALENDAR ↗</a>' : '') + '</div>' : '') +
    '<div class="row"><button class="btn sm solid" type="button" data-act="edit-save">SAVE</button><button class="btn sm danger" type="button" data-act="shred" data-id="' + e.id + '">' + (ui.confirmShred === e.id ? 'CONFIRM SHRED' : 'SHRED') + '</button></div></div>';
}
function viewOps(D) {
  if (!S.ready) return viewLoading();
  const n0 = D.open[0].length;
  const head = '<div class="vhead"><div class="vhead-t"><div class="eyebrow">Station 02 // Sprint board</div><h1 class="vt">OPS BOARD</h1><p class="vsub">Sorted by how each op feels, not what it is. Warm up in Sandbox or Grunt Work, then move to Critical.</p></div>' +
    '<div class="vhead-a"><button class="btn amber" type="button" data-act="dump">BRAIN DUMP</button>' + (n0 ? '<button class="btn hud" type="button" data-act="triage">TRIAGE ' + n0 + '</button>' : '') + '</div></div>';
  const qt = ui.draft.quickTier || 0;
  const quick = '<form class="panel quick" id="quickf" autocomplete="off"><div class="field"><label for="quick-in">New op</label><div class="quick-row"><input class="inp" id="quick-in" data-bind="draft.quick" maxlength="140" placeholder="What needs doing? Enter files it." value="' + esc(ui.draft.quick) + '"><button class="btn solid" type="submit">FILE</button></div></div>' +
    '<div class="chips" role="group" aria-label="File under">' + [0, 1, 2, 3, 4, 5].map(function (t) { return '<button type="button" class="chipbtn ' + TIERS[t].key + '" data-act="quick-tier" data-v="' + t + '" aria-pressed="' + (qt === t) + '">' + TIERS[t].name + '</button>'; }).join('') + '</div></form>';
  const intake = n0 ? '<section class="panel intake t0"><div class="ph"><span class="ph-t">Intake · ' + n0 + ' unsorted</span><button class="link ph-m" type="button" data-act="triage">TRIAGE NOW →</button></div><div class="intake-list">' + D.open[0].slice(0, 10).map(function (o) { return '<span class="intk">' + esc(o.title) + '</span>'; }).join('') + (n0 > 10 ? '<span class="intk more">+' + (n0 - 10) + ' more</span>' : '') + '</div></section>' : '';
  const cols = [1, 2, 3, 4].map(function (t) {
    const T = TIERS[t], list = D.open[t];
    return '<section class="col ' + T.key + '" aria-label="' + T.name + '"><header class="colh"><span class="nm">' + T.name + '</span><span class="pl">' + T.plain + '</span><span class="ct">' + list.length + '</span></header><p class="cold">' + T.desc + '</p><div class="cards">' +
      (list.length ? list.map(function (o) { return opCardHTML(o, D); }).join('') : '<div class="colempty">' + (t === 1 ? 'No fires. Good.' : 'Nothing here.') + '</div>') + '</div></section>';
  }).join('');
  const arch = D.closed.length ? '<section class="panel"><div class="ph"><span class="ph-t">Archive · ' + D.closed.length + ' closed</span><button class="link ph-m" type="button" data-act="archive">' + (ui.showArchive ? 'HIDE' : 'SHOW') + '</button></div>' + (ui.showArchive ? '<div class="archive">' + D.closed.slice(0, 40).map(archRowHTML).join('') + '</div>' : '') + '</section>' : '';
  return '<div class="view">' + head + suggHTML() + quick + intake + rtPanelHTML(D) + '<div class="board">' + cols + '</div>' + arch + '</div>';
}
function archRowHTML(op) {
  const x = closeXP(op), db = op.debrief || {};
  return '<div class="arow ' + TIERS[op.tier || 0].key + '"><div class="ar-main"><div class="opcode">OPERATION ' + esc(op.code) + '</div><button type="button" class="optitle case-link" data-act="case" data-id="' + op.id + '">' + esc(op.title) + '</button>' +
    (db.note ? '<p class="opnote">' + esc(db.note) + '</p>' : '') +
    '<div class="opmeta"><span>' + (op.closedAt ? dtg(op.closedAt) : '') + '</span>' + (db.mins ? '<span>' + hm(db.mins) + ' LOGGED</span>' : '') + ((op.used || 0) ? '<span>' + op.used + (op.est ? '/' + op.est : '') + ' WIN</span>' : '') + '<span class="good">+' + x.total + ' XP' + (x.tag ? ' · ' + x.tag : '') + '</span></div></div>' +
    '<div class="ar-side"><span class="mstamp">CLOSED</span><button class="link" type="button" data-act="case" data-id="' + op.id + '">CASE FILE</button><button class="link" type="button" data-act="reopen" data-id="' + op.id + '">REOPEN</button></div></div>';
}
function thermoHTML(cur, th) {
  const P = function (h) { return Math.max(0, Math.min(100, (h - HMIN) / (HMAX - HMIN) * 100)); };
  const a = P(th), b = P(cur), edge = function (p) { return p < 16 ? ' l' : p > 84 ? ' r' : ''; };
  return '<div class="thermo" style="background:' + THERMAL_CSS + '" role="img" aria-label="You are at heat ' + fmtHeat(cur) + ', target is at ' + fmtHeat(th) + '"><div class="gapband" style="left:' + Math.min(a, b).toFixed(1) + '%;width:' + Math.abs(b - a).toFixed(1) + '%"></div>' +
    '<div class="mk tgt' + edge(a) + '" style="left:' + a.toFixed(1) + '%"><span>TARGET ' + fmtHeat(th) + '</span></div><div class="mk you' + edge(b) + '" style="left:' + b.toFixed(1) + '%"><span>YOU ' + fmtHeat(cur) + '</span></div></div>' +
    '<div class="tscale"><span>COLD · BORING</span><span>HOT · STIMULATING</span></div>';
}
function routeChartSVG(steps, at) {
  const narrow = window.innerWidth < 600;
  const W = narrow ? 360 : 680, H = narrow ? 240 : 250, pl = 38, pr = 14, pt = 30, pb = 30, n = steps.length;
  const X = function (i) { return pl + (W - pl - pr) * (n === 1 ? .5 : i / (n - 1)); };
  const Y = function (h) { return pt + (H - pt - pb) * (1 - (Math.max(HMIN, Math.min(HMAX, h)) - HMIN) / (HMAX - HMIN)); };
  const h0 = steps[0].heat, hn = steps[n - 1].heat;
  let g = '';
  [300, 200, 100, 0].forEach(function (h) { g += '<line x1="' + pl + '" x2="' + (W - pr) + '" y1="' + Y(h).toFixed(1) + '" y2="' + Y(h).toFixed(1) + '" class="gl"/><text x="' + (pl - 6) + '" y="' + (Y(h) + 3.5).toFixed(1) + '" text-anchor="end" class="ax">' + fmtHeat(h) + '</text>'; });
  const stops = THERMAL.slice().reverse().map(function (p) { return '<stop offset="' + ((HMAX - p[0]) / (HMAX - HMIN) * 100).toFixed(1) + '%" stop-color="rgb(' + p[1].join(',') + ')"/>'; }).join('');
  let d = 'M' + X(0).toFixed(1) + ' ' + Y(h0).toFixed(1);
  for (let i = 1; i < n; i++) d += ' H' + X(i).toFixed(1) + ' V' + Y(steps[i].heat).toFixed(1);
  let pts = '';
  steps.forEach(function (s, i) {
    const x = X(i), y = Y(s.heat);
    const state = at < 0 ? (i === 0 ? 'done' : 'todo') : i < at ? 'done' : i === at ? 'cur' : 'todo';
    /* The route reaches each point from above and leaves to the right, so labels sit below-centre (the first one above). */
    const anchor = i === 0 ? 'start' : i === n - 1 ? 'end' : 'middle';
    const lx = i === 0 ? x - 6 : i === n - 1 ? x + 6 : x, ly = i === 0 ? y - 13 : Math.min(y + 23, H - 4), c = heatColor(s.heat);
    pts += '<g class="pt ' + state + '"><circle cx="' + x.toFixed(1) + '" cy="' + y.toFixed(1) + '" r="' + (state === 'cur' ? 7 : 5.5) + '" style="fill:' + (state === 'todo' ? '#0b0f14' : c) + ';stroke:' + (state === 'cur' ? 'var(--hud)' : c) + '" stroke-width="2"/>' +
      (state === 'cur' && !REDUCED ? '<circle cx="' + x.toFixed(1) + '" cy="' + y.toFixed(1) + '" r="7" fill="none" style="stroke:var(--hud)" stroke-width="1.5"><animate attributeName="r" values="7;16" dur="1.4s" repeatCount="indefinite"/><animate attributeName="opacity" values=".9;0" dur="1.4s" repeatCount="indefinite"/></circle>' : '') +
      '<text x="' + lx.toFixed(1) + '" y="' + ly.toFixed(1) + '" text-anchor="' + anchor + '" class="wl">' + s.wp + '</text></g>';
  });
  return '<svg viewBox="0 0 ' + W + ' ' + H + '" role="img" aria-label="Descent profile: ' + (n - 1) + ' steps from heat ' + fmtHeat(h0) + ' down to ' + fmtHeat(hn) + '"><defs><linearGradient id="rg" gradientUnits="userSpaceOnUse" x1="0" y1="' + Y(HMAX).toFixed(1) + '" x2="0" y2="' + Y(HMIN).toFixed(1) + '">' + stops + '</linearGradient></defs>' + g +
    '<line x1="' + X(0).toFixed(1) + '" y1="' + Y(h0).toFixed(1) + '" x2="' + X(n - 1).toFixed(1) + '" y2="' + Y(hn).toFixed(1) + '" class="direct"/>' +
    '<path d="' + d + '" fill="none" stroke="url(#rg)" stroke-width="3"/>' + pts + '</svg>';
}
function routeLegend(steps) {
  let big = 0;
  for (let i = 1; i < steps.length; i++) big = Math.max(big, steps[i - 1].heat - steps[i].heat);
  const jump = steps[0].heat - steps[steps.length - 1].heat;
  return '<div class="rlegend"><span class="lr route">YOUR ROUTE · BIGGEST STEP ' + fmtHeat(-big) + '</span><span class="lr jump">DIRECT JUMP ' + fmtHeat(-jump) + ' · REJECTED</span></div>';
}
function wpListHTML(route, live) {
  return '<ol class="wps">' + route.steps.map(function (s, i) {
    const st = !live ? (i === 0 ? 'here' : 'todo') : i < route.at ? 'done' : i === route.at ? 'cur' : 'todo';
    const delta = i ? s.heat - route.steps[i - 1].heat : 0;
    let acts = '';
    if (live && i === route.at) {
      if (s.kind === 'env' || s.kind === 'gen') acts = '<button class="btn sm hud" type="button" data-act="wp-next">' + (s.kind === 'env' ? 'REACHED' : 'DONE') + '</button>';
      else if (s.kind === 'op') acts = '<button class="btn sm hud" type="button" data-act="wp-done" data-id="' + esc(s.op) + '">CLOSED ✓</button><button class="btn sm" type="button" data-act="wp-next">SKIP</button>';
      else if (s.kind === 'target') acts = '<button class="btn sm solid" type="button" data-act="wp-breach">BREACH</button>';
    }
    return '<li class="wp ' + st + '" style="--h:' + heatColor(s.heat) + '"><span class="wpc">' + s.wp + '</span><div class="wpb"><div class="wpt">' + esc(stepLabel(s, route, i)) + '</div><div class="wpm">HEAT ' + fmtHeat(s.heat) + (i ? ' · STEP ' + fmtHeat(delta) : '') + '</div>' + (acts ? '<div class="wpa">' + acts + '</div>' : '') + '</div></li>';
  }).join('') + '</ol>';
}
function viewInfil(D) {
  if (!S.ready) return viewLoading();
  let out = '<div class="vhead"><div class="vhead-t"><div class="eyebrow">Station 03 // Downshift</div><h1 class="vt">INFILTRATION</h1><p class="vsub">Can\'t start? Don\'t jump the gap. Cool down in steps: each one a little less stimulating than the last, but still easy to start.</p></div></div>';
  const route = S.hq && S.hq.route;
  if (route && route.steps && route.steps.length) {
    const p = POSITIONS.find(function (x) { return x.id === route.from; });
    out += '<section class="panel frame"><div class="ph"><span class="ph-t">Active route · from ' + esc(p ? p.label.toLowerCase() : 'start') + '</span><span class="ph-m">WAYPOINT ' + Math.min(route.at + 1, route.steps.length) + '/' + route.steps.length + '</span></div><div class="rchart">' + routeChartSVG(route.steps, route.at) + '</div>' + routeLegend(route.steps) + wpListHTML(route, true) + '<div class="row end"><button class="link danger" type="button" data-act="route-abort">ABORT ROUTE</button></div></section>';
  }
  const pool = [1, 2, 3, 4, 0].reduce(function (a, x) { return a.concat(D.open[x]); }, []);
  if (!pool.length) return '<div class="view infil">' + out + '<section class="panel"><div class="ph"><span class="ph-t">No targets</span></div><p class="dim">File at least one op first. Infiltration needs a target.</p><div class="row" style="margin-top:12px"><a class="btn amber" href="#ops">GO TO OPS BOARD</a></div></section></div>';
  const tid = infilTargetId(D), tgt = S.ops[tid], th = opHeat(tgt);
  const pos = POSITIONS.find(function (p) { return p.id === ui.infil.pos; }) || null;
  out += '<section class="panel"><div class="ph"><span class="ph-t">' + (route ? 'New route · ' : '') + '01 · Where are you right now?</span></div><div class="posgrid">' +
    POSITIONS.map(function (p) { return '<button type="button" class="pos" data-act="pos" data-v="' + p.id + '" aria-pressed="' + (ui.infil.pos === p.id) + '" style="--h:' + heatColor(p.heat) + '"><span class="sw"></span><span class="pl">' + p.label + '</span><span class="phh">HEAT ' + fmtHeat(p.heat) + '</span></button>'; }).join('') + '</div></section>';
  const opts = [1, 2, 3, 4, 0].map(function (t) { return D.open[t].length ? '<optgroup label="' + TIERS[t].name + '">' + D.open[t].map(function (o) { return '<option value="' + o.id + '"' + (o.id === tid ? ' selected' : '') + '>' + esc(o.title) + '</option>'; }).join('') + '</optgroup>' : ''; }).join('');
  out += '<section class="panel"><div class="ph"><span class="ph-t">02 · Target op</span><span class="ph-m">HEAT ' + fmtHeat(th) + '</span></div><label class="sr" for="infil-tgt">Target op</label><select class="inp" id="infil-tgt" data-bind="infil.target" data-live="1">' + opts + '</select><p class="hint">Defaults to your most important open op. Its heat comes from its tier and resistance.</p></section>';
  if (!pos) out += '<section class="panel"><div class="ph"><span class="ph-t">03 · Gap readout</span></div><p class="dim">Pick where you are right now to read the gap.</p></section>';
  else {
    const plan = buildRoute(pos.id, tgt, D), gap = Math.max(0, pos.heat - th), v = verdict(gap);
    out += '<section class="panel frame"><div class="ph"><span class="ph-t">03 · Gap readout</span><span class="ph-m">THERMAL</span></div>' + thermoHTML(pos.heat, th) +
      '<div class="gapread"><div class="gapnum"><span class="lbl">GAP</span>' + gap + '</div><div class="verdict ' + v.cls + '">' + v.label + '</div><p class="vtext">' + v.text + '</p></div>' +
      (plan.direct
        ? '<div class="row"><button class="deploy-btn" type="button" data-act="pin-go" data-id="' + tgt.id + '"><span class="dl">ENGAGE</span><span class="dt">→</span></button></div>'
        : '<div class="rchart">' + routeChartSVG(plan.steps, -1) + '</div>' + routeLegend(plan.steps) + wpListHTML({ steps: plan.steps, at: -1 }, false) + '<div class="row"><button class="deploy-btn" type="button" data-act="route-start"><span class="dl">INFILTRATE</span><span class="dt">' + (plan.steps.length - 1) + ' STEPS</span></button></div>') +
      '</section>';
  }
  return '<div class="view infil">' + out + '</div>';
}
function viewLedger(D) {
  if (!S.ready) return viewLoading();
  const head = '<div class="vhead"><div class="vhead-t"><div class="eyebrow">Station 04 // Record</div><h1 class="vt">LEDGER</h1><p class="vsub">Every closed op is one colored block. The score that matters: starting, not perfection.</p></div></div>';
  const weekDone = D.week.reduce(function (s, w) { return s + w.done.length; }, 0), left = Math.max(0, D.quota - D.doneToday.length);
  const tiles = [
    ['Today', D.doneToday.length + '<small>/' + D.quota + '</small>', left ? left + ' TO QUOTA' : 'QUOTA MET'],
    ['This week', String(weekDone), 'OPS CLOSED'],
    ['All time', fmtN(D.doneTotal), 'OPS CLOSED'],
    ['Routes', fmtN(D.routes.length), 'INFILTRATIONS RUN'],
    ['Streak', D.streak + '<small>D</small>', 'BEST ' + D.longest + 'D'],
    ['Time logged', D.loggedMin ? hm(D.loggedMin) : '—', 'FROM DEBRIEFS'],
    ['Op windows', fmtN(D.total), D.total ? hm(D.focusMin) + ' FOCUSED' : 'OPTIONAL']
  ].map(function (t) { return '<div class="tile"><div class="lbl">' + t[0] + '</div><div class="v">' + t[1] + '</div><div class="s">' + t[2] + '</div></div>'; }).join('');
  const week = D.week.map(function (w) {
    const isT = w.k === D.todayK, fut = w.k > D.todayK;
    return '<div class="wrow' + (isT ? ' today' : '') + (fut ? ' fut' : '') + '">' + (fut ? '<span class="wd">' + DOW[w.d.getDay()] + ' ' + pad(w.d.getDate()) + '</span>' : '<button type="button" class="wd" data-act="day" data-v="' + w.k + '" aria-label="Open the report for ' + dayLabel(w.k) + '">' + DOW[w.d.getDay()] + ' ' + pad(w.d.getDate()) + '</button>') + '<div class="cells sm">' + cellsHTML(w.done.map(doneCell), isT ? D.quota : 0) + '</div><span class="wn">' + w.done.length + '</span></div>';
  }).join('');
  const mon = D.week[0].d;
  let heat = '';
  for (let wk = 12; wk >= 0; wk--) for (let i = 0; i < 7; i++) {
    const d = new Date(mon.getFullYear(), mon.getMonth(), mon.getDate() - wk * 7 + i, 12), k = dayKey(d.getTime()), c = D.closesByDay[k] || 0;
    const lv = c === 0 ? 0 : c <= 1 ? 1 : c <= 3 ? 2 : c <= 5 ? 3 : 4;
    heat += k > D.todayK ? '<span class="hc fut"></span>' : '<button type="button" class="hc l' + lv + (k === D.todayK ? ' now' : '') + '" data-act="day" data-v="' + k + '" title="' + dayLabel(k) + ': ' + c + ' closed" aria-label="' + dayLabel(k) + ', ' + c + ' closed. Open the day report"></button>';
  }
  const ladder = RANKS.map(function (r, i) { return '<li class="' + (i < D.rank.idx ? 'got' : i === D.rank.idx ? 'cur' : '') + '"><span>L' + (i + 1) + '</span><span>' + r[1] + '</span><span>' + fmtN(r[0]) + '</span></li>'; }).join('');
  const got = BADGES.filter(function (b) { return D.badges[b.id]; }).length;
  const medals = BADGES.map(function (b) {
    const has = D.badges[b.id];
    return '<div class="medal' + (has ? ' got' : '') + '"><div class="hex"><svg viewBox="0 0 24 24" aria-hidden="true">' + GLYPH[b.glyph] + '</svg></div><div class="mn">' + (has ? b.name : '<span class="redact" style="width:' + (b.name.length * .62).toFixed(1) + 'em" role="img" aria-label="Locked commendation"></span>') + '</div><div class="mr">' + b.req + '</div></div>';
  }).join('');
  const recent = D.closed.slice(0, 12).map(function (o) { return '<li class="' + TIERS[o.tier || 0].key + '"><span class="cell"></span><button type="button" class="t case-link" data-act="case" data-id="' + o.id + '"><span class="opcode">OPERATION ' + esc(o.code) + '</span>' + esc(o.title) + '</button><span class="d">' + (o.debrief && o.debrief.mins ? hm(o.debrief.mins) + ' · ' : '') + (o.closedAt ? dtg(o.closedAt) : '') + '</span></li>'; }).join('');
  return '<div class="view">' + head + '<div class="tiles">' + tiles + '</div><div class="lgrid">' +
    '<section class="panel frame"><div class="ph"><span class="ph-t">This week</span><span class="ph-m">' + weekDone + ' OPS CLOSED</span></div><div class="week">' + week + '</div><div class="legend">' + [1, 2, 3, 4, 0].map(function (t) { return '<span class="lg ' + TIERS[t].key + '"><i></i>' + TIERS[t].name + '</span>'; }).join('') + '</div></section>' +
    '<section class="panel"><div class="ph"><span class="ph-t">Last 13 weeks</span><span class="ph-m">COLUMNS = WEEKS</span></div><div class="heat">' + heat + '</div><p class="hint">Brighter squares mean more ops closed that day. Tap any square to open the report for that day.</p></section>' +
    '<section class="panel"><div class="ph"><span class="ph-t">Clearance ladder</span><span class="ph-m">' + fmtN(D.xp) + ' XP</span></div><ol class="ladder">' + ladder + '</ol><p class="hint">XP: closed ops pay 60 to 200 by tier, plus 50 on budget or 100 under budget. Finished routes pay 50 plus 10 per step. Optional op windows add 100 per 15-min window, 70 per 10-min.</p></section>' +
    '<section class="panel"><div class="ph"><span class="ph-t">Commendations</span><span class="ph-m">' + got + '/' + BADGES.length + '</span></div><div class="medals">' + medals + '</div></section>' +
    '<section class="panel span2"><div class="ph"><span class="ph-t">Recently closed</span><span class="ph-m">TAP FOR CASE FILE</span></div>' + (recent ? '<ul class="logl">' + recent + '</ul>' : '<p class="dim">No closed ops yet. Your first one shows up here.</p>') + '</section>' +
    '</div></div>';
}
/* ================= OVERLAYS ================= */
function wedgePath(f) {
  const cx = 150, cy = 150, r = 121;
  if (f <= .0005) return '';
  if (f >= .9995) return 'M' + cx + ' ' + (cy - r) + 'A' + r + ' ' + r + ' 0 1 1 ' + cx + ' ' + (cy + r) + 'A' + r + ' ' + r + ' 0 1 1 ' + cx + ' ' + (cy - r) + 'Z';
  const a = f * Math.PI * 2, x = cx + r * Math.sin(a), y = cy - r * Math.cos(a);
  return 'M' + cx + ' ' + cy + 'L' + cx + ' ' + (cy - r) + 'A' + r + ' ' + r + ' 0 ' + (f > .5 ? 1 : 0) + ' 1 ' + x.toFixed(2) + ' ' + y.toFixed(2) + 'Z';
}
function scopeSVG(mins) {
  const every = mins === 10 ? 6 : 4;
  let ticks = '';
  for (let i = 0; i < 60; i++) {
    const a = i / 60 * Math.PI * 2, major = i % every === 0, r1 = major ? 125 : 130, r2 = 137;
    ticks += '<line x1="' + (150 + r1 * Math.sin(a)).toFixed(1) + '" y1="' + (150 - r1 * Math.cos(a)).toFixed(1) + '" x2="' + (150 + r2 * Math.sin(a)).toFixed(1) + '" y2="' + (150 - r2 * Math.cos(a)).toFixed(1) + '" class="' + (major ? 'tk mj' : 'tk') + '"/>';
  }
  const sweep = REDUCED ? '' : '<g><path d="M150 150L150 30A120 120 0 0 1 210 46.1Z" fill="url(#swg)"/><line x1="150" y1="150" x2="210" y2="46.1" class="swl"/><animateTransform attributeName="transform" type="rotate" from="0 150 150" to="360 150 150" dur="6s" repeatCount="indefinite"/></g>';
  return '<svg viewBox="0 0 300 300" role="img" aria-label="Visual timer: the colored wedge is the time left"><defs><radialGradient id="wg" cx="50%" cy="50%" r="50%"><stop offset="0" style="stop-color:var(--tc);stop-opacity:.95"/><stop offset="1" style="stop-color:var(--tc);stop-opacity:.72"/></radialGradient><linearGradient id="swg" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#ffffff" stop-opacity="0"/><stop offset="1" stop-color="#ffffff" stop-opacity=".16"/></linearGradient></defs>' +
    '<circle cx="150" cy="150" r="146" class="ring1"/><circle cx="150" cy="150" r="140" class="ring2"/>' + ticks + '<circle cx="150" cy="150" r="121" class="face"/><path id="wedge" d="" style="fill:url(#wg)"/>' +
    '<g class="cross"><line x1="30" y1="150" x2="270" y2="150"/><line x1="150" y1="30" x2="150" y2="270"/><circle cx="150" cy="150" r="80"/><circle cx="150" cy="150" r="44"/></g>' + sweep +
    '<circle cx="150" cy="150" r="36" class="hub"/><text id="digits" x="150" y="157" text-anchor="middle" class="dig">--:--</text></svg>';
}
function overlayType() {
  const a = S.hq && S.hq.active;
  if (a && !ui.minimized) return a.kind === 'break' ? 'break' : 'window';
  if (!a && (ui.overlay === 'secured' || ui.overlay === 'breakdone')) return ui.overlay;
  return null;
}
function lockChip() { return Sfx.enabled() && !Sfx.unlocked ? '<button class="chip audio-lock" type="button" data-act="arm-audio">AUDIO LOCKED · TAP TO ARM</button>' : ''; }
function popBtn() { return '<button class="btn sm hud" type="button" data-act="popout">' + (Pip.active ? 'POP IN' : 'POP OUT') + '</button>'; }
function silenceLink() { return Sfx.ringing ? '<button class="link" type="button" data-act="silence">SILENCE ALARM</button>' : ''; }
function overlayHTML(D) {
  if (ui.widget) return '';
  const t = overlayType(), a = S.hq && S.hq.active;
  if (t === 'window') {
    const T = TIERS[a.tier || 0];
    return '<div class="ov ' + T.key + '" role="dialog" aria-modal="true" aria-label="Op window active"><div class="ov-in"><div class="ov-top"><span class="rec"><i></i>OP WINDOW ACTIVE · ' + a.mins + ' MIN</span>' + lockChip() + '<div class="ov-btns">' + popBtn() + '<button class="btn sm" type="button" data-act="minimize">MINIMIZE</button></div></div>' +
      '<div class="ov-op"><div class="opcode">' + (a.code ? 'OPERATION ' + esc(a.code) : 'UNASSIGNED WINDOW') + '</div><div class="optitle">' + esc(a.title) + '</div><span class="chip">' + T.name + '</span></div>' +
      '<div class="scope">' + scopeSVG(a.mins) + '</div><p class="ov-rule"><b>Objective:</b> work on it for ' + a.mins + ' minutes. Finishing is optional. No negotiating until the window closes.</p>' +
      (a.opId && S.ops[a.opId] && S.ops[a.opId].status !== 'closed' ? '<button class="btn hud" type="button" data-act="finish-early">MISSION COMPLETE ✓</button>' : '') +
      '<button class="hold" id="hold" type="button" aria-label="Hold for 1.5 seconds to abort the window"><span>HOLD TO ABORT</span></button></div></div>';
  }
  if (t === 'break') {
    return '<div class="ov brk" role="dialog" aria-modal="true" aria-label="Stand down"><div class="ov-in"><div class="ov-top"><span class="rec"><i></i>STAND DOWN · 15 MIN</span>' + lockChip() + '<div class="ov-btns">' + popBtn() + '<button class="btn sm" type="button" data-act="minimize">MINIMIZE</button></div></div>' +
      '<div class="ov-op"><div class="opcode">BREAK</div><div class="optitle">Keep it low-stim so the gap stays small.</div></div><div class="scope">' + scopeSVG(15) + '</div>' +
      '<p class="ov-rule">Water, stretch, walk, look out a window. Phone stays face down. When the timer ends, you redeploy.</p><button class="btn" type="button" data-act="end-break">END BREAK EARLY</button></div></div>';
  }
  if (t === 'secured' && ui.secured) {
    const s = ui.secured, T = TIERS[s.tier || 0], op = s.op && S.ops[s.op], opOpen = op && op.status !== 'closed', r = D.rank;
    return '<div class="ov ' + T.key + (Sfx.ringing ? ' ringing' : '') + '" role="dialog" aria-modal="true" aria-label="Window secured"><div class="ov-in sec"><div class="stamp good">SECURED</div><div class="xppop">+' + s.xp + ' XP</div>' +
      '<div class="ov-op"><div class="opcode">' + (s.code ? 'OPERATION ' + esc(s.code) : 'UNASSIGNED WINDOW') + '</div><div class="optitle">' + esc(s.title) + '</div></div>' +
      '<div class="secbox"><div class="ph"><span class="ph-t">Op windows today</span><span class="ph-m">' + D.today.length + ' BLOCKS</span></div><div class="cells">' + cellsHTML(D.today, 0, s.id) + '</div><div class="xpmeta"><span><b>' + r.name + '</b></span><span>' + (r.next ? fmtN(r.next.xp - D.xp) + ' XP TO ' + r.next.name : 'MAXIMUM CLEARANCE') + '</span></div></div>' +
      '<div class="secact"><button class="deploy-btn" type="button" data-act="again"><span class="dl">DEPLOY AGAIN</span><span class="dt">' + pad(ui.mins) + ':00</span></button><button class="btn hud" type="button" data-act="break">STAND DOWN · 15 MIN BREAK</button>' +
      (opOpen ? '<button class="btn" type="button" data-act="close-sec">OBJECTIVE COMPLETE · CLOSE OP</button>' : '') + silenceLink() + '<button class="link" type="button" data-act="dismiss">BACK TO HQ</button></div></div></div>';
  }
  if (t === 'breakdone') {
    const op = ui.breakOp && S.ops[ui.breakOp], name = op && op.status !== 'closed' ? op.title : (D.rec ? D.rec.op.title : 'Unassigned window');
    return '<div class="ov brk' + (Sfx.ringing ? ' ringing' : '') + '" role="dialog" aria-modal="true" aria-label="Break over"><div class="ov-in sec"><div class="stamp good">BREAK OVER</div><div class="ov-op"><div class="opcode">Next up</div><div class="optitle">' + esc(name) + '</div></div>' +
      '<div class="secact"><button class="deploy-btn" type="button" data-act="redeploy"><span class="dl">REDEPLOY</span><span class="dt">' + pad(ui.mins) + ':00</span></button>' + silenceLink() + '<button class="link" type="button" data-act="dismiss">BACK TO HQ</button></div></div></div>';
  }
  return '';
}
/* Compact layout for a small window (for example one pinned on top with PowerToys). */
function widgetHTML(D) {
  if (!S.ready) return '<div class="wdg brk"><div class="wdg-l blink">CONNECTING</div></div>';
  if (!S.hq) return '<div class="wdg brk"><div class="wdg-l">ENLIST FIRST</div></div>';
  const a = S.hq.active, cells = '<div class="cells sm">' + cellsHTML(D.doneToday.map(doneCell), D.quota) + '</div>';
  if (a) {
    const brk = a.kind === 'break', T = TIERS[brk ? 0 : (a.tier || 0)];
    return '<div class="wdg ' + (brk ? 'brk' : T.key) + '"><div class="wdg-top"><span class="rec"><i></i>' + (brk ? 'STAND DOWN' : 'OP WINDOW · ' + a.mins + ' MIN') + '</span>' + lockChip() + '</div>' +
      '<div class="scope">' + scopeSVG(a.mins) + '</div><div class="wdg-op">' + esc(brk ? 'Break. Back soon.' : a.title) + '</div>' +
      (brk ? '<button class="btn sm" type="button" data-act="end-break">END BREAK EARLY</button>' : '<button class="hold" id="hold" type="button" aria-label="Hold for 1.5 seconds to abort the window"><span>HOLD TO ABORT</span></button>') + '</div>';
  }
  if (ui.overlay === 'secured' && ui.secured) {
    const s = ui.secured, op = s.op && S.ops[s.op], opOpen = op && op.status !== 'closed';
    return '<div class="wdg ' + TIERS[s.tier || 0].key + (Sfx.ringing ? ' ringing' : '') + '"><div class="wdg-l good">SECURED</div><div class="wdg-x">+' + s.xp + ' XP</div><div class="wdg-op">' + esc(s.title) + '</div>' + cells +
      '<div class="wdg-act"><button class="btn solid" type="button" data-act="again">AGAIN · ' + ui.mins + '</button><button class="btn hud" type="button" data-act="break">BREAK</button>' + (opOpen ? '<button class="btn" type="button" data-act="close-sec">CLOSE OP</button>' : '') + '</div>' + silenceLink() + '<button class="link" type="button" data-act="dismiss">DONE</button></div>';
  }
  if (ui.overlay === 'breakdone') {
    return '<div class="wdg brk' + (Sfx.ringing ? ' ringing' : '') + '"><div class="wdg-l good">BREAK OVER</div><div class="wdg-act"><button class="btn solid" type="button" data-act="redeploy">REDEPLOY · ' + ui.mins + '</button></div>' + silenceLink() + '<button class="link" type="button" data-act="dismiss">DONE</button></div>';
  }
  const rec = D.rec;
  return '<div class="wdg brk"><div class="wdg-top"><span class="rec idle"><i></i>STANDBY</span>' + lockChip() + '</div>' +
    (rec ? '<div class="opcode ' + TIERS[tierOf(rec.op)].key + '">OPERATION ' + esc(rec.op.code) + '</div><div class="wdg-op">' + esc(opLabel(rec.op)) + '</div>' : '<div class="wdg-op">No ops on the board.</div>') +
    (rec ? '<button class="deploy-btn" type="button" data-act="close-op" data-id="' + rec.op.id + '"><span class="dl">COMPLETE</span><span class="dt">✓</span></button>' : '') + cells + '</div>';
}
function miniHTML() {
  const a = S.hq && S.hq.active;
  if (!a || !ui.minimized) return '';
  return '<div class="mini ' + (a.kind === 'break' ? 'brk' : TIERS[a.tier || 0].key) + '"><button type="button" class="mini-pop" data-act="popout" aria-label="' + (Pip.active ? 'Close the pop-out timer' : 'Pop out the timer') + '" title="Pop out the timer">' + ICON.pip + '</button><button type="button" class="mini-main" data-act="restore" aria-label="Open the timer"><span class="rec"><i></i></span><span class="mini-l">' + (a.kind === 'break' ? 'STAND DOWN' : 'OP WINDOW') + '</span><span class="mini-t" id="mini-t">' + fmtMS(a.end - Date.now()) + '</span><span class="mini-o">' + esc(a.kind === 'break' ? 'Back soon' : a.title) + '</span><span class="mini-go">OPEN</span></button></div>';
}

/* ================= MODALS ================= */
function segHTML(label, act, cur, opts) {
  return '<div class="field"><span>' + label + '</span><div class="seg" role="radiogroup" aria-label="' + label + '">' + opts.map(function (o) { return '<button type="button" role="radio" aria-checked="' + (cur === o[1]) + '" data-act="' + act + '" data-v="' + o[0] + '">' + o[2] + '</button>'; }).join('') + '</div></div>';
}
function closeX(label) { return '<button class="ibtn mx" type="button" data-act="close-mod" aria-label="' + (label || 'Close') + '">✕</button>'; }
function modalHTML(D) {
  const m = ui.modal;
  if (m === 'enroll') {
    const e = ui.enroll;
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="en-t"><div class="mcard enroll"><div class="mstamp2">NEW RECRUIT</div><div><div class="eyebrow">ZERØ GAP // Enrollment</div><h2 class="mtitle" id="en-t">AGENT ENROLLMENT</h2></div>' +
      '<p>This system runs your tasks like covert ops. Two quick choices, then you dump your task list.</p>' +
      '<div class="field"><label for="enroll-cs">Callsign</label><input class="inp big" id="enroll-cs" data-bind="enroll.callsign" maxlength="18" placeholder="' + esc(e.sugg[0]) + '" value="' + esc(e.callsign) + '" autocomplete="off"></div>' +
      '<div class="chips">' + e.sugg.map(function (s) { return '<button type="button" class="chipbtn" data-act="en-sugg" data-v="' + esc(s) + '">' + esc(s) + '</button>'; }).join('') + '<button type="button" class="chipbtn" data-act="en-reroll">↻ MORE</button></div>' +
      '<div class="field"><span>Daily quota · ops closed</span><div class="seg" role="radiogroup" aria-label="Daily quota">' + [1, 2, 3, 4, 5].map(function (q) { return '<button type="button" role="radio" aria-checked="' + (e.quota === q) + '" data-act="en-quota" data-v="' + q + '">' + q + '</button>'; }).join('') + '</div><p class="hint" style="margin-top:4px">' + e.quota + (e.quota === 1 ? ' op' : ' ops') + ' closed a day. You can change it later.</p></div>' +
      '<button class="deploy-btn" type="button" data-act="enlist"><span class="dl">ENLIST</span><span class="dt">→</span></button>' + (isApp() ? '<button class="link" type="button" data-act="backup-restore">MOVING FROM CLAUDE? RESTORE A BACKUP →</button>' : '') + '</div></div>';
  }
  if (m === 'dump') {
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="dm-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Intake</div><h2 class="mtitle" id="dm-t">BRAIN DUMP</h2></div>' + closeX() + '</div>' +
      '<p>Everything in your head, one line per task. Don\'t sort it and don\'t judge it. Triage comes next.</p><label class="sr" for="dump-text">Tasks, one per line</label>' +
      '<textarea class="inp" id="dump-text" data-bind="draft.dump" rows="9" placeholder="email professor about lab 3&#10;laundry&#10;edit gameplay clip&#10;renew car registration&#10;study for quiz">' + esc(ui.draft.dump) + '</textarea>' +
      '<button class="deploy-btn" type="button" data-act="dump-save"><span class="dl">UPLOAD INTEL</span><span class="dt">→</span></button>' + suggHTML() + '</div></div>';
  }
  if (m === 'triage' && ui.triage) {
    const tr = ui.triage, op = S.ops[tr.queue[tr.i]];
    if (!op) return '';
    const left = tr.queue.length - tr.i - 1;
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="tr-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Intel triage · ' + (tr.i + 1) + ' of ' + tr.queue.length + '</div><h2 class="mtitle" id="tr-t">HOW DOES IT FEEL?</h2></div>' + closeX('Pause triage') + '</div>' +
      '<div class="tri-op"><div class="opcode">OPERATION ' + esc(op.code) + '</div><div class="optitle">' + esc(op.title) + '</div></div>' +
      '<div class="field"><span>Resistance · 1 easy, 5 brutal</span><div class="seg" role="radiogroup" aria-label="Resistance">' + [1, 2, 3, 4, 5].map(function (r) { return '<button type="button" role="radio" aria-checked="' + (tr.res === r) + '" data-act="tri-res" data-v="' + r + '">' + r + '</button>'; }).join('') + '</div></div>' +
      '<div class="field"><label for="tri-due">Deadline (optional)</label><input class="inp" type="date" id="tri-due" data-bind="triage.due" value="' + esc(tr.due) + '"></div>' +
      '<div class="field"><span>Tap the tier to file it</span><div class="tri-tiers">' + [1, 2, 3, 4].map(function (t) { return '<button type="button" class="tri ' + TIERS[t].key + '" data-act="tri-tier" data-v="' + t + '"><span class="nm">' + TIERS[t].name + '</span><span class="pl">' + TIERS[t].plain.toUpperCase() + '</span><span class="ds">' + TIERS[t].desc + '</span></button>'; }).join('') + '</div></div>' +
      '<button class="btn t5 rt-tri" type="button" data-act="tri-routine">↻ STANDING ORDER (REPEATS DAILY)</button><div class="row"><button class="btn sm" type="button" data-act="tri-skip">SKIP</button><button class="btn sm danger" type="button" data-act="tri-shred">SHRED IT</button><span class="dim small">' + left + ' left after this</span></div></div></div>';
  }
  if (m === 'pick') {
    const groups = [1, 2, 3, 4, 0].filter(function (t) { return D.open[t].length; }).map(function (t) {
      return '<div class="pk-g ' + TIERS[t].key + '"><div class="pk-h"><span class="chip">' + TIERS[t].name + '</span></div>' + D.open[t].map(function (o) { return '<button type="button" class="pk" data-act="pick-op" data-id="' + o.id + '"><span class="opcode">OPERATION ' + esc(o.code) + '</span><span class="pk-t">' + esc(o.title) + '</span>' + resHTML(o.res || 3) + '</button>'; }).join('') + '</div>';
    }).join('');
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="pk-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Your call</div><h2 class="mtitle" id="pk-t">CHOOSE AN OP</h2></div>' + closeX() + '</div>' + (groups || '<p>No open ops.</p>') + '</div></div>';
  }
  if (m === 'manual') {
    const sec = [
      ['The gap', 'Every activity has a heat level. Scrolling in bed runs hot, around +300. Opening a boring document runs cold, around −10. Your brain compares what you are doing now with what is next and refuses big drops. That refusal is not laziness. It is the gap.', 'Fix the gap, not your willpower.'],
      ['Infiltration', 'Do not jump the gap. Step down instead: bed to desk (keep scrolling), then the same app on the PC browser, then your easiest op, then a second easy op, then the target. Each step is a little less stimulating than the last, and still easy to start.', 'INFIL station plots the route for you.'],
      ['Tiers', 'Sort ops by how they feel, not by what they are. An email about taxes and an email about a fun project are different ops. Warm up in Sandbox or Grunt Work. Once you are rolling, move to Critical and stay in one tier so you do not pay switching costs.', 'OPS board. NEXT OP on HQ follows this order.'],
      ['Mission complete', 'The goal is to start, not to finish perfectly. When an op is done, close it with MISSION COMPLETE and HQ hands you the next one. Every closed op colors one block.', 'MISSION COMPLETE on HQ.'],
      ['Op windows (optional)', 'Need a forcing function? Run a 10- or 15-minute op window with the timer where you can see it. No negotiating mid-window. It is an extra: the system works without it.', '10 MIN / 15 MIN under the next op. Hold-to-abort is for real emergencies.'],
      ['The score', 'Every closed op colors one block on your board: the quick payoff that scrolling usually steals. Hit your daily quota, keep the streak alive and watch the clearance ladder climb.', 'LEDGER station.'],
      ['Baseline', 'Less scrolling overall lowers your baseline heat, which shrinks every gap. It helps, but you cannot block every distraction forever. The steps above work even when the distractions are right there.', 'Optional. The stations are the main tools.']
    ];
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="mn-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Doctrine</div><h2 class="mtitle" id="mn-t">FIELD MANUAL</h2></div>' + closeX() + '</div><div class="man">' +
      sec.map(function (s, i) { return '<div class="man-s"><span class="man-n">' + (i + 1) + '</span><div class="man-h">' + s[0].toUpperCase() + '</div><p class="man-p">' + s[1] + '</p><div class="man-a">→ ' + s[2] + '</div></div>'; }).join('') +
      '</div><p class="credit">Method from Ruri Ohama\'s video <a href="https://youtu.be/NOjCGhB-vkQ" target="_blank" rel="noopener">How I Trick My ADHD Brain to Do Stuff I Don\'t Want to Do</a>.</p></div></div>';
  }
  if (m === 'settings' && ui.settings) {
    const s = ui.settings;
    const modeText = S.mode === 'db' ? 'Secure store. Synced across your devices.' : S.why === 'guest' ? 'Guest terminal. Saved in this browser only.' : S.why === 'app' ? 'On this device. Works with no internet.' : S.why === 'copy' ? 'Offline copy. Saved in this browser only.' : 'Offline terminal. Saved in this browser only.';
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="st-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Terminal</div><h2 class="mtitle" id="st-t">SETTINGS</h2></div>' + closeX() + '</div>' +
      '<div class="field"><label for="set-cs">Callsign</label><input class="inp" id="set-cs" data-bind="settings.callsign" maxlength="18" value="' + esc(s.callsign) + '" autocomplete="off"></div>' +
      '<div class="field"><span>Daily quota</span><div class="stepper"><button type="button" class="btn sm" data-act="set-q" data-v="-1" aria-label="Lower quota">−</button><b>' + s.quota + '</b><span class="dim">' + (s.quota === 1 ? 'op' : 'ops') + ' closed a day</span><button type="button" class="btn sm" data-act="set-q" data-v="1" aria-label="Raise quota">+</button></div></div>' +
      '<div class="field"><span>Optional op window length</span><div class="seg" role="radiogroup" aria-label="Default window">' + [15, 10].map(function (x) { return '<button type="button" role="radio" aria-checked="' + (s.defMins === x) + '" data-act="set-mins" data-v="' + x + '">' + x + ' MIN</button>'; }).join('') + '</div></div>' +
      '<div class="audio-sec"><div class="lbl">Audio</div>' +
      segHTML('Sound', 'set-sound', s.sound, [['on', true, 'ON'], ['off', false, 'OFF']]) +
      '<div class="field"><label for="set-vol">Volume · ' + clampInt(s.vol, 0, 100, 80) + '%</label><input class="range" type="range" id="set-vol" min="0" max="100" step="5" data-bind="settings.vol" data-live="1" value="' + clampInt(s.vol, 0, 100, 80) + '"></div>' +
      segHTML('Background sound during windows', 'set-amb', s.amb, [['off', 'off', 'SILENT'], ['noise', 'noise', 'BROWN NOISE'], ['sonar', 'sonar', 'SONAR'], ['tick', 'tick', 'TICK']]) +
      segHTML('Button and typing sounds', 'set-uisfx', s.uisfx, [['on', true, 'ON'], ['off', false, 'OFF']]) +
      segHTML('End alarm', 'set-alarm', s.alarm, [['0', 0, 'ONCE'], ['30', 30, '30 SEC'], ['60', 60, '60 SEC']]) +
      '<div class="row"><button class="btn sm hud" type="button" data-act="set-test">TEST AUDIO</button><span class="dim small">Plays the end alarm.</span></div></div>' +
      offlineSettingsHTML() + segHTML('Debrief after closing an op', 'set-debrief', s.debrief, [['on', true, 'ASK'], ['off', false, 'SKIP']]) + '<div class="field"><span>Storage</span><p>' + modeText + '</p></div>' +
      '<div class="row"><button class="btn solid" type="button" data-act="set-save">SAVE</button><button class="btn" type="button" data-act="close-mod">CANCEL</button></div>' +
      '<div class="danger-zone">' + (ui.purgeOpen
        ? '<p>Deletes every op, block, route and rank. This cannot be undone. Type PURGE to confirm.</p><label class="sr" for="purge-in">Type PURGE</label><input class="inp" id="purge-in" data-bind="purgeText" data-live="1" autocomplete="off" value="' + esc(ui.purgeText) + '"><div class="row"><button class="btn danger" type="button" data-act="purge"' + (ui.purgeText.trim().toUpperCase() === 'PURGE' ? '' : ' disabled') + '>PURGE EVERYTHING</button><button class="btn sm" type="button" data-act="purge-cancel">CANCEL</button></div>'
        : '<button class="link danger" type="button" data-act="purge-open">PURGE ALL DATA…</button>') + '</div></div></div>';
  }
  if (m === 'promo') {
    const idx = ui.promo || 0;
    return '<div class="mod promo" role="dialog" aria-modal="true" aria-labelledby="pr-t"><div class="mcard"><div class="lbl">Promotion order · ' + dtg(Date.now()) + '</div><div class="promo-ins">' + insignia(idx) + '</div><div class="stamp good">PROMOTED</div>' +
      '<h2 class="promo-rank" id="pr-t">' + RANKS[idx][1] + '</h2><div class="clr">CLEARANCE L' + (idx + 1) + ' GRANTED</div><button class="btn solid" type="button" data-act="promo-ok">ACKNOWLEDGE</button></div></div>';
  }
  if (m === 'debrief' && ui.debrief) {
    const d = ui.debrief, op = S.ops[d.id]; if (!op) return '';
    const wins = D.blocks.filter(function (b) { return b.op === op.id; }), winMin = wins.reduce(function (a, b) { return a + (b.m || 15); }, 0);
    const presets = [[15, '15M'], [30, '30M'], [60, '1H'], [120, '2H'], [180, '3H'], [300, '5H']];
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="db-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Mission complete · Debrief</div><h2 class="mtitle" id="db-t">FILE THE REPORT</h2></div>' + closeX('Skip the debrief') + '</div>' +
      '<div class="tri-op"><div class="opcode">OPERATION ' + esc(op.code) + '</div><div class="optitle">' + esc(op.title) + '</div></div>' +
      '<div class="field"><label for="db-note">What did you do? (optional)</label><textarea class="inp" id="db-note" data-bind="debrief.note" rows="4" maxlength="2000" placeholder="What got done, what was tricky, what is left for next time.">' + esc(d.note) + '</textarea></div>' +
      '<div class="field"><span>Time spent</span><div class="chips">' + presets.map(function (p) { return '<button type="button" class="chipbtn num" data-act="db-mins" data-v="' + p[0] + '" aria-pressed="' + (d.mins === p[0] && !d.custom) + '">' + p[1] + '</button>'; }).join('') + '</div>' +
      '<label class="db-custom" for="db-min"><span>Or minutes</span><input class="inp" id="db-min" type="number" min="1" max="6000" inputmode="numeric" data-bind="debrief.custom" value="' + esc(d.custom) + '"></label></div>' +
      (wins.length ? '<p class="hint" style="margin:0">Op windows run on this op: ' + wins.length + ' (' + hm(winMin) + ').</p>' : '') +
      '<div class="row"><button class="btn solid" type="button" data-act="db-save">FILE REPORT</button><button class="btn" type="button" data-act="close-mod">SKIP</button></div></div></div>';
  }
  if (m === 'case' && ui.caseId) {
    const op = S.ops[ui.caseId]; if (!op) return '';
    const db = op.debrief || {}, x = closeXP(op), T = TIERS[op.tier || 0];
    const wins = D.blocks.filter(function (b) { return b.op === op.id; }), winMin = wins.reduce(function (a, b) { return a + (b.m || 15); }, 0);
    const days = op.created && op.closedAt ? Math.max(0, Math.round((op.closedAt - op.created) / 86400000)) : null;
    const stat = function (k, v) { return '<div><dt>' + k + '</dt><dd>' + v + '</dd></div>'; };
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="cf-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Case file · Operation ' + esc(op.code) + '</div><h2 class="mtitle" id="cf-t">' + esc(op.title) + '</h2></div>' + closeX() + '</div>' +
      '<div class="row"><span class="chip ' + T.key + '">' + T.name + '</span>' + (op.course ? '<span class="cchip">' + esc(courseLabel(op.course)) + '</span>' : '') + (op.status === 'closed' ? '<span class="chip t0">CLOSED</span>' : '<span class="chip t3">OPEN</span>') + '</div>' +
      '<dl class="case-stats">' + stat('Time logged', db.mins ? hm(db.mins) : '—') + stat('Op windows', wins.length ? wins.length + ' · ' + hm(winMin) : '—') + stat('On the board', days === null ? '—' : days === 0 ? 'SAME DAY' : days + (days === 1 ? ' DAY' : ' DAYS')) + stat('XP earned', op.status === 'closed' ? '+' + x.total : '—') +
        stat('Filed', op.created ? dtg(op.created) : '—') + stat('Closed', op.closedAt ? dtg(op.closedAt) : '—') + '</dl>' +
      '<div class="case-sec"><div class="lbl">Notes</div><p>' + (op.notes ? esc(op.notes) : '<span class="dim">No notes on this op.</span>') + '</p></div>' +
      '<div class="case-sec"><div class="lbl">Debrief</div><p>' + (db.note ? esc(db.note) : '<span class="dim">No debrief filed.</span>') + '</p></div>' +
      '<div class="row"><button class="btn hud" type="button" data-act="db-edit" data-id="' + op.id + '">' + (db.note || db.mins ? 'EDIT DEBRIEF' : 'ADD DEBRIEF') + '</button>' + (op.status === 'closed' ? '<button class="btn" type="button" data-act="reopen" data-id="' + op.id + '">REOPEN</button>' : '') + '<button class="btn" type="button" data-act="close-mod">DONE</button></div></div></div>';
  }
  if (m === 'day' && ui.dayK) {
    const k = ui.dayK, on = function (t) { return t && dayKey(t) === k; };
    const ops = D.closed.filter(function (o) { return on(o.closedAt); }).sort(function (a, b) { return a.closedAt - b.closedAt; });
    const rts = D.rdone.filter(function (o) { return on(o.closedAt); });
    const routes = D.routes.filter(function (x) { return on(x.t); });
    const wins = D.byDay[k] || [];
    const mins = ops.reduce(function (a, o) { return a + ((o.debrief && o.debrief.mins) || 0); }, 0) + wins.reduce(function (a, b) { return a + (b.m || 15); }, 0);
    const xp = ops.reduce(function (a, o) { return a + closeXP(o).total; }, 0) + rts.length * 40 + routes.reduce(function (a, x) { return a + routeXP(x.n); }, 0) + wins.reduce(function (a, b) { return a + blockXP(b.m); }, 0);
    const total = ops.length + rts.length;
    const d = parseDay(k), prev = dayKey(new Date(d.getFullYear(), d.getMonth(), d.getDate() - 1, 12).getTime()), next = dayKey(new Date(d.getFullYear(), d.getMonth(), d.getDate() + 1, 12).getTime());
    const stat = function (a, b) { return '<div><dt>' + a + '</dt><dd>' + b + '</dd></div>'; };
    const list = ops.map(function (o) {
      const T = TIERS[o.tier || 0], db = o.debrief || {}, note = db.note || o.notes || '';
      return '<li class="' + T.key + '"><div class="dr-top"><span class="opcode">' + T.name + ' · ' + pad(new Date(o.closedAt).getHours()) + ':' + pad(new Date(o.closedAt).getMinutes()) + '</span>' + (db.mins ? '<span class="chip t5">' + hm(db.mins) + '</span>' : '') + (o.course ? '<span class="cchip">' + esc(courseLabel(o.course)) + '</span>' : '') + '</div>' +
        '<button type="button" class="optitle case-link" data-act="case" data-id="' + o.id + '">' + esc(o.title) + '</button>' +
        (note ? '<p class="dr-note">' + esc(note) + '</p>' : '<p class="dr-note dim">No debrief. Tap the title to add one.</p>') + '</li>';
    }).join('');
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="dr-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Day report · ' + dayLabel(k) + '</div><h2 class="mtitle" id="dr-t">' + (total ? total + (total === 1 ? ' WIN ON FILE' : ' WINS ON FILE') : 'NO WINS LOGGED') + '</h2></div>' + closeX() + '</div>' +
      (total ? '<p class="dr-proof">Evidence on file: you did every one of these.</p>' : '<p>Nothing closed this day. Rest days are part of the mission too.</p>') +
      '<dl class="case-stats">' + stat('Ops closed', ops.length) + stat('Standing orders', rts.length) + stat('Time logged', mins ? hm(mins) : '—') + stat('XP earned', xp ? '+' + fmtN(xp) : '—') + '</dl>' +
      (list ? '<ul class="dr-list">' + list + '</ul>' : '') +
      (rts.length ? '<div class="case-sec"><div class="lbl">Standing orders kept</div><div class="chips">' + rts.map(function (o) { return '<span class="chip t5">✓ ' + esc(o.title) + '</span>'; }).join('') + '</div></div>' : '') +
      (routes.length ? '<p class="hint" style="margin:0">' + routes.length + ' infiltration route' + (routes.length === 1 ? '' : 's') + ' completed.</p>' : '') +
      '<div class="dr-nav"><button class="btn sm" type="button" data-act="day" data-v="' + prev + '">← PREV DAY</button>' + (next <= D.todayK ? '<button class="btn sm" type="button" data-act="day" data-v="' + next + '">NEXT DAY →</button>' : '') + '</div></div></div>';
  }
  if (m === 'pipfail') {
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="pf-t"><div class="mcard"><div class="mhead"><div><div class="eyebrow">Pop-out</div><h2 class="mtitle" id="pf-t">NO POP-OUT IN THIS VIEW</h2></div>' + closeX() + '</div>' +
      '<p>This browser view won\'t open a floating timer. You can still keep the timer on top of everything:</p>' +
      '<ol class="steps"><li>Open ZERØ GAP in its own app window (Chrome ⋮ → Cast, save, and share → Install page as app).</li><li>Drag that window small. Below about 600 × 600 the page turns into a compact timer widget.</li><li>Install Microsoft PowerToys, click the window, and press Win + Ctrl + T to pin it on top.</li></ol>' +
      '<p class="small">The pop-out works in Chrome and Edge on a computer, but some app views turn it off.</p><div class="row"><button class="btn" type="button" data-act="close-mod">GOT IT</button></div></div></div>';
  }
  if (m === 'restore' && ui.restore) return restoreModalHTML();
  if (m === 'away' && ui.away) {
    const a = ui.away;
    return '<div class="mod" role="dialog" aria-modal="true" aria-labelledby="aw-t"><div class="mcard"><div><div class="eyebrow">Debrief required</div><h2 class="mtitle" id="aw-t">WINDOW CLOSED OFF-SCREEN</h2></div>' +
      '<p>Your ' + a.mins + '-minute window on <b>' + esc(a.title) + '</b> ended at ' + dtg(a.end) + ' while this terminal was closed. Did you work it?</p>' +
      '<div class="row"><button class="btn solid" type="button" data-act="away-log">YES, LOG THE BLOCK</button><button class="btn" type="button" data-act="away-discard">NO, DISCARD</button></div></div></div>';
  }
  return '';
}
function bannerHTML() {
  const ab = appBannerHTML(); if (ab) return ab;
  if (S.mode === 'local' && S.why === 'copy') return '<div class="banner"><div class="wrap bn-row"><span>OFFLINE COPY · Works without Wi-Fi · saved in this browser' + (SEED && SEED.at ? ' · made ' + dtg(SEED.at) : '') + '</span><button class="link bn-act" type="button" data-act="off-export">EXPORT CHANGES →</button></div></div>';
  if (S.mode === 'db') {
    const n = obCount(), off = navigator.onLine === false;
    if (!n && !off) return movedBannerHTML();
    return '<div class="banner"><div class="wrap">' + (off ? 'NO CONNECTION · Keep working. ' : 'RECONNECTING · ') + (n ? n + (n === 1 ? ' change is' : ' changes are') + ' saved on this device and will sync automatically.' : 'New changes save on this device until you are back.') + '</div></div>';
  }
  if (S.mode !== 'local' || S.why === 'app') return '';
  return '<div class="banner"><div class="wrap">' + (S.why === 'guest' ? 'GUEST TERMINAL · This HQ belongs to another agent. Your progress saves in this browser only.' : 'OFFLINE TERMINAL · Progress saves in this browser only.') + '</div></div>';
}

/* ================= RENDER ================= */
function render() {
  const D = derive(); lastD = D;
  if (S.ready && !S.hq && ui.modal !== 'enroll' && ui.modal !== 'restore') ui.modal = 'enroll';
  if (S.hq && ui.modal === 'enroll') ui.modal = null;
  if (ui.modal === 'triage' && ui.triage && !S.ops[ui.triage.queue[ui.triage.i]]) { ui.triage = null; ui.modal = null; }
  if (!(S.hq && S.hq.active)) ui.minimized = false;
  setHTML($('#tabs-top'), tabsHTML(D));
  setHTML($('#tabs-bottom'), tabsHTML(D));
  setHTML($('#banner'), bannerHTML());
  setHTML($('#view'), ui.tab === 'ops' ? viewOps(D) : ui.tab === 'infil' ? viewInfil(D) : ui.tab === 'ledger' ? viewLedger(D) : viewHQ(D));
  setHTML($('#ov'), overlayHTML(D));
  setHTML($('#mod'), modalHTML(D));
  setHTML($('#mini'), miniHTML());
  setHTML($('#widget'), ui.widget ? widgetHTML(D) : '');
  document.body.classList.toggle('widget', !!ui.widget);
  document.body.classList.toggle('has-mini', !!(S.hq && S.hq.active && ui.minimized));
  document.body.classList.toggle('locked', !!((!ui.widget && overlayType()) || ui.modal));
  const sb = document.getElementById('snd-btn');
  if (sb) {
    const on = Sfx.enabled(), lk = on && !Sfx.unlocked && !!S.hq;
    setHTML(sb, on ? ICON.snd : ICON.mute);
    sb.classList.toggle('snd-off', !on); sb.classList.toggle('snd-lock', lk);
    sb.title = !on ? 'Sound is off. Tap to turn it on.' : lk ? 'Audio locked. Tap anywhere to arm it.' : 'Sound is on. Tap to mute.';
    sb.setAttribute('aria-pressed', String(on));
  }
  const pb = document.getElementById('pip-btn');
  if (pb) { setHTML(pb, ICON.pip); pb.classList.toggle('pip-on', Pip.active); pb.title = Pip.active ? 'Close the pop-out timer' : 'Pop out the timer'; pb.hidden = !(S.hq && S.hq.active) && !Pip.active; }
  updateTimer();
}
function renderClock() { const el = $('#dtg'); if (!el) return; const n = Date.now(); el.innerHTML = '<b>' + dtg(n) + '</b><span>' + zulu(n) + '</span>'; }
function updateTimer() {
  const a = S.hq && S.hq.active;
  if (!a) { if (document.title !== BASE_TITLE) document.title = BASE_TITLE; return; }
  const rem = Math.max(0, a.end - Date.now()), total = (a.mins || 15) * 60000;
  const w = document.getElementById('wedge'); if (w) w.setAttribute('d', wedgePath(rem / total));
  const dg = document.getElementById('digits'); if (dg) dg.textContent = fmtMS(rem);
  const mt = document.getElementById('mini-t'); if (mt) mt.textContent = fmtMS(rem);
  const sc = document.querySelector('.scope'); if (sc) sc.classList.toggle('final', rem > 0 && rem < 60000);
  document.title = fmtMS(rem) + (a.kind === 'break' ? ' · STAND DOWN' : ' · OP WINDOW');
}
/* Voice cues fire only when the countdown crosses the mark during this page's life, never in a burst after a reload. */
let cueLast = null;
function cueCheck(a) {
  if (!a || a.kind !== 'op' || !S.ready) { cueLast = null; return; }
  const rem = a.end - Date.now();
  if (cueLast && cueLast.start === a.start) {
    const p = cueLast.rem, cross = function (th) { return p > th && rem <= th; };
    if (a.mins === 15 && cross(450000)) Sfx.say('Halfway.');
    if (cross(300000)) Sfx.say('Five minutes remaining.');
    if (cross(60000)) Sfx.say('One minute.');
  }
  cueLast = { start: a.start, rem: rem };
}
/* A worker keeps the clock ticking while the tab is in the background; browsers slow down page timers there. */
function startClock() {
  try {
    const url = URL.createObjectURL(new Blob(['setInterval(function(){postMessage(0)},250)'], { type: 'text/javascript' }));
    const w = new Worker(url);
    w.onmessage = function () { tick(); };
    w.onerror = function () {};
  } catch (e) {}
  setInterval(tick, 1000);
}
function tick() {
  updateTimer();
  const a = S.hq && S.hq.active;
  cueCheck(a);
  if (Pip.active) Pip.draw();
  if (!a || !S.ready || Date.now() < a.end || completing === a.start) return;
  if (a.end <= pageLoadedAt) {
    if (a.kind === 'break') { completing = a.start; patchHQ({ active: null }); render(); return; }
    if (ui.awaySeen !== a.start) { ui.awaySeen = a.start; ui.away = a; ui.modal = 'away'; render(); }
    return;
  }
  completing = a.start;
  if (a.kind === 'break') finishBreak(a); else secureBlock(a);
}

/* ================= EVENTS ================= */
function closeModal() {
  if (ui.modal === 'triage') { ui.triage = null; ui.modal = null; const n = derive().open[0].length; if (n) toast('Triage paused', n + ' still unsorted. Resume from the OPS board.', 'info'); render(); return; }
  if (ui.modal === 'settings') { ui.purgeOpen = false; ui.purgeText = ''; }
  if (ui.modal === 'restore') ui.restore = null;
  if (ui.modal === 'case' && ui.caseBack) { ui.modal = 'day'; ui.dayK = ui.caseBack; ui.caseBack = null; render(); return; }
  if (ui.modal === 'debrief') { ui.debrief = null; ui.modal = ui.promoQueued ? 'promo' : null; ui.promoQueued = false; render(); return; }
  if (ui.modal === 'promo') ui.promo = 0;
  ui.modal = null; render();
}
function onEscape() {
  if (ui.modal) { if (ui.modal !== 'enroll' && ui.modal !== 'away') closeModal(); return; }
  const t = overlayType();
  if (t === 'window' || t === 'break') { ui.minimized = true; render(); return; }
  if (t) { ui.overlay = null; ui.secured = null; render(); }
}
const ACT_SFX = { manual: 'open', settings: 'open', dump: 'open', pick: 'open', triage: 'open', 'purge-open': 'warn', 'close-mod': 'close', 'promo-ok': 'close', dismiss: 'close', 'purge-cancel': 'close', 'crs-cancel': 'close', 'route-abort': 'abort', 'away-discard': 'abort', mins: 'blip', 'tri-res': 'blip', 'en-quota': 'blip', 'set-q': 'blip' };
const ACT_SELF = new Set(['deploy', 'pick-op', 'again', 'redeploy', 'wp-deploy', 'wp-breach', 'close-op', 'close-sec', 'shred', 'tri-tier', 'tri-shred', 'enlist', 'route-start', 'wp-next', 'pos', 'feed-sync', 'feed-link', 'set-test', 'minimize', 'restore', 'popout', 'end-break', 'purge', 'dump-save', 'break', 'away-log', 'sound-toggle', 'quick-tier', 'arm-audio', 'silence', 'note-add', 'off-copy']);
document.addEventListener('click', function (ev) {
  const el = ev.target.closest('[data-act]');
  if (!el) return;
  const act = el.dataset.act, v = el.dataset.v, id = el.dataset.id;
  Sfx.ensure();
  if (!ACT_SELF.has(act)) Sfx.ui(ACT_SFX[act] || 'tap');
  const D = lastD || derive();
  switch (act) {
    case 'sound-toggle': {
      if (!S.hq) break;
      const on = !Sfx.enabled();
      patchHQ({ sound: on }); Sfx.setLevel();
      if (on) { Sfx.unlock(); Sfx.play('lock'); }
      else { Sfx.silence(); Sfx.ambientStop(); try { window.speechSynthesis && window.speechSynthesis.cancel(); } catch (e) {} }
      toast(on ? 'Sound on' : 'Sound off', on ? '' : 'Alarms and voice are muted.', 'info'); render(); break;
    }
    case 'arm-audio': Sfx.unlock(); Sfx.play('lock'); render(); break;
    case 'silence': render(); break;
    case 'popout': Pip.toggle(); break;
    case 'day': ui.dayK = v; ui.modal = 'day'; render(); break;
    case 'case': ui.caseBack = ui.modal === 'day' ? ui.dayK : null; ui.caseId = id; ui.modal = 'case'; render(); break;
    case 'db-mins': if (ui.debrief) { ui.debrief.mins = Number(v); ui.debrief.custom = ''; render(); } break;
    case 'db-edit': { const op = S.ops[id]; if (op) { const db = op.debrief || {}, pre = [15, 30, 60, 120, 180, 300].indexOf(db.mins) >= 0; ui.debrief = { id: id, note: db.note || '', mins: pre ? db.mins : null, custom: db.mins && !pre ? String(db.mins) : '' }; ui.modal = 'debrief'; render(); } break; }
    case 'db-save': if (ui.debrief) { const d = ui.debrief, op = S.ops[d.id]; if (op) { const mins = d.custom ? clampInt(d.custom, 1, 6000, 0) : d.mins; const note = String(d.note || '').trim().slice(0, 2000); saveOp(Object.assign({}, op, { debrief: { note: note, mins: mins || null, at: Date.now() } })); toast('Debrief filed', (mins ? hm(mins) + ' logged' : 'No time logged') + ' · Operation ' + op.code, 'good'); } ui.debrief = null; ui.modal = ui.promoQueued ? 'promo' : null; ui.promoQueued = false; render(); } break;
    case 'set-debrief': if (ui.settings) { ui.settings.debrief = v === 'on'; render(); } break;
    case 'fullscreen': {
      const fail = function () { toast('Full screen is blocked here', 'Press F11 in your browser instead.', 'warn'); };
      try {
        if (document.fullscreenElement) { const q = document.exitFullscreen(); if (q && q.catch) q.catch(function () {}); }
        else if (document.documentElement.requestFullscreen) { const q = document.documentElement.requestFullscreen(); if (q && q.catch) q.catch(fail); }
        else fail();
      } catch (e) { fail(); }
      break;
    }
    case 'set-amb': if (ui.settings) { ui.settings.amb = v; render(); } break;
    case 'set-voice': if (ui.settings) { ui.settings.voice = v === 'on'; render(); } break;
    case 'set-uisfx': if (ui.settings) { ui.settings.uisfx = v === 'on'; render(); } break;
    case 'set-alarm': if (ui.settings) { ui.settings.alarm = Number(v) || 0; render(); } break;
    case 'set-test': if (ui.settings) { const s = ui.settings; Sfx.test({ sound: s.sound, vol: clampInt(s.vol, 0, 100, 80) / 100, voice: s.voice, uisfx: s.uisfx }); } break;
    case 'deploy': if (S.ready) startWindow(id || null, v ? Number(v) : ui.mins); break;
    case 'wp-done': routeAdvance(true); closeOp(id, true); break;
    case 'pin-go': ui.pinned = id || null; ui.pinWhy = 'Gap closable. Direct entry authorized.'; if (ui.tab !== 'hq') location.hash = 'hq'; else render(); break;
    case 'unpin': ui.pinned = null; render(); break;
    case 'rt-done': rtToggle(id); break;
    case 'rt-mode': if (ui.edit) { const e = ui.edit; e.rtPick = v === 'pick'; e.repeat = v === 'no' ? null : v === 'all' ? { days: [0, 1, 2, 3, 4, 5, 6] } : v === 'wk' ? { days: [1, 2, 3, 4, 5] } : { days: (e.repeat && e.repeat.days) || [] }; render(); } break;
    case 'rt-day': if (ui.edit) { const e = ui.edit, x = Number(v), d = ((e.repeat && e.repeat.days) || []).slice(), i = d.indexOf(x); if (i >= 0) d.splice(i, 1); else d.push(x); e.repeat = { days: d }; e.rtPick = true; render(); } break;
    case 'tri-routine': { const tr = ui.triage, op = tr && S.ops[tr.queue[tr.i]]; if (op) saveOp(Object.assign({}, op, { repeat: { days: [0, 1, 2, 3, 4, 5, 6] }, res: tr.res, autoTier: false })); toast('Standing order filed', op ? op.title : '', 'good'); triageNext(); break; }
    case 'finish-early': { const a = S.hq && S.hq.active; if (!a) break; completing = a.start; Sfx.silence(); Sfx.ambientStop(); releaseWake(); patchHQ({ active: null }); ui.minimized = false; if (a.opId && S.ops[a.opId]) closeOp(a.opId); else render(); break; }
    case 'sg-add': { const x = (S.sugg || []).find(function (y) { return y.id === id; }); if (x) { const op = newOp(String(x.title).slice(0, 140), clampInt(x.tier, 0, 4, 0)); if (isDate(x.due)) op.due = x.due; saveOp(op); store.dropSugg(id); toast('Op filed · ' + TIERS[tierOf(op)].name, 'Operation ' + op.code, 'good'); render(); } break; }
    case 'sg-drop': store.dropSugg(id); render(); break;
    case 'rem-link': { const op = S.ops[id], a = op && remAt(op); if (a) setTimeout(function () { const cur = S.ops[id]; if (cur) { saveOp(Object.assign({}, cur, { remLink: isoLocal(a) })); render(); } }, 400); break; }
    case 'rem-when': if (S.hq) { patchHQ({ remWhen: v }); remFail.clear(); scheduleRem(); render(); } break;
    case 'rem-auto': if (S.hq) { patchHQ({ remAuto: !remCfg().auto }); remFail.clear(); scheduleRem(); render(); } break;
    case 'mins': ui.mins = Number(v) === 10 ? 10 : 15; render(); break;
    case 'pick': ui.modal = 'pick'; render(); break;
    case 'pick-op': ui.pinned = id || null; ui.pinWhy = 'Your call. Start with the smallest piece.'; ui.modal = null; if (ui.tab !== 'hq') location.hash = 'hq'; else render(); break;
    case 'dump': ui.modal = 'dump'; render(); focusSoon('dump-text'); break;
    case 'dump-save': dumpSave(); break;
    case 'triage': openTriage(D); break;
    case 'tri-res': if (ui.triage) { ui.triage.res = Number(v); render(); } break;
    case 'tri-tier': triageAssign(Number(v)); break;
    case 'tri-skip': triageNext(); break;
    case 'tri-shred': { const t = ui.triage, oid = t && t.queue[t.i]; if (oid) removeOp(oid); Sfx.play('shred'); triageNext(); break; }
    case 'manual': ui.modal = 'manual'; render(); break;
    case 'settings': openSettings(); break;
    case 'close-mod': closeModal(); break;
    case 'quick-tier': ui.draft.quickTier = Number(v); Sfx.ui('t' + v); render(); break;
    case 'edit':
      if (ui.expanded === id) { ui.expanded = null; ui.edit = null; } else if (S.ops[id]) { ui.expanded = id; ui.edit = clone(S.ops[id]); ui.edit.tier = S.ops[id].repeat ? (S.ops[id].tier || 0) : tierOf(S.ops[id]); ui.confirmShred = null; }
      render(); if (ui.expanded) focusSoon('edit-title'); break;
    case 'edit-set': if (ui.edit) { ui.edit[el.dataset.k] = Number(v); render(); } break;
    case 'edit-reroll': if (ui.edit) { ui.edit.code = codename(); render(); } break;
    case 'edit-save': editSave(); break;
    case 'shred':
      if (ui.confirmShred === id) { const op = S.ops[id]; removeOp(id); ui.expanded = null; ui.edit = null; ui.confirmShred = null; Sfx.play('shred'); toast('Op shredded', op ? op.title : '', 'warn'); }
      else { ui.confirmShred = id; Sfx.play('warn'); }
      render(); break;
    case 'close-op': closeOp(id); break;
    case 'reopen': { if (ui.modal === 'case') ui.modal = null; const op = S.ops[id]; if (op) { saveOp(Object.assign({}, op, { status: 'open', closedAt: null, used: null })); toast('Op reopened', op.title, 'info'); render(); } break; }
    case 'archive': ui.showArchive = !ui.showArchive; render(); break;
    case 'pos': { ui.infil.pos = v; if (!ui.infil.target) ui.infil.target = infilTargetId(D); const p = POSITIONS.find(function (x) { return x.id === v; }); Sfx.play('scan', p ? p.heat : 0); render(); break; }
    case 'route-start': routeStart(); break;
    case 'wp-next': routeAdvance(false); break;
    case 'wp-deploy': routeAdvance(true); startWindow(id, 10); break;
    case 'wp-breach': routeBreach(); break;
    case 'route-abort': patchHQ({ route: null }); toast('Route aborted', 'Plot a new one any time.', 'warn'); render(); break;
    case 'minimize': ui.minimized = true; Sfx.ui('min'); render(); break;
    case 'restore': ui.minimized = false; Sfx.ui('max'); render(); break;
    case 'again': { const sid = ui.secured && ui.secured.op, op = sid && S.ops[sid]; startWindow(op && op.status !== 'closed' ? sid : (D.rec ? D.rec.op.id : null), ui.mins); break; }
    case 'break': startBreak(ui.secured && ui.secured.op); break;
    case 'close-sec': { const sid = ui.secured && ui.secured.op; ui.overlay = null; ui.secured = null; if (sid) closeOp(sid); else render(); break; }
    case 'dismiss': ui.overlay = null; ui.secured = null; render(); break;
    case 'end-break': abortWindow(); break;
    case 'redeploy': { const op = ui.breakOp && S.ops[ui.breakOp]; startWindow(op && op.status !== 'closed' ? op.id : (D.rec ? D.rec.op.id : null), ui.mins); break; }
    case 'enlist': enlist(); break;
    case 'en-sugg': ui.enroll.callsign = v; render(); break;
    case 'en-reroll': ui.enroll.sugg = pickSuggestions(); render(); break;
    case 'en-quota': ui.enroll.quota = Number(v); render(); break;
    case 'set-q': if (ui.settings) { ui.settings.quota = Math.max(1, Math.min(24, ui.settings.quota + Number(v))); render(); } break;
    case 'set-mins': if (ui.settings) { ui.settings.defMins = Number(v) === 10 ? 10 : 15; render(); } break;
    case 'set-sound': if (ui.settings) { ui.settings.sound = v === 'on'; render(); } break;
    case 'set-save': settingsSave(); break;
    case 'purge-open': ui.purgeOpen = true; ui.purgeText = ''; render(); focusSoon('purge-in'); break;
    case 'purge-cancel': ui.purgeOpen = false; ui.purgeText = ''; render(); break;
    case 'purge': if (ui.purgeText.trim().toUpperCase() === 'PURGE') purgeAll(); break;
    case 'promo-ok': ui.modal = null; ui.promo = 0; render(); break;
    case 'away-log': { const a = ui.away; ui.modal = null; ui.away = null; if (a) { completing = a.start; secureBlock(a, true); } else render(); break; }
    case 'away-discard': { const a = ui.away; ui.modal = null; ui.away = null; if (a && S.hq && S.hq.active && S.hq.active.start === a.start) patchHQ({ active: null }); render(); break; }
    case 'backup-export': exportBackup(); break;
    case 'backup-restore': { const inp = document.getElementById('sync-in'); if (inp) inp.click(); break; }
    case 'restore-ok': applyRestore(); break;
    case 'app-update': { const w = ui.update && ui.update.waiting; if (w) { toast('Updating', 'ZERØ GAP reloads in a second.', 'info'); w.postMessage('skip-waiting'); } else { ui.update = null; render(); } break; }
    case 'note-add': noteAdd(); break;
    case 'note-edit': { const n = S.notes[id]; if (n) { ui.notes.edit = id; ui.notes.editText = n.text; ui.notes.del = null; render(); focusSoon('note-edit'); } break; }
    case 'note-cancel': ui.notes.edit = null; render(); break;
    case 'note-save': noteSave(id); break;
    case 'note-pin': { const n = S.notes[id]; if (n) { saveNote(Object.assign({}, n, { pin: !n.pin })); render(); } break; }
    case 'note-op': noteToOp(id); break;
    case 'note-more': ui.notes.open = ui.notes.open === id ? null : id; render(); break;
    case 'note-all': ui.notes.all = !ui.notes.all; render(); break;
    case 'note-del': {
      clearTimeout(noteDelT);
      if (ui.notes.del === id) { ui.notes.del = null; removeNote(id); Sfx.play('shred'); toast('Note deleted', '', 'warn'); }
      else { ui.notes.del = id; noteDelT = setTimeout(function () { ui.notes.del = null; scheduleRender(); }, 4000); }
      render(); break;
    }
    case 'off-copy': downloadCopy(); break;
    case 'off-import': { const inp = document.getElementById('sync-in'); if (inp) inp.click(); break; }
    case 'off-export': exportChanges(); break;
    case 'ics-pick': { const inp = document.getElementById('ics-in'); if (inp && !ui.cal.busy) inp.click(); break; }
    case 'cal-del': {
      clearTimeout(calDelT);
      if (ui.cal.del === id) { const c = S.cals[id]; ui.cal.del = null; removeCal(id); toast('Calendar removed', c ? c.name : '', 'warn'); }
      else { ui.cal.del = id; calDelT = setTimeout(function () { ui.cal.del = null; scheduleRender(); }, 4000); }
      render(); break;
    }
    case 'feed-link': case 'feed-sync': ui.feed.didAuto = true; syncFeed(true); break;
    case 'feed-perm': if (PERM) PERM.manage().then(function () { syncFeed(true); }).catch(function () { toast('Permissions panel did not open', 'Use the artifact\'s Permissions menu, then tap SYNC NOW.', 'warn'); }); break;
    case 'feed-hz': if (S.feed) { saveFeed(Object.assign({}, S.feed, { horizon: Number(v) || 10 })); render(); syncFeed(true); } break;
    case 'crs-edit': ui.courseEdit = v; ui.courseDraft = courseLabel(v); render(); focusSoon('crs-in'); break;
    case 'crs-cancel': ui.courseEdit = null; render(); break;
    case 'crs-save': if (S.feed && ui.courseEdit) { const c = Object.assign({}, S.feed.courses || {}); const name = String(ui.courseDraft || '').trim().toUpperCase().slice(0, 24); if (name) c[ui.courseEdit] = name; saveFeed(Object.assign({}, S.feed, { courses: c })); ui.courseEdit = null; toast('Course renamed', name, 'info'); render(); } break;
  }
});
document.addEventListener('submit', function (ev) {
  if (!ev.target || ev.target.id !== 'quickf') return;
  ev.preventDefault();
  const title = String(ui.draft.quick || '').trim();
  if (!title || !S.ready) return;
  const op = newOp(title.slice(0, 140), ui.draft.quickTier || 0);
  if (op.tier === 5) { op.tier = 0; op.repeat = { days: [0, 1, 2, 3, 4, 5, 6] }; }
  saveOp(op);
  ui.draft.quick = '';
  Sfx.play('t' + op.tier);
  toast('Op filed · ' + TIERS[op.tier].name, 'Operation ' + op.code, 'good');
  render(); focusSoon('quick-in');
});
function onBind(ev) {
  const t = ev.target, k = t && t.dataset && t.dataset.bind;
  if (!k) return;
  setPath(ui, k, t.value);
  if (k === 'settings.vol' && ev.type === 'change' && ui.settings) Sfx.test({ sound: ui.settings.sound, vol: clampInt(t.value, 0, 100, 80) / 100 }, true);
  if (t.dataset.live) render();
}
document.addEventListener('input', onBind);
document.addEventListener('change', onBind);
let holdRAF = 0, holdStart = 0;
function holdBegin() {
  const b = document.getElementById('hold'); if (!b) return;
  holdStart = performance.now();
  Sfx.holdStart();
  const step = function () {
    if (!holdStart) return;
    const p = Math.min(1, (performance.now() - holdStart) / 1500);
    b.style.setProperty('--p', String(p));
    if (p >= 1) { holdStart = 0; Sfx.holdStop(true); abortWindow(); return; }
    holdRAF = requestAnimationFrame(step);
  };
  cancelAnimationFrame(holdRAF); holdRAF = requestAnimationFrame(step);
}
function holdEnd() { cancelAnimationFrame(holdRAF); holdStart = 0; Sfx.holdStop(); const b = document.getElementById('hold'); if (b) b.style.setProperty('--p', '0'); }
document.addEventListener('pointerdown', function () { Sfx.unlock(); if (Sfx.ringing) { Sfx.silence(); scheduleRender(); } }, true);
document.addEventListener('pointerdown', function (ev) { if (ev.target.closest && ev.target.closest('#hold')) { ev.preventDefault(); Sfx.ensure(); holdBegin(); } });
document.addEventListener('pointerup', function () { if (holdStart) holdEnd(); });
document.addEventListener('pointercancel', function () { if (holdStart) holdEnd(); });
document.addEventListener('contextmenu', function (ev) { if (ev.target.closest && ev.target.closest('#hold')) ev.preventDefault(); });
document.addEventListener('keydown', function (ev) {
  if (ev.key !== 'Escape') Sfx.unlock();
  if (Sfx.ringing) { Sfx.silence(); scheduleRender(); }
  const tg = ev.target;
  if (tg && (tg.tagName === 'INPUT' || tg.tagName === 'TEXTAREA') && tg.type !== 'range' && (ev.key.length === 1 || ev.key === 'Backspace' || ev.key === 'Enter')) Sfx.key();
  if (ev.key === 'Escape') { onEscape(); return; }
  if ((ev.key === ' ' || ev.key === 'Enter') && document.activeElement && document.activeElement.id === 'hold') { ev.preventDefault(); if (!ev.repeat) holdBegin(); }
});
document.addEventListener('keyup', function (ev) { if ((ev.key === ' ' || ev.key === 'Enter') && holdStart) holdEnd(); });
window.addEventListener('hashchange', function () {
  const t = tabFromHash();
  if (t === ui.tab) return;
  ui.tab = t;
  Sfx.ui('tab');
  if (t === 'infil' && !ui.infil.target && lastD) ui.infil.target = infilTargetId(lastD);
  render(); window.scrollTo(0, 0);
});
let rsT = 0;
window.addEventListener('resize', function () { clearTimeout(rsT); rsT = setTimeout(function () { if (ui.tab === 'infil') render(); }, 200); });
document.addEventListener('visibilitychange', function () {
  if (document.visibilityState !== 'visible') return;
  const a = S.hq && S.hq.active;
  if (a && a.kind === 'op' && !wake) holdWake();
  tick(); renderClock(); maybeAutoSync();
});

/* ================= BOOT ================= */
document.querySelector('[data-act="manual"]').innerHTML = ICON.manual;
document.querySelector('[data-act="settings"]').innerHTML = ICON.gear;
function syncFs() { const b = document.getElementById('fs-btn'); if (!b) return; const on = !!document.fullscreenElement; b.innerHTML = on ? ICON.fsOff : ICON.fsOn; b.title = on ? 'Exit full screen (Esc)' : 'Full screen'; b.setAttribute('aria-label', b.title); b.classList.toggle('pip-on', on); }
document.addEventListener('fullscreenchange', syncFs); syncFs();
try {
  const wq = window.matchMedia('(max-width: 600px) and (max-height: 620px)');
  ui.widget = wq.matches;
  const onWq = function () { ui.widget = wq.matches; render(); };
  if (wq.addEventListener) wq.addEventListener('change', onWq); else if (wq.addListener) wq.addListener(onWq);
} catch (e) { ui.widget = false; }
try { if (window.speechSynthesis) window.speechSynthesis.onvoiceschanged = function () {}; } catch (e) {}
ui.notes.draft = draftRead();
renderClock();
render();
setTimeout(function () { Pip.prepare(); }, 800);
startClock();
setInterval(renderClock, 15000);
setInterval(maybeAutoSync, 10 * 60000);
connect();
initFeed();
initIcsInput();
initSyncInput();
initDownloads();
initApp();
window.addEventListener('online', function () { if (store && store.flush) store.flush(); render(); });
window.addEventListener('offline', function () { render(); });
setInterval(function () { if (store && store.flush && obCount()) store.flush(); }, 20000);
setInterval(function () { if (ui.tab === 'hq' && calIds().length) scheduleRender(); }, 30000);
})();
</script>

</body>
</html>
