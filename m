From: JoonSoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 13/18] memcg/sl[au]b Track all the memcg children of a kmem_cache.
Date: Tue, 30 Oct 2012 00:26:43 +0900
Message-ID: <CAAmzW4MGdj-jL_FJ2Nkoa4Hx8KUDCeVK6HFidYQLauu_0vHhCg@mail.gmail.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
	<1350656442-1523-14-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=8GDGNSXKB1rpFA3MisBzUIUZn4J0HMHSpLWj22xdsJI=;
        b=RdgzlH0xWRsE4jCjhKAtO05mWCWQOPafslhvkTqR01XTRSqjkxGnsfQn2Bvgo3voB5
         T46jkaYJGs0yUfXGQV2J3jsOzk9tccw39+BIgrWB2U65KZhKDYDJnbCmKm1w+CazD7oU
         w/QG4nra9Fy78Z17noWqynzrAaLLHxoAz7LFcoI+3ql544oi0B3oWs1/VWTMwBhPbI7y
         ytwoF9nOJAczM/9YWICurnP03bdM8FGl4m6aqn9ka/kQuIgYJgdDNsJj1OzVOAPmOM2/
         c5cABZtAK5UgRmhOjt/nGYcTnWifzqpdN9vyUHo1AqACvGH97Jy+ptLfLjfZP3zw+pVd
         veeA==
In-Reply-To: <1350656442-1523-14-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

2012/10/19 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>:
> +void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
> +{
> +       struct kmem_cache *c;
> +       int i;
> +
> +       if (!s->memcg_params)
> +               return;
> +       if (!s->memcg_params->is_root_cache)
> +               return;
> +
> +       /*
> +        * If the cache is being destroyed, we trust that there is no one else
> +        * requesting objects from it. Even if there are, the sanity checks in
> +        * kmem_cache_destroy should caught this ill-case.
> +        *
> +        * Still, we don't want anyone else freeing memcg_caches under our
> +        * noses, which can happen if a new memcg comes to life. As usual,
> +        * we'll take the set_limit_mutex to protect ourselves against this.
> +        */
> +       mutex_lock(&set_limit_mutex);
> +       for (i = 0; i < memcg_limited_groups_array_size; i++) {
> +               c = s->memcg_params->memcg_caches[i];
> +               if (c)
> +                       kmem_cache_destroy(c);
> +       }
> +       mutex_unlock(&set_limit_mutex);
> +}

It may cause NULL deref.
Look at the following scenario.

1. some memcg slab caches has remained object.
2. start to destroy memcg.
3. schedule_delayed_work(kmem_cache_destroy_work_func, @delay 60hz)
4. all remained object is freed.
5. start to destroy root cache.
6. kmem_cache_destroy makes 's->memcg_params->memcg_caches[i]" NULL!!
7. Start delayed work function.
8. cachep in kmem_cache_destroy_work_func() may be NULL

Thanks.
