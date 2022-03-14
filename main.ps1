$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.39" 

function Login {
    param (
        $username,
        $password
    )
    
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
        "username" = $username
        "password" = $password
    };

    if ($res.StatusCode -ne 200) {
        throw "登录失败";
    }
}

function Check {
    Write-Host "登录成功，开始晨午晚检打卡";

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
        "sfzx"         = 0
        "tw"           = 1
        "area"         = "陕西省 渭南市 临渭区"
        "city"         = "渭南市"
        "province"     = "陕西省"
        "address"      = "陕西省渭南市临渭区杜桥街道东风大街6号恒昌王子国际酒店"
        "geo_api_info" = ConvertFrom-Json '{"type":"complete","position":{"Q":34.499926215278,"R":109.49075412326397,"lng":109.490754,"lat":34.499926},"location_type":"html5","message":"Get ipLocation failed.Get geolocation success.Convert Success.Get address success.","accuracy":18,"isConverted":true,"status":1,"addressComponent":{"citycode":"0913","adcode":"610502","businessAreas":[{"name":"朝阳大街","id":"610502","location":{"Q":34.492806,"R":109.476858,"lng":109.476858,"lat":34.492806}}],"neighborhoodType":"","neighborhood":"","building":"","buildingType":"","street":"东风大街","streetNumber":"6号","country":"中国","province":"陕西省","city":"渭南市","district":"临渭区","towncode":"610502001000","township":"杜桥街道"},"formattedAddress":"陕西省渭南市临渭区杜桥街道东风大街6号恒昌王子国际酒店","roads":[],"crosses":[],"pois":[],"info":"SUCCESS"}';
        "sfcyglq"      = 0
        "sfyzz"        = 0
        "qtqk"         = ''
        "askforleave"  = 0
    };

    if ($res.StatusCode -ne 200) {
        throw "打卡失败";
    }
}

Login $env:BUPT_USERNAME $env:BUPT_PASSWORD;
Check;
