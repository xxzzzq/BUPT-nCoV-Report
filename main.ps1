if ($null -eq $env:IS_AT_SCHOOL -or $null -eq $env:BUPT_USERNAME -or $null -eq $env:BUPT_PASSWORD) {
    throw "Secrtes参数未设置，请参考README."
}

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.39";

Write-Host "正在尝试登录";

$res = Invoke-WebRequest -UseBasicParsing -Uri "https://app.bupt.edu.cn/uc/wap/login/check" `
    -Method "POST" `
    -WebSession $session `
    -Headers @{
    "sec-ch-ua"          = "`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"99`", `"Microsoft Edge`";v=`"99`""
    "Accept"             = "application/json, text/javascript, */*; q=0.01"
    "X-Requested-With"   = "XMLHttpRequest"
    "sec-ch-ua-mobile"   = "?0"
    "sec-ch-ua-platform" = "`"Windows`""
    "Origin"             = "https://app.bupt.edu.cn"
    "Sec-Fetch-Site"     = "same-origin"
    "Sec-Fetch-Mode"     = "cors"
    "Sec-Fetch-Dest"     = "empty"
    "Referer"            = "https://app.bupt.edu.cn/uc/wap/login"
    "Accept-Encoding"    = "gzip, deflate, br"
    "Accept-Language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
} `
    -ContentType "application/x-www-form-urlencoded; charset=UTF-8" `
    -Body @{
    "username" = $env:BUPT_USERNAME
    "password" = $env:BUPT_PASSWORD
};

if ($res.StatusCode -ne 200 -or (ConvertFrom-Json $res.Content).e -ne 0) {
    throw "登录失败";
}

Write-Host "登录成功，开始获取现存填报数据";

$res = Invoke-WebRequest -UseBasicParsing -Uri "https://app.bupt.edu.cn/xisuncov/wap/open-report/index" `
    -WebSession $session `
    -Headers @{
    "sec-ch-ua"          = "`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"99`", `"Microsoft Edge`";v=`"99`""
    "Accept"             = "application/json, text/plain, */*"
    "X-Requested-With"   = "XMLHttpRequest"
    "sec-ch-ua-mobile"   = "?0"
    "sec-ch-ua-platform" = "`"Windows`""
    "Sec-Fetch-Site"     = "same-origin"
    "Sec-Fetch-Mode"     = "cors"
    "Sec-Fetch-Dest"     = "empty"
    "Referer"            = "https://app.bupt.edu.cn/site/ncov/xisudailyup"
    "Accept-Encoding"    = "gzip, deflate, br"
    "Accept-Language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
};

$content = ConvertFrom-Json($res.Content);
if ($res.StatusCode -ne 200 -or $content.e -ne 0) {
    throw "现存填报数据获取失败，手动填报一次可能会解决问题";
}
$data = $content.d.info;

Write-Host "获取现存填报数据成功，开始晨午晚检打卡";

$res = Invoke-WebRequest -UseBasicParsing -Uri "https://app.bupt.edu.cn/xisuncov/wap/open-report/save" `
    -Method "POST" `
    -WebSession $session `
    -Headers @{
    "sec-ch-ua"          = "`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"99`", `"Microsoft Edge`";v=`"99`""
    "Accept"             = "application/json, text/plain, */*"
    "X-Requested-With"   = "XMLHttpRequest"
    "sec-ch-ua-mobile"   = "?0"
    "sec-ch-ua-platform" = "`"Windows`""
    "Origin"             = "https://app.bupt.edu.cn"
    "Sec-Fetch-Site"     = "same-origin"
    "Sec-Fetch-Mode"     = "cors"
    "Sec-Fetch-Dest"     = "empty"
    "Referer"            = "https://app.bupt.edu.cn/site/ncov/xisudailyup"
    "Accept-Encoding"    = "gzip, deflate, br"
    "Accept-Language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
} `
    -ContentType "application/x-www-form-urlencoded" `
    -Body @{
    "sfzx"         = $env:IS_AT_SCHOOL
    "tw"           = 1
    "area"         = $data.area
    "city"         = $data.city
    "province"     = $data.province
    "address"      = $data.address
    "geo_api_info" = $data.geo_api_info
    "sfcyglq"      = 0
    "sfyzz"        = 0
    "qtqk"         = ''
    "askforleave"  = 0
};

if ($res.StatusCode -ne 200 -or (ConvertFrom-Json $res.Content).e -ne 0) {
    throw "打卡失败";
}

Write-Host "晨晚午检打卡成功";
