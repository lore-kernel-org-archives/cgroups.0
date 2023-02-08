From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 8 Feb 2023 11:23:50 -0800
Message-ID: <Y+P2xp5BfmGh5Fin@P9FQF9L96D.corp.robot.car>
References: <Y9FzSBw10MGXm2TK@tpad>
 <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
 <Y9LDAZmApLeffrT8@tpad>
 <Y9LQ615H13RmG7wL@dhcp22.suse.cz>
 <0122005439ffb7895efda7a1a67992cbe41392fe.camel@redhat.com>
 <Y9j9BnMwfm4TJks7@tpad>
 <Y9pd7AxAILUSHrpe@dhcp22.suse.cz>
 <28e08669302ad1e7a41bdf8b9988de6a352b5fe1.camel@redhat.com>
 <Y+AIOQy0HdVXCw8m@P9FQF9L96D>
 <4b232f47e038ab6fcaa0114f73c28d4bf8799f84.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675884258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P/TREvcTU2ZKZKzZHmQjoKV0cBls9RA3p0pPuU4/Cfg=;
        b=dBHuAn91UmuMSd0dpLbfmhQmO74rioQZ9qO43NYOt/gaoWOf1GRawK2w6FVay9PPAa61eU
        dxkHEk2s1GDr66AjfQnDBwGLmkzTL8Hu6BrqxP6MCCIigV/hadn5L4CjnTwCg8urlcoYVa
        9usytnN742sp5xIxjPQIDIPFIm9NkTw=
Content-Disposition: inline
In-Reply-To: <4b232f47e038ab6fcaa0114f73c28d4bf8799f84.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 07, 2023 at 12:18:01AM -0300, Leonardo Br=E1s wrote:
> On Sun, 2023-02-05 at 11:49 -0800, Roman Gushchin wrote:
> > Hi Leonardo!
>=20
> Hello Roman,
> Thanks a lot for replying!
>=20
> >=20
> > > Yes, but we are exchanging an "always schedule_work_on()", which is a=
 kind of
> > > contention, for a "sometimes we hit spinlock contention".
> > >=20
> > > For the spinlock proposal, on the local cpu side, the *worst case* co=
ntention
> > > is:
> > > 1 - wait the spin_unlock() for a complete <percpu cache drain process=
>,
> > > 2 - wait a cache hit for local per-cpu cacheline=A0
> > >=20
> > > What is current implemented (schedule_work_on() approach), for the lo=
cal
> > > cpu=A0side there is *always* this contention:
> > > 1 - wait for a context switch,
> > > 2 - wait a cache hit from it's local per-cpu cacheline,
> > > 3 - wait a complete <percpu cache drain process>,=A0
> > > 4 - then for a new context switch to the current thread.
> >=20
> > I think both Michal and me are thinking of a more generic case in which=
 the cpu
> > is not exclusively consumed by 1 special process, so that the draining =
work can
> > be executed during an idle time. In this case the work is basically fre=
e.
>=20
> Oh, it makes sense.
> But in such scenarios, wouldn't the same happens to spinlocks?
>=20
> I mean, most of the contention with spinlocks only happens if the remote =
cpu is
> trying to drain the cache while the local cpu happens to be draining/char=
ging,
> which is quite rare due to how fast the local cpu operations are.
>=20
> Also, if the cpu has some idle time, using a little more on a possible sp=
inlock
> contention should not be a problem. Right?
>=20
> >=20
> > And the introduction of a spin_lock() on the hot path is what we're are=
 concerned
> > about. I agree, that on some hardware platforms it won't be that expens=
ive,=A0
> >=20
>=20
> IIRC most hardware platforms with multicore supported by the kernel shoul=
d have
> the same behavior, since it's better to rely on cache coherence than lock=
ing the
> memory bus.
>=20
> For instance, the other popular architectures supported by Linux use the =
LR/SC
> strategy for atomic operations (tested on ARM, POWER, RISCV) and IIRC the
> LoadReserve slow part waits for the cacheline exclusivity, which is alrea=
dy
> already exclusive in this perCPU structure.
>=20
>=20
> > but in general not having any spinlocks is so much better.
>=20
> I agree that spinlocks may bring contention, which is not ideal in many c=
ases.
> In this case, though, it may not be a big issue, due to very rare remote =
access
> in the structure, for the usual case (non-pre-OOMCG)

Hi Leonardo!

I made a very simple test: replaced pcp local_lock with a spinlock and ran
a very simple kernel memory accounting benchmark (attached below) on
my desktop pc (Intel Core i9-7940X).

Original (3 attempts):
81341 us
80973 us
81258 us

Patched (3 attempts):
99918 us
100220 us
100291 us

This is without any contention and without CONFIG_LOCKDEP.

Thanks!

--

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 49f67176a1a2..bafd3cde4507 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6563,6 +6563,37 @@ static int memory_stat_show(struct seq_file *m, void=
 *v)
        return 0;
 }

+static int memory_alloc_test(struct seq_file *m, void *v)
+{
+       unsigned long i, j;
+       void **ptrs;
+       ktime_t start, end;
+       s64 delta, min_delta =3D LLONG_MAX;
+
+       ptrs =3D kvmalloc(sizeof(void *) * 1024 * 1024, GFP_KERNEL);
+       if (!ptrs)
+               return -ENOMEM;
+
+       for (j =3D 0; j < 100; j++) {
+               start =3D ktime_get();
+               for (i =3D 0; i < 1024 * 1024; i++)
+                       ptrs[i] =3D kmalloc(8, GFP_KERNEL_ACCOUNT);
+               end =3D ktime_get();
+
+               delta =3D ktime_us_delta(end, start);
+               if (delta < min_delta)
+                       min_delta =3D delta;
+
+               for (i =3D 0; i < 1024 * 1024; i++)
+                       kfree(ptrs[i]);
+       }
+
+       kvfree(ptrs);
+       seq_printf(m, "%lld us\n", min_delta);
+
+       return 0;
+}
+
 #ifdef CONFIG_NUMA
 static inline unsigned long lruvec_page_state_output(struct lruvec *lruvec,
                                                     int item)
@@ -6758,6 +6789,10 @@ static struct cftype memory_files[] =3D {
                .name =3D "stat",
                .seq_show =3D memory_stat_show,
        },
+       {
+               .name =3D "test",
+               .seq_show =3D memory_alloc_test,
+       },
 #ifdef CONFIG_NUMA
        {
                .name =3D "numa_stat",
