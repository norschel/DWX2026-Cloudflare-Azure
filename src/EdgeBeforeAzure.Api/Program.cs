using System.Net;
using System.Net.Sockets;
using EdgeBeforeAzure.Api;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration["AllowedHosts"] = "*";
var app = builder.Build();
var originServer = await GetOriginServerNetworkInfoAsync(app.Logger);

var imagesPath = Path.Combine(builder.Environment.ContentRootPath, "images");
if (Directory.Exists(imagesPath))
{
    app.UseStaticFiles(new StaticFileOptions
    {
        FileProvider = new PhysicalFileProvider(imagesPath),
        RequestPath = "/images"
    });
}

app.MapGet("/", async (HttpContext context, ILogger<Program> logger) =>
{
    var requestHostInfo = GetRequestHostInfo(context.Request);
    var clientNetwork = await GetNetworkInfoAsync(context.Request, context.Connection.RemoteIpAddress, logger);
    var edgeNetwork = await GetEdgeNodeNetworkInfoAsync(context.Connection.RemoteIpAddress, logger);

    return Results.Ok(new
    {
        service = "edge-before-azure-demo",
        status = "ok",
        origin = "azure",
        requestHost = requestHostInfo.EffectiveHost,
        requestNode = requestHostInfo.EffectiveHost,
        forwardedHost = requestHostInfo.ForwardedHost,
        edgeNode = GetEdgeNode(context.Request),
        edgeNodeIp = edgeNetwork.IpAddress,
        edgeNodeHostName = edgeNetwork.HostName,
        clientIp = clientNetwork.IpAddress,
        clientHostName = clientNetwork.HostName,
        originServerIp = originServer.IpAddress,
        originServerHostName = originServer.HostName,
        timestamp = DateTimeOffset.UtcNow
    });
});

app.MapGet("/api/weather", async (HttpContext context, ILogger<Program> logger) =>
{
    LogDemoRequest("security-funnel", context, logger);
    context.Response.Headers.Append("x-demo-origin", "azure");
    var requestHostInfo = GetRequestHostInfo(context.Request);
    var clientNetwork = await GetNetworkInfoAsync(context.Request, context.Connection.RemoteIpAddress, logger);
    var edgeNetwork = await GetEdgeNodeNetworkInfoAsync(context.Connection.RemoteIpAddress, logger);

    var temperature = Random.Shared.Next(-5, 38);
    var summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Cloudy"
    };

    return Results.Ok(new
    {
        demo = "security-funnel",
        origin = "azure",
        edgeNode = GetEdgeNode(context.Request),
        requestHost = requestHostInfo.EffectiveHost,
        requestNode = requestHostInfo.EffectiveHost,
        forwardedHost = requestHostInfo.ForwardedHost,
        edgeNodeIp = edgeNetwork.IpAddress,
        edgeNodeHostName = edgeNetwork.HostName,
        clientIp = clientNetwork.IpAddress,
        clientHostName = clientNetwork.HostName,
        originServerIp = originServer.IpAddress,
        originServerHostName = originServer.HostName,
        temperatureC = temperature,
        summary = summaries[Random.Shared.Next(summaries.Length)],
        timestamp = DateTimeOffset.UtcNow
    });
});

app.MapGet("/api/crawler-check", async (HttpContext context, ILogger<Program> logger) =>
{
    LogDemoRequest("ai-crawler-governance", context, logger);
    var requestHostInfo = GetRequestHostInfo(context.Request);
    var clientNetwork = await GetNetworkInfoAsync(context.Request, context.Connection.RemoteIpAddress, logger);
    var edgeNetwork = await GetEdgeNodeNetworkInfoAsync(context.Connection.RemoteIpAddress, logger);

    var userAgent = context.Request.Headers.UserAgent.ToString();
    var category = UserAgentCategorizer.Categorize(userAgent);
    context.Response.Headers.Append("x-demo-client-category", category);

    return Results.Ok(new
    {
        demo = "ai-crawler-governance",
        requestHost = requestHostInfo.EffectiveHost,
        requestNode = requestHostInfo.EffectiveHost,
        forwardedHost = requestHostInfo.ForwardedHost,
        edgeNode = GetEdgeNode(context.Request),
        edgeNodeIp = edgeNetwork.IpAddress,
        edgeNodeHostName = edgeNetwork.HostName,
        userAgent,
        clientIp = clientNetwork.IpAddress,
        clientHostName = clientNetwork.HostName,
        originServerIp = originServer.IpAddress,
        originServerHostName = originServer.HostName,
        category,
        recommendation = category == "ai-crawler" || category == "scraper"
            ? "handle at edge"
            : "allow to origin"
    });
});

