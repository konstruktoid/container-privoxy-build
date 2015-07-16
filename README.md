#Privoxy

_"Privoxy is a non-caching web proxy with filtering capabilities for 
enhancing privacy, manipulating cookies and modifying web page data 
and HTTP headers before the page is rendered by the browser. Privoxy 
is a "privacy enhancing proxy", filtering Web pages and removing 
advertisements."_  

Website: http://www.privoxy.org/  

```sh
$ docker build -t privoxy -f Dockerfile .
$ docker run --cap-drop=all --cap-add={setgid,setuid} -d -p 8118:8118 -t privoxy --no-daemon --user privoxy /etc/privoxy/config
```
