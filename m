From: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg: yield cpu when we fail to charge pages
Date: Tue, 8 Sep 2020 13:31:51 -0700
Message-ID: <CAHbLzkqYrkA6=RSBpwEQJ5WaLUWwdP=05BPE2F4pRgk98NuVTg@mail.gmail.com>
References: <20200908201426.14837-1-jpitti@cisco.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0s348EPZ76opdRD/bPy7Rbwh7tSlsvQeVHt84ZwjP8=;
        b=LRKeA5oYb87EGM45Ap1miIQqlIeSijAGRkWs3y4OODay63a561ttieuA5tKjKoztai
         2G/7a30tV/htfcq5CRqGXNqp/q55zOIwocN+4OMl05zoi5hAo19lTpeAL1maw4fTbdDn
         9cQYDcRSxIGwtEStIYyOouUZnn9wlHzDDxFgvSfxMUl7eqDDU3jbCR4uMgIwwsypUHJA
         KKPbUWwRWK1n1pjIn+P7MK03hEuzm2a9mIiTByFVxUxFPuUY7jPLfZdS+Vpwjm06d33K
         Qz2fzk7wXgy0CU/xVGCo4vXis/5sgpqH0xXWQrkcrL2bSt8ueHjnz1CuT31bA0kaAw4x
         E8NQ==
In-Reply-To: <20200908201426.14837-1-jpitti-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julius Hemanth Pitti <jpitti-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xe-linux-external-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

On Tue, Sep 8, 2020 at 1:14 PM Julius Hemanth Pitti <jpitti-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>
> For non root CG, in try_charge(), we keep trying
> to charge until we succeed. On non-preemptive
> kernel, when we are OOM, this results in holding
> CPU forever.
>
> On SMP systems, this doesn't create a big problem
> because oom_reaper get a change to kill victim
> and make some free pages. However on a single-core
> CPU (or cases where oom_reaper pinned to same CPU
> where try_charge is executing), oom_reaper shall
> never get scheduled and we stay in try_charge forever.
>
> Steps to repo this on non-smp:
> 1. mount -t tmpfs none /sys/fs/cgroup
> 2. mkdir /sys/fs/cgroup/memory
> 3. mount -t cgroup none /sys/fs/cgroup/memory -o memory
> 4. mkdir /sys/fs/cgroup/memory/0
> 5. echo 40M > /sys/fs/cgroup/memory/0/memory.limit_in_bytes
> 6. echo $$ > /sys/fs/cgroup/memory/0/tasks
> 7. stress -m 5 --vm-bytes 10M --vm-hang 0

Isn't it the same problem solved by e3336cab2579 ("mm: memcg: fix
memcg reclaim soft lockup")? It has been in Linus's tree.

>
> Signed-off-by: Julius Hemanth Pitti <jpitti-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> ---
>
> Changes in v2:
>  - Added comments.
>  - Added "Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>".
> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cfa6cbad21d5..4f293bf8c7ed 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2745,6 +2745,15 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>         if (fatal_signal_pending(current))
>                 goto force;
>
> +       /*
> +        * We failed to charge even after retries, give oom_reaper or
> +        * other process a change to make some free pages.
> +        *
> +        * On non-preemptive, Non-SMP system, this is critical, else
> +        * we keep retrying with no success, forever.
> +        */
> +       cond_resched();
> +
>         /*
>          * keep retrying as long as the memcg oom killer is able to make
>          * a forward progress or bypass the charge if the oom killer
> --
> 2.17.1
>
>
