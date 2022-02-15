From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/4] memcg: synchronously enforce memory.high for large overcharges
Date: Tue, 15 Feb 2022 10:50:03 -0800
Message-ID: <CALvZod6Fpt6ofP=f63+qdv-hwKm8RekS2qtGHrKfoFb=PcRCPA@mail.gmail.com>
References: <20220211064917.2028469-1-shakeelb@google.com> <20220211064917.2028469-5-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Xnr8BvsNvJcUeAT+XTUM3XKtkq81lQw2/bkBVhK17c=;
        b=Sfe/kuKEpWEWZjVJDL2psXjG9oUfvqPlmdtCHVjzjva5Wf4hgOym+ssmVRUnZneaA2
         rEkXJ6PqgGUbzerluit/C1Y3RqEu1S5bYN/tNFSYc4A5kPeu9G3E82vvyMHH6f16rRsY
         y+OdypvtdIdQcjShE2Ydr+tNu8kR1mF0qx5XOsBDCXMb09E2+SV+WVbERkryp01EqPei
         0+5L0KO/aEa5PsYc4A+s/3lgkQDYrL7LcIUbxKDZxMJD+qr4LQbpfxisHlC99/g6Rd7E
         qvdfK8AZjD7qDatwPsLGEWXQtAWkFS+YwYoq/b26HhsMtTgjy6v3qudX31TKl19Ek6Fi
         fetw==
In-Reply-To: <20220211064917.2028469-5-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 10, 2022 at 10:49 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> The high limit is used to throttle the workload without invoking the
> oom-killer. Recently we tried to use the high limit to right size our
> internal workloads. More specifically dynamically adjusting the limits
> of the workload without letting the workload get oom-killed. However due
> to the limitation of the implementation of high limit enforcement, we
> observed the mechanism fails for some real workloads.
>
> The high limit is enforced on return-to-userspace i.e. the kernel let
> the usage goes over the limit and when the execution returns to
> userspace, the high reclaim is triggered and the process can get
> throttled as well. However this mechanism fails for workloads which do
> large allocations in a single kernel entry e.g. applications that
> mlock() a large chunk of memory in a single syscall. Such applications
> bypass the high limit and can trigger the oom-killer.
>
> To make high limit enforcement more robust, this patch makes the limit
> enforcement synchronous only if the accumulated overcharge becomes
> larger than MEMCG_CHARGE_BATCH. So, most of the allocations would still
> be throttled on the return-to-userspace path but only the extreme
> allocations which accumulates large amount of overcharge without
> returning to the userspace will be throttled synchronously. The value
> MEMCG_CHARGE_BATCH is a bit arbitrary but most of other places in the
> memcg codebase uses this constant therefore for now uses the same one.
>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Any comments or concerns on this patch? Otherwise I would ask Andrew
to add this series into the mm tree.

> ---
> Changes since v1:
> - Based on Roman's comment simply the sync enforcement and only target
>   the extreme cases.
>
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 292b0b99a2c7..0da4be4798e7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2703,6 +2703,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>                 }
>         } while ((memcg = parent_mem_cgroup(memcg)));
>
> +       if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> +           !(current->flags & PF_MEMALLOC) &&
> +           gfpflags_allow_blocking(gfp_mask)) {
> +               mem_cgroup_handle_over_high();
> +       }
>         return 0;
>  }
>
> --
> 2.35.1.265.g69c8d7142f-goog
>
