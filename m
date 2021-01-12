From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: prevent starvation when writing memory.high
Date: Tue, 12 Jan 2021 10:59:58 -0800
Message-ID: <CALvZod4VFA52dsdkW79-gUbiCf2ONfFJj6LkRU+3-fQpvYXL+A@mail.gmail.com>
References: <20210112163011.127833-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cY7LiOljtRpl7NP8koJL4MoVHQoaXBOmsr02Iq9gODY=;
        b=oS8itD4fagD9W0NDK8IL/kpF+AARyhuR4yh5nmMvhIUGA47rDp5coomF6EJpC62Dyw
         ToCn3gbqEFz6X1QbaUx5S/wUB4rwXFX3vIQLHosV8OKDpieZPjmIQFrlOot9id0T2ty3
         4eewXDIOfQ4y0CgYEJX/eHqHPQb2R2M1PU4iwsmW28SYKQTGiNSVZ9sMsdT68+7Pypmd
         K0vqQbdjwoua0+2ReyH6Wdu6+4Sl2BzxuQCtyf2H7rjiQy47dBC1majpefS2fz3Uq7mk
         bECOoYxXCtMKsol4oYi1r02vng0JwkyNbQNUqRuDsdNNLj+zirPpWCI/85QKmQyHEumQ
         KaPw==
In-Reply-To: <20210112163011.127833-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Jan 12, 2021 at 9:12 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> When a value is written to a cgroup's memory.high control file, the
> write() context first tries to reclaim the cgroup to size before
> putting the limit in place for the workload. Concurrent charges from
> the workload can keep such a write() looping in reclaim indefinitely.
>

Is this observed on real workload?

>
> In the past, a write to memory.high would first put the limit in place
> for the workload, then do targeted reclaim until the new limit has
> been met - similar to how we do it for memory.max. This wasn't prone
> to the described starvation issue. However, this sequence could cause
> excessive latencies in the workload, when allocating threads could be
> put into long penalty sleeps on the sudden memory.high overage created
> by the write(), before that had a chance to work it off.
>
> Now that memory_high_write() performs reclaim before enforcing the new
> limit, reflect that the cgroup may well fail to converge due to
> concurrent workload activity. Bail out of the loop after a few tries.
>
> Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.8+
> Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 605f671203ef..63a8d47c1cd3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6275,7 +6275,6 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>
>         for (;;) {
>                 unsigned long nr_pages = page_counter_read(&memcg->memory);
> -               unsigned long reclaimed;
>
>                 if (nr_pages <= high)
>                         break;
> @@ -6289,10 +6288,10 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>                         continue;
>                 }
>
> -               reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> -                                                        GFP_KERNEL, true);
> +               try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> +                                            GFP_KERNEL, true);
>
> -               if (!reclaimed && !nr_retries--)

Any particular reason to remove !reclaimed?

> +               if (!nr_retries--)
>                         break;
>         }
>
> --
> 2.30.0
>
