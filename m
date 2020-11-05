From: =?GBK?B?y9W71A==?= <sh_def-9Onoh4P/yGk@public.gmane.org>
Subject: Re:Re: [PATCH] mm/memcontrol: replace '== root_mem_cgroup' with
 mem_cgroup_is_root
Date: Thu, 5 Nov 2020 10:45:20 +0800 (CST)
Message-ID: <4c956479.1572.175964b555a.Coremail.sh_def@163.com>
References: <20201104151457.GA108301@rlk>
 <20201104224622.GE1938922@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=MbJ4j
        SQ9NcxDw1MYdK9VeZXzTkW8dChBtbcdzOJbkoo=; b=B/lY2RsBObmpA0rifnVkS
        F4At5Hxb74vF421+tb0guw7QBMQ25I/2lL8V6+3ZAN6cdfBui/jKlxcXrttlP//x
        n+YgK1VUq9bNqMqu4giMY3wHaTXR1b+P4jVtXsXh1wDtHUvKBGPpZ8EDoz909Icn
        3H5OX4GiVq70Vr80NDNkdE=
In-Reply-To: <20201104224622.GE1938922-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

CkF0IDIwMjAtMTEtMDUgMDY6NDY6MjIsICJSb21hbiBHdXNoY2hpbiIgPGd1cm9AZmIuY29tPiB3
cm90ZToKPk9uIFdlZCwgTm92IDA0LCAyMDIwIGF0IDExOjE0OjU3UE0gKzA4MDAsIEh1aSBTdSB3
cm90ZToKPj4gV2UgaGF2ZSBzdXBwbGllZCB0aGUgaW5saW5lIGZ1bmM6IG1lbV9jZ3JvdXBfaXNf
cm9vdCgpLgo+PiBTbyB3ZSBtYXkgdXNlIG1lbV9jZ3JvdXBfaXNfcm9vdCgpIGluc3RlYWQgb2Yg
dXNpbmcKPj4gJ21lbWNnID09IHJvb3RfbWVtX2Nncm91cCcgb3IgJ21lbWNnICE9IHJvb3RfbWVt
X2Nncm91cCcKPj4gZGlyZWN0bHksIHdoaWNoIGlzIG1vcmUgcmVhZGFibGUuCj4KPk1vc3Qgb2Yg
dGhlc2UgY29tcGFyaXNvbnMgd2lsbCBnbyBhd2F5IHNvb246Cj5odHRwczovL2xrbWwub3JnL2xr
bWwvMjAyMC8xMC8yMS82MTIgKHRoaXMgaXMKPmFuIHJmYyB2ZXJzaW9uLCBJJ2xsIHNlbmQgYW4g
dXBkYXRlZCB2ZXJzaW9uIHNvb24pLgo+Cj5UaGFua3MhCgpZZWFoLCB0aGFua3MuCgpQbGVhc2Ug
aWdub3JlIHRoaXMgY2hhbmdlLgo=
