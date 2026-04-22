$path = "C:\Users\Tesla Laptops\Downloads\moondogai-landing\moondogai-landing\dist"
$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Started HTTP Server on port $port"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $filePath = $path + $request.Url.LocalPath.Replace("/", "\")
    if ($filePath.EndsWith("\")) { $filePath += "index.html" }
    if (Test-Path $filePath -PathType Leaf) {
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $content.Length
        if ($filePath.EndsWith(".js")) { $response.ContentType = "application/javascript" }
        elseif ($filePath.EndsWith(".css")) { $response.ContentType = "text/css" }
        elseif ($filePath.EndsWith(".html")) { $response.ContentType = "text/html" }
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
    }
    $response.OutputStream.Close()
}
