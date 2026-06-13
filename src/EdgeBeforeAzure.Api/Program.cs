using EdgeBeforeAzure.Api;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => Results.Ok(new
{
    service = "edge-before-azure-demo",
    status = "ok",
    timestamp = DateTimeOffset.UtcNow
}));

app.MapGet("/api/weather", (HttpContext context, ILogger<Program> logger) =>
{
    LogDemoRequest("security-funnel", context, logger);
    context.Response.Headers.Append("x-demo-origin", "azure");

    var temperature = Random.Shared.Next(-5, 38);
    var summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Cloudy"
    };

    return Results.Ok(new
    {
        demo = "security-funnel",
        origin = "azure",
        temperatureC = temperature,
        summary = summaries[Random.Shared.Next(summaries.Length)],
        timestamp = DateTimeOffset.UtcNow
    });
});

app.MapGet("/api/crawler-check", (HttpContext context, ILogger<Program> logger) =>
{
    LogDemoRequest("ai-crawler-governance", context, logger);

    var userAgent = context.Request.Headers.UserAgent.ToString();
    var category = UserAgentCategorizer.Categorize(userAgent);
    context.Response.Headers.Append("x-demo-client-category", category);

    return Results.Ok(new
    {
        demo = "ai-crawler-governance",
        userAgent,
        category,
        recommendation = category == "ai-crawler" || category == "scraper"
            ? "handle at edge"
            : "allow to origin"
    });
});

app.MapGet("/api/products", async (HttpContext context, IConfiguration configuration, ILogger<Program> logger) =>
{
    LogDemoRequest("cache-hit-vs-origin-hit", context, logger);

    var delayMs = Math.Max(configuration.GetValue<int?>("Demo:ProductsDelayMilliseconds") ?? 500, 0);
    await Task.Delay(delayMs);

    context.Response.Headers.Append("Cache-Control", "public, max-age=60");
    context.Response.Headers.Append("x-demo-origin", "azure");

    return Results.Ok(new
    {
        demo = "cache-hit-vs-origin-hit",
        origin = "azure",
        processingDelayMs = delayMs,
        products = new[]
        {
            new { id = "espresso-001", name = "Rocket Espresso R58 v2", category = "coffee" },
            new { id = "devops-001", name = "Deployment Pipeline", category = "platform" }
        },
        timestamp = DateTimeOffset.UtcNow
    });
});

app.MapGet("/api/health", () => Results.Ok(new { status = "healthy" }));

app.Run();

static void LogDemoRequest(string demoName, HttpContext context, ILogger logger)
{
    var request = context.Request;
    var userAgent = request.Headers.UserAgent.ToString();
    var clientIp = context.Connection.RemoteIpAddress?.ToString() ?? "unknown";
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

public partial class Program;
