From: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm/page_owner: Print memcg information
Date: Thu, 3 Feb 2022 08:53:10 +0200
Message-ID: <Yft71q+OO7lg90sl@kernel.org>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643871201;
        bh=9nbtztfsgUhdr6aIZKYDMaKCReVO1EVdAswxzSjNC7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6HEisU3wiHHxL8R9caiTeqrkK56FJXhwb2DFel+9K7/RdNm4Abym6AZjPQJ+NRIG
         RUmDLCvDW+mWgyKh8KuFV1evSRBK58szRcB/zqQzJv+AxciTxWg8rz133mfo6wSxUi
         9c2ELDV7ixzAhlyQEz7+VvbHhyH1QoadIgBpJBu5nUpDAha3FFEuOXoqJlgQp2p6Hv
         gPkrqy9u/H3pGZmDePLjGeGyXE5NXCe7adhLerCiQsWgbnb4LELuRs/bSzlztvlAds
         Q7suEazu8PcoROGWUdjBttRsFysrf0TPvRT9JysqR1aAii9GBOGpVSCrzoq3fW9HVA
         YbQYF9iNsK73g==
Content-Disposition: inline
In-Reply-To: <20220202203036.744010-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Feb 02, 2022 at 03:30:35PM -0500, Waiman Long wrote:
> It was found that a number of offline memcgs were not freed because
> they were pinned by some charged pages that were present. Even "echo 1 >
> /proc/sys/vm/drop_caches" wasn't able to free those pages. These offline
> but not freed memcgs tend to increase in number over time with the side
> effect that percpu memory consumption as shown in /proc/meminfo also
> increases over time.
> 
> In order to find out more information about those pages that pin
> offline memcgs, the page_owner feature is extended to print memory
> cgroup information especially whether the cgroup is offline or not.
> RCU read lock is taken when memcg is being accessed to make sure
> that it won't be freed.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Acked-by: Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

And my akcs for the first two patches are missing somehow in v4...

> ---
>  mm/page_owner.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 28dac73e0542..f7820357e4d4 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -10,6 +10,7 @@
>  #include <linux/migrate.h>
>  #include <linux/stackdepot.h>
>  #include <linux/seq_file.h>
> +#include <linux/memcontrol.h>
>  #include <linux/sched/clock.h>
>  
>  #include "internal.h"
> @@ -325,6 +326,45 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
>  	seq_putc(m, '\n');
>  }
>  
> +/*
> + * Looking for memcg information and print it out
> + */
> +static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
> +					 struct page *page)
> +{
> +#ifdef CONFIG_MEMCG
> +	unsigned long memcg_data;
> +	struct mem_cgroup *memcg;
> +	bool online;
> +	char name[80];
> +
> +	rcu_read_lock();
> +	memcg_data = READ_ONCE(page->memcg_data);
> +	if (!memcg_data)
> +		goto out_unlock;
> +
> +	if (memcg_data & MEMCG_DATA_OBJCGS)
> +		ret += scnprintf(kbuf + ret, count - ret,
> +				"Slab cache page\n");
> +
> +	memcg = page_memcg_check(page);
> +	if (!memcg)
> +		goto out_unlock;
> +
> +	online = (memcg->css.flags & CSS_ONLINE);
> +	cgroup_name(memcg->css.cgroup, name, sizeof(name));
> +	ret += scnprintf(kbuf + ret, count - ret,
> +			"Charged %sto %smemcg %s\n",
> +			PageMemcgKmem(page) ? "(via objcg) " : "",
> +			online ? "" : "offline ",
> +			name);
> +out_unlock:
> +	rcu_read_unlock();
> +#endif /* CONFIG_MEMCG */
> +
> +	return ret;
> +}
> +
>  static ssize_t
>  print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  		struct page *page, struct page_owner *page_owner,
> @@ -365,6 +405,8 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  			migrate_reason_names[page_owner->last_migrate_reason]);
>  	}
>  
> +	ret = print_page_owner_memcg(kbuf, count, ret, page);
> +
>  	ret += snprintf(kbuf + ret, count - ret, "\n");
>  	if (ret >= count)
>  		goto err;
> -- 
> 2.27.0
> 
> 

-- 
Sincerely yours,
Mike.
