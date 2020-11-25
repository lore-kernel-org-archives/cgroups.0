From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: Regression from 5.7.17 to 5.9.9 with memory.low cgroup
 constraints
Date: Wed, 25 Nov 2020 10:21:03 -0800
Message-ID: <20201125182103.GA840171@carbon.dhcp.thefacebook.com>
References: <20201125123956.61d9e16a@hemera>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=I+DChthk9EiQffLmkW7CdZyX3w3ZthaRkxF45MUhAUU=;
 b=RSrHna0YSIa1WqX05smVN7dzqhNmogshqVt908LV95Sbi7NTtdHkjv+fpw1dDAWE1VCv
 3PuCIukl4ovtDk5KUPtA+rsmHwoUJWMW7v5Dcb/l8aMhH9q1AoyOk/tU5K80bhYFLwo4
 XopIxuwtv9LQkpX4O9h0Y4yEOqJdDKIDj40= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eC0XA7PRBvXNoDxjpsoS98lL59qwkgWsvaA77URoGYA=;
 b=JKdtFgG0d3tjmWOcNo4FMKYpVtOGkVujcJT0iyNT2g/BcuNOw5EhHp4i6vAQjCNEKkrIZyLmm1udBeFc3/p5aWKOVjUYWIek/4ORK2xK8Y7xLRaCc4UtKnuMY/hq8GEVMmj92/CCJr79CixAhIqtAA4qplb4k74bkibrRLQO7j0=
