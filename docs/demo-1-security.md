# Demo 1 – Azure sieht plötzlich nichts mehr

## Ziel
Zeigen, dass unerwünschter Traffic schon am Edge blockiert wird und Azure weniger Last sieht.

## Ablauf
1. API lokal oder in Azure starten.
2. Normale Last erzeugen:
   ```bash
   ./scripts/load-demo-1.sh https://demo.example.com normal
   ```
3. Verdächtige Last erzeugen:
   ```bash
   ./scripts/load-demo-1.sh https://demo.example.com suspicious
   ```
4. Cloudflare-Regel aktivieren:
   - `http.request.headers["x-demo-traffic"][0] eq "suspicious"`
   - oder `http.user_agent contains "demo-scanner"`
5. Verdächtige Last erneut senden und blockierte Requests zeigen.

## Erwartete Ausgabe
```text
Mode: suspicious
Total requests: 20
Successful responses: 0
Blocked responses: 20
Average duration: 0.013s
```

## Talk Track
Sobald Cloudflare blockiert, muss Azure nicht skalieren, nicht loggen und nicht zahlen.
