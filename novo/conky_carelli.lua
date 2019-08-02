-- Rede
exibeRede = true
tituloRede = "Rede"
gapRede = 90
redeX = 100
redeY = 50

-- Indicadores
exibeIndicadores = false
indicadoresX = 1300
indicadoresY = 50

-- Processos
exibeProcessos = false
processosX = 1400
processosY = 800

-- Configuracoes gerais
fontName="Technical CE"
fontSize=17
corLabel = "44d31f"
corValor = "f09309"
tableFontColor = "FFFFFF"
corTitulo = "FFFFFF" -- Linha do cabecalho
corPar = "53c9d6"    -- Linhas pares
corImpar = "61EAF9"  -- Linhas impares

-- Outras cores - Vivas
cor1 = "#44d31f"
cor2 = "#df3b11"
cor3 = "#f35aca"
cor4 = "#f09309"
cor5 = "#53c9d6"

-- Outras cores - Pasteis
cor6 = "EBD891"
cor7 = "8E8831"
cor8 = "62A5A5"
cor9 = "8A522D"
cor10 = "1B314B"

-- Customizacoes dos adaptadores de rede
wlanAdapter = "wlp3s0"
ethAdapter = "enp2s0"

-- Configurações das bordas
raioBorda = 20
espessuraBorda = 6 --Usar apenas numeros pares
margensBorda = 10
corBorda = "00a4d1"

-- Tabela
alturaLinhaTabela = 21  -- Espaco para pular para proxima linha (texto e tabela)

-- Configuracees de Rede --
corLabelRede = corLabel
corValorRede = corValor
corBordaRede = corBorda

-- Parametros da tabela Rede
linecapRede = CAIRO_LINE_CAP_BUTT
larguraTabelaRede = 650
transparenciaRede = 0.15
corTituloRede = corTitulo -- Linha do cabecalho
corParRede = corPar    -- Linhas pares
corImparRede = corImpar  -- Linhas impares
tableFontColorRede = tableFontColor

-- Parametros Indicadores
gapIndicador = 120
raioIndicador = 50
espessuraIndicador = 8
corSeparadorIndicadores = "F2CB19"
-------------------

-- Parametros Processos
corSeparadorProcessos = "94b672"


require 'cairo'

-- Converte o angulo de graus para radianos
-- E corrige o angulo inicial do arco (-90)
function angulo( graus )
  local radianos = (graus - 90) * (math.pi/180)
  return radianos
end

function hex2rgb(hex)
    local hex = hex:gsub("#","")
    return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end

function desenhaLinha(corHex, startX, startY, endX, endY, espessura)
  local r, g, b = hex2rgb(corHex)
  local alpha=1
  cairo_set_source_rgba (cr,r,g,b,alpha)

  -- Configura a linha
  cairo_set_line_width (cr, espessura)
  cairo_set_line_cap  (cr, linecapRede)

  cairo_move_to (cr, startX, startY)
  cairo_line_to (cr, endX, endY)

  cairo_stroke (cr)
end

function desenhaArco(corHex, raio, centroX, centroY, posX, posY, espessura, anguloInicial, anguloFinal)
  local r, g, b = hex2rgb(corHex)
  local alpha=1
  cairo_set_source_rgba (cr,r,g,b,alpha)

  -- Configura o arco
  cairo_set_line_width (cr, espessura)
  cairo_set_line_cap  (cr, linecapRede)

  local startAngle = angulo(anguloInicial)
  local endAngle = angulo(anguloFinal)
  --cairo_move_to (cr, posX, posY)
  cairo_arc (cr, centroX, centroY, raio, startAngle, endAngle)

  cairo_stroke (cr)
end

