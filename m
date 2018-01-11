From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Thu, 11 Jan 2018 11:42:39 +0100
Message-ID: <20180111104239.GZ1732@dhcp22.suse.cz>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180110124317.28887-1-aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed 10-01-18 15:43:17, Andrey Ryabinin wrote:
[...]
> @@ -2506,15 +2480,13 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
> -
> -		curusage = page_counter_read(counter);
> -		/* Usage is reduced ? */
> -		if (curusage >= oldusage)
> -			retry_count--;
> -		else
> -			oldusage = curusage;
> -	} while (retry_count);
> +		usage = page_counter_read(counter);
> +		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
> +						GFP_KERNEL, !memsw)) {

If the usage drops below limit in the meantime then you get underflow
and reclaim the whole memcg. I do not think this is a good idea. This
can also lead to over reclaim. Why don't you simply stick with the
original SWAP_CLUSTER_MAX (aka 1 for try_to_free_mem_cgroup_pages)?

> +			ret = -EBUSY;
> +			break;
> +		}
> +	} while (true);

-- 
Michal Hocko
SUSE Labs
