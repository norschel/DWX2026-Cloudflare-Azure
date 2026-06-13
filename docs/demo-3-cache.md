# Demo 3 – Cache Hit vs Origin Hit

## Ziel
Latenz- und Lastunterschied zwischen Origin-Hit und Edge-Cache-Hit sichtbar machen.

## Ablauf
1. Sicherstellen, dass `Demo__ProductsDelayMilliseconds=500` gesetzt ist.
2. Script starten:
   ```bash
   ./scripts/cache-demo-3.sh https://demo.example.com
   ```
3. Ohne Cloudflare-Cache bleiben Requests langsam.
4. Cache-Regel für `/api/products` aktivieren (TTL 60s).
5. Script erneut starten und HITs mit niedriger Latenz zeigen.

## Erwartete Ausgabe
```text
Run    Status   Duration   CF-Cache-Status    Age    Origin
1      200      0.534s     MISS               0      azure
2      200      0.021s     HIT                4      azure
3      200      0.018s     HIT                5      azure
```

## Talk Track
Der schnellste Azure-Request ist der, der nie bei Azure ankommt.
