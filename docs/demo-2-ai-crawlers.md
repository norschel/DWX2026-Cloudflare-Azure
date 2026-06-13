# Demo 2 – AI Crawler Governance

## Ziel
Zeigen, dass verschiedene Clients klar erkannt und am Edge gesteuert werden können.

## Ablauf
1. Script starten:
   ```bash
   ./scripts/crawler-demo-2.sh https://demo.example.com
   ```
2. Lokal zeigt die API alle Kategorien über `x-demo-client-category`.
3. Cloudflare-Bot-Regeln aktivieren (AI-Bots blocken, Scraper challengen).
4. Script erneut starten und Unterschiede zeigen.

## Erwartete Ausgabe
```text
User-Agent                    HTTP Status  Detected Category      Duration
Mozilla/5.0 Demo Browser      200          human-browser          0.041s
GPTBot                        403          edge-blocked           0.012s
ClaudeBot                     403          edge-blocked           0.011s
curl/8.0                      403          edge-blocked           0.015s
```

## Talk Track
Im Jahr 2026 ist der Request-Mix nicht nur Browser. Governance beginnt vor dem Backend.
