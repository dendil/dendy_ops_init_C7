
# Use Aliyun NTP server
https://help.aliyun.com/document_detail/92704.html
# China — cn.pool.ntp.org
https://www.pool.ntp.org/zone/cn

ntpdate时间同步命令很简单
```bash
ntpdate [-nv] [NTP IP/hostname]
ntpdate 0.cn.pool.ntp.org
```
但这样的同步，只是强制性的将系统时间设置为ntp服务器时间。如果cpu tick有问题，只是治标不治本。所以，一般配合cron命令，来进行定期同步设置。比如，在crontab中添加：

*/5 * * * * * /usr/sbin/ntpdate 192.168.0.1

每5秒同步一次
因为，ntpdate同步时间，会造成时间的跳跃，对一些依赖时间的程序和服务会造成影响。比 如sleep，timer等。而且，ntpd服务可以在修正时间的同时，修正cpu tick。

理想的做法为，在开机的时候，使用ntpdate强制同步时间，在其他时候使用chrony服务来同步时间。

# chrony
### chrony 的优势：
>更快的同步，从而最大程度减少了时间和频率误差，对于并非全天 24 小时运行的虚拟计算机而言非常有用
>能够更好地响应时钟频率的快速变化，对于具备不稳定时钟的虚拟机或导致时钟频率发生变化的节能技术而言非常有用
>在初始同步后，它不会停止时钟，以防对需要系统时间保持单调的应用程序造成影响
>在应对临时非对称延迟时（例如，在大规模下载造成链接饱和时）提供了更好的稳定性
>无需对服务器进行定期轮询，因此具备间歇性网络连接的系统仍然可以快速同步时钟
```bash
echo 'server 0.cn.pool.ntp.org iburst' >> /etc/chrony.conf
echo 'server 1.cn.pool.ntp.org iburst' >> /etc/chrony.conf
echo 'server 2.cn.pool.ntp.org iburst' >> /etc/chrony.conf
echo 'server 3.cn.pool.ntp.org iburst' >> /etc/chrony.conf
```
