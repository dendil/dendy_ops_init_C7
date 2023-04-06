# useragent count
```bash
cat /opt/nginx/logs/access.log* |jq .agent |egrep -v "iPhone|Linux|Windows|Macintosh"|sort -n   |uniq -c  |sort
cat /opt/nginx/logs/access.log  |jq .xff  |sort  -n  |uniq -c
```

```
server{ 
if ($http_user_agent ~* "^(?=.*censys)") {
    return 444;
}
}
```