From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Wed, 23 Nov 2022 18:18:06 -0700
Message-ID: <CAOUHufZxguv_m3Td7e5Qt-yKpV7rmWyv_m_UFS9n19K=_=xLcA@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
 <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
 <Y31s/K8T85jh05wH@google.com> <Y36PF972kOK3ADvx@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7tBUw05aOdjyO9WsFCtTrKc5G8bk3/uCIv/FSXOVjTg=;
        b=cR5Tx2OzMDMnzLuq7r4ycWlRO2gzxpltG7WVxggQ3gkD+H3QiCLqshLPiuVxRJBFSU
         0Dsod0ESCG9U1Y2Aqi9PF/Nv0lOtf83kNL85Mf0frsQ6U3JQ76FniUpqF2VAjwvca1/R
         WUvPfq1mJ0L6Y7QVHxD4+iO9ze85KXFCSaLauEtk3/gSVWHeaP7bEmE8bzDOwW68Pm/7
         8kYPeF3UpkDZOn5PVa5upr+5tIqawN9l5Kge+KTEeHp8MWMmzNnu+YgckbCx/b91yURh
         sdLhWAYMIsjgOSUVC4+ufPavt+Btcq6W8cnHS2pv41s+tlftvvgZPEFPXzgj+qIQTbSC
         CdTg==
In-Reply-To: <Y36PF972kOK3ADvx-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Wed, Nov 23, 2022 at 2:22 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Tue, Nov 22, 2022 at 05:44:44PM -0700, Yu Zhao wrote:
> > Hi Johannes,
> >
> > Do you think it makes sense to have the below for both the baseline and
> > MGLRU or it's some behavior change that the baseline doesn't want to
> > risk?
>
> It looks good to me. Besides the new FMODE_NOREUSE, it's also a nice
> cleanup on the rmap side!
>
> It would just be good to keep the comment from folio_referenced_one() and
> move it to the vma_has_locality() check in invalid_folio_referenced_vma().
>
> Otherwise,
>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks.

I've added Ivan's test case to my collection. Interestingly, after
this patch, the download speed increased while fio was running (my
guess is that fio pushed more cold anon into swap):

$ uname
Linux test127 6.1.0-rc6-dirty #2 SMP PREEMPT_DYNAMIC Wed Nov 23
16:51:20 MST 2022 x86_64 x86_64 x86_64 GNU/Linux

$ go version
go version go1.18.1 linux/amd64

$ fio -v
fio-3.28

$ curl --version
curl 7.81.0 (x86_64-pc-linux-gnu) libcurl/7.81.0 OpenSSL/3.0.2
zlib/1.2.11 brotli/1.0.9 zstd/1.4.8 libidn2/2.3.2 libpsl/0.21.0
(+libidn2/2.3.2) libssh/0.9.6/openssl/zlib nghttp2/1.43.0 librtmp/2.3
OpenLDAP/2.5.13
Release-Date: 2022-01-05
Protocols: dict file ftp ftps gopher gophers http https imap imaps
ldap ldaps mqtt pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps
telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN
IPv6 Kerberos Largefile libz NTLM NTLM_WB PSL SPNEGO SSL TLS-SRP
UnixSockets zstd

fio NOT running:

 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  83.6M      0 --:--:--  0:00:57 --:--:-- 87.0M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.8M      0 --:--:--  0:00:57 --:--:-- 79.1M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.7M      0 --:--:--  0:00:57 --:--:-- 89.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  87.4M      0 --:--:--  0:00:54 --:--:-- 94.3M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  88.1M      0 --:--:--  0:00:54 --:--:-- 94.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.6M      0 --:--:--  0:00:57 --:--:-- 83.9M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  86.4M      0 --:--:--  0:00:55 --:--:-- 90.1M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.8M      0 --:--:--  0:00:57 --:--:-- 67.5M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  83.4M      0 --:--:--  0:00:57 --:--:-- 78.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  84.0M      0 --:--:--  0:00:56 --:--:-- 87.4M


fio running:

 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  86.7M      0 --:--:--  0:01:11 --:--:-- 88.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  87.7M      0 --:--:--  0:00:54 --:--:-- 93.5M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  88.5M      0 --:--:--  0:00:53 --:--:-- 95.1M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  91.6M      0 --:--:--  0:00:52 --:--:-- 94.4M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  89.4M      0 --:--:--  0:00:53 --:--:-- 86.6M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  88.6M      0 --:--:--  0:00:53 --:--:-- 84.8M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  84.6M      0 --:--:--  0:00:56 --:--:-- 87.5M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  86.9M      0 --:--:--  0:00:54 --:--:-- 81.4M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  89.0M      0 --:--:--  0:00:53 --:--:-- 86.4M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  91.1M      0 --:--:--  0:00:52 --:--:-- 90.6M
