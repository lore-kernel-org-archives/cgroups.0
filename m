From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix return child memcg objcg for root memcg
Date: Thu, 29 Oct 2020 08:48:45 -0700
Message-ID: <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N6hFvPTvw/59UWHjYIOWZNWhefGQ9eQg3cKC2KPGwCM=;
        b=stI5fekXpQhrvKoARPS6AF6qpqpjEK9uc1LX1KLKNec1z0x6yaI9ATroJZ6+pRrtiJ
         FvADZnyT/zRZVVgZVWol+0ltxgd6Y5ix42oFmmPz1B4V3VaTnokEqQhsTYWVICBUWIku
         9Fk5j0+BjuxdxZRChwMI39Yk9ngWlL3BcekHDWpvHzItzJBoi6KSCSEv6qaof6slywA6
         Z9ycEF1H96wb+5jRFrczxm3/mBE78YGj9HFBmUeyT77Ei7G5GWeT7iG/OlQqsUaiNa81
         mZ/65I1f9jDxJXkblfK/CmELlWosZmafXB34IDtR+1D72hSzwMd7skKYuGU3X9dTZ3t0
         F1Zg==
In-Reply-To: <20201028035013.99711-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Oct 27, 2020 at 8:50 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> Consider the following memcg hierarchy.
>
>                     root
>                    /    \
>                   A      B
>
> If we get the objcg of memcg A failed,

Please fix the above statement.

> the get_obj_cgroup_from_current
> can return the wrong objcg for the root memcg.
>
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  changelog in v2:
>  1. Do not use a comparison with the root_mem_cgroup
>
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1337775b04f3..8c8b4c3ed5a0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2961,6 +2961,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
>                 objcg = rcu_dereference(memcg->objcg);
>                 if (objcg && obj_cgroup_tryget(objcg))
>                         break;
> +               objcg = NULL;

Roman, in your cleanup, are you planning to have objcg for root memcg as well?

>         }
>         rcu_read_unlock();
>
> --
> 2.20.1
>
