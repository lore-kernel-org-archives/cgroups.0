From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Fri, 1 May 2020 07:59:57 +0800
Message-ID: <CALOAHbBub_oojkb5DpXUoHV=-e9PDAeVzJvKvDtyk-9Jg6_Pkw@mail.gmail.com>
References: <cover.1588092152.git.chris@chrisdown.name> <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <20200429101510.GA28637@dhcp22.suse.cz> <20200429140330.GA5054@cmpxchg.org>
 <20200429150414.GI28637@dhcp22.suse.cz> <20200429165627.GA24768@cmpxchg.org> <20200430145721.GF12655@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mOWNIHM3btZ9j8NGTIPkfbXQJm50r4PKpoMQv4LKbCU=;
        b=TOA/ANfb70xaeNIZuwPe7XM6HwdhADVz6L1VFwi33HMb/y5M5WgGTtZpDZ8WlZjY+s
         xFY3SD+a5uwlNQCX0ZZ30liXUSeyUwQ4/PePP7Ta2QfGSPDRtU8sygsaBZbpQ/XD4US4
         gj99XYNqk93FaBc/yFpxyenl4NfN4hIhvPjMIgNN2tLL7WhxcWoYaOG6iC1w+kVfJ4Sh
         TWt9bMNxfD7/wzCIh5RzTmAHqnQua/zu9GmPI66+VnLZ56vD6wgxB92fHKLOlw3zA6NB
         XxrU2jcjVQS2AVlubjNuSb0wg9qgF/ANq+MixLoLAbQaEvrX0pCBj0f8Dvyi4Y4GWoEh
         S0xA==
In-Reply-To: <20200430145721.GF12655-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 30, 2020 at 10:57 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed 29-04-20 12:56:27, Johannes Weiner wrote:
> [...]
> > I think to address this, we need a more comprehensive solution and
> > introduce some form of serialization. I'm not sure yet how that would
> > look like yet.
>
> Yeah, that is what I've tried to express earlier and that is why I would
> rather go with an uglier workaround for now and think about a more
> robust effective values calculation on top.
>

Agreed.
If there's a more robust effective values calculation on top, then we
don't need to hack it here and there.

> > I'm still not sure it's worth having a somewhat ugly workaround in
> > mem_cgroup_protection() to protect against half of the bug. If you
> > think so, the full problem should at least be documented and marked
> > XXX or something.
>
> Yes, this makes sense to me. What about the following?

Many thanks for the explaination on this workaround.
With this explanation, I think the others will have a clear idea why
we must add this ugly workaround here.


> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1b4150ff64be..50ffbc17cdd8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -350,6 +350,42 @@ static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
>         if (mem_cgroup_disabled())
>                 return 0;
>
> +       /*
> +        * There is no reclaim protection applied to a targeted reclaim.
> +        * We are special casing this specific case here because
> +        * mem_cgroup_protected calculation is not robust enough to keep
> +        * the protection invariant for calculated effective values for
> +        * parallel reclaimers with different reclaim target. This is
> +        * especially a problem for tail memcgs (as they have pages on LRU)
> +        * which would want to have effective values 0 for targeted reclaim
> +        * but a different value for external reclaim.
> +        *
> +        * Example
> +        * Let's have global and A's reclaim in parallel:
> +        *  |
> +        *  A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
> +        *  |\
> +        *  | C (low = 1G, usage = 2.5G)
> +        *  B (low = 1G, usage = 0.5G)
> +        *
> +        * For the global reclaim
> +        * A.elow = A.low
> +        * B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
> +        * C.elow = min(C.usage, C.low)
> +        *
> +        * With the effective values resetting we have A reclaim
> +        * A.elow = 0
> +        * B.elow = B.low
> +        * C.elow = C.low
> +        *
> +        * If the global reclaim races with A's reclaim then
> +        * B.elow = C.elow = 0 because children_low_usage > A.elow)
> +        * is possible and reclaiming B would be violating the protection.
> +        *
> +        */
> +       if (memcg == root)
> +               return 0;
> +
>         if (in_low_reclaim)
>                 return READ_ONCE(memcg->memory.emin);
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 05b4ec2c6499..df88a22f09bc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6385,6 +6385,14 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>
>         if (!root)
>                 root = root_mem_cgroup;
> +
> +       /*
> +        * Effective values of the reclaim targets are ignored so they
> +        * can be stale. Have a look at mem_cgroup_protection for more
> +        * details.
> +        * TODO: calculation should be more robust so that we do not need
> +        * that special casing.
> +        */
>         if (memcg == root)
>                 return MEMCG_PROT_NONE;
>
>
> > In practice, I doubt this matters all that much because limit reclaim
> > and global reclaim tend to occur in complementary
> > containerization/isolation strategies, not heavily simultaneously.
>
> I would expect that as well but this is always hard to tell.
>
> --
> Michal Hocko
> SUSE Labs



-- 
Thanks
Yafang
