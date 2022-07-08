From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for
 enforced allocations
Date: Thu, 7 Jul 2022 20:18:52 -0700
Message-ID: <YseiHOgqLapJPiyC@castle>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
 <CALvZod7TGhWtcRD6HeEx90T2+Rod-yamq9i+WbEQUKwNFTi-1A@mail.gmail.com>
 <YsBmoqEBCa7ra7w2@castle>
 <YsMCMveSdiYX/2eH@dhcp22.suse.cz>
 <YsSj6rZmUkR8amT2@castle>
 <CALOAHbAb9DT6ihyxTm-4FCUiqiAzRSUHJw9erc+JTKVT9p8tow@mail.gmail.com>
 <YsUBQsTjVuXvt1Wr@castle>
 <CALOAHbDjRzySCHeMVHtVDe=Ji+qh=n0pT4CwiAM5Pahi2-QNCQ@mail.gmail.com>
 <YsUH7pgBVnWSkC1q@castle>
 <CAADnVQ+qqeAVvtDYox4xj85Qxt79EV1Hn+HDEMuzHrwZv14X4Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657250338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZzXf77ZnSEJIjuevx+EB4GpaxQjdHtz9/POLfph/nBE=;
        b=Qy4O0B3TXJnXaPohoJlWl3VViPm/HiAjQYjCu92SV5MLaTSvFAV+asc6HCYkyU8p29uqsK
        PkUyYZY6tI8B3J1zEbsMAdtKcYG8wSnd5IjAKW9MMeB6HBjelCfaH6lEOd/IoUOOQGqtdu
        qmer4OS87yqwZODPooty6DN/RPX+W9E=
Content-Disposition: inline
In-Reply-To: <CAADnVQ+qqeAVvtDYox4xj85Qxt79EV1Hn+HDEMuzHrwZv14X4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 07, 2022 at 03:41:11PM -0700, Alexei Starovoitov wrote:
> On Tue, Jul 5, 2022 at 9:24 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > Anyway, here is the patch for reparenting bpf maps:
> > https://github.com/rgushchin/linux/commit/f57df8bb35770507a4624fe52216b6c14f39c50c
> >
> > I gonna post it to bpf@ after some testing.
> 
> Please do. It looks good.
> It needs #ifdef CONFIG_MEMCG_KMEM
> because get_obj_cgroup_from_current() is undefined otherwise.
> Ideally just adding a static inline to a .h ?

Actually all call sites are already under CONFIG_MEMCG_KMEM.

> 
> and
> if (map->objcg)
>    memcg = get_mem_cgroup_from_objcg(map->objcg);
> 
> or !NULL check inside get_mem_cgroup_from_objcg()
> which would be better.

Yes, you're right, as now we need to handle it specially.

In the near future it won't be necessary. There are patches in
mm-unstable which make objcg API useful outside of CONFIG_MEMCG_KMEM.
In particular it means that objcg will be created for the root_mem_cgroup.
So map->objcg can always point at a valid objcg and we will be able
to drop this check.

Will post an updated version shortly.

Thanks!
