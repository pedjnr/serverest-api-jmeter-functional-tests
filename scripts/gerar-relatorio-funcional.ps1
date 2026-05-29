param(
    [string]$InputJtl = "artifacts\functional\resultados-funcionais-serverest.jtl",
    [string]$FallbackJtl = "artifacts\functional\kpi.jtl",
    [string]$OutputDir = "relatorio"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $InputJtl) -and (Test-Path -LiteralPath $FallbackJtl)) {
    $InputJtl = $FallbackJtl
}

if (-not (Test-Path -LiteralPath $InputJtl)) {
    throw "Arquivo de resultados nao encontrado: $InputJtl"
}

if (Test-Path -LiteralPath $OutputDir) {
    Remove-Item -LiteralPath $OutputDir -Recurse -Force
}

New-Item -ItemType Directory -Path $OutputDir | Out-Null

$rows = @(Import-Csv -Path $InputJtl)
if ($rows.Count -eq 0) {
    throw "Arquivo de resultados vazio: $InputJtl"
}

$outputJtl = Join-Path $OutputDir "resultados-funcionais-serverest.jtl"
Copy-Item -LiteralPath $InputJtl -Destination $outputJtl -Force

function HtmlEncode([object]$value) {
    if ($null -eq $value) {
        return ""
    }

    return [System.Net.WebUtility]::HtmlEncode([string]$value)
}

function UnixMsToLocal([object]$value) {
    try {
        return [DateTimeOffset]::FromUnixTimeMilliseconds([int64]$value).LocalDateTime
    }
    catch {
        return $null
    }
}

function ToNumber([object]$value) {
    try {
        return [double]$value
    }
    catch {
        return 0
    }
}

function GetCaseParts([object]$labelValue) {
    $label = ([string]$labelValue).Trim()
    if ([string]::IsNullOrWhiteSpace($label)) {
        return [PSCustomObject]@{
            Suite = "GERAL"
            Name = "Cenario sem nome"
        }
    }

    if ($label -match '^\[(?<tag>[^\]]+)\]\s*(?<rest>.*)$') {
        $tag = $Matches.tag.Trim()
        $rest = $Matches.rest.Trim()

        if ($rest -match '^(?<suite>.+?)\s+[-|:]\s+(?<test>.+)$') {
            return [PSCustomObject]@{
                Suite = "[$tag] $($Matches.suite.Trim())"
                Name = $Matches.test.Trim()
            }
        }

        return [PSCustomObject]@{
            Suite = "[$tag]"
            Name = if ([string]::IsNullOrWhiteSpace($rest)) { $label } else { $rest }
        }
    }

    return [PSCustomObject]@{
        Suite = "GERAL"
        Name = $label
    }
}

function GetFailureDetailsHtml([object]$failureMessage) {
    if ([string]::IsNullOrWhiteSpace([string]$failureMessage)) {
        return "<span class=""muted"">-</span>"
    }

    $failure = HtmlEncode $failureMessage
    return "<details><summary>Ver detalhe</summary><pre>$failure</pre></details>"
}

$testCases = @(
    foreach ($row in $rows) {
        $parts = GetCaseParts $row.label
        [PSCustomObject]@{
            Suite = $parts.Suite
            Name = $parts.Name
            Label = $row.label
            ResponseCode = $row.responseCode
            ResponseMessage = $row.responseMessage
            Elapsed = $row.elapsed
            FailureMessage = $row.failureMessage
            IsPassed = $row.success -eq "true"
        }
    }
)

$passed = @($testCases | Where-Object { $_.IsPassed })
$failed = @($testCases | Where-Object { -not $_.IsPassed })
$total = $testCases.Count
$passedCount = $passed.Count
$failedCount = $failed.Count
$passRate = if ($total -gt 0) { [math]::Round(($passedCount / $total) * 100, 2) } else { 0 }
$failedRate = if ($total -gt 0) { [math]::Round(($failedCount / $total) * 100, 2) } else { 0 }
$passedPercentForChart = if ($total -gt 0) { [math]::Round(($passedCount / $total) * 100, 4) } else { 0 }
$avgMs = [math]::Round((($rows | ForEach-Object { ToNumber $_.elapsed } | Measure-Object -Average).Average), 2)
$maxMs = [math]::Round((($rows | ForEach-Object { ToNumber $_.elapsed } | Measure-Object -Maximum).Maximum), 2)