Content-Disposition: inline
In-Reply-To: <20201125123956.61d9e16a@hemera>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Nov 25, 2020 at 12:39:56PM +0100, Bruno Pr=E9mont wrote:
> Hello,
>=20
> On a production system I've encountered a rather harsh behavior from
> kernel in the context of memory cgroup (v2) after updating kernel from
> 5.7 series to 5.9 series.
>=20
>=20
> It seems like kernel is reclaiming file cache but leaving inode cache
> (reclaimable slabs) alone in a way that the server ends up trashing and
> maxing out on IO to one of its disks instead of doing actual work.
>=20
>=20
> My setup, server has 64G of RAM:
>   root
>    + system        { min=3D0, low=3D128M, high=3D8G, max=3D8G }
>      + base        { no specific constraints }
>      + backup      { min=3D0, low=3D32M, high=3D2G, max=3D2G }
>      + shell       { no specific constraints }
>   + websrv         { min=3D0, low=3D4G, high=3D32G, max=3D32G }
>   + website        { min=3D0, low=3D16G, high=3D40T, max=3D40T }
>     + website1     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
>     + website2     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
>       ...
>   + remote         { min=3D0, low=3D1G, high=3D14G, max=3D14G }
>     + webuser1     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
>     + webuser2     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
>       ...
>=20
>=20
> When the server was struggling I've had mostly IO on disk hosting
> system processes and some cache files of websrv processes.
> It seems that running backup does make the issue much more probable.
>=20
> The processes in websrv are the most impacted by the trashing and this
> is the one with lots of disk cache and inode cache assigned to it.
> (note a helper running in websrv cgroup scan whole file system
> hierarchy once per hour and this keeps inode cache pretty filled.
> Dropping just file cache (about 10G) did not unlock situation but
> dropping reclaimable slabs (inode cache, about 30G) got the system back
> running.
>=20
>=20
>=20
> Some metrics I have collected during a trashing period (metrics
> collected at about 5min interval) - I don't have ful memory.stat
> unfortunately:
>=20
> system/memory.min              0              =3D 0
> system/memory.low              134217728      =3D 134217728
> system/memory.high             8589934592     =3D 8589934592
> system/memory.max              8589934592     =3D 8589934592
> system/memory.pressure
>     some avg10=3D54.41 avg60=3D59.28 avg300=3D69.46 total=3D7347640237
>     full avg10=3D27.45 avg60=3D22.19 avg300=3D29.28 total=3D3287847481
>   ->
>     some avg10=3D77.25 avg60=3D73.24 avg300=3D69.63 total=3D7619662740
>     full avg10=3D23.04 avg60=3D25.26 avg300=3D27.97 total=3D3401421903
> system/memory.current          262533120      < 263929856
> system/memory.events.local
>     low                        5399469        =3D 5399469
>     high                       0              =3D 0
>     max                        112303         =3D 112303
>     oom                        0              =3D 0
>     oom_kill                   0              =3D 0
>=20
> system/base/memory.min         0              =3D 0
> system/base/memory.low         0              =3D 0
> system/base/memory.high        max            =3D max
> system/base/memory.max         max            =3D max
> system/base/memory.pressure
>     some avg10=3D18.89 avg60=3D20.34 avg300=3D24.95 total=3D5156816349
>     full avg10=3D10.90 avg60=3D8.50 avg300=3D11.68 total=3D2253916169
>   ->
>     some avg10=3D33.82 avg60=3D32.26 avg300=3D26.95 total=3D5258381824
>     full avg10=3D12.51 avg60=3D13.01 avg300=3D12.05 total=3D2301375471
> system/base/memory.current     31363072       < 32243712
> system/base/memory.events.local
>     low                        0              =3D 0
>     high                       0              =3D 0
>     max                        0              =3D 0
>     oom                        0              =3D 0
>     oom_kill                   0              =3D 0
>=20
> system/backup/memory.min       0              =3D 0
> system/backup/memory.low       33554432       =3D 33554432
> system/backup/memory.high      2147483648     =3D 2147483648
> system/backup/memory.max       2147483648     =3D 2147483648
> system/backup/memory.pressure
>     some avg10=3D41.73 avg60=3D45.97 avg300=3D56.27 total=3D3385780085
>     full avg10=3D21.78 avg60=3D18.15 avg300=3D25.35 total=3D1571263731
>   ->
>     some avg10=3D60.27 avg60=3D55.44 avg300=3D54.37 total=3D3599850643
>     full avg10=3D19.52 avg60=3D20.91 avg300=3D23.58 total=3D1667430954
> system/backup/memory.current  222130176       < 222543872
> system/backup/memory.events.local
>     low                       5446            =3D 5446
>     high                      0               =3D 0
>     max                       0               =3D 0
>     oom                       0               =3D 0
>     oom_kill                  0               =3D 0
>=20
> system/shell/memory.min       0               =3D 0
> system/shell/memory.low       0               =3D 0
> system/shell/memory.high      max             =3D max
> system/shell/memory.max       max             =3D max
> system/shell/memory.pressure
>     some avg10=3D0.00 avg60=3D0.12 avg300=3D0.25 total=3D1348427661
>     full avg10=3D0.00 avg60=3D0.04 avg300=3D0.06 total=3D493582108
>   ->
>     some avg10=3D0.00 avg60=3D0.00 avg300=3D0.06 total=3D1348516773
>     full avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D493591500
> system/shell/memory.current  8814592          < 8888320
> system/shell/memory.events.local
>     low                      0                =3D 0
>     high                     0                =3D 0
>     max                      0                =3D 0
>     oom                      0                =3D 0
>     oom_kill                 0                =3D 0
>=20
> website/memory.min           0                =3D 0
> website/memory.low           17179869184      =3D 17179869184
> website/memory.high          45131717672960   =3D 45131717672960
> website/memory.max           45131717672960   =3D 45131717672960
> website/memory.pressure
>     some avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D415009408
>     full avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D201868483
>   ->
>     some avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D415009408
>     full avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D201868483
> website/memory.current       11811520512      > 11456942080
> website/memory.events.local
>     low                      11372142         < 11377350
>     high                     0                =3D 0
>     max                      0                =3D 0
>     oom                      0                =3D 0
>     oom_kill                 0                =3D 0
>=20
> remote/memory.min            0
> remote/memory.low            1073741824
> remote/memory.high           15032385536
> remote/memory.max            15032385536
> remote/memory.pressure
>     some avg10=3D0.00 avg60=3D0.25 avg300=3D0.50 total=3D2017364408
>     full avg10=3D0.00 avg60=3D0.00 avg300=3D0.01 total=3D738071296
>   ->
> remote/memory.current        84439040         > 81797120
> remote/memory.events.local
>     low                      11372142         < 11377350
>     high                     0                =3D 0
>     max                      0                =3D 0
>     oom                      0                =3D 0
>     oom_kill                 0                =3D 0
>=20
> websrv/memory.min            0                =3D 0
> websrv/memory.low            4294967296       =3D 4294967296
> websrv/memory.high           34359738368      =3D 34359738368
> websrv/memory.max            34426847232      =3D 34426847232
> websrv/memory.pressure
>     some avg10=3D40.38 avg60=3D62.58 avg300=3D68.83 total=3D7760096704
>     full avg10=3D7.80 avg60=3D10.78 avg300=3D12.64 total=3D2254679370
>   ->
>     some avg10=3D89.97 avg60=3D83.78 avg300=3D72.99 total=3D8040513640
>     full avg10=3D11.46 avg60=3D11.49 avg300=3D11.47 total=3D2300116237
> websrv/memory.current        18421673984      < 18421936128
> websrv/memory.events.local
>     low                      0                =3D 0
>     high                     0                =3D 0
>     max                      0                =3D 0
>     oom                      0                =3D 0
>     oom_kill                 0                =3D 0
>=20
>=20
>=20
> Is there something important I'm missing in my setup that could prevent
> things from starving?
>=20
> Did memory.low meaning change between 5.7 and 5.9? From behavior it
> feels as if inodes are not accounted to cgroup at all and kernel pushes
> cgroups down to their memory.low by killing file cache if there is not
> enough free memory to hold all promises (and not only when a cgroup
> tries to use up to its promised amount of memory).
> As system was trashing as much with 10G of file cache dropped
> (completely unused memory) as with it in use.
>=20
>=20
> I will try to create a test-case for it to reproduce it on a test
> machine an be able to verify a fix or eventually bisect to triggering
> patch though it this all rings a bell, please tell!
>=20
> Note until I have a test-case I'm reluctant to just wait [on
> production system] for next occurrence (usually at unpractical times) to
> gather some more metrics.

Hi Bruno!

Thank you for the report.

Can you, please, check if the following patch fixes the issue?

Thanks!

--

diff --git a/mm/slab.h b/mm/slab.h
index 6cc323f1313a..ef02b841bcd8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -290,7 +290,7 @@ static inline struct obj_cgroup *memcg_slab_pre_alloc_h=
ook(struct kmem_cache *s,
=20
        if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s))) {
                obj_cgroup_put(objcg);
-               return NULL;
+               return (struct obj_cgroup *)-1UL;
        }
=20
        return objcg;
@@ -501,9 +501,13 @@ static inline struct kmem_cache *slab_pre_alloc_hook(s=
truct kmem_cache *s,
                return NULL;
=20
        if (memcg_kmem_enabled() &&
-           ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
+           ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT))) {
                *objcgp =3D memcg_slab_pre_alloc_hook(s, size, flags);
=20
+               if (unlikely(*objcgp =3D=3D (struct obj_cgroup *)-1UL))
+                       return NULL;
+       }
+
        return s;
 }
=20
