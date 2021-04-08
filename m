From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: memcg: performance degradation since v5.9
Date: Thu, 8 Apr 2021 13:53:47 -0700
Message-ID: <YG9tW1h9VSJcir+Y@carbon.dhcp.thefacebook.com>
References: <20210408193948.vfktg3azh2wrt56t@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=7ChLymD/Rx15uAsFPHgBsDg9sElJvaFBelRs9fpbN8U=;
 b=Q2yvZd+teypOYJAZRlO4YFUJIhfihJV9XqvN0uoM3bnfZca7Iy1InWIWGb10Febdhppk
 F+F1gp3acdeWKR1yorOcXG7aMQ0LLosi/Ll/MEQq2A9tvqZgizLpTXiXDD+zu9mKKu+1
 VyUyQm3Jde34VFS+mHi3Lfdab0GQyi1YTh8= 
Content-Disposition: inline
In-Reply-To: <20210408193948.vfktg3azh2wrt56t@gabell>
List-ID: <cgroups.vger.kernel.org>
To: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 08, 2021 at 03:39:48PM -0400, Masayoshi Mizuma wrote:
> Hello,
>=20
> I detected a performance degradation issue for a benchmark of PostgresSQL=
 [1],
> and the issue seems to be related to object level memory cgroup [2].
> I would appreciate it if you could give me some ideas to solve it.
>=20
> The benchmark shows the transaction per second (tps) and the tps for v5.9
> and later kernel get about 10%-20% smaller than v5.8.
>=20
> The benchmark does sendto() and recvfrom() system calls repeatedly,
> and the duration of the system calls get longer than v5.8.
> The result of perf trace of the benchmark is as follows:
>=20
> =A0 - v5.8
>=20
>    syscall            calls  errors  total       min       avg       max =
      stddev
>                                      (msec)    (msec)    (msec)    (msec)=
        (%)
>    --------------- --------  ------ -------- --------- --------- --------=
-     ------
>    sendto            699574      0  2595.220     0.001     0.004     0.46=
2      0.03%
>    recvfrom         1391089 694427  2163.458     0.001     0.002     0.44=
2      0.04%
>=20
> =A0 - v5.9
>=20
>    syscall            calls  errors  total       min       avg       max =
      stddev
>                                      (msec)    (msec)    (msec)    (msec)=
        (%)
>    --------------- --------  ------ -------- --------- --------- --------=
-     ------
>    sendto            699187      0  3316.948     0.002     0.005     0.04=
4      0.02%
>    recvfrom         1397042 698828  2464.995     0.001     0.002     0.02=
5      0.04%
>=20
> =A0 - v5.12-rc6
>=20
>    syscall            calls  errors  total       min       avg       max =
      stddev
>                                      (msec)    (msec)    (msec)    (msec)=
        (%)
>    --------------- --------  ------ -------- --------- --------- --------=
-     ------
>    sendto            699445      0  3015.642     0.002     0.004     0.02=
7      0.02%
>    recvfrom         1395929 697909  2338.783     0.001     0.002     0.02=
4      0.03%
>=20
> I bisected the kernel patches, then I found the patch series, which add
> object level memory cgroup support, causes the degradation.
>=20
> I confirmed the delay with a kernel module which just runs
> kmem_cache_alloc/kmem_cache_free as follows. The duration is about
> 2-3 times than v5.8.
>=20
>    dummy_cache =3D KMEM_CACHE(dummy, SLAB_ACCOUNT);
>    for (i =3D 0; i < 100000000; i++)
>    {
>            p =3D kmem_cache_alloc(dummy_cache, GFP_KERNEL);
>            kmem_cache_free(dummy_cache, p);
>    }
>=20
> It seems that the object accounting work in slab_pre_alloc_hook() and
> slab_post_alloc_hook() is the overhead.
>=20
> cgroup.nokmem kernel parameter doesn't work for my case because it disabl=
es
> all of kmem accounting.
>=20
> The degradation is gone when I apply a patch (at the bottom of this email)
> that adds a kernel parameter that expects to fallback to the page level
> accounting, however, I'm not sure it's a good approach though...

Hello Masayoshi!

Thank you for the report!

It's not a secret that per-object accounting is more expensive than a per-p=
age
allocation. I had micro-benchmark results similar to yours: accounted
allocations are about 2x slower. But in general it tends to not affect real
workloads, because the cost of allocations is still low and tends to be only
a small fraction of the whole cpu load. And because it brings up significant
benefits: 40%+ slab memory savings, less fragmentation, more stable working=
set,
etc, real workloads tend to perform on pair or better.

So my first question is if you see the regression in any real workload
or it's only about the benchmark?

Second, I'll try to take a look into the benchmark to figure out why it's
affected so badly, but I'm not sure we can easily fix it. If you have any
ideas what kind of objects the benchmark is allocating in big numbers,
please let me know.

Thanks!