$timestamps = @($rows | ForEach-Object { UnixMsToLocal $_.timeStamp } | Where-Object { $null -ne $_ })
$startTime = if ($timestamps.Count -gt 0) { ($timestamps | Sort-Object | Select-Object -First 1).ToString("dd/MM/yyyy HH:mm:ss") } else { "-" }
$endTime = if ($timestamps.Count -gt 0) { ($timestamps | Sort-Object | Select-Object -Last 1).ToString("dd/MM/yyyy HH:mm:ss") } else { "-" }
$generatedAt = (Get-Date).ToString("dd/MM/yyyy HH:mm:ss")
$sourceFileName = Split-Path -Leaf $InputJtl

$sortedCases = @(
    $testCases | Sort-Object `
        @{ Expression = { if ($_.IsPassed) { 1 } else { 0 } } }, `
        @{ Expression = { $_.Suite } }, `
        @{ Expression = { $_.Name } }
)

$tableRows = foreach ($case in $sortedCases) {
    $isPassed = $case.IsPassed
    $statusText = if ($isPassed) { "PASSOU" } else { "FALHOU" }
    $statusClass = if ($isPassed) { "passed" } else { "failed" }
    $details = GetFailureDetailsHtml $case.FailureMessage

    @"
<tr data-status="$statusClass">
  <td><span class="badge $statusClass">$statusText</span></td>
  <td class="suite-cell">$(HtmlEncode $case.Suite)</td>
  <td class="test-name">$(HtmlEncode $case.Name)</td>
  <td>$(HtmlEncode $case.ResponseCode)</td>
  <td>$(HtmlEncode $case.ResponseMessage)</td>
  <td class="number">$(HtmlEncode $case.Elapsed)</td>
  <td>$details</td>
</tr>
"@
}

$suiteGroups = @(
    $testCases |
        Group-Object Suite |
        Sort-Object `
            @{ Expression = { @($_.Group | Where-Object { -not $_.IsPassed }).Count }; Descending = $true }, `
            @{ Expression = { $_.Name } }
)

$suiteCards = foreach ($suiteGroup in $suiteGroups) {
    $suiteCases = @($suiteGroup.Group | Sort-Object @{ Expression = { if ($_.IsPassed) { 1 } else { 0 } } }, Name)
    $suiteTotal = $suiteCases.Count
    $suitePassed = @($suiteCases | Where-Object { $_.IsPassed }).Count
    $suiteFailed = @($suiteCases | Where-Object { -not $_.IsPassed }).Count
    $suitePassedRate = if ($suiteTotal -gt 0) { [math]::Round(($suitePassed / $suiteTotal) * 100, 2) } else { 0 }
    $suiteFailedRate = if ($suiteTotal -gt 0) { [math]::Round(($suiteFailed / $suiteTotal) * 100, 2) } else { 0 }
    $suiteOpen = if ($suiteFailed -gt 0) { " open" } else { "" }
    $failedSegment = if ($suiteFailed -gt 0) { "<span class=""bar-failed"" style=""width: $suiteFailedRate%;"">$suiteFailed</span>" } else { "" }
    $passedSegment = if ($suitePassed -gt 0) { "<span class=""bar-passed"" style=""width: $suitePassedRate%;"">$suitePassed</span>" } else { "" }

    $suiteRows = foreach ($case in $suiteCases) {
        $statusText = if ($case.IsPassed) { "PASSOU" } else { "FALHOU" }
        $statusClass = if ($case.IsPassed) { "passed" } else { "failed" }
        $details = GetFailureDetailsHtml $case.FailureMessage

        @"
<tr data-status="$statusClass">
  <td><span class="badge $statusClass">$statusText</span></td>
  <td class="test-name">$(HtmlEncode $case.Name)</td>
  <td>$(HtmlEncode $case.ResponseCode)</td>
  <td>$(HtmlEncode $case.ResponseMessage)</td>
  <td class="number">$(HtmlEncode $case.Elapsed)</td>
  <td>$details</td>
</tr>
"@
    }

    @"
<details class="suite-card"$suiteOpen>
  <summary>
    <span class="suite-title">$(HtmlEncode $suiteGroup.Name)</span>
    <span class="suite-count">$suiteTotal testes</span>
    <span class="suite-bar" aria-label="$suitePassed testes passaram e $suiteFailed testes falharam">
      $failedSegment
      $passedSegment
    </span>
  </summary>
  <div class="suite-tests">
    <table>
      <thead>
        <tr>
          <th>Status</th>
          <th>Cenario</th>
          <th>HTTP</th>
          <th>Mensagem</th>
          <th>Tempo (ms)</th>
          <th>Detalhe</th>
        </tr>
      </thead>
      <tbody>
        $($suiteRows -join "`n")
      </tbody>
    </table>
  </div>
</details>
"@
}

