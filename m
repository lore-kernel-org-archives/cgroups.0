From: Yu Zhao <yuzhao@google.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Wed, 23 Nov 2022 18:29:01 -0700
Message-ID: <CAOUHufZyE6Qo-FWvDjYQrwYg1KaT=+5Khy_ji8tTN2iAMyd52w@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
 <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
 <Y31s/K8T85jh05wH@google.com> <Y36PF972kOK3ADvx@cmpxchg.org> <CAOUHufZxguv_m3Td7e5Qt-yKpV7rmWyv_m_UFS9n19K=_=xLcA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1fnmRHuC0+yQgv2N5cDHL0+8S+SApOU5affk2tW+8RI=;
        b=Kg9dxVbpFy1QGNmYu5mluAC8FbOjsrd3VGHz1Xw1eB5JmUlXd6/vUX/f7Qs1GsceQe
         qiq3HKOvJZI8CDuBNcKBINx39Al3fBX1zpv9msgyA3teFqVsAFQxOTTcTqg4uqLbvxZ0
         32UGeSBr60jeh2LOtbBGYzq3JagtcNWKe/sjGoknfXZSKKMLgCzLiVv/aJbuXUcFn8lj
         iqNEq5UM7Aeq7rIkXiEQfuEvM9nI+3PLMOSSu0jAIYd73ZJZ+uQlQy22barLFPkaxvNS
         Ub33Y1CcHtEvh2PWQ+78FLe/QueLpwlNUklpmhKyMYSNAaUkTJhVQ5iP+Caew6oIihbo
         gMmQ==
In-Reply-To: <CAOUHufZxguv_m3Td7e5Qt-yKpV7rmWyv_m_UFS9n19K=_=xLcA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Ivan Babrou <ivan@cloudflare.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Wed, Nov 23, 2022 at 6:18 PM Yu Zhao <yuzhao@google.com> wrote:
>
> On Wed, Nov 23, 2022 at 2:22 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Tue, Nov 22, 2022 at 05:44:44PM -0700, Yu Zhao wrote:
> > > Hi Johannes,
> > >
> > > Do you think it makes sense to have the below for both the baseline and
> > > MGLRU or it's some behavior change that the baseline doesn't want to
> > > risk?
> >
> > It looks good to me. Besides the new FMODE_NOREUSE, it's also a nice
> > cleanup on the rmap side!
> >
> > It would just be good to keep the comment from folio_referenced_one() and
> > move it to the vma_has_locality() check in invalid_folio_referenced_vma().
> >
> > Otherwise,
> >
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> Thanks.
>
> I've added Ivan's test case to my collection. Interestingly, after
> this patch, the download speed increased while fio was running (my
> guess is that fio pushed more cold anon into swap):
>
> $ uname
> Linux test127 6.1.0-rc6-dirty #2 SMP PREEMPT_DYNAMIC Wed Nov 23
> 16:51:20 MST 2022 x86_64 x86_64 x86_64 GNU/Linux

This is the baseline kernel, not MGLRU.

> $ go version
> go version go1.18.1 linux/amd64
>
> $ fio -v
> fio-3.28
>
> $ curl --version
> curl 7.81.0 (x86_64-pc-linux-gnu) libcurl/7.81.0 OpenSSL/3.0.2
> zlib/1.2.11 brotli/1.0.9 zstd/1.4.8 libidn2/2.3.2 libpsl/0.21.0
> (+libidn2/2.3.2) libssh/0.9.6/openssl/zlib nghttp2/1.43.0 librtmp/2.3
> OpenLDAP/2.5.13
> Release-Date: 2022-01-05
> Protocols: dict file ftp ftps gopher gophers http https imap imaps
> ldap ldaps mqtt pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps
> telnet tftp
> Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN
> IPv6 Kerberos Largefile libz NTLM NTLM_WB PSL SPNEGO SSL TLS-SRP
> UnixSockets zstd
>
> fio NOT running:
>
>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  83.6M      0 --:--:--  0:00:57 --:--:-- 87.0M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  82.8M      0 --:--:--  0:00:57 --:--:-- 79.1M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  82.7M      0 --:--:--  0:00:57 --:--:-- 89.7M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  87.4M      0 --:--:--  0:00:54 --:--:-- 94.3M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  88.1M      0 --:--:--  0:00:54 --:--:-- 94.7M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  82.6M      0 --:--:--  0:00:57 --:--:-- 83.9M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  86.4M      0 --:--:--  0:00:55 --:--:-- 90.1M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  82.8M      0 --:--:--  0:00:57 --:--:-- 67.5M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  83.4M      0 --:--:--  0:00:57 --:--:-- 78.7M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  84.0M      0 --:--:--  0:00:56 --:--:-- 87.4M
>
>
> fio running:
>
>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  86.7M      0 --:--:--  0:01:11 --:--:-- 88.7M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  87.7M      0 --:--:--  0:00:54 --:--:-- 93.5M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  88.5M      0 --:--:--  0:00:53 --:--:-- 95.1M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  91.6M      0 --:--:--  0:00:52 --:--:-- 94.4M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  89.4M      0 --:--:--  0:00:53 --:--:-- 86.6M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  88.6M      0 --:--:--  0:00:53 --:--:-- 84.8M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  84.6M      0 --:--:--  0:00:56 --:--:-- 87.5M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  86.9M      0 --:--:--  0:00:54 --:--:-- 81.4M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  89.0M      0 --:--:--  0:00:53 --:--:-- 86.4M
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                  Dload  Upload   Total   Spent    Left  Speed
> 100 4768M    0 4768M    0     0  91.1M      0 --:--:--  0:00:52 --:--:-- 90.6M
