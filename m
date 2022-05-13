From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Fri, 13 May 2022 10:23:36 -0700
Message-ID: <CALvZod6kBZZFfD6Y5p_=9TMJr8P-vU_77NTq048wGUDr0wTv0Q@mail.gmail.com>
References: <20220510152847.230957-1-hannes@cmpxchg.org> <20220510152847.230957-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUiCnPMeV2tewEXDSR1Opfl8CW/W1nTXt/fBcyuE7po=;
        b=hcbrT8LB9KtUyOFhJcjNGDoACadQCvR45e8T6zhTyidWst7gm9QCPlPUMus2qyKZO5
         F5DqklOOcurOuJJoDyNyaahuz9kll92/JgnSl7AlqgPH+K3Sn2fBXIsuvf7m/+R6yAVS
         fsGK3TwUuxHbSqM+peiMHJozwxnh0TRDv3ZGQTeyAIlOMdMVBvwteTZ4PytPmR9t47Gg
         pqGrxwTsmpv7IbPbGbuf/rmrhjr8qRe8wpa4F75swNWUD2SfEYFj+qQV2DV/gexKRIvo
         8snEpImCqQT57ffaUneyHTR7IkLcLcdzbaRzu3MoseaxEL7zq3AKDZum93Mv0C+hXL9+
         x1Jw==
In-Reply-To: <20220510152847.230957-7-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, May 10, 2022 at 8:29 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
[...]
> +void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
> +{
> +       struct mem_cgroup *memcg;
> +
> +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> +
> +       /* PF_MEMALLOC context, charging must succeed */
)
Instead of these warnings and comment why not just explicitly use
memalloc_noreclaim_[save|restore]() ?

> +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))

Can we please make this specific charging an opt-in feature or at
least provide a way to opt-out? This will impact users/providers where
swap is used transparently (in terms of memory usage). Also do you
want this change for v1 users as well?

> +               VM_WARN_ON_ONCE(1);
> +
> +       rcu_read_lock();
> +       memcg = obj_cgroup_memcg(objcg);
> +       mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> +       rcu_read_unlock();
> +}
> +
