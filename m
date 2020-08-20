From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm/memcg: Unify swap and memsw page counters
Date: Thu, 20 Aug 2020 08:46:32 -0700
Message-ID: <CALvZod7cNkjgd_YWzPSFm=AeC8sy5kWspX3J_Q7237Q9+N5Pxw@mail.gmail.com>
References: <20200820130350.3211-1-longman@redhat.com> <20200820130350.3211-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J1RrYNr31NQi6xNHXP2IRc+NcviE0ZSrBQayM98jfLA=;
        b=B66nR30x++j+0C6TC7iGxqjyYlJdwDK1j7E7nieS/4aXdOCO0M8a/jFKAtiw85Q+nG
         ieb5GxU155DY0Dh3SvFGyBaBDNAb6JRuhPmIt7S+QiiKGe2bQTwVYBoA1fGVAU6okfSJ
         RRiTXS4u+PFueBC8wjb2zeohu0Ie7ja9DN+i3K16n3LUK6HEk0fMCd6dWblnnKyS2ei7
         3eQdvarbSACmkDn6nfAzjuUUh8yXU7o3Jcg+0En+/v7rM1MxUqbvc/RReMDdW9up1bHA
         LT7SQl4hEfm16MsHes5PHoJ2qRPzuijyk+uljFR0v7utOJtWG3CitkqEh2kSy7/awP0c
         a3kg==
In-Reply-To: <20200820130350.3211-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Aug 20, 2020 at 6:04 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> The swap page counter is v2 only while memsw is v1 only. As v1 and v2
> controllers cannot be active at the same time, there is no point to keep
> both swap and memsw page counters in mem_cgroup. The previous patch has
> made sure that memsw page counter is updated and accessed only when in
> v1 code paths. So it is now safe to alias the v1 memsw page counter to v2
> swap page counter. This saves 14 long's in the size of mem_cgroup. This
> is a saving of 112 bytes for 64-bit archs.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 3 +--
>  mm/memcontrol.c            | 8 +++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d0b036123c6a..d2a819d7db70 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -216,10 +216,9 @@ struct mem_cgroup {
>
>         /* Accounted resources */
>         struct page_counter memory;
> -       struct page_counter swap;
> +       struct page_counter swap;       /* memsw (memory+swap) for v1 */
>
>         /* Legacy consumer-oriented counters */
> -       struct page_counter memsw;
>         struct page_counter kmem;
>         struct page_counter tcpmem;
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d219dca5239f..04c3794cdc98 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -68,6 +68,11 @@
>
>  #include <trace/events/vmscan.h>
>
> +/*
> + * The v1 memsw page counter is aliased to the v2 swap page counter.
> + */
> +#define memsw  swap
> +

Personally I would prefer a union instead of #define.

>  struct cgroup_subsys memory_cgrp_subsys __read_mostly;
>  EXPORT_SYMBOL(memory_cgrp_subsys);
>
> @@ -5279,13 +5284,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>                 memcg->use_hierarchy = true;
>                 page_counter_init(&memcg->memory, &parent->memory);
>                 page_counter_init(&memcg->swap, &parent->swap);
> -               page_counter_init(&memcg->memsw, &parent->memsw);
>                 page_counter_init(&memcg->kmem, &parent->kmem);
>                 page_counter_init(&memcg->tcpmem, &parent->tcpmem);
>         } else {
>                 page_counter_init(&memcg->memory, NULL);
>                 page_counter_init(&memcg->swap, NULL);
> -               page_counter_init(&memcg->memsw, NULL);
>                 page_counter_init(&memcg->kmem, NULL);
>                 page_counter_init(&memcg->tcpmem, NULL);
>                 /*
> @@ -5414,7 +5417,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>
>         page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
>         page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
> -       page_counter_set_max(&memcg->memsw, PAGE_COUNTER_MAX);
>         page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
>         page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
>         page_counter_set_min(&memcg->memory, 0);
> --
> 2.18.1
>