$failedRows = foreach ($case in $failed) {
    $failure = HtmlEncode $case.FailureMessage
    @"
<li>
  <strong>$(HtmlEncode $case.Name)</strong>
  <span>$(HtmlEncode $case.Suite) - HTTP $(HtmlEncode $case.ResponseCode) - $(HtmlEncode $case.ResponseMessage)</span>
  <pre>$failure</pre>
</li>
"@
}

if ($failedRows.Count -eq 0) {
    $failedList = "<p class=""empty"">Nenhum teste falhou nesta execucao.</p>"
}
else {
    $failedList = "<ul class=""failure-list"">$($failedRows -join "`n")</ul>"
}

$html = @"
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Relatorio Funcional - ServeRest</title>
  <style>
    :root {
      color-scheme: light;
      --bg: #f5f7fb;
      --panel: #ffffff;
      --text: #182230;
      --muted: #667085;
      --line: #d9e0ea;
      --pass: #16803c;
      --pass-bg: #e8f7ee;
      --fail: #b42318;
      --fail-bg: #fdeaea;
      --accent: #245bdb;
      --shadow: 0 10px 30px rgba(23, 37, 84, 0.08);
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      background: var(--bg);
      color: var(--text);
      font-family: "Segoe UI", Arial, sans-serif;
      line-height: 1.45;
    }

    header {
      background: #182230;
      color: #fff;
      padding: 28px 32px;
    }

    main {
      width: min(1180px, calc(100% - 32px));
      margin: 24px auto 48px;
    }

    h1, h2 {
      margin: 0;
      letter-spacing: 0;
    }

    h1 {
      font-size: 28px;
      font-weight: 700;
    }

    h2 {
      font-size: 18px;
      margin-bottom: 14px;
    }

    .subtitle {
      margin: 8px 0 0;
      color: #cbd5e1;
    }

    .summary {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 14px;
      margin-bottom: 18px;
    }

    .card, .panel {
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
      box-shadow: var(--shadow);
    }

    .card {
      padding: 16px;
    }

    .card span {
      color: var(--muted);
      display: block;
      font-size: 13px;
      margin-bottom: 8px;
    }

    .card strong {
      display: block;
      font-size: 28px;
    }

    .passed-text { color: var(--pass); }
    .failed-text { color: var(--fail); }

    .result-visual {
      align-items: center;
      display: grid;
      gap: 24px;
      grid-template-columns: minmax(220px, 300px) 1fr;
      padding: 18px;
    }

    .pie-chart {
      aspect-ratio: 1 / 1;
      background: conic-gradient(var(--pass) 0 var(--passed-percent), var(--fail) var(--passed-percent) 100%);
      border: 1px solid var(--line);
      border-radius: 50%;
      box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.5);
      margin: 0 auto;
      max-width: 260px;
      width: 100%;
    }

    .chart-stats {
      display: grid;
      gap: 12px;
    }

    .legend-item {
      align-items: center;
      border: 1px solid var(--line);
      border-radius: 6px;
      display: grid;
      gap: 10px;
      grid-template-columns: 14px 1fr auto;
      padding: 12px;
    }

    .swatch {
      border-radius: 3px;
      display: block;
      height: 14px;
      width: 14px;
    }

    .swatch.passed { background: var(--pass); }
    .swatch.failed { background: var(--fail); }

    .legend-label {
      color: var(--muted);
      display: block;
      font-size: 12px;
    }

    .legend-value {
      font-size: 22px;
      font-weight: 700;
    }

    .legend-percent {
      color: var(--muted);
      font-weight: 700;
      white-space: nowrap;
    }

    .panel {
      margin-top: 18px;
      overflow: hidden;
    }

    .suites {
      display: grid;
    }

    .suite-card {
      border-bottom: 1px solid var(--line);
    }

    .suite-card:last-child {
      border-bottom: 0;
    }

    .suite-card > summary {
      align-items: center;
      color: var(--text);
      cursor: pointer;
      display: grid;
      font-weight: 400;
      gap: 14px;
      grid-template-columns: minmax(220px, 1fr) 90px minmax(260px, 46%);
      list-style: none;
      padding: 14px 16px;
    }

    .suite-card > summary::-webkit-details-marker {
      display: none;
    }

    .suite-card[open] > summary {
      background: #fbfcff;
      border-bottom: 1px solid var(--line);
    }

    .suite-title {
      font-weight: 700;
    }

    .suite-count {
      color: var(--muted);
      font-size: 13px;
      text-align: right;
      white-space: nowrap;
    }

    .suite-bar {
      background: #edf1f7;
      border-radius: 4px;
      display: flex;
      height: 22px;
      overflow: hidden;
      width: 100%;
    }

    .suite-bar span {
      align-items: center;
      color: #fff;
      display: flex;
      font-size: 12px;
      font-weight: 700;
      justify-content: center;
      min-width: 28px;
    }

    .bar-passed { background: var(--pass); }
    .bar-failed { background: var(--fail); }

    .suite-tests {
      overflow: auto;
      padding: 0 16px 16px;
    }

    .suite-tests th {
      position: static;
    }

    .panel-header {
      align-items: center;
      border-bottom: 1px solid var(--line);
      display: flex;
      gap: 16px;
      justify-content: space-between;
      padding: 16px;
    }

    .meta {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 12px;
      padding: 16px;
    }

    .meta div {
      border: 1px solid var(--line);
      border-radius: 6px;
      padding: 10px;
    }

    .meta span {
      color: var(--muted);
      display: block;
      font-size: 12px;
      margin-bottom: 4px;
    }

    .toolbar {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }

    input, button {
      border: 1px solid var(--line);
      border-radius: 6px;
      font: inherit;
      min-height: 36px;
      padding: 8px 10px;
    }

    input {
      min-width: min(360px, 100%);
    }

    button {
      background: #fff;
      color: var(--text);
      cursor: pointer;
    }

    button.active {
      background: var(--accent);
      border-color: var(--accent);
      color: #fff;
    }

    table {
      border-collapse: collapse;
      width: 100%;
    }

    th, td {
      border-bottom: 1px solid var(--line);
      padding: 12px 14px;
      text-align: left;
      vertical-align: top;
    }

    th {
      background: #f8fafc;
      color: #344054;
      font-size: 13px;
      position: sticky;
      top: 0;
      z-index: 1;
    }

    tr:hover td {
      background: #fbfcff;
    }

    .test-name {
      font-weight: 600;
      min-width: 260px;
    }

    .suite-cell {
      color: var(--muted);
      font-weight: 600;
      white-space: nowrap;
    }

    .number {
      text-align: right;
      white-space: nowrap;
    }

    .badge {
      border-radius: 999px;
      display: inline-block;
      font-size: 12px;
      font-weight: 700;
      padding: 4px 8px;
      white-space: nowrap;
    }

    .badge.passed {
      background: var(--pass-bg);
      color: var(--pass);
    }

    .badge.failed {
      background: var(--fail-bg);
      color: var(--fail);
    }

    details summary {
      color: var(--accent);
      cursor: pointer;
      font-weight: 600;
    }

    pre {
      background: #101828;
      border-radius: 6px;
      color: #f8fafc;
      margin: 10px 0 0;
      max-width: 680px;
      overflow: auto;
      padding: 10px;
      white-space: pre-wrap;
      word-break: break-word;
    }

    .failure-list {
      list-style: none;
      margin: 0;
      padding: 16px;
    }

    .failure-list li {
      border-bottom: 1px solid var(--line);
      padding: 12px 0;
    }

    .failure-list li:first-child {
      padding-top: 0;
    }

    .failure-list li:last-child {
      border-bottom: 0;
      padding-bottom: 0;
    }

    .failure-list strong, .failure-list span {
      display: block;
    }

    .failure-list span, .muted, .empty {
      color: var(--muted);
    }

    .table-wrap {
      max-height: 720px;
      overflow: auto;
    }

    @media (max-width: 860px) {
      header { padding: 22px 16px; }
      .summary, .meta { grid-template-columns: repeat(2, minmax(0, 1fr)); }
      .result-visual { grid-template-columns: 1fr; }
      .suite-card > summary { grid-template-columns: 1fr; }
      .suite-count { text-align: left; }
      .panel-header { align-items: stretch; flex-direction: column; }
    }

    @media (max-width: 560px) {
      .summary, .meta { grid-template-columns: 1fr; }
      th, td { padding: 10px; }
    }
  </style>
</head>
<body>
  <header>
    <h1>Relatorio Funcional - ServeRest</h1>
    <p class="subtitle">Resultado dos testes JMeter executados com Taurus</p>
  </header>

  <main>
    <section class="summary" aria-label="Resumo">
      <div class="card"><span>Total de testes</span><strong>$total</strong></div>
      <div class="card"><span>Passaram</span><strong class="passed-text">$passedCount</strong></div>
      <div class="card"><span>Falharam</span><strong class="failed-text">$failedCount</strong></div>
      <div class="card"><span>Taxa de sucesso</span><strong>$passRate%</strong></div>
    </section>

    <section class="panel">
      <div class="panel-header">
        <h2>Passaram x falharam</h2>
      </div>
      <div class="result-visual">
        <div class="pie-chart" style="--passed-percent: $passedPercentForChart%;" role="img" aria-label="$passedCount testes passaram e $failedCount testes falharam"></div>
        <div class="chart-stats">
          <div class="legend-item">
            <span class="swatch passed"></span>
            <div>
              <span class="legend-label">Passaram</span>
              <span class="legend-value passed-text">$passedCount testes</span>
            </div>
            <span class="legend-percent">$passRate%</span>
          </div>
          <div class="legend-item">
            <span class="swatch failed"></span>
            <div>
              <span class="legend-label">Falharam</span>
              <span class="legend-value failed-text">$failedCount testes</span>
            </div>
            <span class="legend-percent">$failedRate%</span>
          </div>
        </div>
      </div>
    </section>

    <section class="panel">
      <div class="panel-header">
        <h2>Suites</h2>
      </div>
      <div class="suites">
        $($suiteCards -join "`n")
      </div>
    </section>

    <section class="panel">
      <div class="panel-header">
        <h2>Informacoes da execucao</h2>
      </div>
      <div class="meta">
        <div><span>Arquivo fonte</span><strong>$(HtmlEncode $sourceFileName)</strong></div>
        <div><span>Inicio</span><strong>$startTime</strong></div>
        <div><span>Fim</span><strong>$endTime</strong></div>
        <div><span>Gerado em</span><strong>$generatedAt</strong></div>
        <div><span>Tempo medio</span><strong>$avgMs ms</strong></div>
        <div><span>Maior tempo</span><strong>$maxMs ms</strong></div>
        <div><span>Resultados brutos</span><strong><a href="resultados-funcionais-serverest.jtl">JTL</a></strong></div>
        <div><span>Tipo</span><strong>Funcional</strong></div>
      </div>
    </section>

    <section class="panel">
      <div class="panel-header">
        <h2>Falhas</h2>
      </div>
      $failedList
    </section>

    <section class="panel">
      <div class="panel-header">
        <h2>Cenarios executados</h2>
        <div class="toolbar">
          <input id="search" type="search" placeholder="Filtrar por nome, status ou codigo">
          <button type="button" class="active" data-filter="all">Todos</button>
          <button type="button" data-filter="failed">Falharam</button>
          <button type="button" data-filter="passed">Passaram</button>
        </div>
      </div>
      <div class="table-wrap">
        <table id="results-table">
          <thead>
            <tr>
              <th>Status</th>
              <th>Suite</th>
              <th>Cenario</th>
              <th>HTTP</th>
              <th>Mensagem</th>
              <th>Tempo (ms)</th>
              <th>Detalhe</th>
            </tr>
          </thead>
          <tbody>
            $($tableRows -join "`n")
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <script>
    const search = document.querySelector("#search");
    const buttons = document.querySelectorAll("[data-filter]");
    const rows = Array.from(document.querySelectorAll("#results-table tbody tr"));
    let statusFilter = "all";

    function applyFilters() {
      const term = search.value.trim().toLowerCase();
      rows.forEach((row) => {
        const statusOk = statusFilter === "all" || row.dataset.status === statusFilter;
        const textOk = !term || row.innerText.toLowerCase().includes(term);
        row.style.display = statusOk && textOk ? "" : "none";
      });
    }

    buttons.forEach((button) => {
      button.addEventListener("click", () => {
        buttons.forEach((item) => item.classList.remove("active"));
        button.classList.add("active");
        statusFilter = button.dataset.filter;
        applyFilters();
      });
    });

    search.addEventListener("input", applyFilters);
  </script>
</body>
</html>
"@

$indexPath = Join-Path $OutputDir "index.html"
Set-Content -Path $indexPath -Value $html -Encoding UTF8
Write-Host "Relatorio funcional gerado em $indexPath"
