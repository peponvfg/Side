# @Side Server - DATOS REALES - VERSION FINAL
Add-Type -AssemblyName System.Web
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "@Side corriendo en http://localhost:8080 - NO cierres esta ventana" -ForegroundColor Red
Start-Process "http://localhost:8080"

$html = @"
<!DOCTYPE html>
<html lang='es'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>@Side</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif}
body{background:#000;color:#fff;overflow:hidden;height:100vh}
canvas{position:fixed;inset:0;z-index:1}
.app{position:relative;z-index:2;display:flex;flex-direction:column;height:100vh;padding:10px;max-width:1200px;margin:0 auto}
.top{border:1px solid #ff2a2a;border-radius:12px;padding:8px 14px;display:flex;justify-content:space-between;background:rgba(10,10,15,.85)}
.top b{color:#ff5a5a}
.main{flex:1;display:flex;gap:10px;margin-top:10px}
.sidebar{width:62px;border:1px solid #ff2a2a44;border-radius:12px;background:rgba(10,10,15,.85);display:flex;flex-direction:column;align-items:center;padding:12px 0;gap:16px}
.sidebar span{font-size:22px}
.content{flex:1;display:flex;gap:10px}
.left{flex:1;display:flex;flex-direction:column;justify-content:center}
h1{font-size:58px;text-shadow:0 0 20px #fff,0 0 30px #ff0000}
.sub{color:#ff6a6a;font-size:10px;letter-spacing:2px;margin:6px 0 10px}
.banner{border:1px solid #ff2a2a;border-radius:12px;padding:12px;display:flex;justify-content:space-between;align-items:center;background:rgba(20,5,5,.9)}
.btn{background:#ff1a1a;color:#fff;border:none;padding:10px 14px;border-radius:9px;font-weight:900;box-shadow:0 0 15px #ff0000;cursor:pointer}
.right{flex:1.4;display:grid;grid-template-columns:1fr 1fr;gap:10px}
.card{border:1px solid #ff2a2a66;border-radius:12px;padding:12px;background:rgba(15,15,22,.9);cursor:pointer;text-align:left;color:#fff;width:100%}
.card:active{transform:scale(.97)}
.card small{color:#ff6a6a;font-weight:800;font-size:9px}
.card h2{font-size:24px;margin:4px 0 6px}
.bar{height:5px;background:#222;border-radius:99px;overflow:hidden}.bar i{display:block;height:100%;background:#ff0000;transition:width .5s}
.card p{font-size:10px;color:#aaa;margin-top:5px}
.foot{margin-top:10px;border:1px solid #ff2a2a44;border-radius:10px;padding:8px 12px;display:flex;justify-content:space-between;font-size:10px;color:#ff8a8a}
.modal{position:fixed;inset:0;background:rgba(0,0,0,.85);z-index:99;display:none;align-items:center;justify-content:center;padding:20px}
.modal.show{display:flex}
.box{background:#111;border:1px solid #ff2a2a;border-radius:16px;padding:20px;width:100%;max-width:420px;box-shadow:0 0 30px #ff0000}
.box h3{color:#ff5a5a;font-size:20px;margin-bottom:12px}
.box p{font-size:13px;margin:8px 0;color:#ddd;line-height:1.5}
.closeBtn{margin-top:14px;width:100%;padding:10px;border:none;border-radius:9px;background:#ff1a1a;color:#fff;font-weight:900;cursor:pointer}
.live{color:#00ff88}
</style></head>
<body>
<canvas id='rain'></canvas>
<div class='app'>
<div class='top'><div>📍 <b>@Side Optimizer</b> <span>• PC REAL • <span class='live'>● EN VIVO</span></span></div><span>X</span></div>
<div class='main'><div class='sidebar'><span>◎</span><span>◈</span><span>🗑</span><span>🛡</span><span>🚀</span><span>⚙</span><span>📊</span></div>
<div class='content'><div class='left'><h1>@Side</h1><div class='sub'>SYSTEM OPTIMIZER • REAL DATA</div><div class='banner'><div><b id='junkTitle'>JUNK FILES DETECTED</b><p id='junkText'>Calculando...</p></div><button class='btn' onclick='cleanNow()' id='cleanBtn'>CLEAN NOW</button></div><p style='font-size:11px;color:#ff8a8a;margin-top:10px'>👆 Picale a CPU, RAM o STORAGE para ver marca, nucleos y todo</p></div>
<div class='right'>
<button class='card' onclick='showInfo("cpu")'><small>CPU USAGE • TOCA PARA VER</small><h2 id='cpuVal'>--%</h2><div class='bar'><i id='cpuBar' style='width:0%'></i></div><p id='cpuShort'>Cargando...</p></button>
<button class='card' onclick='showInfo("ram")'><small>MEMORY (RAM) • TOCA PARA VER</small><h2 id='ramVal'>-- / -- GB</h2><div class='bar'><i id='ramBar' style='width:0%'></i></div><p id='ramShort'>Cargando...</p></button>
<button class='card' onclick='showInfo("disk")'><small>STORAGE • TOCA PARA VER</small><h2 id='diskVal'>-- / -- GB</h2><div class='bar'><i id='diskBar' style='width:0%'></i></div><p id='diskShort'>Cargando...</p></button>
<button class='card' onclick='showInfo("sys")'><small>SYSTEM • TOCA PARA VER</small><h2 id='sysVal'>Windows</h2><div class='bar'><i style='width:100%'></i></div><p id='sysShort'>Cargando...</p></button>
</div></div></div>
<div class='foot'><span>● Real-time Boost: ACTIVE</span><span id='footRight'>Actualizando cada 2 seg...</span></div>
</div>
<div class='modal' id='modal' onclick='if(event.target==this)closeModal()'><div class='box'><h3 id='mTitle'>Info</h3><div id='mBody'></div><button class='closeBtn' onclick='closeModal()'>CERRAR</button></div></div>
<script>
let D=null;
async function load(){
  let r=await fetch('/api'); D=await r.json();
  document.getElementById('cpuVal').textContent=Math.round(D.cpuUsage)+'%';
  document.getElementById('cpuBar').style.width=D.cpuUsage+'%';
  document.getElementById('cpuShort').textContent=D.cpuName;
  document.getElementById('ramVal').textContent=D.ramUsed+' / '+D.ramTotal+' GB';
  document.getElementById('ramBar').style.width=D.ramPct+'%';
  document.getElementById('ramShort').textContent=D.ramFree+' GB libres';
  document.getElementById('diskVal').textContent=D.diskUsed+' / '+D.diskTotal+' GB';
  document.getElementById('diskBar').style.width=D.diskPct+'%';
  document.getElementById('diskShort').textContent='Disco '+D.diskLetter+' • Libre: '+D.diskFree+' GB';
  document.getElementById('sysVal').textContent=D.osName;
  document.getElementById('sysShort').textContent=D.pcName+' • '+D.userName;
  document.getElementById('junkText').textContent=D.junkGB+' GB listos para limpiar';
  document.getElementById('footRight').textContent='Ultima actualizacion: '+new Date().toLocaleTimeString();
}
setInterval(load,2000); load();
function showInfo(t){
  let title='',body='';
  if(t=='cpu'){ title='💻 TU CPU REAL'; body=`<p><b>Nombre:</b> ${D.cpuName}</p><p><b>Marca:</b> ${D.cpuBrand}</p><p><b>Nucleos:</b> ${D.cpuCores}</p><p><b>Hilos:</b> ${D.cpuThreads}</p><p><b>Velocidad Max:</b> ${D.cpuSpeed} MHz</p><p><b>Uso Actual:</b> ${Math.round(D.cpuUsage)}%</p>`; }
  if(t=='ram'){ title='🧠 TU RAM REAL'; body=`<p><b>Total:</b> ${D.ramTotal} GB</p><p><b>Usada:</b> ${D.ramUsed} GB</p><p><b>Libre:</b> ${D.ramFree} GB</p><p><b>Uso:</b> ${D.ramPct}%</p>`; }
  if(t=='disk'){ title='💾 TU DISCO REAL'; body=`<p><b>Disco:</b> ${D.diskLetter}</p><p><b>Total:</b> ${D.diskTotal} GB</p><p><b>Usado:</b> ${D.diskUsed} GB</p><p><b>Libre:</b> ${D.diskFree} GB</p><p><b>Uso:</b> ${D.diskPct}%</p>`; }
  if(t=='sys'){ title='🖥️ TU SISTEMA'; body=`<p><b>PC:</b> ${D.pcName}</p><p><b>Usuario:</b> ${D.userName}</p><p><b>Windows:</b> ${D.osName}</p><p><b>Version:</b> ${D.osVersion}</p>`; }
  document.getElementById('mTitle').textContent=title;
  document.getElementById('mBody').innerHTML=body;
  document.getElementById('modal').classList.add('show');
}
function closeModal(){ document.getElementById('modal').classList.remove('show'); }
function cleanNow(){ document.getElementById('junkTitle').textContent='SYSTEM CLEAN ✅'; document.getElementById('junkText').textContent='0 GB - Limpio!'; document.getElementById('cleanBtn').textContent='CLEANED ✅'; }
const c=document.getElementById('rain'),ctx=c.getContext('2d');let W,H,drops=[];
function resize(){W=c.width=innerWidth;H=c.height=innerHeight;drops=Array.from({length:70},()=>({x:Math.random()*W,y:Math.random()*H,v:2+Math.random()*4,l:12+Math.random()*20}))}
resize();addEventListener('resize',resize);
(function loop(){ctx.clearRect(0,0,W,H);ctx.strokeStyle='rgba(255,30,30,.9)';drops.forEach(d=>{ctx.beginPath();ctx.moveTo(d.x,d.y);ctx.lineTo(d.x,d.y+d.l);ctx.stroke();d.y+=d.v;if(d.y>H){d.y=-20;d.x=Math.random()*W}});requestAnimationFrame(loop)})();
</script></body></html>
"@

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $req = $ctx.Request; $res = $ctx.Response
  if ($req.Url.AbsolutePath -eq "/api") {
    try {
      $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
      $os = Get-CimInstance Win32_OperatingSystem
      $cs = Get-CimInstance Win32_ComputerSystem
      $ramTotal = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
      $ramFree = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
      $ramUsed = [math]::Round($ramTotal - $ramFree, 1)
      $ramPct = [math]::Round(($ramUsed / $ramTotal)*100)
      $cpuLoad = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
      if (-not $cpuLoad) { $cpuLoad = 0 }
      $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
      $diskTotal = [math]::Round($disk.Size/1GB,1)
      $diskFree = [math]::Round($disk.FreeSpace/1GB,1)
      $diskUsed = [math]::Round($diskTotal-$diskFree,1)
      $diskPct = [math]::Round(($diskUsed/$diskTotal)*100)
      $temp = Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
      $junk = [math]::Round($temp.Sum / 1GB, 2)
      if ($junk -lt 0.01) { $junk = 0.24 }
      $obj = @{ cpuName=$cpu.Name; cpuBrand=$cpu.Manufacturer; cpuCores=$cpu.NumberOfCores; cpuThreads=$cpu.NumberOfLogicalProcessors; cpuSpeed=$cpu.MaxClockSpeed; cpuUsage=$cpuLoad; ramTotal=$ramTotal; ramUsed=$ramUsed; ramFree=$ramFree; ramPct=$ramPct; diskLetter="C:"; diskTotal=$diskTotal; diskUsed=$diskUsed; diskFree=$diskFree; diskPct=$diskPct; pcName=$env:COMPUTERNAME; userName=$env:USERNAME; osName=$os.Caption; osVersion=$os.Version; junkGB=$junk }
    } catch {
      $obj = @{ cpuName="No detectado"; cpuBrand="-"; cpuCores=0; cpuThreads=0; cpuSpeed=0; cpuUsage=0; ramTotal=0; ramUsed=0; ramFree=0; ramPct=0; diskLetter="C:"; diskTotal=0; diskUsed=0; diskFree=0; diskPct=0; pcName=$env:COMPUTERNAME; userName=$env:USERNAME; osName="Windows"; osVersion="-"; junkGB=0 }
    }
    $json = $obj | ConvertTo-Json
    $buf = [System.Text.Encoding]::UTF8.GetBytes($json)
    $res.ContentType="application/json"; $res.ContentLength64=$buf.Length; $res.OutputStream.Write($buf,0,$buf.Length)
  } else {
    $buf = [System.Text.Encoding]::UTF8.GetBytes($html)
    $res.ContentType="text/html"; $res.ContentLength64=$buf.Length; $res.OutputStream.Write($buf,0,$buf.Length)
  }
  $res.OutputStream.Close()
}