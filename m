From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3] memcg, kmem: further deprecate kmem.limit_in_bytes
Date: Tue, 19 Oct 2021 12:51:47 -0700
Message-ID: <20211019125147.0ad010f318bbd8233cadcdae@linux-foundation.org>
References: <20211019153408.2916808-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634673110;
        bh=jGj86H0JaCzg0FpU/IIjOqXur5MOCHmg5HVDErAlS9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TE+8q5G6fg7FTvw+yGNn9m1udm/EaXQQxjSdnl2DK2j9ru/LUmoehpNnHbrC3ahjC
         L3ozhy5L4vY9OfwgTE/VfwTdlx7EA2Oi0pPjdAPUIGoqSfE9cYyVqOgIumoSSkTTZc
         rqu3KbK+HyM8WLPftcSg3LwtyGTSq5mEdyEezJdg=
In-Reply-To: <20211019153408.2916808-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, 19 Oct 2021 08:34:08 -0700 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> The deprecation process of kmem.limit_in_bytes started with the commit
> 0158115f702 ("memcg, kmem: deprecate kmem.limit_in_bytes") which also
> explains in detail the motivation behind the deprecation. To summarize,
> it is the unexpected behavior on hitting the kmem limit. This patch
> moves the deprecation process to the next stage by disallowing to set
> the kmem limit. In future we might just remove the kmem.limit_in_bytes
> file completely.
> 
> ...
>
> @@ -3791,10 +3766,8 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>  			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
>  			break;
>  		case _KMEM:
> -			pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
> -				     "Please report your usecase to linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org if you "
> -				     "depend on this functionality.\n");
> -			ret = memcg_update_kmem_max(memcg, nr_pages);
> +			/* kmem.limit_in_bytes is deprecated. */
> +			ret = -ENOTSUPP;
>  			break;
>  		case _TCP:
>  			ret = memcg_update_tcp_max(memcg, nr_pages);

checkpatch said "ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP"?
