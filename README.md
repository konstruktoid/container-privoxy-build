#Privoxy

```sh
$ docker build -t privoxy -f Dockerfile .
$ docker run --cap-drop=all --cap-add={setgid,setuid} -d -p 8118:8118 -t privoxy --no-daemon --user privoxy /etc/privoxy/config
```
