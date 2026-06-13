# Troubleshooting

## Local fallback mode
Wenn Cloudflare/Azure nicht erreichbar ist, lokal ausführen:
```bash
dotnet run --project src/EdgeBeforeAzure.Api/EdgeBeforeAzure.Api.csproj
export DEMO_BASE_URL=http://localhost:5000
./scripts/load-demo-1.sh "$DEMO_BASE_URL" normal
./scripts/crawler-demo-2.sh "$DEMO_BASE_URL"
./scripts/cache-demo-3.sh "$DEMO_BASE_URL"
```

## Häufige Probleme
- **Port-Konflikt:** Anderen Port in `ASPNETCORE_URLS` setzen.
- **Keine Cache-HITs:** Cloudflare Cache-Regel prüfen und Cache purgen.
- **Crawler bleiben 200:** Block-Regel für GPTBot/ClaudeBot/PerplexityBot aktivieren.
- **Terraform Auth Fehler:** GitHub Secrets (`AZURE_CREDENTIALS`, `CLOUDFLARE_*`) prüfen.

## Environment variables
- `ASPNETCORE_ENVIRONMENT`
- `APPLICATIONINSIGHTS_CONNECTION_STRING`
- `Demo__ProductsDelayMilliseconds`
- `DEMO_BASE_URL` (für Scripts)
