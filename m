From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix get_active_memcg return value
Date: Tue, 23 Feb 2021 07:18:46 -0800
Message-ID: <CALvZod6=TYHPC3g3RzX84KeR8p74RH5PdbT+aNy+m5n2Yboskw@mail.gmail.com>
References: <20210223091101.42150-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gQTPFz0KpYE2dWkk3abN3T0OszgB57hAvGOE8ZYtgAA=;
        b=o+//MZFFfHtdHG0DGPb2hEKrGlrSgOgpcvlv8EkAotugJY4tPbXDcnXMc/VzRl1B3v
         8Se2eEU44z6Q2HXZys/VPsHf2iTTAXagOhaMxbzKf/kYTJgl/71uLPYbBHMQVhMIiqf6
         lXh+kxA8+09dEncWcHnEJKWScOXu2/9+AcCwK4jrjBqPzowQtoohRQyVHx7jfl3vv4Fs
         Fijdk/U3Vezsc6EkpisJM7UVqdp7xiKs5x6ThOTcy4dnDSq/zFQA67Frm2NFaB8YAD1Q
         Mclf3NnaduBtsQcwblXZrVEVZ3XJAYcht0XC3zb/ADdnOxPytBSC2EUz+zidmXWF86UY
         bhHQ==
In-Reply-To: <20210223091101.42150-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Feb 23, 2021 at 1:14 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> We use a global percpu int_active_memcg variable to store the remote
> memcg when we are in the interrupt context. But get_active_memcg always
> return the current->active_memcg or root_mem_cgroup. The remote memcg
> (set in the interrupt context) is ignored. This is not what we want.
> So fix it.
>
> Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Good catch.
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  mm/memcontrol.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index be6bc5044150..bbe25655f7eb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1061,13 +1061,9 @@ static __always_inline struct mem_cgroup *get_active_memcg(void)
>
>         rcu_read_lock();
>         memcg = active_memcg();
> -       if (memcg) {
> -               /* current->active_memcg must hold a ref. */
> -               if (WARN_ON_ONCE(!css_tryget(&memcg->css)))
> -                       memcg = root_mem_cgroup;
> -               else
> -                       memcg = current->active_memcg;
> -       }
> +       /* remote memcg must hold a ref. */
> +       if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
> +               memcg = root_mem_cgroup;
>         rcu_read_unlock();
>
>         return memcg;
> --
> 2.11.0
>