app.MapGet("/api/products", async (HttpContext context, IConfiguration configuration, ILogger<Program> logger) =>
{
    LogDemoRequest("cache-hit-vs-origin-hit", context, logger);
    var requestHostInfo = GetRequestHostInfo(context.Request);
    var clientNetwork = await GetNetworkInfoAsync(context.Request, context.Connection.RemoteIpAddress, logger);
    var edgeNetwork = await GetEdgeNodeNetworkInfoAsync(context.Connection.RemoteIpAddress, logger);

    var delayMs = Math.Max(configuration.GetValue<int?>("Demo:ProductsDelayMilliseconds") ?? 500, 0);
    await Task.Delay(delayMs);

    context.Response.Headers.Append("Cache-Control", "public, max-age=60");
    context.Response.Headers.Append("x-demo-origin", "azure");

    return Results.Ok(new
    {
        demo = "cache-hit-vs-origin-hit",
        origin = "azure",
        requestHost = requestHostInfo.EffectiveHost,
        requestNode = requestHostInfo.EffectiveHost,
        forwardedHost = requestHostInfo.ForwardedHost,
        edgeNode = GetEdgeNode(context.Request),
        edgeNodeIp = edgeNetwork.IpAddress,
        edgeNodeHostName = edgeNetwork.HostName,
        clientIp = clientNetwork.IpAddress,
        clientHostName = clientNetwork.HostName,
        originServerIp = originServer.IpAddress,
        originServerHostName = originServer.HostName,
        processingDelayMs = delayMs,
        products = new[]
        {
            new { id = "espresso-001", name = "Rocket Espresso R58 v2", category = "coffee" },
            new { id = "devops-001", name = "Deployment Pipeline", category = "platform" }
        },
        timestamp = DateTimeOffset.UtcNow
    });
});

app.MapGet("/api/health", async (HttpContext context, ILogger<Program> logger) =>
{
    var requestHostInfo = GetRequestHostInfo(context.Request);
    var clientNetwork = await GetNetworkInfoAsync(context.Request, context.Connection.RemoteIpAddress, logger);
    var edgeNetwork = await GetEdgeNodeNetworkInfoAsync(context.Connection.RemoteIpAddress, logger);

    return Results.Ok(new
    {
        status = "healthy",
        origin = "azure",
        requestHost = requestHostInfo.EffectiveHost,
        requestNode = requestHostInfo.EffectiveHost,
        forwardedHost = requestHostInfo.ForwardedHost,
        edgeNode = GetEdgeNode(context.Request),
        edgeNodeIp = edgeNetwork.IpAddress,
        edgeNodeHostName = edgeNetwork.HostName,
        clientIp = clientNetwork.IpAddress,
        clientHostName = clientNetwork.HostName,
        originServerIp = originServer.IpAddress,
        originServerHostName = originServer.HostName
    });
});

app.Run();

static void LogDemoRequest(string demoName, HttpContext context, ILogger logger)
{
    var request = context.Request;
    var userAgent = request.Headers.UserAgent.ToString();
    var clientIp = GetClientIpAddress(request, context.Connection.RemoteIpAddress);
    var xForwardedFor = request.Headers["X-Forwarded-For"].ToString();
    var cfRay = request.Headers["CF-Ray"].ToString();
    var timestamp = DateTimeOffset.UtcNow;

    logger.LogInformation(
        "Demo request {DemoName} {Path} {Method} {UserAgent} {ClientIp} {XForwardedFor} {CfRay} {Timestamp}",
        demoName,
        request.Path,
        request.Method,
        userAgent,
        clientIp,
        xForwardedFor,
        cfRay,
        timestamp);
}

static async Task<NetworkInfo> GetNetworkInfoAsync(HttpRequest request, IPAddress? remoteIpAddress, ILogger logger)
{
    var clientIpAddress = GetClientIpAddress(request, remoteIpAddress);
    var clientHostName = await TryResolveHostNameAsync(clientIpAddress, logger);
    return new NetworkInfo(clientIpAddress, clientHostName);
}