function texto(txt, x, y, corHex, fs)
    fs = fs or fontSize

    -- Inicializa o Cairo com as configuracoes de fontes
    local red,green,blue = hex2rgb(corHex)
    local alpha=1
    cairo_set_source_rgba(cr, red, green, blue, alpha)
    cairo_select_font_face(cr, fontName, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size(cr, fs)

    cairo_move_to(cr, x, y)
    cairo_show_text(cr, txt)
    cairo_stroke(cr)
end

function titulo(label, x, y, corHex, altura, largura, gap)
  -- Escreve titulo
  local xpos = x + 50
  local ypos = y
  texto(label, xpos, ypos, corHex, 32)

  -- Desenha a linha horizontal
  local startX = x
  local startY = y-8
  local endX = startX + 40
  local endY = startY
  desenhaLinha(corHex, startX, startY, endX, endY, espessuraBorda)

  startX = endX + gap
  endX = x + largura - raioBorda - (espessuraBorda/2)
  desenhaLinha(corHex, startX, startY, endX, endY, espessuraBorda)

  --desenha a curva
  local centroX = endX
  local centroY = endY + raioBorda
  local aInicial = 0
  local aFinal = 90
  desenhaArco(corHex, raioBorda, centroX, centroY, startX, startY, espessuraBorda, aInicial, aFinal)

  -- desenha a linha vertical
  startX = endX + raioBorda
  startY = endY + raioBorda
  endX = startX
  endY = endY + altura + 8 + (espessuraBorda/2)
  desenhaLinha(corHex, startX, startY, endX, endY, espessuraBorda)
end

function indicadorArco(x, y, valor, label, cor)
     --indicator value settings
     local maxValue=360
     local inicial = maxValue * valor / 100
     local final = 360
     local centroX = x + raioIndicador
     local centroY = y + raioIndicador

     -- Desenha o arco
     desenhaArco(cor, raioIndicador, centroX, centroY, x, y, espessuraIndicador, inicial, final)

     -- Label
     -- Centraliza o texto no arco
     local extents = cairo_text_extents_t:create()
     tolua.takeownership(extents)
     cairo_text_extents(cr, label, extents)
     x = centroX - (extents.width / 2 + extents.x_bearing)
     y = centroY - (extents.height / 2 + extents.y_bearing) - 9
     texto(label, x, y, cor)

     local txt = valor .. "%"
     cairo_text_extents(cr, txt, extents)
     x = centroX - (extents.width / 2 + extents.x_bearing)
     y = centroY - (extents.height / 2 + extents.y_bearing) + 9
     texto(txt, x, y, cor)
end

function desenhaTabela(xx, yy, pos, largura)
  local cor = corImparRede

  -- Ajusta a cor da linha
  if pos == -1 then         -- Linha do cabecalho
    cor = corTituloRede
  elseif pos % 2 == 0 then  -- Linhas pares
    cor = corParRede
  else                      -- Linhas impares
    cor = corImparRede
  end

  -- Configura a tabela
  cairo_set_line_width (cr, alturaLinhaTabela)
  cairo_set_line_cap  (cr, linecapRede)
  local vermelho,verde,azul=hex2rgb(cor)
  cairo_set_source_rgba (cr,vermelho,verde,azul,transparenciaRede)

  -- Desenha a tabela
  local endy = yy-5
  local endx = xx-5
  cairo_move_to (cr,endx,endy)
  endx = xx + largura
  cairo_line_to (cr,endx,endy)

  cairo_stroke (cr)
end

function openPorts(x, y)
  local txt = "Open Ports:"
  texto(txt, x, y, corLabelRede, fontSize)

  local xx = x + 100
  local numPorts = tostring(conky_parse("${tcp_portmon 1 65535 count}"))
  texto(numPorts, xx, y, corValorRede, fontSize)

  local yy = y+alturaLinhaTabela+alturaLinhaTabela

  --Titulos da tabela
  txt = "Port"
  texto(txt, x, yy, tableFontColorRede, fontSize)
  txt = "IP"
  ipX = x+70
  texto(txt, ipX, yy, tableFontColorRede, fontSize)
  txt = "Host"
  hostX = ipX+140
  texto(txt, hostX, yy, tableFontColorRede, fontSize)
  txt = "rhost"

  -- Desenha bordas do titulo
  desenhaTabela(x, yy, -1, larguraTabelaRede)

  for i=0,numPorts-1 do
      local rport = tostring(conky_parse("${tcp_portmon 1 65535 rport " .. i .. "}"))
      local rip = tostring(conky_parse("${tcp_portmon 1 65535 rip " .. i .. "}"))
      local rhost = conky_parse("${tcp_portmon 1 65535 rhost " .. i .. "}")

      yy = yy+alturaLinhaTabela
      texto(rport, x, yy, tableFontColorRede, fontSize)
      texto(rip, ipX, yy, tableFontColorRede, fontSize)
      texto(rhost, hostX, yy, tableFontColorRede, fontSize)
      desenhaTabela(x, yy, i, larguraTabelaRede)
  end

  return yy
end

function redeInfo(x, y, adaptador)
  texto(adaptador, x, y, corLabelRede, fontSize)
  local essid = tostring(conky_parse("${wireless_essid " .. adaptador .. "}"))

  if essid ~= nil and essid ~= "" then
    essid = "(" .. essid .. ")"
  end

  local xx = x + 60
  local yy = y
  texto(essid, xx, yy, corValorRede, fontSize)

  local addrs = tostring(conky_parse("${addr " .. adaptador .. "}"))
  xx = x
  yy = yy + alturaLinhaTabela
  texto(addrs, xx, yy, corValorRede, fontSize)

  xx = x
  yy = yy + alturaLinhaTabela
  texto("Upload:", xx, yy, corLabelRede, fontSize)

  local upspeed = tostring(conky_parse("${upspeed " .. adaptador .. "}"))
  xx = x + 60
  texto(upspeed, xx, yy, corValorRede, fontSize)

  xx = x
  yy = yy + alturaLinhaTabela
  texto("Download:", xx, yy, corLabelRede, fontSize)

  local downspeed = tostring(conky_parse("${downspeed " .. adaptador .. "}"))
  xx = x + 80
  texto(downspeed, xx, yy, corValorRede, fontSize)

  return yy
end

function pip (x, y)
  local xx = x
  local yy = y
  texto("Public IP:", xx, yy, corLabelRede, fontSize)

  local ip = tostring(conky_parse("${execi 3600 curl ipinfo.io/ip}"))
  xx = x + 75
  texto(ip, xx, yy, corValorRede, fontSize)

  return yy
end

function rede(startX, startY)
  local altura = 9*alturaLinhaTabela
  local largura = larguraTabelaRede 
  titulo(tituloRede, startX, startY, corBordaRede, altura, largura, gapRede)

  -- Wlan
  local x = startX
  local y = startY + 40
  redeInfo(x, y, wlanAdapter)

  -- Eth
  x = startX + 300
  y = startY + 40
  y = redeInfo(x, y, ethAdapter)

  -- Public IP:
  x = startX
  y = y + alturaLinhaTabela + alturaLinhaTabela
  y = pip(x, y)

  -- Lista de portas abertas
  x = startX
  y = y + alturaLinhaTabela
  openPorts(x, y)
end

function indicadores(startX, startY)
    --Titulo
    local altura = gapIndicador
    local largura = 5*gapIndicador
    local gap = 185
    titulo("Indicadores", startX, startY, corSeparadorIndicadores, altura, largura, gap)

    -- Ajusta a posição dos indicadores.
    startY = startY + 15

    -- Indicador CPU
    local valor = tonumber( conky_parse("${cpu cpu0}") )
    indicadorArco(startX, startY, valor, "CPU", cor1)

    -- Indicador RAM
    startX = startX + gapIndicador
    valor = tonumber( conky_parse("${memperc}") )
    indicadorArco(startX, startY, valor, "RAM", cor2)
    
    -- Indicador SWAP
    startX = startX + gapIndicador
    valor = tonumber( conky_parse("${swapperc}") )
    indicadorArco(startX, startY, valor, "SWAP", cor3)
    
    -- Indicador Disco (Home)
    startX = startX + gapIndicador
    valor  = 100-tonumber( conky_parse("${fs_free_perc /home}") )
    indicadorArco(startX, startY, valor, "Home", cor4)
    
    -- Indicador Disco (Root)
    startX = startX + gapIndicador
    valor  = 100 - tonumber( conky_parse("${fs_free_perc /}") )
    indicadorArco(startX, startY, valor, "Root", cor5)
end

function processos(processosX, processosY)
--  Process       PID           CPU%          MEM%
--  ${top name 1} ${top pid 1}  ${top cpu 1}  ${top mem 1}

    --Titulo
    local altura = alturaLinhaTabela * 12 -- O conky limita a 10 processos (mais a linha de título e o espaco extra)
    local largura = 500
    local gap = 170
    titulo("Processos", processosX, processosY, corSeparadorProcessos, altura, largura, gap)

    local procX = processosX
    local pidX =  procX + 200
    local cpuX =  pidX + 70
    local memX =  cpuX + 70

    local y = processosY + alturaLinhaTabela + 9

--    --Titulos da tabela
    txt = "Processos"
    texto(txt, procX, y, tableFontColor, fontSize)
    txt = "PID"
    texto(txt, pidX, y, tableFontColor, fontSize)
    txt = "CPU%"
    texto(txt, cpuX, y, tableFontColor, fontSize)
    txt = "MEM%"
    texto(txt, memX, y, tableFontColor, fontSize)

    -- Desenha bordas do titulo
    local larguraTabela = largura - 25
    desenhaTabela(processosX, y, -1, larguraTabela)

    for i=1, 10 do
        local proc = tostring(conky_parse("${top name " .. i .. "}"))
        local pid  = tostring(conky_parse("${top pid " .. i .. "}"))
        local cpu  = conky_parse("${top cpu " .. i .. "}")
        local mem  = conky_parse("${top mem " .. i .. "}")

        y = y + alturaLinhaTabela
        texto(proc, procX, y, tableFontColorRede, fontSize)
        texto(pid,  pidX,  y, tableFontColorRede, fontSize)
        texto(cpu,  cpuX,  y, tableFontColorRede, fontSize)
        texto(mem,  memX,  y, tableFontColorRede, fontSize)
        desenhaTabela(processosX, y, i, larguraTabela)
    end
end

function conky_main()
    if conky_window == nil then
        return
    end

    -- Inicializa cairo
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs) --CR definido no conky_main

    -- Rede
    if exibeRede then rede(redeX, redeY) end

    -- Indicadores
    if exibeIndicadores then indicadores(indicadoresX, indicadoresY) end
    
    -- Processos
    if exibeProcessos then processos(processosX, processosY) end

    -- Finaliza cairo
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end
