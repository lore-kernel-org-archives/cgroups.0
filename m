From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v2 4/4] mm/slub: Fix sysfs shrink circular locking dependency
Date: Mon, 27 Apr 2020 20:13:35 -0400
Message-ID: <55509F31-A503-4148-B209-B4D062AD0ED7@lca.pw>
References: <20200427235621.7823-5-longman@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=T8w1cAu62fq3Z/o1KAR+sWAmzB/rXmhhrpuLQFBAE2o=;
        b=F6JtusMLTinzcqcUGMiUbaV2UdtlgxhuL6LAGXkeTZHk+Pr449mf/NN+OXQurRixTB
         q4taVk1n0AyKdsw8fkHxyPWrHStJ44B9LkpKzmEXsYSFT5xBk4bxXdYS/tmiiaAN077Y
         3sGnQt+B20IiZIqcvCmYTOWkrh/zocQxGAH3tQeeyd86oBSPbGIAYupBvOX1dsqmYWt1
         v8dSIy15SqYvOQ9owwKsiH3P2mH/omX7QeNRAfTuf2LVpiVaGHGw6acfvDTAWsxnOLuD
         La9kc2JCwHNei5DoPqEuqHjYb/VS7FQUmOlfJ7GOS3tUAUQy946ci3hYJLFuFB+Rlb4B
         rntQ==
In-Reply-To: <20200427235621.7823-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



> On Apr 27, 2020, at 7:56 PM, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> A lockdep splat is observed by echoing "1" to the shrink sysfs file
> and then shutting down the system:
>=20
> [  167.473392] Chain exists of:
> [  167.473392]   kn->count#279 --> mem_hotplug_lock.rw_sem --> slab_mutex
> [  167.473392]
> [  167.484323]  Possible unsafe locking scenario:
> [  167.484323]
> [  167.490273]        CPU0                    CPU1
> [  167.494825]        ----                    ----
> [  167.499376]   lock(slab_mutex);
> [  167.502530]                                lock(mem_hotplug_lock.rw_sem=
);
> [  167.509356]                                lock(slab_mutex);
> [  167.515044]   lock(kn->count#279);
> [  167.518462]
> [  167.518462]  *** DEADLOCK ***
>=20
> It is because of the get_online_cpus() and get_online_mems() calls in
> kmem_cache_shrink() invoked via the shrink sysfs file. To fix that, we
> have to use trylock to get the memory and cpu hotplug read locks. Since
> hotplug events are rare, it should be fine to refuse a kmem caches
> shrink operation when some hotplug events are in progress.

I don=E2=80=99t understand how trylock could prevent a splat. The fundamenta=
l issue is that in sysfs slab store case, the locking order (once trylock su=
cceed) is,

kn->count =E2=80=94> cpu/memory_hotplug

But we have the existing reverse chain everywhere.

cpu/memory_hotplug =E2=80=94> slab_mutex =E2=80=94> kn->count