static async Task<NetworkInfo> GetEdgeNodeNetworkInfoAsync(IPAddress? remoteIpAddress, ILogger logger)
{
    var edgeNodeIp = remoteIpAddress?.ToString() ?? "unknown";
    var edgeNodeHostName = await TryResolveHostNameAsync(edgeNodeIp, logger);
    return new NetworkInfo(edgeNodeIp, edgeNodeHostName);
}

static string GetClientIpAddress(HttpRequest request, IPAddress? remoteIpAddress)
{
    var cloudflareIp = request.Headers["CF-Connecting-IP"].FirstOrDefault();
    if (!string.IsNullOrWhiteSpace(cloudflareIp))
    {
        return cloudflareIp.Trim();
    }

    var forwardedIp = request.Headers["X-Forwarded-For"].FirstOrDefault();
    if (!string.IsNullOrWhiteSpace(forwardedIp))
    {
        return forwardedIp.Split(',')[0].Trim();
    }

    return remoteIpAddress?.ToString() ?? "unknown";
}

static RequestHostInfo GetRequestHostInfo(HttpRequest request)
{
    var host = request.Host.Value;
    var forwardedHost = request.Headers["X-Forwarded-Host"].FirstOrDefault();
    var effectiveHost = !string.IsNullOrWhiteSpace(forwardedHost) ? forwardedHost : host;
    return new RequestHostInfo(
        string.IsNullOrWhiteSpace(effectiveHost) ? "unknown" : effectiveHost,
        string.IsNullOrWhiteSpace(forwardedHost) ? null : forwardedHost);
}

static string? GetEdgeNode(HttpRequest request)
{
    var cfRay = request.Headers["CF-Ray"].FirstOrDefault();
    return cfRay?.Contains('-') == true ? cfRay.Split('-')[^1] : null;
}

static async Task<NetworkInfo> GetOriginServerNetworkInfoAsync(ILogger logger)
{
    var originServerHostName = Dns.GetHostName();

    try
    {
        var addresses = await Dns.GetHostAddressesAsync(originServerHostName).WaitAsync(TimeSpan.FromSeconds(2));
        var preferredAddress = addresses.FirstOrDefault(address => address.AddressFamily == AddressFamily.InterNetwork && !IPAddress.IsLoopback(address))
            ?? addresses.FirstOrDefault(address => address.AddressFamily == AddressFamily.InterNetworkV6 && !IPAddress.IsLoopback(address))
            ?? addresses.FirstOrDefault(address => !IPAddress.IsLoopback(address))
            ?? addresses.FirstOrDefault();

        return new NetworkInfo(
            preferredAddress?.ToString() ?? "unknown",
            string.IsNullOrWhiteSpace(originServerHostName) ? null : originServerHostName);
    }
    catch (SocketException)
    {
        return new NetworkInfo(
            "unknown",
            string.IsNullOrWhiteSpace(originServerHostName) ? null : originServerHostName);
    }
    catch (TimeoutException)
    {
        return new NetworkInfo(
            "unknown",
            string.IsNullOrWhiteSpace(originServerHostName) ? null : originServerHostName);
    }
    catch (Exception exception)
    {
        logger.LogWarning(exception, "Origin server network info lookup failed");
        return new NetworkInfo(
            "unknown",
            string.IsNullOrWhiteSpace(originServerHostName) ? null : originServerHostName);
    }
}

static async Task<string?> TryResolveHostNameAsync(string clientIpAddress, ILogger logger)
{
    if (!IPAddress.TryParse(clientIpAddress, out var ipAddress))
    {
        return null;
    }

    try
    {
        var hostEntry = await Dns.GetHostEntryAsync(ipAddress).WaitAsync(TimeSpan.FromSeconds(2));
        return string.IsNullOrWhiteSpace(hostEntry.HostName) || string.Equals(hostEntry.HostName, clientIpAddress, StringComparison.OrdinalIgnoreCase)
            ? null
            : hostEntry.HostName;
    }
    catch (SocketException)
    {
        return null;
    }
    catch (TimeoutException)
    {
        return null;
    }
    catch (Exception exception)
    {
        logger.LogWarning(exception, "Reverse DNS lookup failed for client IP {ClientIpAddress}", clientIpAddress);
        return null;
    }
}

internal sealed record NetworkInfo(string IpAddress, string? HostName);
internal sealed record RequestHostInfo(string EffectiveHost, string? ForwardedHost);

public partial class Program;
