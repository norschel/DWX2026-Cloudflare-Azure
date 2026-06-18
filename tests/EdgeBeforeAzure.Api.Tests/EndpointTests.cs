using System.Net;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;

namespace EdgeBeforeAzure.Api.Tests;

public class EndpointTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public EndpointTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task Health_ReturnsHealthy()
    {
        var response = await _client.GetAsync("/api/health");

        response.EnsureSuccessStatusCode();
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("healthy", document.RootElement.GetProperty("status").GetString());
        AssertCommonNetworkMetadata(document.RootElement);
    }

    [Fact]
    public async Task Root_ReturnsCommonNetworkMetadata()
    {
        var response = await _client.GetAsync("/");

        response.EnsureSuccessStatusCode();
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("edge-before-azure-demo", document.RootElement.GetProperty("service").GetString());
        AssertCommonNetworkMetadata(document.RootElement);
    }

    [Fact]
    public async Task Products_IncludesCacheControlHeader()
    {
        var response = await _client.GetAsync("/api/products");

        response.EnsureSuccessStatusCode();
        Assert.True(response.Headers.TryGetValues("Cache-Control", out var values));
        Assert.Contains("public", values.Single(), StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task CrawlerCheck_GptBot_ReturnsAiCrawler()
    {
        var request = new HttpRequestMessage(HttpMethod.Get, "/api/crawler-check");
        request.Headers.UserAgent.ParseAdd("GPTBot");

        var response = await _client.SendAsync(request);

        response.EnsureSuccessStatusCode();
        Assert.True(response.Headers.TryGetValues("x-demo-client-category", out var values));
        Assert.Equal("ai-crawler", values.Single());
    }

    [Fact]
    public async Task Weather_IncludesOriginHeader()
    {
        var response = await _client.GetAsync("/api/weather");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.True(response.Headers.TryGetValues("x-demo-origin", out var values));
        Assert.Equal("azure", values.Single());
    }

    [Fact]
    public async Task Weather_WithoutCfRay_EdgeNodeIsNull()
    {
        var response = await _client.GetAsync("/api/weather");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var body = await response.Content.ReadAsStringAsync();
        Assert.Contains("\"edgeNode\":null", body, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task Weather_WithCfRay_IncludesEdgeNode()
    {
        var request = new HttpRequestMessage(HttpMethod.Get, "/api/weather");
        request.Headers.Add("CF-Ray", "abc123def456-FRA");

        var response = await _client.SendAsync(request);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var body = await response.Content.ReadAsStringAsync();
        Assert.Contains("\"edgeNode\":\"FRA\"", body, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task Weather_WithCfConnectingIp_IncludesClientIp()
    {
        var request = new HttpRequestMessage(HttpMethod.Get, "/api/weather");
        request.Headers.Add("CF-Connecting-IP", "198.51.100.10");

        var response = await _client.SendAsync(request);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("198.51.100.10", document.RootElement.GetProperty("clientIp").GetString());
    }

    [Fact]
    public async Task Weather_IncludesEdgeNodeIp()
    {
        var response = await _client.GetAsync("/api/weather");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        AssertCommonNetworkMetadata(document.RootElement);
    }

    [Fact]
    public async Task CrawlerCheck_IncludesEdgeNodeIp()
    {
        var response = await _client.GetAsync("/api/crawler-check");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        AssertCommonNetworkMetadata(document.RootElement);
    }

    [Fact]
    public async Task Products_IncludesEdgeNodeIp()
    {
        var response = await _client.GetAsync("/api/products");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        AssertCommonNetworkMetadata(document.RootElement);
    }

    [Fact]
    public async Task Weather_WithForwardedHost_UsesForwardedHostAsRequestHost()
    {
        var request = new HttpRequestMessage(HttpMethod.Get, "/api/weather");
        request.Headers.Add("X-Forwarded-Host", "demo.example.com");

        var response = await _client.SendAsync(request);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("demo.example.com", document.RootElement.GetProperty("requestHost").GetString());
        Assert.Equal("demo.example.com", document.RootElement.GetProperty("requestNode").GetString());
        Assert.Equal("demo.example.com", document.RootElement.GetProperty("forwardedHost").GetString());
    }

    [Fact]
    public async Task Weather_WithLoopbackClientIp_TriesToResolveHostName()
    {
        var request = new HttpRequestMessage(HttpMethod.Get, "/api/weather");
        request.Headers.Add("CF-Connecting-IP", "127.0.0.1");

        var response = await _client.SendAsync(request);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.False(string.IsNullOrWhiteSpace(document.RootElement.GetProperty("clientHostName").GetString()));
    }

    [Theory]
    [InlineData("Mozilla/5.0 Demo Browser", "human-browser")]
    [InlineData("GPTBot", "ai-crawler")]
    [InlineData("Googlebot", "search-bot")]
    [InlineData("curl/8.0", "scraper")]
    [InlineData("unknown-agent", "unknown")]
    public void UserAgentCategorizer_ReturnsExpectedCategory(string userAgent, string expected)
    {
        var actual = UserAgentCategorizer.Categorize(userAgent);

        Assert.Equal(expected, actual);
    }

    private static void AssertCommonNetworkMetadata(JsonElement root)
    {
        Assert.True(root.TryGetProperty("requestHost", out _));
        Assert.True(root.TryGetProperty("requestNode", out _));
        Assert.True(root.TryGetProperty("forwardedHost", out _));
        Assert.True(root.TryGetProperty("edgeNode", out _));
        Assert.True(root.TryGetProperty("edgeNodeIp", out _));
        Assert.True(root.TryGetProperty("edgeNodeHostName", out _));
        Assert.True(root.TryGetProperty("clientIp", out _));
        Assert.True(root.TryGetProperty("clientHostName", out _));
        Assert.True(root.TryGetProperty("originServerIp", out _));
        Assert.True(root.TryGetProperty("originServerHostName", out _));
    }
}
