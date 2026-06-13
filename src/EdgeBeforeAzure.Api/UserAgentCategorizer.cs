namespace EdgeBeforeAzure.Api;

public static class UserAgentCategorizer
{
    public static string Categorize(string? userAgent)
    {
        if (string.IsNullOrWhiteSpace(userAgent))
        {
            return "unknown";
        }

        var normalized = userAgent.Trim();

        if (ContainsAny(normalized, "GPTBot", "ClaudeBot", "PerplexityBot"))
        {
            return "ai-crawler";
        }

        if (ContainsAny(normalized, "Googlebot", "Bingbot"))
        {
            return "search-bot";
        }

        if (ContainsAny(normalized, "curl", "python"))
        {
            return "scraper";
        }

        if (ContainsAny(normalized, "Mozilla"))
        {
            return "human-browser";
        }

        return "unknown";
    }

    private static bool ContainsAny(string value, params string[] tokens)
    {
        return tokens.Any(token => value.Contains(token, StringComparison.OrdinalIgnoreCase));
    }
}
