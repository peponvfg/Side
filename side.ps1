# @Side - MAIN SOLO DISEÑO - ESTILO NEON GALAXIA / LLUVIA ROJA
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "@Side"
$form.Size = New-Object System.Drawing.Size(800,560)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::Black
$form.FormBorderStyle = "None"
$form.DoubleBuffered = $true

# --- LLUVIA ROJA ---
$particulas = @()
$rand = New-Object Random
for($i=0; $i -lt 60; $i++){
    $particulas += [PSCustomObject]@{ X=$rand.Next(0,800); Y=$rand.Next(0,560); Vel=$rand.Next(3,7); Largo=$rand.Next(12,28) }
}

$fondo = New-Object System.Windows.Forms.Panel
$fondo.Dock = "Fill"
$fondo.BackColor = [System.Drawing.Color]::Black
$form.Controls.Add($fondo)

$fondo.Add_Paint({
    param($s,$e)
    $g = $e.Graphics
    # Galaxia estatica - estrellitas
    for($i=0; $i -lt 100; $i++){
        $g.FillEllipse([System.Drawing.Brushes]::White, $rand.Next(0,800), $rand.Next(0,560), 1, 1)
    }
    # Lluvia roja con glow
    foreach($p in $particulas){
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255,40,40), 1)
        $g.DrawLine($pen, $p.X, $p.Y, $p.X, $p.Y + $p.Largo)
    }
})

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 30
$timer.Add_Tick({
    foreach($p in $particulas){ $p.Y += $p.Vel; if($p.Y -gt 560){ $p.Y=-20; $p.X=$rand.Next(0,800) } }
    $fondo.Invalidate()
})
$timer.Start()

# --- SIDEBAR NEON ---
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Size = New-Object System.Drawing.Size(110,460)
$sidebar.Location = New-Object System.Drawing.Point(15,45)
$sidebar.BackColor = [System.Drawing.Color]::FromArgb(10,10,15)
$fondo.Controls.Add($sidebar)

# Borde neon simulado con label
$iconos = @("◎","◈","🗑","🛡","🚀","⚙")
$y=20
foreach($ic in $iconos){
    $l = New-Object System.Windows.Forms.Label
    $l.Text = $ic
    $l.Font = New-Object System.Drawing.Font("Segoe UI",22)
    $l.ForeColor = [System.Drawing.Color]::FromArgb(255,50,50)
    $l.AutoSize = $true
    $l.Location = New-Object System.Drawing.Point(35,$y)
    $sidebar.Controls.Add($l)
    $y+=65
}

# --- TITULO @Side ---
$titulo = New-Object System.Windows.Forms.Label
$titulo.Text = "@Side"
$titulo.Font = New-Object System.Drawing.Font("Segoe UI",48,[System.Drawing.FontStyle]::Bold)
$titulo.ForeColor = [System.Drawing.Color]::White
$titulo.AutoSize = $true
$titulo.BackColor = [System.Drawing.Color]::Transparent
$titulo.Location = New-Object System.Drawing.Point(300,50)
$fondo.Controls.Add($titulo)

$sub = New-Object System.Windows.Forms.Label
$sub.Text = "SYSTEM OPTIMIZER  •  NEON EDITION"
$sub.Font = New-Object System.Drawing.Font("Segoe UI",9)
$sub.ForeColor = [System.Drawing.Color]::FromArgb(255,80,80)
$sub.AutoSize = $true
$sub.Location = New-Object System.Drawing.Point(310,135)
$fondo.Controls.Add($sub)

# --- TARJETAS SOLO DISEÑO ---
function Nueva-Tarjeta($x,$y,$tituloTxt,$valor){
    $p = New-Object System.Windows.Forms.Panel
    $p.Size = New-Object System.Drawing.Size(300,110)
    $p.Location = New-Object System.Drawing.Point($x,$y)
    $p.BackColor = [System.Drawing.Color]::FromArgb(15,15,22)
    $fondo.Controls.Add($p)

    $t = New-Object System.Windows.Forms.Label
    $t.Text = $tituloTxt
    $t.ForeColor = [System.Drawing.Color]::FromArgb(255,90,90)
    $t.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $t.AutoSize = $true
    $t.Location = New-Object System.Drawing.Point(15,12)
    $p.Controls.Add($t)

    $v = New-Object System.Windows.Forms.Label
    $v.Text = $valor
    $v.ForeColor = [System.Drawing.Color]::White
    $v.Font = New-Object System.Drawing.Font("Segoe UI",26,[System.Drawing.FontStyle]::Bold)
    $v.AutoSize = $true
    $v.Location = New-Object System.Drawing.Point(15,35)
    $p.Controls.Add($v)
}

Nueva-Tarjeta 150 180 "CPU USAGE" "32%"
Nueva-Tarjeta 470 180 "MEMORY" "6.2 / 16 GB"
Nueva-Tarjeta 150 310 "STORAGE" "240 / 512 GB"
Nueva-Tarjeta 470 310 "SYSTEM TEMP" "41°C"

# Boton cerrar
$btnX = New-Object System.Windows.Forms.Button
$btnX.Text = "X"
$btnX.Size = New-Object System.Drawing.Size(35,30)
$btnX.Location = New-Object System.Drawing.Point(750,10)
$btnX.BackColor = [System.Drawing.Color]::Black
$btnX.ForeColor = [System.Drawing.Color]::Red
$btnX.FlatStyle = "Flat"
$btnX.Add_Click({ $form.Close() })
$fondo.Controls.Add($btnX)

[void]$form.ShowDialog()
