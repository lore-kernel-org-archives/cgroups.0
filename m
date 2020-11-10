From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix use after free in obj_cgroup_charge
Date: Tue, 10 Nov 2020 11:19:46 +0800
Message-ID: <CAMZfGtVgtJ0BdL_tXzgC3qh5Bn+0GpJJNHyE5RzEm=B3GO5q2w@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com> <20201028035013.99711-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmZMs4GZmfJF8Fdhkv3dMimRPyWWITH+SYPWeKRj3iE=;
        b=V/8PpzAY+tj3MaT3pbJokjVFCPodRWTiKBOOsxnc5JOelQuZm4fKIz3aMJU/9mRavo
         6sqeUvW5CF7aOdRtY24WWtf2pnqJpF6d8QJqegvaLZWlSk/lE5qKa8f9bUj7N5h1IQH/
         itrE++Uoz4EefemYNYYiOcGrNoUn2daqWgwXx9XFCXw7jGEwXXw/A/mnlNz10/GU4On0
         UIRYmMjY3KcKBgYFoGlwvJGK9vaTuP87RBUE8AxVQ8BegKaXClTX48zscvECI+cAzrC8
         /hw44C1Mv1tGKJ4OEgTd0Cs5LFv7Mdj6tIPvPQt2S9UL1uhUyTDGWkF49IJYJTIM7OCB
         X3EQ==
In-Reply-To: <20201028035013.99711-2-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Oct 28, 2020 at 11:50 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> The rcu_read_lock/unlock only can guarantee that the memcg will
> not be freed, but it cannot guarantee the success of css_get to
> memcg.
>
> If the whole process of a cgroup offlining is completed between
> reading a objcg->memcg pointer and bumping the css reference on
> another CPU, and there are exactly 0 external references to this
> memory cgroup (how we get to the obj_cgroup_charge() then?),
> css_get() can change the ref counter from 0 back to 1.
>
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hi Andrew,

Maybe you forgot to add this to the queue for the merge window?

Thanks.

> ---
>  changelog in v2:
>  1. Add unlikely and update the commit log suggested by Roman.
>
>  mm/memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8c8b4c3ed5a0..d9cdf899c6fc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3221,8 +3221,10 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
>          * independently later.
>          */
>         rcu_read_lock();
> +retry:
>         memcg = obj_cgroup_memcg(objcg);
> -       css_get(&memcg->css);
> +       if (unlikely(!css_tryget(&memcg->css)))
> +               goto retry;
>         rcu_read_unlock();
>
>         nr_pages = size >> PAGE_SHIFT;
> --
> 2.20.1
>

