From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 3/4] mm/page_owner: Print memcg information
Date: Tue, 8 Feb 2022 13:13:14 +0100
Message-ID: <YgJeWth50eP9L0PK@dhcp22.suse.cz>
References: <20220208000532.1054311-1-longman@redhat.com>
 <20220208000532.1054311-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644322395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QLOYwEHWVSzw5MCgmxkNKcSwN+xc3CSk3rKsHEFXQ0w=;
        b=umK5/28r4Ry0plkxqSGj9jm/h56veWrz8pKMp5ppf56ETUdrsuH1hb86FdlcFXeoSoulaz
        lFOqeYg0yKPsQLWHc2dl8AHyW3Z0SGNQaJUUnjkpcUPE824yWe2B0B5R3iQOcbdFzLrhCJ
        ik3wNbCbeuoS3QIUfYl3YJI1RMqv5xo=
Content-Disposition: inline
In-Reply-To: <20220208000532.1054311-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On Mon 07-02-22 19:05:31, Waiman Long wrote:
> It was found that a number of dying memcgs were not freed because
> they were pinned by some charged pages that were present. Even "echo 1 >
> /proc/sys/vm/drop_caches" wasn't able to free those pages. These dying
> but not freed memcgs tend to increase in number over time with the side
> effect that percpu memory consumption as shown in /proc/meminfo also
> increases over time.

I still believe that this is very suboptimal way to debug offline memcgs
but memcg information can be useful in other contexts and it doesn't
cost us anything except for an additional output so I am fine with this.
 
> In order to find out more information about those pages that pin
> dying memcgs, the page_owner feature is extended to print memory
> cgroup information especially whether the cgroup is dying or not.
> RCU read lock is taken when memcg is being accessed to make sure
> that it won't be freed.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

With few comments/questions below.

> ---
>  mm/page_owner.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 28dac73e0542..d4c311455753 100644
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
> @@ -325,6 +326,47 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
>  	seq_putc(m, '\n');
>  }
>  
> +/*
> + * Looking for memcg information and print it out
> + */

I am not sure this is particularly useful comment.

> +static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
> +					 struct page *page)
> +{
> +#ifdef CONFIG_MEMCG
> +	unsigned long memcg_data;
> +	struct mem_cgroup *memcg;
> +	bool dying;
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
> +	dying = (memcg->css.flags & CSS_DYING);

Is there any specific reason why you haven't used mem_cgroup_online?

> +	ret += scnprintf(kbuf + ret, count - ret,
> +			"Charged %sto %smemcg ",
> +			PageMemcgKmem(page) ? "(via objcg) " : "",
> +			dying ? "dying " : "");
> +
> +	/* Write cgroup name directly into kbuf */
> +	cgroup_name(memcg->css.cgroup, kbuf + ret, count - ret);
> +	ret += strlen(kbuf + ret);

cgroup_name should return the length of the path added to the buffer.

> +	ret += scnprintf(kbuf + ret, count - ret, "\n");

I do not see any overflow prevention here. I believe you really need to
check ret >= count after each scnprintf/cgroup_name.
-- 
Michal Hocko
SUSE Labs
