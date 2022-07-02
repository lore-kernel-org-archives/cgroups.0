From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations
Date: Fri, 1 Jul 2022 22:50:40 -0700
Message-ID: <CALvZod7TGhWtcRD6HeEx90T2+Rod-yamq9i+WbEQUKwNFTi-1A@mail.gmail.com>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8qtzQsHSUiJ4njxuFZSHmk7WzYx/9S8h0IgnGcSJp0Q=;
        b=XbpRXQnjxt6+EHcIDifmMhgCz9P8NjZYvPJBAcZpS+YAbhdr4Mf7ucGl3K9kDWb3Sk
         +omwUSF8e7r/y9zsWXeYQTGko6DwIp1zn8qlu0/b97RKhhQur2P7I6eOomkFo2PU1ALH
         hgR0bVsN0kiKxy8apJ780YH98SbKF0ZRzjbv68R9DXzZ8zDo3WWIaeYNFgNMUcwHJtm3
         NA2FDZizt58+qGaSs1wCCGy6jERhpsILnicGek6cuTJ4TWYSyapTs3JoLWOCGZTy6FS0
         aAtJWrvejyeFPvDiCh/SKTO4KRN+neIA605mh/Dpcy9lOJCa++OhJPONojzpSN0nzgZD
         6ydg==
In-Reply-To: <20220702033521.64630-1-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jul 1, 2022 at 8:35 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> Yafang Shao reported an issue related to the accounting of bpf
> memory: if a bpf map is charged indirectly for memory consumed
> from an interrupt context and allocations are enforced, MEMCG_MAX
> events are not raised.
>
> It's not/less of an issue in a generic case because consequent
> allocations from a process context will trigger the reclaim and
> MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
> memory cgroup, so it might never happen.

The patch looks good but the above sentence is confusing. What might
never happen? Reclaim or MAX event on dying memcg?

> So the cgroup can
> significantly exceed the memory.max limit without even triggering
> MEMCG_MAX events.
>
> Fix this by making sure that we never enforce allocations without
> raising a MEMCG_MAX event.
>
> Reported-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 655c09393ad5..eb383695659a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2577,6 +2577,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>         bool passed_oom = false;
>         bool may_swap = true;
>         bool drained = false;
> +       bool raised_max_event = false;
>         unsigned long pflags;
>
>  retry:
> @@ -2616,6 +2617,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>                 goto nomem;
>
>         memcg_memory_event(mem_over_limit, MEMCG_MAX);
> +       raised_max_event = true;
>
>         psi_memstall_enter(&pflags);
>         nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> @@ -2682,6 +2684,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>         if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
>                 return -ENOMEM;
>  force:
> +       /*
> +        * If the allocation has to be enforced, don't forget to raise
> +        * a MEMCG_MAX event.
> +        */
> +       if (!raised_max_event)
> +               memcg_memory_event(mem_over_limit, MEMCG_MAX);
> +
>         /*
>          * The allocation either can't fail or will lead to more memory
>          * being freed very soon.  Allow memory usage go over the limit
> --
> 2.36.1
>
