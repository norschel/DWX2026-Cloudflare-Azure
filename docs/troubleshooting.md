# Troubleshooting

## Local fallback mode
If Cloudflare or Azure is unavailable during a demo, run everything locally:
```bash
dotnet run --project src/EdgeBeforeAzure.Api/EdgeBeforeAzure.Api.csproj
export DEMO_BASE_URL=http://localhost:5000
./scripts/load-demo-1.sh "$DEMO_BASE_URL" normal
./scripts/crawler-demo-2.sh "$DEMO_BASE_URL"
./scripts/cache-demo-3.sh "$DEMO_BASE_URL"
```

## Common issues
- **Port conflict:** set a different value for `ASPNETCORE_URLS`.
- **No cache HITs:** verify Cloudflare cache rule and purge cache.
- **Crawler requests still 200:** enable bot block rules for GPTBot/ClaudeBot/PerplexityBot.
- **Terraform auth failures:** verify GitHub secrets (`AZURE_CREDENTIALS`, `CLOUDFLARE_*`).

## Environment variables
- `ASPNETCORE_ENVIRONMENT`
- `APPLICATIONINSIGHTS_CONNECTION_STRING`
- `Demo__ProductsDelayMilliseconds`
- `DEMO_BASE_URL` (scripts)
